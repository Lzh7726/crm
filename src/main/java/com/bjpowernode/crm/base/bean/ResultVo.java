package com.bjpowernode.crm.base.bean;

import lombok.Data;

import java.util.List;

@Data
public class ResultVo<T> {

    private boolean isOk;
    private String message;

    private T t;//任何类型 存储单个数据
    private List<T> list;

}
