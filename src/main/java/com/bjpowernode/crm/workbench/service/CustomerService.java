package com.bjpowernode.crm.workbench.service;


import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.github.pagehelper.PageInfo;



public interface CustomerService {
    PageInfo<Customer> list(Customer customer, int page, int pageSize);



    ResultVo saveOrUpdateCustomer(Customer customer, User user);

    Customer queryCustomerById(String id);

    void deleteCustomer(String ids);

    Customer toDetail(String id);

    CustomerRemark saveCustomerRemark(CustomerRemark customerRemark, User user);

    void deleteCustomerRemark(String id);

    void updateCustomerRemark(CustomerRemark customerRemark,User user);
}
