package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
//市场活动字典表
@Data
@Table(name = "tbl_activity_remark")
@NameStyle(Style.normal)
public class ActivityRemark {

    @Id
    private String id;
    private String noteContent;
    private String createTime;
    private String createBy;
    private String editTime;
    private String editBy;
    private String editFlag;
    private String activityId;
    private String owner;

    @Transient  //忽略某个字段，数据库中可以不存在改字段
    private String img;//用户头像，数据库表中没有改字段，通过关联查询出来的

}
