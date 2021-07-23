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

	<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="/crm/jquery/layer.js"></script>
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	});
	
</script>

</head>
<body>
<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="clueRemarkId" />
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bindModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						  <div class="form-group has-feedback">
						    <input type="text" id="name" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="father"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="bindActivityBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" onclick="bind()" class="btn btn-primary" data-dismiss="modal">关联</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 修改线索的模态窗口 -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form" id="updateClue">
                        <input type="hidden" name="id" id="id" />
                        <div class="form-group">
                            <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-clueOwner" name="owner">
                                  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">
										  ${user.name}
									  </option>
								  </c:forEach>
                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company" name="company">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-call" name="appellation">
                                 <c:forEach items="${dics['appellation']}" var="dic">
									 <option value="${dic.value}">
										 ${dic.text}
									 </option>
								 </c:forEach>

                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-surname" name="fullname">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">职位</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" name="job">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" name="email">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" name="phone">
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" name="website">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone" name="mphone">
                            </div>
                            <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-status" name="state">
									<c:forEach items="${dics['clueState']}" var="dic">
										<option value="${dic.value}">
												${dic.text}
										</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source" name="source">
									<c:forEach items="${dics['source']}" var="dic">
										<option value="${dic.value}">
												${dic.text}
										</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe" name="description"></textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control chooseTime" id="edit-nextContactTime" name="nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address" name="address"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="saveOrUpdateClue($('#updateClue'))">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="showTitle"> <small id="showTitle-company"></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='/crm/workbench/clue/toConvert?id=${id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default"  onclick="openUpdateClueModal()"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" onclick="deleteClue()"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="fullnameappellation"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="owner"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="company"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="job"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="email"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="phone"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="website"> </b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="mphone"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="state"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="source"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="createTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">

				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
