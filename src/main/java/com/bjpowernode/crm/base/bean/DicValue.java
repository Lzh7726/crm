package com.bjpowernode.crm.base.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.util.List;

@Data
@Table(name = "tbl_dic_value")
@NameStyle(Style.normal)
public class DicValue {
    @Id
    private String id;
    private String value;
    private String text;
    private String orderNo;
    private String typeCode;

    private List<String> appellations;//称呼
    private List<String> clueStates;//线索状态
    private List<String> returnPrioritys;//回访优先级
    private List<String> returnStates;//回访状态
    private List<String> sources;//来源
    private List<String> stages;//阶段
    private List<String> transactionTypes;//交易类型







}
