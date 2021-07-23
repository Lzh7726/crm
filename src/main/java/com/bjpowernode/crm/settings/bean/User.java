package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.util.List;

@Data
@Table(name = "tbl_user")
@NameStyle(Style.normal)
public class User {

    //比较主键
    @Id
    private String id;//采用UUID方式生成的长度为32位永远不重复的字符串序列
    private String loginAct;//登录账户
    private String name;//昵称
    private String loginPwd;//登录密码 加密md5加密
    private String salt;//盐
    private String email;
    /**
     * 日期可以给定字符串，也可以给定日期类型
     * 如果时间用于计算的时候，给定日期类型
     * 如果时间只是用来显示给用户看，给字符串类型
     */
    private String expireTime;//失效时间 char:19 yyyy-MM-dd hh:mm:ss
    private String lockState;//账号是否被锁定 0:被锁定
    private String deptno;//部门编号
    private String allowIps;//允许登录的ip 192.168.10.123,192.168.22.30
    private String createTime;//创建时间
    private String createBy;//创建者
    private String editTime;//编辑时间
    private String editBy;//编辑者
    private String img;//用户头像

    //所具有的角色集合
    private List<Role> roles;

}
