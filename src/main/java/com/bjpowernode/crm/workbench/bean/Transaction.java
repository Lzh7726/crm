package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;

//交易事务
@Data
@Table(name = "tbl_tran")
@NameStyle(Style.normal)
public class Transaction implements Serializable {

    @Id
    private String id;
    private String owner;
    private String money;//成交金额
    private String name;//交易名称
    private String expectedDate;//预计成交日期
    private String customerId;//客户id，需要查询并显示出名称
    private String stage;
    private String possibility;
    private String type;
    private String source;
    private String activityId;//相关的市场活动id，需要查询并显示出名称
    private String contactsId;//联系人id，需要查询并显示出名称
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;//描述
    private String contactSummary;//联系纪要
    private String nextContactTime;//下次联系时间

}
