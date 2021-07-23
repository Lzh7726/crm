package com.bjpowernode.crm.test;

import com.bjpowernode.crm.base.exception.CrmEnum;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.MD5Util;
import com.bjpowernode.crm.base.util.UUIDUtil;
import com.bjpowernode.crm.settings.bean.Permission;
import com.bjpowernode.crm.settings.bean.Role;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.workbench.bean.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import org.junit.Test;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import tk.mybatis.mapper.entity.Example;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
/*测试类启动前，应该注释掉com.bjpowernode.crm.base.cache.CrmCache下注入的
    @Autowired
   private ServletContext servletContext;
   因为ServletContext是一个接口，无法被实例化（暂不追究：既然不能被实例化，为何注入却不会出现问题的问题）*/

public class CrmTest {

    BeanFactory beanFactory = new ClassPathXmlApplicationContext("classpath:spring/spring-context.xml");
    UserMapper userMapper = (UserMapper) beanFactory.getBean("userMapper");
    ContactsMapper contactsMapper = (ContactsMapper) beanFactory.getBean("contactsMapper");
    //tkMapper的添加操作
    @Test
    public void test01(){

        User user = new User();
        user.setId(UUIDUtil.getUUID());
        user.setLoginAct("lisi");
        user.setLoginPwd(MD5Util.getMD5(""));
        //只插入非空字段
        userMapper.insertSelective(user);
    }

    //测试UUID
    @Test
    public void test02(){
        String uuid = UUID.randomUUID().toString().replace("-","");
        System.out.println(uuid);
    }

    //测试密码加密 md5 + 加盐
    @Test
    public void test03(){
        String password = "1234";
        String md5 = MD5Util.getMD5(password);

        System.out.println(md5);
    }

    //测试修改
    @Test
    public void test04(){
        User user = new User();
        user.setId("0dffe93101bc4e1db4fd9245db92f020");
        user.setEmail("2655904102@qq.com");
        Example example = new Example(User.class);
        //参数1:实体类属性名
        example.createCriteria().andEqualTo("id",user.getId());
        userMapper.updateByExampleSelective(user,example);
      //  userMapper.updateByPrimaryKeySelective(user);
    }

    //测试删除
    @Test
    public void test05(){
        //直接给定主键删除
        // userMapper.deleteByPrimaryKey();
        User user = new User();
        user.setId("ab5c0ca21f944acdbe3467ac18cc526d");
        user.setEmail("2655904102@qq.com");
        //只能做等值判断
//        userMapper.delete(user);
        Example example = new Example(User.class);
        example.createCriteria().andEqualTo("id",user.getId());
        userMapper.deleteByExample(example);
    }


    //测试查询
    @Test
    public void test06(){
        //1、根据主键查询
       /* User user = userMapper.selectByPrimaryKey("ba3a6452690943f58d909fb2c9b88337");

        System.out.println(user);*/

       //2、查询所有
       /* List<User> users = userMapper.selectAll();
        System.out.println(users);*/

       //3、条件模糊查询 id=ba3a6452690943f58d909fb2c9b88337
        Example example = new Example(User.class);
        //链式调用(导航调用) %:0-n个 _:1个
        String loginAct = "zhang";
        example.createCriteria().andLike("loginAct","%" + loginAct + "%")
        .andEqualTo("id","ba3a6452690943f58d909fb2c9b88337");
        List<User> users = userMapper.selectByExample(example);
        System.out.println(users);
    }

    //测试自定义异常
    @Test
    public void test07(){
        int a = 0;
        try{
            if(a == 0){
                throw new CrmException(CrmEnum.LOGIN_EXPIRE);
            }
        }catch (CrmException e){
            System.out.println(e.getMessage());
        }

    }

    //字符串日期类型的大小比较

    /**
     * 字符串日期类型的比较
     * d1 d2
     * d1 > d2 : >0的结果
     * d1==d2:==0
     * d1 < d2 : < 0的结果
     * 3099-06-11
     * 2021-06-11
     */
    @Test
    public void test08(){
        String expireTime = "3099-06-11";
        String now = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        System.out.println(expireTime.compareTo(now));
    }

    @Test
    public void test09(){
        System.out.println(File.separator);
    }

    @Test
    public void test10(){
        String fileName ="121212.png";
        System.out.println(fileName.substring(fileName.lastIndexOf(".")+1));
    }
    @Test
    public void test11(){
        //参数id既是customer对应表的主键，又是contacts的外键
        Example example = new Example(Contacts.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("customerId","2716371e835046ff9af34316f0b0fa85");
        List<Contacts> contacts = contactsMapper.selectByExample(example);
        System.out.println("contacts =******************** " + contacts);
    }
    @Test
    public void test12(){
        User user = userMapper.findRolesByUserName("lisi");
        System.out.println("==============================");
        List<Role> roles = user.getRoles();
        for (Role role : roles) {
            System.out.println("*****roleName = " + role.getRole_name());
          /*Role role1 = userMapper.findPermissionsByRoleId(role.getId());
            List<Permission> pers = role1.getPermissionList();
            for (Permission per : pers) {
                System.out.println("*****"+per.getPer_name());
            }*/

        }
        System.out.println("===============================");
        }


}
