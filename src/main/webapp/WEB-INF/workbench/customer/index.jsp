<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap-theme.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/npm.js"></script>
    <link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="/crm/jquery/layer.js"></script>
    <%--分页插件--%>
    <link href="/crm/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="/crm/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="/crm/jquery/bs_pagination/en.js" charset="UTF-8"></script>
    <script type="text/javascript">

        $(function () {

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

        });

    </script>

</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1" >创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="saveCustome">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="owner" id="create-customerOwner">
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="name" id="create-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="website" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="phone" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" name="description" id="create-describe"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" name="contactSummary"
                                          id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" name="nextContactTime"
                                       id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address1"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="saveOrUpdateCustomer($('#saveCustome'))">保存
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="editCustomer">
                    <input type="hidden" name="id" id="id"/>
                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;"></span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" name="owner" id="edit-customerOwner">
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="name" id="edit-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="website" id="edit-website">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" name="phone" id="edit-phone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" name="description" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" name="contactSummary"
                                          id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" name="nextContactTime"
                                       id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" name="address" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="saveOrUpdateCustomer($('#editCustomer'))">更新
                </button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
                <input class="form-control" name="name" type="text" >
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" name="name" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" name="owner" type="text" id="careteBy">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" name="phone" type="text" id="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" name="website" type="text" id="website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" onclick="queryCustomer()">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"
                        ><span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" onclick="openUpdateModal()"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" onclick="deleteCustomer()"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="father" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;" id="customerPage">

        </div>

    </div>

