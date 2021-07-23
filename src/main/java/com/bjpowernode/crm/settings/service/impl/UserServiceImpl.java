package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.DateTimeUtil;
import com.bjpowernode.crm.base.util.MD5Util;
import com.bjpowernode.crm.settings.bean.Permission;
import com.bjpowernode.crm.settings.bean.Role;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    //shiro安全管理代理了登录,此处作废.
   /* @Override
    public User login(User user) {
        String loginIp = user.getAllowIps();
        //加密密码
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        Example example = new Example(User.class);
        example.createCriteria().andEqualTo("loginAct",user.getLoginAct())
                .andEqualTo("loginPwd",user.getLoginPwd());
        List<User> users = userMapper.selectByExample(example);


        if(users.size() == 0){
            //账号输入错误
            throw new CrmException(CrmEnum.LOGIN_ACCOUNT);
        }else{
            user = users.get(0);
            //账号是否失效
            if(user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) < 0){
                throw new CrmException(CrmEnum.LOGIN_EXPIRE);
            }
            //账号是否被锁定
            if("0".equals(user.getLockState())){
                throw new CrmException(CrmEnum.LOGIN_LOCKED);
            }
            //是否是允许登录ip地址 abcdefg abc
            if(!user.getAllowIps().contains(loginIp)){
                throw new CrmException(CrmEnum.LOGIN_ALLOW_IP);
            }
        }
        return users.get(0);
    }
*/
    @Override
    public void verifyOldPwd(User user) {
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        List<User> users = userMapper.select(user);
        if(users.size() == 0){
            throw new CrmException(CrmEnum.LOGIN_VERIFY_PWD);
        }
    }

    @Override
    public void updatePwd(User user) {
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        userMapper.updateByPrimaryKeySelective(user);
    }

    @Override
    public User verifyPrincipal(String principal) {
        User user=userMapper.verifyPrincipal(principal);
        return user;
    }

    @Override
    public User findRolesByUserName(String userName) {
        User user = userMapper.findRolesByUserName(userName);
        return user;
    }

    @Override
    public Role findPermissionsByRoleId(String roleId) {
        Role role = userMapper.findPermissionsByRoleId(roleId);
        return role;
    }

}
