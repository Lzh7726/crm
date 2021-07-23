package com.bjpowernode.crm.base.exception;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;


/**
 * 001:用户模块
 * 001-001
 * 001-002
 * 002:市场活动模块
 */
public enum CrmEnum {

    LOGIN_ACCOUNT("001-001","用户名或密码错误"),
    LOGIN_EXPIRE("001-002","账号失效了"),
    LOGIN_LOCKED("001-003","账号被锁定，请联系管理员"),
    LOGIN_ALLOW_IP("001-004","不允许登录的IP"),
    LOGIN_VERIFY_PWD("001-005","原始密码输入不正确"),
    UPLOAD_SUFFIX("001-006","只能上传png,gif,bmp,jpeg后缀名文件"),
    UPLOAD_MAX_SIZE("001-007","上传文件大小必须<=2M"),
    ACTIVITY_INSERT("002-001","添加市场活动失败"),
    ACTIVITY_UPDATE("002-002","修改市场活动失败"),
    ACTIVITY_DELETE("002-003","删除市场活动失败"),
    CLUE_CONVERT("003-001","线索转换失败"),
    CUSTOMER_INSERT("003-001","添加客户信息失败"),
    CUSTOMER_UPDATE("003-002","修改客户信息失败"),
    CUSTOMER_DELETE("003-003","删除客户信息失败"),
    CUSTOMER_NONENTITY("003-004","客户不存在"),
    TRANSACTION_INSERT("004-001","创建交易失败" ),
    TRANSACTION_UPDATE("004-001","更新交易失败" ),
    TRANSACTION_DELETE("004-001","删除交易失败" ),
    CLUE_INSERT("005-001","添加线索失败"),
    CLUE_UPDATE("005-002","更新线索失败"),
    CLUE_DELETE("005-003","删除线索失败"),
    CLUE_ACTIVITY_INSERT("006-001","添加线索和市场活动的关联关系失败"),
    CLUE_ACTIVITY_UPDATE("006-002","更新线索和市场活动的关联关系失败"),
    CLUE_ACTIVITY_DELETE("006-003","删除线索和市场活动的关联关系失败"),
    CLUE_REMARK_DELETE("007-001","删除线索备注失败"),
    ACTIVITY_REMARK_DELETE("008-001","删除市场活动备注失败");



    private String message;
    private String typeCode;

    CrmEnum( String typeCode,String message) {
        this.message = message;
        this.typeCode = typeCode;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }}
