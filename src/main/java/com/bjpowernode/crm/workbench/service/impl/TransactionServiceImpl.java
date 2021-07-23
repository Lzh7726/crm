package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.EntityColumn;
import tk.mybatis.mapper.entity.Example;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private  TransactionMapper transactionMapper;
    @Autowired
    private  TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public List<String> queryCustomerNames(String customerName) {
        Example example = new Example(Customer.class);
        example.createCriteria().andLike("name","%" + customerName + "%");
        List<Customer> customers = customerMapper.selectByExample(example);

        //定义一个集合，存放所有客户的名字
        List<String> names = new ArrayList<>();

        for (Customer customers1 : customers) {
            names.add(customers1.getName());
        }
        return names;
    }

    @Override
    public ResultVo createTransaction(Transaction transaction, User user) {
        ResultVo resultVo = new ResultVo();
        Example example = new Example(Customer.class);
        example.createCriteria().andEqualTo("name", transaction.getCustomerId());
        //判断客户是否存在
        //根据前端传入的id（实为name），查询客户是否存在。
        //前端传来的是客户name，Transaction没有customerName属性，所以用id接收，因此不能根据主键查询。

        Customer customer = customerMapper.selectOneByExample(example);

        //查出的虽然是集合，但客户名称不会重复，只有一个，因此集合的第一个元素即是查询出的唯一客户。
        if(customer == null){
            //客户不存在
            resultVo.setT(CrmEnum.CUSTOMER_NONENTITY);

        }else {
            //前端contactsId实为contactsName，通过contactsName查询出contactsId
            Example example1 = new Example(Contacts.class);
             example1.createCriteria().andEqualTo("fullname", transaction.getContactsId());
            //查询出contactsId，设置
            List<Contacts> contacts = contactsMapper.selectByExample(example1);
            //联系人不会重复，所以for循环id只有一个
            String id=null;
            for (Contacts contact : contacts) {
                id = contact.getId();
            }
            //客户存在，创建交易
            transaction.setContactsId(id);
            transaction.setCreateBy(user.getName());//所有者就是创建者
            transaction.setCreateTime(DateTimeUtil.getSysTime());
            transaction.setCustomerId(customer.getId());
            transaction.setId(UUIDUtil.getUUID());
            Example example2 = new Example(Activity.class);
            example2.createCriteria().andEqualTo("name", transaction.getActivityId());
            Activity activity = activityMapper.selectOneByExample(example2);
            if (activity.getId()!=null){transaction.setActivityId(activity.getId());}

            int i = transactionMapper.insertSelective(transaction);
            if (i == 0){
                throw new CrmException(CrmEnum.TRANSACTION_INSERT);
            }
            resultVo.setMessage("创建交易成功");
        }

        resultVo.setOk(true);
        return resultVo;
    }

    @Override
    public List<Transaction> selectCustomerTransactionInfo(String id) {
        Example example = new Example(Transaction.class);
        example.createCriteria().andEqualTo("customerId", id);
        List<Transaction> transactions = transactionMapper.selectByExample(example);
        return transactions;
    }

    @Override
    public int deleteTransaction(String id) {
        int result = transactionMapper.deleteByPrimaryKey(id);
        return result;
    }
    @Override
    public List<TransactionHistory> queryHistory(String id) {
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setTranId(id);
        List<TransactionHistory> transactionHistories = transactionHistoryMapper.select(transactionHistory);
        return transactionHistories;
    }
    /*@Override
    public ResultVo stageList(String id, Map<String,String> stage2Possibility, Integer position, User user) {

        ResultVo resultVo = new ResultVo();
        //查询当前交易所处的阶段
        Transaction transaction = transactionMapper.selectByPrimaryKey(id);
        //当前交易所处阶段 08丢失的线索
        String currentStage = transaction.getStage();
        //当前交易阶段对应的可能性：为了后面能够方便判断
        String currentPossibility = transaction.getPossibility();

        //取出所有阶段,把Map转换成List HashMap:数组+单向链表
        List<Map.Entry<String,String>> list = new ArrayList(stage2Possibility.entrySet());
        //获取当前交易阶段在所有阶段中数组的索引下标
        int pointer = 0;

        if(position != null){
            //点击修改交易图标
            pointer = position;
            //更新数据库交易阶段信息
            Map.Entry<String, String> entry = list.get(position);

            currentStage = entry.getKey();
            currentPossibility = entry.getValue();
            transaction.setStage(currentStage);
            transaction.setPossibility(currentPossibility);
            transactionMapper.updateByPrimaryKeySelective(transaction);

            //添加一条新的交易历史记录
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtil.getUUID());
            transactionHistory.setTranId(id);
            transactionHistory.setStage(currentStage);
            transactionHistory.setPossibility(currentPossibility);
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            transactionHistory.setCreateTime(DateTimeUtil.getSysTime());
            transactionHistory.setCreateBy(user.getName());
            transactionHistoryMapper.insertSelective(transactionHistory);
            resultVo.setT(transactionHistory);
        }else{
            for(int i = 0; i < list.size(); i++){
                Map.Entry<String, String> entry = list.get(i);
                //每个阶段
                String stage = entry.getKey();
                //每个阶段的可能性
                String possibility = entry.getValue();
                if(currentPossibility.equals(possibility)){
                    //当前交易在所有阶段中位置
                    pointer = i;
                    break;
                }
            }
        }

        int index = 0;
        for(int i = 0; i < list.size(); i++){
            Map.Entry<String, String> entry = list.get(i);
            //每个阶段的可能性
            String possibility = entry.getValue();
            if("0".equals(possibility)){
                //当前交易在所有阶段中位置
                index = i;
                break;
            }
        }

        List<Stage> stageList = new ArrayList<>();

        //确定交易失败了，能确定前7个是黑圈，后面两个是X，哪个是黑X和红X
        if("0".equals(currentPossibility)){
            for(int i = 0; i < list.size(); i++){
                Stage s = new Stage();
                Map.Entry<String, String> entry = list.get(i);
                //每个阶段
                String stage = entry.getKey();
                //每个阶段的可能性
                String possibility = entry.getValue();
                //所有阶段中可能性为0的阶段 可能是第8阶段，也可能是第9阶段
                if("0".equals(possibility)){
                    if(currentStage.equals(stage)){
                        //确定是红X
                        s.setType("红X");
                    }else{
                        s.setType("黑X");
                    }
                }else{
                    s.setType("黑圈");
                }
                s.setPosition(i+"");
                s.setContent(stage);
                s.setPossibility(possibility);
                stageList.add(s);
            }
        }else{
            //交易中状态(包含成功状态) 只能确定后两个是黑X
            for(int i = 0; i < list.size(); i++){
                Map.Entry<String, String> entry = list.get(i);
                //每个阶段
                String stage = entry.getKey();
                //每个阶段的可能性
                String possibility = entry.getValue();
                Stage s = new Stage();
                if(i < pointer){
                    s.setType("绿圈");
                }else if(i == pointer){
                    s.setType("锚点");
                }else if(i < index && i > pointer){
                    s.setType("黑圈");
                }else{
                    s.setType("黑X");
                }
                s.setPosition(i+"");
                s.setContent(stage);
                s.setPossibility(possibility);
                stageList.add(s);
            }
        }
        resultVo.setList(stageList);
        return resultVo;
    }

    @Override
    public void exportExcel(String realPath) {
        Example example = new Example(Transaction.class);
        Map<String, EntityColumn> propertyMap = example.getPropertyMap();


        //查询所有交易数据
        List<Transaction> transactions = transactionMapper.selectByExample(example);

        String fileName = System.currentTimeMillis() + ".xlsx";
        // 通过工具类创建writer
        ExcelWriter writer = ExcelUtil.getWriter(realPath + File.separator + fileName);

        //跳过第一行
        writer.passCurrentRow();

        // 合并单元格后的标题行，使用默认标题样式
        writer.merge(propertyMap.size() - 1, "交易统计图标");

        // 一次性写出内容，使用默认样式，强制输出标题
        writer.write(transactions, true);
        // 关闭writer，释放内存
        writer.close();
    }

    //把数据写入Excel文档中
    @Override
    public void writeToClient(ExcelWriter writer) {
        Example example = new Example(Transaction.class);
        Map<String, EntityColumn> propertyMap = example.getPropertyMap();


        //查询所有交易数据
        List<Transaction> transactions = transactionMapper.selectByExample(example);

        //跳过第一行
        writer.passCurrentRow();

        // 合并单元格后的标题行，使用默认标题样式
        writer.merge(propertyMap.size() - 1, "交易统计图标");

        // 一次性写出内容，使用默认样式，强制输出标题
        writer.write(transactions, true);
    }*/
}
