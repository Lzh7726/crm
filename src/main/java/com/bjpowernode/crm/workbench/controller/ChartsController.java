package com.bjpowernode.crm.workbench.controller;

import com.bjpowernode.crm.base.bean.BarVo;
import com.bjpowernode.crm.base.bean.PieVo;
import com.bjpowernode.crm.workbench.service.ChartsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController()
public class ChartsController {
    @Autowired
    private ChartsService chartsService;

    @RequestMapping("/workbench/chart/transactionBarEcharts")
    public BarVo transactionBarEcharts() {

        return chartsService.transactionBarEcharts();
    }

    @RequestMapping("/workbench/chart/transactionPieEcharts")
    public List<PieVo> transactionPieEcharts() {

        return chartsService.transactionPieEcharts();
    }
}
