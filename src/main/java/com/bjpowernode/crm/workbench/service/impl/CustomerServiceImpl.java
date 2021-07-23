package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.mapper.CustomerRemarkMapper;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsMapper contactsMapper;


    @Override
    public PageInfo<Customer> list(Customer customer,int page,int pageSize) {


        Example example = new Example(Customer.class);
        Example.Criteria criteria = example.createCriteria();

        //判断客户名称
        String name = customer.getName();
        if(StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%" + name + "%");
        }

        //所有者查询
        /*
            1、根据用户输入的名字查询满足条件的用户的主键，把主键放入到集合中
            2、查询客户表，查询owner的值在1中查询出来的用户的主键中包含的数据
         */
        String owner1 = customer.getOwner();
        if(StrUtil.isNotEmpty(owner1)){
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name","%" + owner1 + "%");
            List<User> users = userMapper.selectByExample(example1);
            System.out.println("ActivityServiceImplusers = " + users);
            //定义一个集合存放用户主键
            List<String> ids = new ArrayList<>();
            for (User user : users) {
                ids.add(user.getId());
            }
            criteria.andIn("owner",ids);
        }


        //参数1:page 参数2:pageSize 改行代码等同于limit a,b:底层通过拦截器(过滤器)
        PageHelper.startPage(page,pageSize);

        List<Customer> customers = customerMapper.selectByExample(example);

        //遍历客户信息集合，查询所有者信息
        for (Customer customer1 : customers) {
            //owner就是用户表的外检
            String owner = customer1.getOwner();
            //根据owner查询用户信息
            User user = userMapper.selectByPrimaryKey(owner);


            customer1.setOwner(user.getName());
        }
        PageInfo<Customer> pageInfo = new PageInfo<>(customers);

        return pageInfo;
    }



    @Override
    public ResultVo saveOrUpdateCustomer(Customer customer, User user) {
        ResultVo resultVo = new ResultVo();
        if(customer.getId() != null){
            //更新
            customer.setEditBy(user.getName());
            customer.setEditTime(DateTimeUtil.getSysTime());
            int count = customerMapper.updateByPrimaryKeySelective(customer);

            if(count == 0){
                throw new CrmException(CrmEnum.CUSTOMER_UPDATE);
            }

            resultVo.setMessage("更新客户信息成功");
        }else{
            //添加
            //设置创建者
            customer.setCreateBy(user.getName());
            //设置主键
            customer.setId(UUIDUtil.getUUID());
            //设置创建时间
            customer.setCreateTime(DateTimeUtil.getSysTime());
            int count = customerMapper.insertSelective(customer);
            if(count == 0){
                throw new CrmException(CrmEnum.CUSTOMER_INSERT);
            }

            resultVo.setMessage("添加客户信息成功");
        }
        resultVo.setOk(true);
        return resultVo;
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectByPrimaryKey(id);
    }

    @Override
    public void deleteCustomer(String ids) {
        String[] split = ids.split(",");
        //把数组转换成集合
        List<String> aids = Arrays.asList(split);
        Example example = new Example(Customer.class);
        example.createCriteria().andIn("id",aids);
        int count = customerMapper.deleteByExample(example);
        if(count == 0){
            throw new CrmException(CrmEnum.CUSTOMER_INSERT);
        }
    }

    @Override
    public Customer toDetail(String id) {

        //查询出客户信息
        Customer customer = customerMapper.selectByPrimaryKey(id);
        //owner就是用户表的外键
        String owner = customer.getOwner();
        //根据owner查询用户信息
        User user = userMapper.selectByPrimaryKey(owner);
        customer.setOwner(user.getName());

        //查询客户备注信息
        CustomerRemark customerRemark =new CustomerRemark();
        customerRemark.setCustomerId(id);
        List<CustomerRemark> customerRemarks = customerRemarkMapper.select(customerRemark);
        //把备注设置到客户信息中
        customer.setCustomerRemarks(customerRemarks);
        //参数id既是customer对应表的主键，又是contacts的外键（字段customerid），根据这个id查出联系人集合
        Example example = new Example(Contacts.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("customerId",id);//查询条件
        List<Contacts> contacts = contactsMapper.selectByExample(example);
        //解决用户头像显示问题
        //1、根据备注中表中的owner查询用户
        for (CustomerRemark remark : customerRemarks) {
            //用户的主键
            String uid = remark.getOwner();
            //查询用户
            User u = userMapper.selectByPrimaryKey(uid);

            //2、把用户中img设置到客户备注中
            remark.setImg(u.getImg());

            //给每个客户备注设置名字
            remark.setCustomerId(customer.getName());
            for (Contacts contact : contacts) {
                if(contact !=null){
                    remark.setFullname(contact.getFullname());
                    remark.setAppellation(contact.getAppellation());
                    break;
                }
            }
        }



        return customer;
    }

    @Override
    public CustomerRemark saveCustomerRemark(CustomerRemark customerRemark,User user) {
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setImg(user.getImg());
        customerRemark.setCreateBy(user.getName());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setOwner(user.getId());
        customerRemarkMapper.insertSelective(customerRemark);

        //根据备注的activityId查询客户名称
        Customer activity = customerMapper.selectByPrimaryKey(customerRemark.getCustomerId());

        customerRemark.setCustomerId(activity.getName());
        return customerRemark;
    }

    @Override
    public void deleteCustomerRemark(String id) {
        customerRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void updateCustomerRemark(CustomerRemark customerRemark, User user) {
        customerRemark.setEditBy(user.getName());
        customerRemark.setEditFlag("1");
        customerRemark.setEditTime(DateTimeUtil.getSysTime());
        customerRemarkMapper.updateByPrimaryKeySelective(customerRemark);
    }
}
