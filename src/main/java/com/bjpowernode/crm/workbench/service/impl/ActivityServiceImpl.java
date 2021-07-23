package com.bjpowernode.crm.workbench.service.impl;

import cn.hutool.core.util.StrUtil;
import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.ActivityRemark;
import com.bjpowernode.crm.workbench.bean.ClueActivity;
import com.bjpowernode.crm.workbench.bean.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.mapper.ClueActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Autowired
    private ClueActivityMapper clueActivityMapper;

    @Override
    public PageInfo<Activity> list(Activity activity,int page,int pageSize) {


        Example example = new Example(Activity.class);
        example.setOrderByClause("name asc");
        Example.Criteria criteria = example.createCriteria();


        //判断市场活动名称
        String name = activity.getName();
        if(StrUtil.isNotEmpty(name)){
            criteria.andLike("name","%" + name + "%");
        }

        //所有者查询
        /*
            1、根据用户输入的名字查询满足条件的用户的主键，把主键放入到集合中
            2、查询市场活动表，查询owner的值在1中查询出来的用户的主键中包含的数据
         */
        String owner1 = activity.getOwner();
        if(StrUtil.isNotEmpty(owner1)){
            Example example1 = new Example(User.class);
            example1.createCriteria().andLike("name","%" + owner1 + "%");
            List<User> users = userMapper.selectByExample(example1);
            //定义一个集合存放用户主键
            List<String> ids = new ArrayList<>();
            for (User user : users) {
                ids.add(user.getId());
            }
            criteria.andIn("owner",ids);
        }
        //判断开始日期
        String startDate = activity.getStartDate();
        if(StrUtil.isNotEmpty(startDate)){
            criteria.andGreaterThanOrEqualTo("startDate",startDate);
        }
        //判断结束日期
        String endDate = activity.getEndDate();
        if(StrUtil.isNotEmpty(endDate)){
            criteria.andLessThanOrEqualTo("endDate",endDate);
        }

            //参数1:page 参数2:pageSize 改行代码等同于limit a,b:底层通过拦截器(过滤器)
            PageHelper.startPage(page,pageSize);



        List<Activity> activities = activityMapper.selectByExample(example);

        //遍历市场活动集合，查询所有者信息
        for (Activity activity1 : activities) {
            //owner就是用户表的外检
            String owner = activity1.getOwner();
            //根据owner查询用户信息
            User user = userMapper.selectByPrimaryKey(owner);

            activity1.setOwner(user.getName());
        }
        PageInfo<Activity> pageInfo = new PageInfo<>(activities);

        return pageInfo;
    }

    @Override
    public List<User> queryUsers() {
        return userMapper.selectAll();
    }

    @Override
    public ResultVo saveOrUpdateActivity(Activity activity, User user) {
        ResultVo resultVo = new ResultVo();
        if(activity.getId() != null){
            //更新
            activity.setEditBy(user.getName());
            activity.setEditTime(DateTimeUtil.getSysTime());
            int count = activityMapper.updateByPrimaryKeySelective(activity);
            if(count == 0){
                throw new CrmException(CrmEnum.ACTIVITY_UPDATE);
            }

            resultVo.setMessage("更新市场活动成功");
        }else{
            //添加
            //设置创建者
            activity.setCreateBy(user.getName());
            //设置主键
            activity.setId(UUIDUtil.getUUID());
            //设置创建时间
            activity.setCreateTime(DateTimeUtil.getSysTime());
            int count = activityMapper.insertSelective(activity);
            if(count == 0){
                throw new CrmException(CrmEnum.ACTIVITY_INSERT);
            }

            resultVo.setMessage("添加市场活动成果");
        }
        resultVo.setOk(true);
        return resultVo;
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectByPrimaryKey(id);
    }

    @Override
    public void deleteActivity(String ids) {
        String[] split = ids.split(",");
        //把数组转换成集合
        List<String> aids = Arrays.asList(split);
        Example example = new Example(Activity.class);
        example.createCriteria().andIn("id",aids);
        int count = activityMapper.deleteByExample(example);

        if(count > 0){
            //连带删除
            //①市场活动删除,则其备注信息也要删除
            Example example1 = new Example(ActivityRemark.class);
            example1.createCriteria().andIn("activityId",aids);
            //备注存在才能删除，否则空指针异常
            List<ActivityRemark> activityRemarks = activityRemarkMapper.selectByExample(example1);
            if (activityRemarks.size() > 0){
                int i = activityRemarkMapper.deleteByExample(example1);
                if (i < 0){
                    throw new CrmException(CrmEnum.ACTIVITY_REMARK_DELETE);
                }
            }
            //②市场活动删除,则线索和市场活动的关联解除
            Example example2 = new Example(ClueActivity.class);
            example2.createCriteria().andIn("activityId",aids);
            //关联关系存在才能删除，否则空指针异常
            List<ClueActivity> clueActivities = clueActivityMapper.selectByExample(example2);
            if (clueActivities.size() > 0){
                int i = clueActivityMapper.deleteByExample(example2);
                if (i < 0){
                    throw new CrmException(CrmEnum.CLUE_ACTIVITY_DELETE);
                }
            }
        } else {
            throw new CrmException(CrmEnum.ACTIVITY_INSERT);
        }



    }

    @Override
    public Activity toDetail(String id) {
        //先查询出市场活动信息
        Activity activity = activityMapper.selectByPrimaryKey(id);

        //owner就是用户表的外检
        String owner = activity.getOwner();
        //根据owner查询用户信息
        User user = userMapper.selectByPrimaryKey(owner);
        activity.setOwner(user.getName());

        //查询市场活动备注信息
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setActivityId(id);
        List<ActivityRemark> activityRemarks = activityRemarkMapper.select(activityRemark);

        //解决用户头像显示问题
        //1、根据备注中表中的owner查询用户
        for (ActivityRemark remark : activityRemarks) {
            //用户的主键
            String uid = remark.getOwner();
            //查询用户
            User u = userMapper.selectByPrimaryKey(uid);

            //2、把用户中img设置到市场活动备注中
            remark.setImg(u.getImg());

            //给每个市场活动备注设置名字
            remark.setActivityId(activity.getName());
        }

        //把备注设置市场活动中
        activity.setActivityRemarks(activityRemarks);

        return activity;
    }

    @Override
    public ActivityRemark saveActivityRemark(ActivityRemark activityRemark,User user) {
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setImg(user.getImg());
        activityRemark.setCreateBy(user.getName());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setOwner(user.getId());
        activityRemarkMapper.insertSelective(activityRemark);

        //根据备注的activityId查询市场活动名称
        Activity activity = activityMapper.selectByPrimaryKey(activityRemark.getActivityId());

        activityRemark.setActivityId(activity.getName());
        return activityRemark;
    }

    @Override
    public void deleteActivityRemark(String id) {
        activityRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void updateActivityRemark(ActivityRemark activityRemark, User user) {
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
    }

}
