<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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



</head>

	<body>
<shiro:hasRole name="admin">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" id="saveActivityForm" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-marketActivityOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="name" class="form-control" id="create-marketActivityName">
							</div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="startDate" class="form-control chooseTime" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="endDate" class="form-control chooseTime" id="create-endTime">
							</div>
						</div>
						<div class="form-group">

							<label for="create-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input name="cost" type="text" class="form-control" id="create-cost">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" onclick="saveOrUpdateActivity($('#saveActivityForm'))" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" id="updateActivityForm" role="form">
						<input type="hidden" name="id" id="id" />
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="edit-marketActivityOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text"  name="name" class="form-control" id="edit-marketActivityName" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="startDate" class="form-control chooseTime" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="endDate" class="form-control chooseTime" id="edit-endTime">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="cost" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea name="description" class="form-control" rows="3" id="edit-describe">
								</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" onclick="saveOrUpdateActivity($('#updateActivityForm'))" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">名称</div>
							<input class="form-control" id="name" type="text">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">所有者</div>
							<input class="form-control" id="owner" type="text">
						</div>
					</div>


					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">开始日期</div>
							<input class="form-control chooseTime" type="text" id="startTime" />
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">结束日期</div>
							<input class="form-control chooseTime" type="text" id="endTime">
						</div>
					</div>

					<button type="button" onclick="queryActivity()" class="btn btn-default">查询</button>

				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<button type="button" class="btn btn-primary" data-toggle="modal"  data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
					<button type="button" class="btn btn-default" data-toggle="modal" onclick="openUpdateModal()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
					<button type="button" onclick="deleteActivity()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>

			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input id="father" type="checkbox" /></td>
						<td>名称</td>
						<td>所有者</td>
						<td>开始日期</td>
						<td>结束日期</td>
					</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>

			<div id="activityPage">


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
		$(".chooseTime").datetimepicker({
			language:  "zh-CN",
			format: "yyyy-mm-dd",//显示格式
			minView: "hour",//设置只显示到月份
			initialDate: new Date(),//初始化当前日期
			autoclose: true,//选中自动关闭
			todayBtn: true, //显示今日按钮
			clearBtn : true,
			pickerPosition: "bottom-left"
		});

		refresh(1,3);

		//刷新页面的方法
		function refresh(page,pageSize){
			//js函数参数实际上是封装到arguments参数数组中
			/*for(var i = 0; i < arguments.length;i++){
                alert(arguments[i]);
            }*/

			$.get("/crm/workbench/activity/list",{
				'page':page,
				'pageSize':pageSize,
				'name' : $('#name').val(),
				'owner' : $('#owner').val(),
				'startDate' : $('#startTime').val(),
				'endDate' : $('#endTime').val()
			},function(data) {
				$('#activityBody').html("");
				var activities = data.list;
				for (var i = 0; i < activities.length; i++) {
					var activity = activities[i];
					$('#activityBody').append("<tr aria-rowspan='' class=\"active\">\n" +
							"\t\t\t\t\t\t\t<td><input value="+activity.id+" class='son' type=\"checkbox\" /></td>\n" +
							"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/activity/detail?id="+activity.id+"'\">" + activity.name + "</a></td>\n" +
							"                            <td>" + activity.owner + "</td>\n" +
							"\t\t\t\t\t\t\t<td>" + activity.startDate + "</td>\n" +
							"\t\t\t\t\t\t\t<td>" + activity.endDate + "</td>\n" +
							"\t\t\t\t\t\t</tr>");
				}

				//利用分页插件查询第一页数据
				$("#activityPage").bs_pagination({
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
					onChangePage : function(event, obj){
						//刷新页面，obj.currentPage:当前点击的页码
						//pageList(obj.currentPage,obj.rowsPerPage);
						refresh(obj.currentPage,obj.rowsPerPage);
					}
				});
			},'json');
		}

		//市场活动条件查询
		function queryActivity() {
			refresh(1,3);
		}
		//点击创建或修改按钮，异步创建/修改市场活动信息
		function saveOrUpdateActivity(form) {
			var form = form.serialize();
			$.post("/crm/workbench/activity/saveOrUpdateActivity",form,function(data){
				if(data.ok){
					layer.alert(data.message, {icon: 6});
					//添加成功，手动刷新页面
					refresh(1,3);
				}
			},'json');
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
			//第一种情况:father影响son:father勾中,则son全勾中
			$('.son').prop('checked',$(this).prop('checked'));
		});

		//son的状态决定father状态，动态生成的元素js会失效的，把子元素的事件委托给父元素(不能是动态生成的)
		//参数1:事件名称 参数2:被绑定的元素 参数3:触发的函数
		//第二种情况:son的勾中情况,影响father的勾中与否
		$('#activityBody').on('click','.son',function () {
			//获取勾中的son的个数
			var checkedLength = $('.son:checked').length;
			//获取总个数
			var sonLength = $('.son').length;

			if(checkedLength == sonLength){
				$('#father').prop('checked',true);
			}else{
				$('#father').prop('checked',false);
			}
		});

		//点击修改按钮，判断son勾中的个数
		/**
		 * var obj
		 * js-->jquery $(obj)
		 * jquery-->js obj[0] obj.get(0)
		 */
		//修改模态框
		function openUpdateModal() {

			var checkedLength = $('.son:checked').length;
			//因为勾中的数据只有一条，直接获取数组的第一个元素，而第一个元素获取后是js对象,value就是勾中数据的主键
			if(checkedLength == 0){
				layer.alert("至少勾中一条记录!", {icon: 5});
			}else if(checkedLength > 1){
				layer.alert("只能操作一条记录!", {icon: 5});
			}else{
				var id = $('.son:checked')[0].value;
				//手动弹出模态窗口 hide/show
				$('#editActivityModal').modal('show');

				//异步查询出勾中的数据，把数据设置到模态窗口中
				$.get("/crm/workbench/activity/queryActivityById",{'id':id},function(data){
					var activity = data;
					//将查询出来的市场活动内容设置到修改模态窗口中
					$('#edit-marketActivityName').val(activity.name);
					$('#edit-startTime').val(activity.startDate);
					$('#edit-endTime').val(activity.endDate);
					$('#edit-cost').val(activity.cost);
					$('#edit-describe').val(activity.description);

					//把市场活动的主键设置到隐藏域中，用于被提交，要不然会更新所有数据了
					$('#id').val(activity.id);


					var owner = activity.owner;
					$('#edit-marketActivityOwner').val(owner);
				},'json');
			}
		}

		//join():默认会把数组中的内容以,号的形式拼接成字符串，也可以指定分隔符
		//删除市场活动
		function deleteActivity() {
			layer.confirm('确认删除线索吗？', {
						btn: ['确定', '取消'] //可以无限个按钮
					}, function(index){
						//按钮【按钮一】的回调
						layer.close(index);
						var ids = [];
						//获取勾中数据id号
						$('.son:checked').each(function () {
							ids.push($(this).val());
						});

						$.post("/crm/workbench/activity/deleteActivity",{'ids':ids.join()},function(data){
							if(data.ok){
								layer.alert(data.message, {icon: 6});
								//添加成功，father取消选中；刷新页面
								$('#father').prop('checked',false);
								refresh(1,3);
							}
						},'json');
						//按钮【按钮二】的回调
					}, function(index){layer.close(index);}
			)

		}
	</script>
</shiro:hasRole>
	</body>


</html>