package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.bean.Role;
import com.bjpowernode.crm.settings.bean.User;

public interface UserService {
    /*//登录:shiro代理了登录,此处作废.
    User login(User user);*/
    //修改密码:查询原有密码
    void verifyOldPwd(User user);
    //修改密码
    void updatePwd(User user);
    //查询user(根据用户名)
    User verifyPrincipal(String principal);
    //查询user所拥有的所有role
    User findRolesByUserName(String userName);
    //根据角色id查询角色对象(包含角色对应的所有权限对象信息)
   Role findPermissionsByRoleId(String roleId);
}
