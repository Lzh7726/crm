package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
//客户(一般是公司)的联系人
@Data
@Table(name = "tbl_contacts")
@NameStyle(Style.normal)
public class Contacts  implements Serializable {
    @Id
    private String id;
    private String owner;
    private String source;
    private String customerId;
    private String fullname;
    private String appellation;
    private String email;
    private String mphone;
    private String job;
    private String birth;
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String description;
    private String contactSummary;
    private String nextContactTime;
    private String address;

}
