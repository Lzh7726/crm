package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.List;
//市场活动
@Data
@Table(name = "tbl_activity")
@NameStyle(Style.normal)
public class Activity implements Serializable {

    @Id
    private String id;
    private String owner;//所有者 用户表的外检
    private String name;//名称
    private String startDate;//开始时间
    private String endDate;//结束时间
    private String cost;//花费
    private String description;//描述
    private String createTime;//创建时间
    private String createBy;//创建者
    private String editTime;
    private String editBy;

    private List<ActivityRemark> activityRemarks;

}
