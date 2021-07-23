package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.base.bean.BarVo;
import com.bjpowernode.crm.base.bean.PieVo;
import com.bjpowernode.crm.workbench.mapper.ChartsMapper;
import com.bjpowernode.crm.workbench.service.ChartsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
@Service
public class ChartsServiceImpl implements ChartsService {
    @Autowired
    private ChartsMapper chartsMapper;
    @Override
    public BarVo transactionBarEcharts() {
        List<BarVo> barVos = chartsMapper.barVoEcharts();
        List<String> titles = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        BarVo barVo = new BarVo();
        for (BarVo vo : barVos) {
            titles.add(vo.getStage());
            data.add(vo.getNum());
        }
        barVo.setTitles(titles);
        barVo.setData(data);
        return barVo;
    }

    @Override
    public List<PieVo> transactionPieEcharts() {
        List<PieVo> pieVos = chartsMapper.PieVoEcharts();
        return pieVos;
    }
}
