package com.bjpowernode.crm.workbench.bean;


import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

//线索字典表
@Data
@Table(name = "tbl_clue_remark")
@NameStyle(Style.normal)
public class ClueRemark {

    @Id
    private String id;
    private String noteContent;//需要注意的内容
    private String createBy;
    private String createTime;
    private String editBy;
    private String editTime;
    private String editFlag;
    private String clueId;
    private String img;
    @Transient
    private String fullname;
    @Transient
    private String appellation;
    @Transient
    private String company;


}
