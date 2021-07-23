package com.bjpowernode.crm.base.exception;

public class CrmException extends RuntimeException {


    private CrmEnum crmEnum;

    public CrmException(CrmEnum crmEnum) {
        //super调用父类的构造方法，是把错误信息放入到堆栈中
        super(crmEnum.getMessage());
        this.crmEnum = crmEnum;
    }
}
