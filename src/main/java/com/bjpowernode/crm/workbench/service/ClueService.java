package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Activity;
import com.bjpowernode.crm.workbench.bean.Clue;
import com.bjpowernode.crm.workbench.bean.ClueRemark;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ClueService {
    PageInfo<Clue> list(Clue clue, int page, int pageSize);
    void saveClue(Clue clue, User user);

    List<Activity> queryActivities(String id,String name);
    ResultVo saveOrUpdateClue(Clue clue, User user);

    List<Activity> queryUnBindActivities(String id,String name);

    void bind(String id, String ids);

    void unbind(String id, String aid);

    Clue toConvert(String id);

    void convert(String id, String isTransaction, Transaction transaction,User user);

    List<Activity> queryBindClue(String id,String name);

    Clue queryClueById(String id);

    ResultVo deleteClues(String id);

    Clue toDetail(String id);

    ClueRemark saveClueRemark(ClueRemark clueRemark, User user);

    void deleteClueRemark(String id);

    void updateClueRemark(ClueRemark clueRemark, User user);
}
