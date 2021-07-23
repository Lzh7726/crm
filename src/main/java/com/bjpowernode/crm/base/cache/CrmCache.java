package com.bjpowernode.crm.base.cache;

import com.bjpowernode.crm.base.bean.DicType;
import com.bjpowernode.crm.base.bean.DicValue;
import com.bjpowernode.crm.base.mapper.DicTypeMapper;
import com.bjpowernode.crm.base.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.bean.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import tk.mybatis.mapper.entity.Example;
import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller
 * Service
 * Repository:Hibernate
 * Component:标注任意组件(对象)
 */
@Component
public class CrmCache {

    @Autowired
    private DicTypeMapper dicTypeMapper;

    @Autowired
    private DicValueMapper dicValueMapper;
    //如果需要测试，则需要注释掉，因为这是一个接口无法被实例化。
 @Autowired
    private ServletContext servletContext;

    @Autowired
    private UserMapper userMapper;


    //该方法在服务器启动的时候要调用
    @PostConstruct
    public void init(){

        //查询所有者信息
        List<User> users = userMapper.selectAll();
  servletContext.setAttribute("users",users);
     //方式一:使用Map<String,List<DicValue>>
        //先查询字典类型
        List<DicType> dicTypes = dicTypeMapper.selectAll();

        //定义一个map存储类型和值
        Map<String,List<DicValue>> dics = new HashMap<>();
        for (DicType dicType : dicTypes) {
            //查询类型对应的值
            String code = dicType.getCode();

            Example example = new Example(DicValue.class);
            example.setOrderByClause("orderNo asc");
            example.createCriteria().andEqualTo("typeCode",code);
            List<DicValue> dicValues = dicValueMapper.selectByExample(example);
            dics.put(code,dicValues);
        }
    servletContext.setAttribute("dics",dics);
      //方式二:List<DicType>
       /* List<DicType> dicTypes = dicTypeMapper.selectAll();
        for (DicType dicType : dicTypes) {
            //查询类型对应的值
            String code = dicType.getCode();
            DicValue dicValue = new DicValue();
            dicValue.setTypeCode(code);
            List<DicValue> dicValues = dicValueMapper.select(dicValue);
            dicType.setDicValues(dicValues);
        }
        servletContext.setAttribute("dicTypes",dicTypes);*/
    }
}
