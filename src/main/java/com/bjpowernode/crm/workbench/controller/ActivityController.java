package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @RestController:不但能够接受请求，而且还能直接返回json串，但是不能跳转视图了,一般用于前后端分离的项目
 */
@RestController
public class ActivityController {

    @Autowired
    private ActivityService activityService;


    //把列表查询和分页都使用一个方法实现，还有多条件复杂查询
    @RequestMapping("/workbench/activity/list")
    public PageInfo list(Integer page, Integer pageSize, Activity activity){
        if(page == null ){page=1;}
        if(pageSize == null){pageSize=5;}
        PageInfo<Activity> pageInfo = activityService.list(activity,page,pageSize);
        return pageInfo;
    }

    //异步查询所有者信息
    @RequestMapping("/workbench/activity/queryUsers")
    public List<User> queryUsers(){
        return activityService.queryUsers();
    }

    //异步保存市场活动信息
    @RequestMapping("/workbench/activity/saveOrUpdateActivity")
    public ResultVo saveOrUpdateActivity(Activity activity, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");

            resultVo = activityService.saveOrUpdateActivity(activity,user);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //根据主键查询市场活动信息
    @RequestMapping("/workbench/activity/queryActivityById")
    public Activity queryActivityById(String id) {
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    //删除市场活动
    @RequestMapping("/workbench/activity/deleteActivity")
    public ResultVo deleteActivity(String ids){
        ResultVo resultVo = new ResultVo();
        try{
            activityService.deleteActivity(ids);
            resultVo.setOk(true);
            resultVo.setMessage("删除市场活动成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //从列表页面跳转到详情页，查询市场活动和备注信息:转发方式
   /* @RequestMapping("/workbench/activity/toDetail")
    private String toDetail(String id, Model model){
        Activity activity = activityService.toDetail(id);
        model.addAttribute("activity",activity);
        return "/workbench/activity/detail";
    }*/

    @RequestMapping("/workbench/activity/toDetail")
    private Activity toDetail(String id){
        Activity activity = activityService.toDetail(id);
       return activity;
    }

    //异步添加市场活动备注
    @RequestMapping("/workbench/activity/saveActivityRemark")
    public ResultVo saveActivityRemark(ActivityRemark activityRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            activityRemark = activityService.saveActivityRemark(activityRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("添加市场活动备注成功！");
            resultVo.setT(activityRemark);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }


    //删除备注
    @RequestMapping("/workbench/activity/deleteActivityRemark")
    public ResultVo deleteActivityRemark(String id){
        ResultVo resultVo = new ResultVo();
        try{
            activityService.deleteActivityRemark(id);
            resultVo.setOk(true);
            resultVo.setMessage("删除市场活动备注成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //修改备注
    @RequestMapping("/workbench/activity/updateActivityRemark")
    public ResultVo updateActivityRemark(ActivityRemark activityRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            activityService.updateActivityRemark(activityRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("修改市场活动备注成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
}
