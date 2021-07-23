package com.bjpowernode.crm.base.bean;

import lombok.Data;

import java.util.List;

/*为页面柱形图提供数据的实体类，这些数据不仅仅只是从数据库查询出来，并且需要做成页面容易匹配元素的格式*/
@Data
public class BarVo {
                private List<String> titles;//横轴（保存数据库字段：交易阶段的名称）
                private String stage;//交易阶段的名称
                private List<Integer> data;//纵轴（数据库字段的值）
                private Integer num;//正处在某个交易阶段的客户的数量
                 /*数据和标题分别对应数据库里面的内容：数据对应正某个交易阶段的客户的数量（有很多客户，他们正处在不同的交易阶段），
                                    标题对应阶段
                                    即，正处在stage阶段的客户的数量是num个*/
}
