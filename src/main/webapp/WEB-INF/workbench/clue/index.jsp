<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="/crm/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--分页插件--%>
	<link href="/crm/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="/crm/jquery/bs_pagination/en.js" charset="UTF-8"></script>

<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer.js"></script>

</head>
<body>
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createClueForm" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="create-clueOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="company" class="form-control required" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="appellation" id="create-call">
									<option>请选择</option>
									<c:forEach items="${dics['appellation']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="fullname" class="form-control required" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input name="job" type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="email" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="phone" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="website" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="mphone" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="state" id="create-status">
									<option>请选择</option>
									<c:forEach items="${dics['clueState']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="source" id="create-source">
									<option>请选择</option>
									<c:forEach items="${dics['source']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" name="contactSummary" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control chooseTime" name="nextContactTime" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" name="address" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="saveOrUpdateClue($('#createClueForm'))" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close"  data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editClue">
						<input type="hidden" name="id" id="id" />
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="edit-clueOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control required" name="company" id="edit-company" required="required">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="appellation" id="edit-call">
									<option>请选择</option>
									<c:forEach items="${dics['appellation']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control required" name="fullname" id="edit-surname" required="required">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="job" id="edit-job" >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="email" id="edit-email" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="phone" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="website" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" name="mphone" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="state" id="edit-status">
									<option>请选择</option>
									<c:forEach items="${dics['clueState']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="source" id="edit-source">
									<option>请选择</option>
									<c:forEach items="${dics['source']}" var="dicValue">
										<option value="${dicValue.value}">${dicValue.text}</option>
									</c:forEach>
								</select>
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
									<textarea class="form-control" rows="3" name="contactSummary" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control chooseTime" name="nextContactTime" id="edit-nextContactTime" >
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
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="saveOrUpdateClue($('#editClue'))">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="fullname" name="fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="company" name="company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="phone" name="phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="source" name="source">
						  <option>请选择</option>
						  <%--List<DicType>--%>
						<%--  <c:forEach items="${applicationScope.dicTypes}" var="dicType">
							  <c:if test="${dicType.code eq 'source'}">
								  <c:forEach items="${dicType.dicValues}" var="dicValue">
									  <option value="${dicValue.value}">${dicValue.text}</option>
								  </c:forEach>
							  </c:if>
						  </c:forEach>--%>

						  <%--Map<String,List<DicVlaue>>--%>
						 <c:forEach items="${dics['source']}" var="dicValue">
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="owner" name="owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="mphone" name="mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="state" name="state">
						  <option>请选择</option>
						  <%--<c:forEach items="${applicationScope.dicTypes}" var="dicType">
							  <c:if test="${dicType.code eq 'clueState'}">
								  <c:forEach items="${dicType.dicValues}" var="dicValue">
									  <option value="${dicValue.value}">${dicValue.text}</option>
								  </c:forEach>
							  </c:if>
						  </c:forEach>--%>

						  <c:forEach items="${dics['clueState']}" var="dicValue">
							  <option value="${dicValue.value}">${dicValue.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default" onclick="queryClue()">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal"  onclick="openUpdateModal()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" onclick="deleteClues()"><span class="glyphicon glyphicon-minus" ></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="father" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
					<%--	<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='/crm/toView/workbench/clue/detail?id=a2e35029c9f442e2aef997c9c1cbb313';">张三先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>--%>

					</tbody>
				</table>
				<div id="cluePage">

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
        rtl:true,
		language:  "zh-CN",
		format: "yyyy-mm-dd",//显示格式
		minView: "month",//设置只显示到月份
		initialDate: new Date(),//初始化当前日期
		autoclose: true,//选中自动关闭
		todayBtn: true, //显示今日按钮
		clearBtn : true,
		pickerPosition: "bottom-left",
	});
	//查询显示线索信息
	refresh(1,5);
	//刷新页面的方法(输入条件就是条件查询,否则为查询全部)
	function refresh(page,pageSize){
		//js函数参数实际上是封装到arguments参数数组中
		/*for(var i = 0; i < arguments.length;i++){
			alert(arguments[i]);
		}*/

		$.get("/crm/workbench/clue/list",{
			'page':page,
			'pageSize':pageSize,
			'fullname' : $('#fullname').val(),
			'company' : $('#company').val(),
			'phone' : $('#phone').val(),
			'source' : $('#source').val(),
			'owner' : $('#owner').val(),
			'mphone' : $('#mphone').val(),
			'state' : $('#state').val()
		},function(data) {
			$('#clueBody').html("");
			var clues = data.list;
			for (var i = 0; i < clues.length; i++) {
				var clue = clues[i];
				$('#clueBody').append("<tr aria-rowspan='' class=\"clue\">\n" +
						"\t\t\t\t\t\t\t<td><input value="+clue.id+" class='son' type=\"checkbox\" /></td>\n" +
						"\t\t\t\t\t\t\t<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/crm/toView/workbench/clue/detail?id="+clue.id+"'\">" + clue.fullname+clue.appellation+"</a></td>\n" +
						"                            <td>" + clue.company + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + clue.phone + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + clue.mphone + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + clue.source + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + clue.owner + "</td>\n" +
						"\t\t\t\t\t\t\t<td>" + clue.state + "</td></tr>");
			}
	/*	<tr>
			<td><input type="checkbox" /></td>
					<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='/crm/toView/workbench/clue/detail?id=a2e35029c9f442e2aef997c9c1cbb313';">张三先生</a></td>
			<td>动力节点</td>
			<td>010-84846003</td>
			<td>12345678901</td>
			<td>广告</td>
			<td>zhangsan</td>
			<td>已联系</td>
			</tr>*/
			//利用分页插件查询第一页数据
			$("#cluePage").bs_pagination({
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
	//线索条件查询
	function queryClue() {
		refresh(1,5);
	}
/*	//必填项检测
	function CheckMustWrite(){
		var count = $("input[mustwrite = 'true']", document.forms[0]);
		for (var i = 0; i< count.length ; i++){
			if(count[i].value == ""){
				alert(count[i].title + " 为必填项");
				count[i].focus();
				return false;
			}
		}*/
	//点击创建或修改按钮，异步创建/修改市场活动信息
	function saveOrUpdateClue(form) {
		var form = form.serialize();
		$.post("/crm/workbench/clue/saveOrUpdateClue",form,function(data){
			if(data.ok){
				layer.alert(data.message, {icon: 6});
				//添加/更新成功，手动刷新页面
				refresh(1,5);
			}
		},'json');}

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
		$('.son').prop('checked',$(this).prop('checked'));
	});

	//son的状态决定father状态，动态生成的元素js会失效的，把子元素的事件委托给父元素(不能是动态生成的)
	//参数1:事件名称 参数2:被绑定的元素 参数3:触发的函数
	$('#clueBody').on('click','.son',function () {
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


	//修改线索模态框
	function openUpdateModal() {

		var checkedLength = $('.son:checked').length;
		//因为勾中的数据只有一条，直接获取数组的第一个元素，而第一个元素获取后是js对象,value就是勾中数据的主键
		if(checkedLength == 0){
			layer.alert("至少勾中一条记录!", {icon: 5});
		}else if(checkedLength > 1){
			layer.alert("只能操作一条记录!", {icon: 5});
		}else{
			var id = $('.son:checked')[0].value;
			//手动弹出模态窗口
			$('#editClueModal').modal('show');

			//异步查询出勾中的数据，把数据设置到模态窗口中
			$.get("/crm/workbench/clue/queryClueById",{'id':id},function(data){
				alert(data);
				var clue = data;
				//将查询出来的市场活动内容设置到修改模态窗口中
				$('#edit-clueOwner').val(clue.owner);
				$('#edit-company').val(clue.company);
				$('#edit-call').val(clue.appellation);
				$('#edit-surname').val(clue.fullname);
				$('#edit-job').val(clue.job);
				$('#edit-email').val(clue.email);
				$('#edit-phone').val(clue.phone);
				$('#edit-website').val(clue.website);
				$('#edit-mphone').val(clue.mphone);
				$('#edit-status').val(clue.state);
				$('#edit-source').val(clue.source);
				$('#edit-describe').val(clue.description);
				$('#edit-contactSummary').val(clue.contactSummary);
				$('#edit-nextContactTime').val(clue.nextContactTime);
				$('#edit-address').val(clue.address);

				//把市场活动的主键设置到隐藏域中，用于被提交，要不然会更新所有数据了
				$('#id').val(clue.id);


				var owner = clue.owner;
				$('#edit-marketClueOwner').val(owner);
			},'json');
		}
	}

	//join():默认会把数组中的内容以,号的形式拼接成字符串，也可以指定分隔符
	//删除线索
	function deleteClues() {
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
			$.post("/crm/workbench/clue/deleteClues",{'ids':ids.join()},function(data){
				if(data.ok){
					layer.alert(data.message, {icon: 6});
					//删除成功，father取消选中；刷新页面
					$('#father').prop('checked',false);
					refresh(1,5);
				}else {
					layer.alert(data.message, {icon: 5});
				}
			},'json');
					//按钮【按钮二】的回调
				}, function(index){layer.close(index);}
		)

	}
/*	//点击保存按钮，创建线索(创建和更新功能已合并)
	function saveClue() {
		$.post("/crm/workbench/clue/saveClue",$('#clueActivityForm').serialize(),function(data){
			if(data.ok){
				layer.alert(data.message, {icon: 6});
			}
		},'json');
	}*/
</script>
</body>
</html>