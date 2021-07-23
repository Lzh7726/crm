package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Table(name = "t_role_permission")
@NameStyle(Style.normal)
public class RolePermission {
    @Id
    private String id;
    private String role_id;
    private String p_id;

}
