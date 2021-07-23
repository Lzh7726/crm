package com.bjpowernode.crm.base.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Enumeration;
import java.util.Map;

/**
 * 负责视图跳转的Controller
 */
@Controller
public class ViewController {

    @RequestMapping("/testRestFul/{username}/{password}")
    public void testRestFul(@PathVariable("username") String username,@PathVariable("password") String password){
        System.out.println(username+":"+password);
    }

    @RequestMapping(value = {"/toView/{firstView}/{secondView}",
            "/toView/{firstView}/{secondView}/{thirdView}",
            "/toView/{firstView}/{secondView}/{thirdView}/{fourthView}"})
    public String toView(@PathVariable(value = "firstView",required = false) String firstView,
                         @PathVariable(value = "secondView",required = false) String secondView,
                         @PathVariable(value = "thirdView",required = false) String thirdView,
                         @PathVariable(value = "fourthView",required = false) String fourthView,
                         HttpServletRequest request){


        //获取前台所有参数的name值
        Enumeration parameterNames = request.getParameterNames();

        //遍历枚举
        while (parameterNames.hasMoreElements()){
            String name = (String) parameterNames.nextElement();
            String value = request.getParameter(name);

            request.setAttribute(name,value);
        }



        if(thirdView == null){
            return firstView + File.separator + secondView;
        }
        if(fourthView == null){
            return firstView + File.separator + secondView + File.separator + thirdView;
        }
        return firstView + File.separator + secondView + File.separator + thirdView + File.separator + fourthView;
    }
}
