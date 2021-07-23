package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.base.bean.ResultVo;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.workbench.bean.Transaction;
import com.bjpowernode.crm.workbench.bean.TransactionHistory;

import java.util.List;

public interface TransactionService {
    List<String> queryCustomerNames(String customerName);

    ResultVo createTransaction(Transaction transaction, User user);

    List<Transaction> selectCustomerTransactionInfo(String id);

    int deleteTransaction(String id);

    List<TransactionHistory> queryHistory(String id);
}
