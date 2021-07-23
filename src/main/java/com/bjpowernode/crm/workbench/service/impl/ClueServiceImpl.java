package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private ClueActivityMapper clueActivityMapper;

    @Autowired
    private ActivityMapper activityMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;


    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactActivityMapper contactActivityMapper;

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;


    @Override
    public PageInfo<Clue> list(Clue clue, int page, int pageSize) {
        Example example = new Example(Clue.class);
        Example.Criteria criteria = example.createCriteria();
    //判断查询条件
        //1判断联系人名称
        String fullname = clue.getFullname();
        if(StrUtil.isNotEmpty(fullname)){
            criteria.andLike("name","%" + fullname + "%");
        }
        //2判断公司名称
        String company = clue.getCompany();
        if (StrUtil.isNotEmpty(company)){
            criteria.andLike("company","%"+company+"%");
        }
        //3判断座机
        String phone = clue.getPhone();
        if (StrUtil.isNotEmpty(phone)){
            criteria.andLike("phone","%"+phone+"%");
        }
        //4判断线索来源
        String source = clue.getSource();

            if (StrUtil.isNotEmpty(source) ){
                if ("请选择".equals(source)){

                    clue.setSource(null);

                }else {criteria.andLike("source","%"+source+"%");}


            }


        //4判断所有者(查询)
        /*
            1、根据用户输入的名字查询满足条件的用户的主键，把主键放入到集合中
            2、查询市场活动表，查询owner的值在1中查询出来的用户的主键中包含的数据
         */
        String owner = clue.getOwner();
        if(StrUtil.isNotEmpty(owner)){
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name","%" + owner + "%");
            List<User> users = userMapper.selectByExample(example1);
            //定义一个集合存放用户主键
            List<String> ids = new ArrayList<>();
            for (User user : users) {
                ids.add(user.getId());
            }
            criteria.andIn("owner",ids);
        }
        //5判断联系人手机
        String mphone = clue.getMphone();
        if (StrUtil.isNotEmpty(mphone)){
            criteria.andLike("mphone","%"+mphone+"%");
        }
        //6判断状态
        String state = clue.getState();

            if (StrUtil.isNotEmpty(state)){
                if ("请选择".equals(state)){

                    clue.setState(null);
                }else{ criteria.andLike("state","%"+state+"%");}

            }





        //参数1:page 参数2:pageSize 改行代码等同于limit a,b:底层通过拦截器(过滤器)
        PageHelper.startPage(page,pageSize);

        List<Clue> clues = clueMapper.selectByExample(example);

        //遍历市场活动集合，查询所有者信息
        for (Clue clue1 : clues) {
            //owner就是用户表的外检
            String owner1 = clue1.getOwner();
            //根据owner查询用户信息
            User user = userMapper.selectByPrimaryKey(owner1);

            clue1.setOwner(user.getName());
        }
        PageInfo<Clue> pageInfo = new PageInfo<>(clues);

        return pageInfo;
    }

    @Override
    public void saveClue(Clue clue, User user) {
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clueMapper.insertSelective(clue);
    }
    @Override
    public ClueRemark saveClueRemark(ClueRemark clueRemark,User user) {
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setImg(user.getImg());
        clueRemark.setCreateBy(user.getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemarkMapper.insertSelective(clueRemark);

        //根据备注的clueId查询备注信息
        Clue clue = clueMapper.selectByPrimaryKey(clueRemark.getClueId());

        clueRemark.setClueId(clue.getId());
        //设置每个备注信息数据库中不存在而页面需要的字段
        clueRemark .setFullname(clue.getFullname());
        clueRemark.setAppellation(clue.getAppellation());
        clueRemark.setCompany(clue.getCompany());
        return clueRemark;
    }

    @Override
    public void deleteClueRemark(String id) {
        clueRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void updateClueRemark(ClueRemark clueRemark, User user) {
        clueRemark.setEditBy(user.getName());
        clueRemark.setEditFlag("1");
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }
    //线索主页删除和线索详情页删除合并
    @Override
    public ResultVo deleteClues(String ids) {
        ResultVo resultVo = new ResultVo();



            String[] split = ids.split(",");
            //把数组转换成集合
            List<String> aids = Arrays.asList(split);
            Example example = new Example(Clue.class);
            example.createCriteria().andIn("id",aids);
        int count= clueMapper.deleteByExample(example);
        if(count > 0){
            //连带删除
            //①线索删除,则其备注信息也要删除
            Example example1 = new Example(ClueRemark.class);
            example1.createCriteria().andIn("clueId",aids);
            //备注存在才能删除，否则空指针异常
            List<ClueRemark> ClueRemarks = clueRemarkMapper.selectByExample(example1);
            if (ClueRemarks.size() > 0){
                int i = clueRemarkMapper.deleteByExample(example1);
                if ( i <=0 ){
                    throw new CrmException(CrmEnum.CLUE_REMARK_DELETE);
                }
            }
            //②线索删除,则线索和市场活动的关联解除
            Example example2 = new Example(ClueActivity.class);
            example2.createCriteria().andIn("clueId",aids);
            //关联关系存在才能删除，否则空指针异常
            List<ClueActivity> clueActivities = clueActivityMapper.selectByExample(example2);
            if (clueActivities.size() > 0){
                int i = clueActivityMapper.deleteByExample(example2);
                if ( i <=0 ){
                    throw new CrmException(CrmEnum.CLUE_ACTIVITY_DELETE);
                }
            }

        } else{
            throw new CrmException(CrmEnum.CLUE_DELETE);
        }
        resultVo.setOk(true);
        resultVo.setMessage("删除线索成功");
        return resultVo;
    }

    @Override
    public Clue toDetail(String id) {
        //先查询出线索
        Clue clue = clueMapper.selectByPrimaryKey(id);

        //owner就是用户表的外检
        String owner = clue.getOwner();
        //根据owner查询用户信息
        User user = userMapper.selectByPrimaryKey(owner);
        clue.setOwner(user.getName());

        //查询市场活动备注信息
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(id);
        List<ClueRemark> clueRemarks = clueRemarkMapper.select(clueRemark);

        //解决用户头像显示问题
        //1、根据备注中表中的owner查询用户
        for (ClueRemark remark : clueRemarks) {
            //用户的主键
            Example example = new Example(User.class);
            example.createCriteria().andEqualTo("name",remark.getCreateBy());
            //查询用户
            List<User> users = userMapper.selectByExample(example);

            //2、把用户中img设置到线索备注中
            remark.setImg(users.get(0).getImg());
            //设置每个备注信息数据库中不存在而页面需要的字段
            remark.setFullname(clue.getFullname());
            remark.setAppellation(clue.getAppellation());
            remark.setCompany(clue.getCompany());


        }

        //把备注设置市场活动中
        clue.setClueRemarks(clueRemarks);

        return clue;
    }

    @Override
    public ResultVo saveOrUpdateClue(Clue clue, User user) {
        ResultVo resultVo = new ResultVo();
        //判断非必选项是否为"请选择"
        if("请选择".equals(clue.getAppellation()) || clue.getAppellation()==null){clue.setAppellation("");}
        if("请选择".equals(clue.getState()) || clue.getState()==null){clue.setState("");}
        if("请选择".equals(clue.getSource()) || clue.getSource()==null){clue.setSource("");}
        if(clue.getId() != null){
            //更新
            clue.setEditBy(user.getName());
            clue.setEditTime(DateTimeUtil.getSysTime());
            int count = clueMapper.updateByPrimaryKeySelective(clue);
            if(count == 0){
                throw new CrmException(CrmEnum.CLUE_UPDATE);
            }

            resultVo.setMessage("更新线索成功");
        }else{
            //添加
            //设置创建者
            clue.setCreateBy(user.getName());
            //设置主键
            clue.setId(UUIDUtil.getUUID());
            //设置创建时间
            clue.setCreateTime(DateTimeUtil.getSysTime());
            int count = clueMapper.insertSelective(clue);
            if(count == 0){
                throw new CrmException(CrmEnum.CLUE_INSERT);
            }

            resultVo.setMessage("添加线索成功");
        }
        resultVo.setOk(true);
        return resultVo;
    }

    @Override
    public List<Activity> queryActivities(String id,String name) {
        //根据线索id号到关联表查询出线索关联的市场活动的主键
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        List<String> ids = new ArrayList<>();
        for(ClueActivity clueActivity1 : clueActivities){
            ids.add(clueActivity1.getActivityId());
        }
        List<Activity> activities=null;
        if (ids.size() != 0){
            Example example = new Example(Activity.class);
            Example.Criteria criteria = example.createCriteria();
            criteria.andIn("id",ids);
            if (name != null){
                criteria.andLike("name","%"+name+"%");
            }
            activities = activityMapper.selectByExample(example);
            for (Activity activity : activities) {
                //将用户id转换为用户名称,显示给页面
                activity.setOwner(userMapper.selectByPrimaryKey(activity.getOwner()).getName());
            }
        }

        //根据查询的主键信息查询市场活动表

        return activities;
    }

    @Override
    public List<Activity> queryUnBindActivities(String id,String name) {
        //查询出当前线索关联的市场活动
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        List<String> ids = new ArrayList<>();
        for(ClueActivity clueActivity1 : clueActivities){
            ids.add(clueActivity1.getActivityId());
        }

        //根据用户输入的名称模糊查询市场活动
        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();
        if(StrUtil.isNotEmpty(name)){
            //用户输入名称了
            criteria.andLike("name","%" + name + "%");
        }
        if (ids.size() !=0 ){
            criteria.andNotIn("id",ids);
        }


        List<Activity> activities = activityMapper.selectByExample(example);
        for (Activity activity : activities) {
            activity.setOwner(userMapper.selectByPrimaryKey(activity.getOwner()).getName());
        }

        return activities;
    }

    @Override
    public void bind(String id, String ids) {
        String[] aIds = ids.split(",");

        for (String aId : aIds) {
            ClueActivity clueActivity = new ClueActivity();
            clueActivity.setId(UUIDUtil.getUUID());
            clueActivity.setClueId(id);
            clueActivity.setActivityId(aId);
            clueActivityMapper.insertSelective(clueActivity);
        }
    }

    @Override
    public void unbind(String id, String aid) {

        if(aid != null){
            ClueActivity clueActivity = new ClueActivity();
            clueActivity.setClueId(id);
            clueActivity.setActivityId(aid);
            clueActivityMapper.delete(clueActivity);
        }else{
            Example example = new Example(ClueActivity.class);
            example.createCriteria().andEqualTo("clueId",id);
            clueActivityMapper.deleteByExample(example);
        }

    }

    @Override
    public Clue toConvert(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    //线索转换
    @Override
    public void convert(String id,String isTransaction,Transaction transaction,User user) {
        int count;
        // 1、根据线索的主键查询线索的信息(线索包含自身、客户、联系人信息)
        Clue clue = clueMapper.selectByPrimaryKey(id);
        //2、先将线索中的客户信息取出来保存在客户表中，当该客户不存在的时候，新建客户(按公司名称精准查询)
        //2.1 按公司名称查询公司是否存在
        Customer customer = new Customer();
        customer.setName(clue.getCompany());
        customer.setAddress(clue.getAddress());
        customer.setCreateBy(user.getName());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customer.setId(UUIDUtil.getUUID());
        customer.setOwner(clue.getOwner());
        List<Customer> customers = customerMapper.select(customer);
        if(customers.size() == 0){
            //客户不存在，插入新客户
            count = customerMapper.insertSelective(customer);
            if (count == 0) {
                throw new CrmException(CrmEnum.CLUE_CONVERT);
            }
        }

        //3、将线索中联系人信息取出来保存在联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setAppellation(clue.getAppellation());
        //有些信息没有，可以通过联系人模块进行修改
        contacts.setCreateBy(user.getName());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setEmail(clue.getEmail());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        count = contactsMapper.insertSelective(contacts);
        if (count == 0) {
            throw new CrmException(CrmEnum.CLUE_CONVERT);
        }

        //4、线索中的备注信息取出来保存在客户备注和联系人备注中
        //先把线索中的备注信息放入到客户备注中
        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setId(UUIDUtil.getUUID());
        contactsRemark.setContactsId(contacts.getId());
        contactsRemark.setCreateBy(user.getName());
        contactsRemark.setCreateTime(DateTimeUtil.getSysTime());

        contactsRemarkMapper.insert(contactsRemark);

        //再把客户备注信息放入到客户备注中
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setCreateBy(user.getName());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setCustomerId(customer.getId());
        customerRemarkMapper.insertSelective(customerRemark);

        //5、将"线索和市场活动的关系"转换到"联系人和市场活动的关系中"
        //根据线索id查询中间表中关联的市场活动
       ClueActivity clueActivity = new ClueActivity();
       clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        for (ClueActivity clueActivity1 : clueActivities) {
            //把联系人和市场活动外键插入到中间表中
            ContactActivity contactActivity = new ContactActivity();
            contactActivity.setId(UUIDUtil.getUUID());
            contactActivity.setActivityId(clueActivity1.getActivityId());
            contactActivity.setContactsId(contacts.getId());
            contactActivityMapper.insertSelective(contactActivity);
        }

        //6、如果转换过程中发生了交易，创建一条新的交易，交易信息不全，后面可以通过修改交易来完善交易信息
        //如果转换页面的"为客户创建交易"复选框勾中的话，说明创建交易了
        if(isTransaction.equals("1")){
            //发生交易，创建交易信息
            transaction.setId(UUIDUtil.getUUID());
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getName());
            transaction.setCreateTime(DateTimeUtil.getSysTime());
            transaction.setCustomerId(customer.getId());
            transaction.setOwner(clue.getOwner());
            transaction.setSource(clue.getSource());

            transactionMapper.insertSelective(transaction);

            //7、创建交易备注和交易历史
            //交易备注
            TransactionRemark transactionRemark = new TransactionRemark();
            transactionRemark.setId(UUIDUtil.getUUID());
            transactionRemark.setCreateBy(user.getName());
            transactionRemark.setCreateTime(DateTimeUtil.getSysTime());
            transactionRemark.setTranId(transaction.getId());
            transactionRemarkMapper.insert(transactionRemark);

            //交易历史
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtil.getUUID());
            transactionHistory.setCreateBy(user.getName());
            transactionHistory.setCreateTime(DateTimeUtil.getSysTime());
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setStage(transaction.getStage());
            transactionHistory.setTranId(transaction.getId());
            transactionHistoryMapper.insert(transactionHistory);
        }

        //8、删除线索的备注信息
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(id);
        clueRemarkMapper.delete(clueRemark);

        //9、删除线索和市场活动的关联关系
        ClueActivity clueActivity1 = new ClueActivity();
        clueActivity1.setClueId(id);
        clueActivityMapper.delete(clueActivity1);

        //10、删除线索
        clueMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<Activity> queryBindClue(String id, String name) {
        //查询当前线索已经绑定的市场活动
        ClueActivity clueActivity = new ClueActivity();
        clueActivity.setClueId(id);
        List<ClueActivity> clueActivities = clueActivityMapper.select(clueActivity);
        List<String> ids = new ArrayList<>();
        for (ClueActivity clueActivity1 : clueActivities) {
            ids.add(clueActivity1.getActivityId());
        }

        Example example = new Example(Activity.class);
        Example.Criteria criteria = example.createCriteria();
        if(StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%" + name + "%");
        }
        criteria.andIn("id",ids);
        List<Activity> activities = activityMapper.selectByExample(example);
        return activities;
    }


}
