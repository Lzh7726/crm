package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
//联系人备注
@Data
@Table(name = "tbl_contacts_remark")
@NameStyle(Style.normal)
public class ContactsRemark {

    @Id
    private String id;
    private String noteContent;//需要注意的内容
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String editFlag;
    private String contactsId;

}
