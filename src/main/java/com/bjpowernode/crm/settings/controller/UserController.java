package com.bjpowernode.crm.settings.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.base.util.FileUploadUtil;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


@Controller
public class UserController {

    @Autowired
    private UserService userService;

/*    @RequestMapping("/settings/user/login")
    @ResponseBody
    public ResultVo login(User user, HttpServletRequest request, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            //获取用户登录的IP  127.0.0.1,0:0:0:0:0:0:0:1
            String remoteAddr = request.getRemoteAddr();
            user.setAllowIps(remoteAddr);
            user = userService.login(user);
            resultVo.setOk(true);
            session.setAttribute("user",user);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }*/

    /*登录:UserControllerd校验账号密码的功能转移到了CustomRealm,此处只负责接受CustomRealm返回的
    结果，并反馈给页面。实际上只有当认证失败,才会重回此方法.认证成功去往successUrl,不再回到此方法.*/
    @RequestMapping("/settings/user/login")
    public String login(HttpServletRequest request) {
        //如果登陆失败从request中获取认证异常信息，shiroLoginFailure就是shiro异常类的全限定名
        String exceptionClassName = (String) request.getAttribute("shiroLoginFailure");
        //根据shiro返回的异常类路径判断，抛出指定异常信息
        if (exceptionClassName != null) {//!=null即说明认证失败:给出提示信息.
            if (UnknownAccountException.class.getName().equals(exceptionClassName)) {
                //最终会抛给异常处理器
                request.setAttribute("msg", "账号不存在");
                /*throw new CustomException("账号不存在");*/
            } else if (AuthenticationException.class.getName().equals(exceptionClassName)) {
                //最终会抛给异常处理器
                request.setAttribute("msg", "账号已作废");
            } else if (IncorrectCredentialsException.class.getName().equals(
                    exceptionClassName)) {
                request.setAttribute("msg", "密码错误");
                /*throw new CustomException("密码错误");*/
            } else if ("randomCodeError".equals(exceptionClassName)) {
                request.setAttribute("msg", "验证码错误");
                /*throw new CustomException("验证码错误");*/
            }
            return "../login";//域中异常对象不为空：认证失败,返回登录页面
        }
        return "workbench/index";/*域中异常对象为空：两种情况①第一次登陆，则认证成功，但不会执行到这里，而是去往successUrl
    ②第N次登陆如果带了上次已经成功登陆的session，则不会被拦截，并且域中异常对象依然为空，就会执行到这里。所以此处直接设置为登陆成功后的首页(静态页面)。*/
    }

    @RequestMapping("/settings/user/index")//配置的successUrl不能直接设置为静态页面，因为无权限，需要做站内跳转。
    public String index() {
        return "workbench/index";
    }


    //清空session,返回登录页(登出,从其他页面返回登录页等)
    @RequestMapping("/settings/user/loginOut")
    public String loginOut() {
        SecurityUtils.getSubject().logout();
        return "redirect:/login.jsp";
    }

    //异步校验用户输入的原始密码是否正确
    @RequestMapping("/settings/user/verifyOldPwd")
    @ResponseBody
    public ResultVo verifyOldPwd(User user) {
        ResultVo resultVo = new ResultVo();
        try {
            userService.verifyOldPwd(user);
            resultVo.setOk(true);
        } catch (CrmException e) {
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }


    //异步上传文件
    @RequestMapping("/settings/user/fileUpload")
    @ResponseBody
    //多文件上传MultipartFile[]即可
    public ResultVo fileUpload(MultipartFile[] img, HttpServletRequest request) {
        ResultVo resultVo = FileUploadUtil.fileUpload(img, request);
        return resultVo;
    }


    //更新密码和头像
    @RequestMapping("/settings/user/updatePwd")
    @ResponseBody
    public ResultVo updatePwd(User user, HttpSession session) {
        ResultVo resultVo = new ResultVo();
        User user1 = (User) session.getAttribute("user");
        user.setId(user1.getId());
        userService.updatePwd(user);
        resultVo.setOk(true);
        resultVo.setMessage("更新密码成功!");
        return resultVo;
    }

}
