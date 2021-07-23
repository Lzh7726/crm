package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
//线索与市场活动相关联的类
@Data
@Table(name = "tbl_clue_activity_relation")
@NameStyle(Style.normal)
public class ClueActivity {
    @Id
    private String id;
    private String clueId;
    private String activityId;

}
