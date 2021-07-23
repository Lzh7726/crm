package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Table(name = "t_user_role")
@NameStyle(Style.normal)
public class UserRole {
    @Id
    private String id;
    private String user_id;
    private String role_id;

}
