package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;
import java.util.List;

@Data
@Table(name = "t_role")
@NameStyle(Style.normal)
public class Role {
    @Id
    private String id;
    private String role_name;

    //角色所拥有的所有权限集合
    private List<Permission> permissionList;

}
