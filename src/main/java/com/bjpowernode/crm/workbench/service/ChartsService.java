package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.BarVo;
import com.bjpowernode.crm.base.bean.PieVo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface ChartsService {
    BarVo transactionBarEcharts();

    List<PieVo> transactionPieEcharts();
}
