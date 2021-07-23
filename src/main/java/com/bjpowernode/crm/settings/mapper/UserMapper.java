package com.bjpowernode.crm.settings.mapper;


import com.bjpowernode.crm.settings.bean.Role;
import com.bjpowernode.crm.settings.bean.User;
import tk.mybatis.mapper.common.Mapper;

public interface UserMapper extends Mapper<User> {
    //根据用户名查询用户
    User verifyPrincipal (String principal);
    //根据用户名查询用户对象(包含所对应的所有角色对象)
    User findRolesByUserName(String userName);
    //根据角色id查询角色对象(包含权限对象集合)
    Role findPermissionsByRoleId(String roleId);

}