</div>
<script>
    var rsc_bs_pag = {
        go_to_page_title: 'Go to page',
        rows_per_page_title: 'Rows per page',
        current_page_label: 'Page',
        current_page_abbr_label: 'p.',
        total_pages_label: 'of',
        total_pages_abbr_label: '/',
        total_rows_label: 'of',
        rows_info_records: 'records',
        go_top_text: '首页',
        go_prev_text: '上一页',
        go_next_text: '下一页',
        go_last_text: '末页'
    };

    (function($){
        $.fn.datetimepicker.dates['zh-CN'] = {
            days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            today: "今天",
            suffix: [],
            meridiem: ["上午", "下午"]
        };
    }(jQuery));

    $(".time").datetimepicker({
        language:  "zh-CN",
        format: "yyyy-mm-dd",//显示格式
        minView: "hour",//设置只显示到月份
        initialDate: new Date(),//初始化当前日期
        autoclose: true,//选中自动关闭
        todayBtn: true, //显示今日按钮
        clearBtn : true,
        pickerPosition: "bottom-left"
    });

   refresh(1, 4);

    //刷新页面(查询客户信息)的方法
    function refresh(page, pageSize) {
        //js函数参数实际上是封装到arguments参数数组中
        /*for(var i = 0; i < arguments.length;i++){
            alert(arguments[i]);
        }*/
        $.get("/crm/workbench/customer/list", {
            'page': page,
            'pageSize': pageSize,
            'name': $('#name').val(),
            'owner': $('#owner').val(),
            'phone': $('#phone').val(),
            'website': $('#website').val()
        }, function (data) {
            $('#customerBody').html("");
            var customers = data.list;
            for (var i = 0; i < customers.length; i++) {
                var customer = customers[i];
                $('#customerBody').append("<tr class=\"customer\">\n" +
                    "\t\t\t\t\t\t\t<td><input value=" + customer.id + " class='son' type=\"checkbox\" /></td>\n" +
                    "\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/customer/detail?id=" + customer.id + "'\">" + customer.name + "</a></td>\n" +
                    "\t\t\t\t\t\t\t<td>" + customer.owner + "</td>\n" +
                    "\t\t\t\t\t\t\t<td>" + customer.phone + "</td>\n" +
                    "\t\t\t\t\t\t\t<td>" + customer.website + "</td>\n" +
                    "\t\t\t\t\t\t</tr>");
            }

            //利用分页插件查询第一页数据
            $("#customerPage").bs_pagination({
                currentPage: data.pageNum, // 页码
                rowsPerPage: data.pageSize, // 每页显示的记录条数
                maxRowsPerPage: 30, // 每页最多显示的记录条数
                totalPages: data.pages, // 总页数
                totalRows: data.total, // 总记录条数
                visiblePageLinks: 3, // 显示几个卡片
                showGoToPage: true,
                showRowsPerPage: true,
                showRowsInfo: true,
                showRowsDefaultInfo: true,
                //回调函数，用户每次点击分页插件进行翻页的时候就会触发该函数
                onChangePage: function (event, obj) {
                    //刷新页面，obj.currentPage:当前点击的页码
                    //pageList(obj.currentPage,obj.rowsPerPage);
                    refresh(obj.currentPage, obj.rowsPerPage);
                }
            });
        }, 'json');
    }


    //条件查询客户信息
    function queryCustomer() {
        refresh(1, 4);
    }


    //点击保存或者更新按钮，异步保存/修改客户信息
    function saveOrUpdateCustomer(form) {

        var form = form.serialize();
        $.post("/crm/workbench/customer/saveOrUpdateCustomer", form, function (data) {
            if (data.ok) {

                layer.alert(data.message, {icon: 6});
                //添加成功，刷新页面
                refresh(1, 4);
            }else {
                layer.alert(data.message, {icon: 5});
            }
        }, 'json');
    }

    //全选和反选 方案一
    /*$('#father').click(function () {
        //判断father是否勾中
        var checked = $(this).prop('checked');
        if(checked){
            //father勾中,son都勾中
            $('.son').each(function () {
                $(this).prop('checked',true);
            });
        }else{
            $('.son').each(function () {
                $(this).prop('checked',false);
            });
        }
    });*/

    //方案二
    $('#father').click(function () {
        //判断father是否勾中
        $('.son').prop('checked', $(this).prop('checked'));
    });

    //son的状态决定father状态，动态生成的元素js会失效的，把子元素的事件委托给父元素(不能是动态生成的)
    //参数1:事件名称 参数2:被绑定的元素 参数3:触发的函数
    $('#customerBody').on('click', '.son', function () {
        //获取勾中的son的个数
        var checkedLength = $('.son:checked').length;
        //获取总个数
        var sonLength = $('.son').length;

        if (checkedLength == sonLength) {
            $('#father').prop('checked', true);
        } else {
            $('#father').prop('checked', false);
        }
    });

    //点击修改按钮，判断son勾中的个数
    /**
     * var obj
     * js-->jquery $(obj)
     * jquery-->js obj[0] obj.get(0)
     */
    function openUpdateModal() {
        var checkedLength = $('.son:checked').length;
        //因为勾中的数据只有一条，直接获取数组的第一个元素，而第一个元素获取后是js对象,value就是勾中数据的主键
        if (checkedLength == 0) {
            layer.alert("至少勾中一条记录!", {icon: 5});
        } else if (checkedLength > 1) {
            layer.alert("只能操作一条记录!", {icon: 5});
        } else {
            var id = $('.son:checked')[0].value;
            //手动弹出模态窗口 hide/show
            $('#editCustomerModal').modal('show');

            //异步查询出勾中的数据，把数据设置到模态窗口中
            $.get("/crm/workbench/customer/queryCustomerById", {'id': id}, function (data) {
                var customer = data;

                //将查询出来的客户信息设置到修改模态窗口中
                $('#edit-customerOwner').val(customer.owner);
                $('#edit-customerName').val(customer.name);
                $('#edit-website').val(customer.website);
                $('#edit-phone').val(customer.phone);
                $('#edit-describe').val(customer.description);
                $('#edit-contactSummary').val(customer.contactSummayr);
                $('#edit-nextContactTime').val(customer.nextContactTime);
                $('#edit-address').val(customer.address);

                //把客户的主键设置到隐藏域中，要不然会更新所有数据了
                $('#id').val(customer.id);

            }, 'json');
        }
    }

    //join():默认会把数组中的内容默认以,号的形式拼接成字符串，也可以指定分隔符
    //删除客户
    function deleteCustomer() {
        layer.confirm('确认删除吗？', {
            btn: ['确定', '取消'] //可以无限个按钮
        }, function (index) {
            //按钮【按钮一】的回调
            layer.close(index);
            var ids = [];
            //获取勾中数据id号
            $('.son:checked').each(function () {
                ids.push($(this).val());
            });

            $.post("/crm/workbench/customer/deleteCustomer", {'ids': ids.join()}, function (data) {
                if (data.ok) {
                    layer.alert(data.message, {icon: 6});
                    //删除成功，刷新页面
                    refresh(1, 4);
                }
            }, 'json');
        }, function (index) {
            //按钮【按钮二】的回调
            layer.close(index);
        });

    }
</script>

</body>
</html>