package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ActivityService {
    PageInfo<Activity> list(Activity activity,int page,int pageSize);

    List<User> queryUsers();

    ResultVo saveOrUpdateActivity(Activity activity, User user);

    Activity queryActivityById(String id);

    void deleteActivity(String ids);

    Activity toDetail(String id);

    ActivityRemark saveActivityRemark(ActivityRemark activityRemark,User user);

    void deleteActivityRemark(String id);

    void updateActivityRemark(ActivityRemark activityRemark,User user);
}
