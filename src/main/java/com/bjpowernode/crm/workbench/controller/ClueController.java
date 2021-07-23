package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.bean.ClueRemark;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class ClueController {

    @Autowired
    private ClueService clueService;


    //查询(条件)线索信息
    @RequestMapping("/workbench/clue/list")
    @ResponseBody
    public PageInfo list(Integer page, Integer pageSize, Clue clue){
        PageInfo<Clue> pageInfo = clueService.list(clue,page,pageSize);

        return pageInfo;
    }
    //根据主键查询线索信息
    @RequestMapping("/workbench/clue/queryClueById")
    @ResponseBody
    public Clue queryClueById(String id) {

        return clueService.queryClueById(id);
    }
    /*//添加线索(创建和删除功能已合并)
    @RequestMapping("/workbench/clue/saveClue")
    @ResponseBody
    public ResultVo saveClue(Clue clue, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            clueService.saveClue(clue,user);
            resultVo.setOk(true);
            resultVo.setMessage("添加线索成功");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }*/
    //显示线索信息
    @RequestMapping("/workbench/clue/toDetail")
    @ResponseBody
    private Clue toDetail(String id){
        Clue clue = clueService.toDetail(id);
        return clue;
    }

    //创建备注

    @RequestMapping("/workbench/clue/saveClueRemark")
    @ResponseBody
    public ResultVo saveClueRemark(ClueRemark clueRemark, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            clueRemark = clueService.saveClueRemark(clueRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("添加线索备注成功！");
            resultVo.setT(clueRemark);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
    //修改备注
    @RequestMapping("/workbench/clue/updateClueRemark")
    @ResponseBody
    public ResultVo updateClueRemark(ClueRemark clueRemark,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            clueService.updateClueRemark(clueRemark,user);
            resultVo.setOk(true);
            resultVo.setMessage("修改线索备注成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
    //删除备注
    @RequestMapping("/workbench/clue/deleteClueRemark")
    @ResponseBody
    public ResultVo deleteClueRemark(String id){
        ResultVo resultVo = new ResultVo();
        try{

           clueService.deleteClueRemark(id);
            resultVo.setOk(true);
            resultVo.setMessage("删除线索备注信息成功！");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //异步 更新/添加 线索
    @RequestMapping("/workbench/clue/saveOrUpdateClue")
    @ResponseBody
    public ResultVo saveOrUpdateClue(Clue clue, HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");

            resultVo = clueService.saveOrUpdateClue(clue,user);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
    @RequestMapping("/workbench/clue/deleteClues")
    @ResponseBody
    public ResultVo deleteClues(String ids){
        ResultVo resultVo = new ResultVo();
        try{
            resultVo = clueService.deleteClues(ids);
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //异步查询线索关联市场活动
    @RequestMapping("/workbench/clue/queryRelationActivities")
    @ResponseBody
    public List<Activity> queryRelationActivities(String id,String name){
        return clueService.queryActivities(id,name);
    }

    //线索详情页的模糊查询市场活动
    @RequestMapping("/workbench/clue/queryUnBindActivities")
    @ResponseBody
    public List<Activity> queryUnBindActivities(String id,String name){
        return clueService.queryUnBindActivities(id,name);
    }
/*

    //线索转换页的模糊查询市场活动
    @RequestMapping("/workbench/clue/queryBindActivity")
    @ResponseBody
    public List<Clue> queryBindClue(String id,String name){
        return clueService.queryBindClue(id,name);
    }
*/


    //绑定
    @RequestMapping("/workbench/clue/bind")
    @ResponseBody
    public ResultVo bind(String id,String ids){
        ResultVo resultVo = new ResultVo();
        try{
            clueService.bind(id,ids);
            resultVo.setOk(true);
            resultVo.setMessage("绑定市场活动成功");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //解绑
    @RequestMapping("/workbench/clue/unbind")
    @ResponseBody
    public ResultVo unbind(String id,String aid){
        ResultVo resultVo = new ResultVo();
        try{
            clueService.unbind(id,aid);
            resultVo.setOk(true);
            resultVo.setMessage("解绑市场活动成功");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    //跳转到线索转换页面
    @RequestMapping("/workbench/clue/toConvert")
    public String toConvert(String id, Model model){
        Clue clue = clueService.toConvert(id);
        model.addAttribute("clue",clue);
        return "workbench/clue/convert";
    }

    //线索转换
    @RequestMapping("/workbench/clue/convert")
    @ResponseBody
    public ResultVo convert(String id, String isTransaction, Transaction transaction,HttpSession session){
        ResultVo resultVo = new ResultVo();
        try{
            User user = (User) session.getAttribute("user");
            clueService.convert(id,isTransaction,transaction,user);
            resultVo.setOk(true);
            resultVo.setMessage("线索转换成功,3秒后返回线索列表页面。");
        }catch (CrmException e){
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }
}
