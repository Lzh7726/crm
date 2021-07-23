<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="name" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" onclick="selectActivity()" class="btn btn-primary" data-dismiss="modal">确定</button>
					</div>
				</div>

			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" value="0" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" >
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" class="form-control">
				<c:forEach items="${dics['stage']}" var="dicValue">
					<option value="${dicValue.value}">${dicValue.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#searchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search" onclick="showActivities()"></span></a></label>
		    <input type="hidden" id="activityId" />
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${user.name}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" onclick="convert()" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>

	<script>

		$('#name').keypress(function () {
			//查询当前线索关联的所有市场活动
			if(event.keyCode==13){
				$.post("/crm/workbench/clue/queryRelationActivities",{'id':'${clue.id}','name':$(this).val()},function(data){
					$('#activityBody').html("");
					for(var i = 0; i < data.length; i++){
						var activity = data[i];
						$('#activityBody').append("<tr>\n" +
								"\t\t\t\t\t\t\t\t<td><input name='activity' type=\"radio\" value="+activity.id+" /></td>\n" +
								"\t\t\t\t\t\t\t\t<td id="+activity.id+">"+activity.name+"</td>\n" +
								"\t\t\t\t\t\t\t\t<td>"+activity.startDate+"</td>\n" +
								"\t\t\t\t\t\t\t\t<td>"+activity.endDate+"</td>\n" +
								"\t\t\t\t\t\t\t\t<td>"+activity.owner+"</td>\n" +
								"\t\t\t\t\t\t\t</tr>");
					}
				},'json');
			}

		});

		//点击确定按钮，选择交易可以关联市场活动
		function selectActivity() {
			//勾中市场活动主键
			var aid = $('input[type=radio]:checked')[0].value;
			//设置到隐藏域中
			$('#activityId').val(aid);
			//把勾中市场活动名称显示在文本域中
			$('#activity').val($("#" + aid).text());
		}

		//点击是否发生交易复选框
		$('#isCreateTransaction').click(function () {
			if($(this).prop('checked')){
				$(this).val("1");//1:代表勾中了，发生交易了
			}else{
				$(this).val("0");//0:没有勾中，没有发生交易
			}
		});

		//线索转换
		function convert() {
			$.post("/crm/workbench/clue/convert",{
				'id':'${clue.id}',
				'isTransaction':$('#isCreateTransaction').val(),
				//交易表单信息
				'money': $('#amountOfMoney').val(),
				'name' : $('#tradeName').val(),
				'expectedDate' : $('#expectedClosingDate').val(),
				'stage' : $('#stage').val(),
				'activityId' : $('#activityId').val()
			},function(data){
				if(data.ok){
					//线索转成功，提示成功；返回线索首页。
					layer.alert(data.message, {icon: 6});
					var time=3;
					setInterval(function () {

						if (time == 0) {
							location.href = "/crm/toView/workbench/clue/index";
						}else {time--}

					},1000)
				}
			},'json');
		}

	</script>
</body>
</html>