<%--
	<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="/crm/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		<div  style="background-color: #E6E6E6; width: 870px; height: 90px;"  id="remarkDiv">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" onclick="saveClueRemark()" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
					<%--	<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bindModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
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

		minView: "month",//设置只显示到月份
		initialDate: new Date(),//初始化当前日期
		autoclose: true,//选中自动关闭
		todayBtn: true, //显示今日按钮
		clearBtn : true,
		pickerPosition: "bottom-left"
	});
	//显示线索详细信息
    showClue();
    function showClue(){
        $.post("/crm/workbench/clue/toDetail",{'id':'${id}'},function(data){

            //显示详情信息

            $('#showTitle').text(data.fullname +data.appellation);
            $('#showTitle-company').text(data.company);
            $('#fullnameappellation').text(data.fullname +data.appellation);
            $('#owner').text(data.owner);
            $('#company').text(data.company);
            $('#job').text(data.job);
            $('#email').text(data.email);
            $('#phone').text(data.phone);
            $('#website').text(data.website);
            $('#mphone').text(data.mphone);
            $('#state').text(data.state);
            $('#source').text(data.source);
            $('#createBy').text(data.createBy);
            $('#createTime').text(data.createTime);
            $('#editBy').text(data.editBy);
            $('#editTime').text(data.editTime);
            $('#description').text(data.description);
            $('#contactSummary').text(data.contactSummary);
            $('#nextContactTime').text(data.nextContactTime);
            $('#address').text(data.address);

            //把线索id设置到隐藏域,用于更新时用
            $('#id').val(data.id);


            //显示备注信息	remarkDiv
            var clueRemarks = data.clueRemarks;
            for(var i = 0; i < clueRemarks.length; i++){
                var clueRemark = clueRemarks[i];
                refresh(clueRemark);
            }
        },'json');
    }

	//刷新备注列表的方法
	function refresh(clueRemark) {
		$('#remarkDiv').before("<div class=\"remarkDiv\" id="+clueRemark.id+"remarkDiv style=\"height: 60px;\">\n" +
				"\t\t\t\t<img title=\"zhangsan\" src='"+clueRemark.img+"' style=\"width: 30px; height:30px;\">\n" +
				"\t\t\t\t<div style=\"position: relative; top: -40px; left: 40px;\" >\n" +
				"\t\t\t\t\t<h5 id="+clueRemark.id+"h5>"+clueRemark.noteContent+"</h5>\n" +
				"\t\t\t\t\t<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>"+clueRemark.fullname+clueRemark.appellation+"-"+clueRemark.company+"</b> <small style=\"color: gray;\"> "+clueRemark.createTime+" 由"+clueRemark.createBy+"</small>\n" +
				"\t\t\t\t\t<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
				"\t\t\t\t\t\t<a class=\"myHref\" onclick=\"openClueRemarkModal('"+clueRemark.id+"','"+clueRemark.noteContent+"')\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;\n" +
				"\t\t\t\t\t\t<a class=\"myHref\" onclick=\"deleteClueRemark('"+clueRemark.id+"')\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
				"\t\t\t\t\t</div>\n" +
				"\t\t\t\t</div>\n" +
				"\t\t\t</div>");
		$('#clueRemarkId').val(clueRemark.id);


		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});

		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});

		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});

		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
	}
    //修改线索模态框
    function openUpdateClueModal() {

        //弹出模态窗口
        $('#editClueModal').modal('show');

            $.get("/crm/workbench/clue/queryClueById",{'id':'${id}'},function(data){

                //将查询出来的市场活动内容设置到修改模态窗口中
                $('#edit-clueOwner').val(data.owner);
                $('#edit-company').val(data.company);
                $('#edit-call').val(data.appellation);
                $('#edit-surname').val(data.fullname);
                $('#edit-job').val(data.job);
                $('#edit-email').val(data.email);
                $('#edit-phone').val(data.phone);
                $('#edit-website').val(data.website);
                $('#edit-mphone').val(data.mphone);
                $('#edit-status').val(data.state);
                $('#edit-source').val(data.source);
                $('#edit-describe').val(data.description);
                $('#edit-contactSummary').val(data.contactSummary);
                $('#edit-nextContactTime').val(data.nextContactTime);
                $('#edit-address').val(data.address);

                //把市场活动的主键设置到隐藏域中，用于被提交，要不然会更新所有数据了
                $('#id').val(data.id);

                $('#edit-marketClueOwner').val(data.owner);
            },'json');

    }
    //点击更新按钮，异步修改线索信息
    function saveOrUpdateClue(form) {
        var form = form.serialize();
        $.post("/crm/workbench/clue/saveOrUpdateClue",form,function(data){
            if(data.ok){
                layer.alert(data.message, {icon: 6});
                //添加/更新成功，手动刷新页面
                showClue();
            }
        },'json');}
    //删除线索信息
    function deleteClue() {
        layer.confirm('确认删除该条线索吗？', {
            btn: ['确定', '取消'] //可以无限个按钮
        }, function(index){
            //按钮【按钮一】的回调
                layer.close(index);
            $.post("/crm/workbench/clue/deleteClues",{'ids':'${id}'},function(data){
                if(data.ok){
                    layer.alert(data.message, {icon: 6});
                    //删除本条线索成功，则此线索和市场活动的关联关系也要删除;返回上一页
                    unbind();
                    //删除成功，本条线索已不存在，返回上一页并刷新
                    self.location=document.referrer;
                }else {
                    layer.alert(data.message, {icon: 5});
                }
            },'json');
            //按钮【按钮二】的回调
        }, function(index){
            layer.close(index);
        }
        )
    }




    //创建备注
	function saveClueRemark() {
		$.post("/crm/workbench/clue/saveClueRemark",{
			'clueId' : '${id}',
			'noteContent' : $('#remark').val()
		},function(data){
			var clueRemark = data.t;
			if(data.ok){
				layer.alert(data.message, {icon: 6});
				//创建成功刷新页面
				refresh(clueRemark);
				//清空文本域内容
				$('#remark').val("");
			}
		},'json');
	}
	//删除市场活动备注
	function deleteClueRemark(id) {
		layer.confirm('确认删除该条备注吗？', {
			btn: ['确定', '取消'] //可以无限个按钮
		}, function(index){
			//按钮【按钮一】的回调
			layer.close(index);
			$.post("/crm/workbench/clue/deleteClueRemark",{
				'id' : id,
			},function(data){
				if(data.ok){
					layer.alert(data.message, {icon: 6});
					//删除页面的dom元素
					$('#'+id + "remarkDiv").remove();
				}
			},'json');
		}, function(index){
			//按钮【按钮二】的回调

		});

	}

	//备注:点击修改按钮，弹出模态窗口
	function openClueRemarkModal(id,noteContent) {
		//弹出模态窗口
		$('#editRemarkModal').modal('show');

		//把备注主键设置到模态窗口的隐藏域中
		$('#clueRemarkId').val(id);

		//文本内容设置到模态窗口的文本域中
		$('#noteContent').val(noteContent);
	}

	//异步查询当前线索关联的市场活动
    queryRelationActivities();
    function queryRelationActivities(){
        $('#activityBody').html("");

        $.post("/crm/workbench/clue/queryRelationActivities",{'id':'${id}'},function(data){
            for(var i = 0; i < data.length; i++){
                var activity = data[i];
                $('#activityBody').append("\t<tr>\n" +
                    "\t\t\t\t\t\t\t<td>"+activity.name+"</td>\n" +
                    "\t\t\t\t\t\t\t<td>"+activity.startDate+"</td>\n" +
                    "\t\t\t\t\t\t\t<td>"+activity.endDate+"</td>\n" +
                    "\t\t\t\t\t\t\t<td>"+activity.owner+"</td>\n" +
                    "\t\t\t\t\t\t\t<td><a onclick=\"unbind('"+activity.id+"')\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>\n" +
                    "\t\t\t\t\t\t</tr>")
            }
        },'json');
    }


	//给关联模态窗口中的文本框触发回车事件
	$('#name').keypress(function () {
		//查询当前线索未关联的所有市场活动
		$.post("/crm/workbench/clue/queryUnBindActivities",{'id':'${id}','name':$(this).val()},function(data){
            $('#bindActivityBody').html("");
			for(var i = 0; i < data.length; i++){
				var activity = data[i];
				$('#bindActivityBody').append("<tr>\n" +
						"\t\t\t\t\t\t\t\t<td><input type=\"checkbox\" class='son' value="+activity.id+" /></td>\n" +
						"\t\t\t\t\t\t\t\t<td>"+activity.name+"</td>\n" +
						"\t\t\t\t\t\t\t\t<td>"+activity.startDate+"</td>\n" +
						"\t\t\t\t\t\t\t\t<td>"+activity.endDate+"</td>\n" +
						"\t\t\t\t\t\t\t\t<td>"+activity.owner+"</td>\n" +
						"\t\t\t\t\t\t\t</tr>");
			}
		},'json');
	});
    //全选反选
    $('#father').click(function () {
            //第一种情况:father影响son:father勾中,则son全勾中
        $('.son').prop('checked',$(this).prop('checked'));
    });
    //son的状态决定father状态，动态生成的元素js会失效的，把子元素的事件委托给父元素(不能是动态生成的)
    //参数1:事件名称 参数2:被绑定的元素 参数3:触发的函数\
            //第二种情况:son的勾中情况,影响father的勾中与否
    $('#bindActivityBody').on('click','.son',function () {

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
	//点击关联按钮进行关联
    function bind() {
        //获取勾中的市场活动id
        var ids = [];
        $('input:checked').each(function () {
            ids.push($(this).val());
        });
        $.post("/crm/workbench/clue/bind",{
            'id' : '${id}',
            'ids' : ids.join()
        },function(data){
            if(data.ok){
                layer.alert(data.message, {icon: 6});
                //关闭模态窗口
                $('#bindModal').modal('hide');
				queryRelationActivities();
            }
        },'json');
    }
    //解除关联
    function unbind(aid) {
        layer.confirm('确认解除关联吗？', {
            btn: ['确定', '取消'] //可以无限个按钮
        }, function () {
            $.post("/crm/workbench/clue/unbind",{
                'id' : '${id}',
                'aid' : aid
            },function(data){
                if(data.ok){
                    layer.alert(data.message, {icon: 6});
                    queryRelationActivities();
                }
            },'json');
        }
        //按钮2的函数(略)
        );

    }

	//点击更新按钮，更新备注信息
	$('#updateRemarkBtn').click(function () {
		$.post("/crm/workbench/clue/updateClueRemark",{
			'id' : $('#clueRemarkId').val(),
			'noteContent' : $('#noteContent').val()
		},function(data){
			if(data.ok){
				layer.alert(data.message, {icon: 6});
				//关闭模态窗口
				$('#editRemarkModal').modal('hide');
				//隐藏域备注的主键
				var id = $('#clueRemarkId').val();
				//备注div中的h5标签
				var h5 = id + "h5";
				//用户输入的备注弹窗中的文本域内容
				var noteContent = $('#noteContent').val();
				$("#" + h5).text(noteContent);
			}
		},'json');
	});
    //当从线索转换返回时(此时线索已转换并被删除，不应该会到本页)，再次回到上一页并刷新
	window.addEventListener("popstate", function(e) {
		self.location=document.referrer;
	}, false);
</script>
</body>
</html>