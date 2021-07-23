package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
//市场活动和联系人的关联类
@Data
@Table(name = "tbl_contacts_activity_relation")
@NameStyle(Style.normal)
public class ContactActivity {

    @Id
    private String id;
    private String contactsId;
    private String activityId;

}
