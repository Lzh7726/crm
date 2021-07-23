package com.bjpowernode.shiro.realm;


import com.bjpowernode.crm.settings.bean.Role;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;

import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;

public class CustomRealm extends AuthorizingRealm {
    @Autowired
    private UserService userService;


    //认证
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {

        //获取用户登录身份
        String principal = (String)token.getPrincipal();

        User user = userService.verifyPrincipal(principal);
        Session session = SecurityUtils.getSubject().getSession();//获取用户现有session
        if (user == null) {
            session.setAttribute("msg","账号不存在");
            return null;
        }


        session.setAttribute("user",user);//向session域中加入新内容：user对象
    //参数可以放盐值,此处略去.
        return new SimpleAuthenticationInfo(user,user.getLoginPwd(),"customRealm");
    }


    //授权
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        //工厂查询身份(用户)
        /*此处不能直接转为String,否则在页面会出现User类无法转为String的类型转换异常,
        此处返回的是Object类型,但是封装了User的信息,因此应该转为User类型*/
        User user1 = (User)principalCollection.getPrimaryPrincipal();
        String loginAct = user1.getLoginAct();
        //查询用户所对应的所有角色
        User user = userService.findRolesByUserName(loginAct);

        //非空判断
        if(user != null){
            //情况
            SimpleAuthorizationInfo perInfo = new SimpleAuthorizationInfo();
            //取出user对象中的角色集合
            List<Role> roles = user.getRoles();
            //遍历角色对象集合
            for (Role role : roles) {
               //将角色名称放入权限聚合对象
                perInfo.addRole(role.getRole_name());
              /*  //根据角色id查询角色对象
                Role role1 = userService.findPermissionsByRoleId(role.getId());
                //取出角色对象中的权限对象集合
                List<Permission> perms = role1.getPermissionList();
                if (!CollectionUtils.isEmpty(perms)){
                    //遍历权限对象集合
                    for (Permission perm : perms) {
                        perInfo.addStringPermission(perm.getCode());
                    }
                }*/
            }
            //用户的所有角色和权限都已放入聚合对象，返回。
            return perInfo;
        }
        //情况二：为空，返回null
        return null;
    }



}
