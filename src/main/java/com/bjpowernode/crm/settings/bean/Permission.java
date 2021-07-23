package com.bjpowernode.crm.settings.bean;

import lombok.Data;
import tk.mybatis.mapper.annotation.NameStyle;
import tk.mybatis.mapper.code.Style;

import javax.persistence.Id;
import javax.persistence.Table;

@Data
@Table(name = "t_permission")
@NameStyle(Style.normal)
public class Permission {
    @Id
    private String id;
    private String per_name;
    private String url;
    private String code;
    private String create_time;
    private String parent_id;

}
