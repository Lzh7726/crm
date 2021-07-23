package com.bjpowernode.crm.workbench.bean;

import lombok.Data;
//交易阶段的展示类
@Data
public class Stage {

    private String type;//交易图标类型 绿圈、黑圈
    private String content;//交易图标上的文本内容
    private String possibility;//交易可能性
    private String position;//当前交易所处的阶段在所有阶段集合中的索引位置
}
