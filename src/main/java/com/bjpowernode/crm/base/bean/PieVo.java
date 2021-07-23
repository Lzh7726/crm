package com.bjpowernode.crm.base.bean;

import lombok.Data;
/*为页面圆饼图提供数据的实体类，这些数据不仅仅只是从数据库查询出来，并且需要做成页面容易匹配元素的格式*/
@Data
public class PieVo {
    private String name;//所处阶段名称（等同于BarVo中的stage）
    private Integer value;//处在某一阶段的客户数量（等同于BarVo中的num）
}
