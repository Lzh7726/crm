package com.bjpowernode.crm.workbench.controller;


import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.base.exception.CrmException;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.bean.TransactionHistory;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class TransactionController {


    @Autowired
    private TransactionService transactionService;

    //自动补全查询
    @RequestMapping("/workbench/transaction/queryCustomerNames")
    @ResponseBody
    public List<String> queryCustomerNames(String customerName) {

        List<String> customerNames = transactionService.queryCustomerNames(customerName);

        return customerNames;
    }

    // 新建交易并不是模态框，而是一个新的页面，此页面在WEB-INF下，需要发送请求，由服务器进行转发。
    @RequestMapping("/workbench/transaction/toCreateTransaction")
    public String toCreateTransaction() {

        return "/workbench/transaction/save";
    }

    //为客户创建交易，如果客户不存在，则创建新客户。
    @RequestMapping("/workbench/transaction/createTransaction")
    @ResponseBody
    public ResultVo createTransaction(Transaction transaction, HttpSession session) {
        ResultVo resultVo = new ResultVo();


        try {
            User user = (User) session.getAttribute("user");
            resultVo = transactionService.createTransaction(transaction, user);
        } catch (CrmException e) {
            resultVo.setMessage(e.getMessage());
        }


        resultVo.setOk(true);
        return resultVo;
    }

    //客户信息详情页：加载与客户相关的交易信息

    @RequestMapping("/workbench/transaction/transactionInfo")
    @ResponseBody
    public List<Transaction> transactionInfo(String id) {
        List<Transaction> list = transactionService.selectCustomerTransactionInfo(id);
        return list;

    }

    //删除交易
    @RequestMapping("/workbench/transaction/deleteTransaction")
    @ResponseBody
    public Integer deleteTransaction(String id) {

        int result = transactionService.deleteTransaction(id);
        return result;

    }

    //查询阶段对应的可能性
    @RequestMapping("/workbench/transaction/queryPossibility")
    @ResponseBody
    public String queryPossibility(String stage, HttpSession session) {
        Map<String, String> stage2Possibility = (Map<String, String>) session.getServletContext().getAttribute("stage2Possibility");
        return stage2Possibility.get(stage);
    }

    //异步查询交易历史信息
    @RequestMapping("/workbench/transaction/queryHistory")
    @ResponseBody
    public List<TransactionHistory> queryHistory(String id) {
        List<TransactionHistory> transactionHistories = transactionService.queryHistory(id);
        return transactionHistories;
    }

  /*  @RequestMapping("/workbench/transaction/stageList")
    @ResponseBody
    public ResultVo stageList(String id, HttpSession session, Integer position) {
        User user = (User) session.getAttribute("user");
        Map<String, String> stage2Possibility = (Map<String, String>) session.getServletContext().getAttribute("stage2Possibility");
        ResultVo resultVo = transactionService.stageList(id, stage2Possibility, position, user);
        return resultVo;
    }*/

   /* //导出报表
    @RequestMapping("/workbench/transaction/exportExcel")
    public void exportExcel(HttpSession session, HttpServletResponse response) {
 *//*       //导出到服务器端
        ResultVo resultVo = new ResultVo();
        try{
            String realPath = session.getServletContext().getRealPath("/excel/transaction");
            File file = new File(realPath);
            if(!file.exists()){
                file.mkdirs();
            }
            transactionService.exportExcel(realPath);
            resultVo.setOk(true);
            resultVo.setMessage("导出报表成功");
        }catch (Exception e){
            e.printStackTrace();
        }*//*

        //客户端下载报表
        ResultVo resultVo = new ResultVo();
        try {
            ExcelWriter writer = ExcelUtil.getWriter();

            transactionService.writeToClient(writer);
            //response为HttpServletResponse对象
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            //test.xls是弹出下载对话框的文件名，不能为中文，中文请自行编码 attachment:附件
            response.setHeader("Content-Disposition", "attachment;filename=test.xls");
            ServletOutputStream out = response.getOutputStream();

            writer.flush(out, true);
            // 关闭writer，释放内存
            writer.close();
            //此处记得关闭输出Servlet流
            IoUtil.close(out);
            resultVo.setOk(true);
            resultVo.setMessage("导出报表成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }*/
}
