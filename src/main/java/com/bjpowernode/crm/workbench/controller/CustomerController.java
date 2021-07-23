package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Customer;
import com.bjpowernode.crm.workbench.bean.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.script.ScriptContext;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
public class CustomerController {
   @Autowired
  private CustomerService customerService;

    //把列表查询和分页都使用一个方法实现，还有多条件复杂查询
    @RequestMapping("/workbench/customer/list")
    public PageInfo list(Integer page, Integer pageSize, Customer customer){
        PageInfo<Customer> pageInfo = customerService.list(customer,page,pageSize);
        return pageInfo;
    }



    //异步保存客户信息
    @RequestMapping("/workbench/customer/saveOrUpdateCustomer")
    public ResultVo saveOrUpdateCustomer(Customer customer, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            customer.setOwner(user.getId());

            resultVo = customerService.saveOrUpdateCustomer(customer,user);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //根据主键查询客户信息
    @RequestMapping("/workbench/customer/queryCustomerById")
    public Customer queryCustomerById(String id,HttpSession session) {
        Customer customer = customerService.queryCustomerById(id);
        session.setAttribute("owner",customer.getOwner());
        return customer;
    }

    //删除客户信息
    @RequestMapping("/workbench/customer/deleteCustomer")
    public ResultVo deleteCustomer(String ids){
        ResultVo resultVo = new ResultVo();
        try{
            customerService.deleteCustomer(ids);
            resultVo.setOk(true);
            resultVo.setMessage("删除客户信息成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //从列表页面跳转到详情页，查询客户和备注信息:转发
   /* @RequestMapping("/workbench/activity/toDetail")
    private String toDetail(String id, Model model){
        Activity activity = activityService.toDetail(id);
        model.addAttribute("activity",activity);
        return "/workbench/activity/detail";
    }*/

    @RequestMapping("/workbench/customer/toDetail")
    private Customer toDetail(String id){
        Customer customer = customerService.toDetail(id);

        return customer;
    }


    //异步添加客户信息备注
    @RequestMapping("/workbench/customer/saveCustomerRemark")
    public ResultVo saveCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            customerRemark = customerService.saveCustomerRemark(customerRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("添加客户备注信息成功！");
            resultVo.setT(customerRemark);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }


    //删除备注
    @RequestMapping("/workbench/customer/deleteCustomerRemark")
    public ResultVo deleteCustomerRemark(String id){
        ResultVo resultVo = new ResultVo();
        try{
            customerService.deleteCustomerRemark(id);
            resultVo.setOk(true);
            resultVo.setMessage("删除客户备注信息成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //修改备注
    @RequestMapping("/workbench/customer/updateCustomerRemark")
    public ResultVo updateCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            customerService.updateCustomerRemark(customerRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("修改客户备注信息成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
}
