<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="/crm/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="/crm/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<link href="/crm/jquery/layer/theme/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="/crm/jquery/layer.js"></script>
<script type="text/javascript" src="/crm/jquery/ajaxfileupload.js"></script>


	<script type="text/javascript">

	//页面加载完毕
	$(function(){
		
		//导航中所有文本颜色为黑色
		$(".liClass > a").css("color" , "black");
		
		//默认选中导航菜单中的第一个菜单项
		$(".liClass:first").addClass("active");
		
		//第一个菜单项的文字变成白色
		$(".liClass:first > a").css("color" , "white");
		
		//给所有的菜单项注册鼠标单击事件
		$(".liClass").click(function(){
			//移除所有菜单项的激活状态
			$(".liClass").removeClass("active");
			//导航中所有文本颜色为黑色
			$(".liClass > a").css("color" , "black");
			//当前项目被选中
			$(this).addClass("active");
			//当前项目颜色变成白色
			$(this).children("a").css("color","white");
		});
		

		//window.open:打开一个新窗口 参数1:发送的url请求 参数2:指定显示页面的位置
		window.open("/crm/toView/workbench/main/index","workareaFrame");
		
	});
	
</script>
<style>
	.file {
		position: relative;
		display: inline-block;
		background: #D0EEFF;
		border: 1px solid #99D3F5;
		border-radius: 4px;
		padding: 4px 12px;
		overflow: hidden;
		color: #1E88C7;
		text-decoration: none;
		text-indent: 0;
		line-height: 20px;
	}
	.file input {
		position: absolute;
		font-size: 100px;
		right: 0;
		top: 0;
		opacity: 0;
	}
	.file:hover {
		background: #AADFFD;
		border-color: #78C3F3;
		color: #004974;
		text-decoration: none;
	}
</style>
</head>
<body>
	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>张三</b><br><br>
						登录帐号：<b>zhangsan</b><br><br>
						组织机构：<b>1005，市场部，二级部门</b><br><br>
						邮箱：<b>zhangsan@bjpowernode.com</b><br><br>
						失效时间：<b>2017-02-14 10:10:10</b><br><br>
						允许访问IP：<b>127.0.0.1,192.168.100.2</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input id="pho" type="hidden" />
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">上传头像</label>
							<div class="col-sm-10" style="width: 300px;">
								<a href="javascript:;" class="file">选择文件
									<input type="file" name="img" id="img">
								</a>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="updatePwd()">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要登出吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='/crm/settings/user/loginOut';">确定</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
		<div style="position: absolute; top: 15px; right: 40px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<img id="photo" style="display:none;border-radius: 100%;width: 30px;height: 30px" />
					</a>
					<c:choose>
						<c:when test="${not empty user.img}">
							<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
								<img src="${user.img}" style="border-radius: 100%;width: 30px;height: 30px" /> ${user.name} <span class="caret"></span>
							</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
								<span id="span" class="glyphicon glyphicon-user"></span> ${user.name} <span class="caret"></span>
							</a>
						</c:otherwise>
					</c:choose>

					<ul class="dropdown-menu">
						<li><a href="/crm/toView/settings/index"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>

	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

		<!-- 导航 -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">

			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="/crm/toView/workbench/main/index" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-tag"></span> 动态</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-time"></span> 审批</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户公海</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/activity/index" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> 市场活动</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/clue/index" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> 线索（潜在客户）</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/customer/index" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 客户</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/contacts/index" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 联系人</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/transaction/index" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 交易（商机）</a></li>
				<li class="liClass"><a href="/crm/toView/workbench/visit/index" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> 售后回访</a></li>
				<li class="liClass">
					<a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span> 统计图表</a>
					<ul id="no2" class="nav nav-pills nav-stacked collapse">
						<li class="liClass"><a href="chart/activity/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 市场活动统计图表</a></li>
						<li class="liClass"><a href="chart/clue/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 线索统计图表</a></li>
						<li class="liClass"><a href="chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
						<li class="liClass"><a href="/crm/toView/workbench/chart/transaction/index" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
					</ul>
				</li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-file"></span> 报表</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-shopping-cart"></span> 销售订单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-send"></span> 发货单</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> 跟进</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-leaf"></span> 产品</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> 报价</a></li>
			</ul>

			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>

		<!-- 工作区 -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>

	</div>

	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

	<!-- 底部 -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	<script>

		//异步上传文件
		$('#img').change(function () {
			$.ajaxFileUpload({
						url: '/crm/settings/user/fileUpload', //用于文件上传的服务器端请求地址
						fileElementId: 'img', //文件上传域的ID
						dataType: 'json', //返回值类型 一般设置为json
						success : function (data,status) {
							if(!data.ok){
								layer.alert(data.message, {icon: 5});
							}else{
								//上传成功
								layer.alert(data.message, {icon: 6});
								//把resultVo中的图片存储路径设置到img中
								var path = data.t;
								//attr:自定义属性 prop:固有属性
								$('#photo').prop("src",path);
								$('#photo').css("display","inline");
								$('#span').css("display","none");

								//把用户回调的头像路径设置到隐藏域中
								$('#pho').val(path);
							}
							/*if(data.ok){
								layer.alert(data.message, {icon: 1});
								$('#photo').prop('src',data.t);
								$('#photo').css('display',"inline");
								$('#span').css('display',"none");
							}*/
						},
					}
			)
			return false;
		});

		$('#oldPwd').blur(function () {
			//异步校验原始密码输入是否正确
			$.post("/crm/settings/user/verifyOldPwd",{
				'loginPwd' : $(this).val(),
				'loginAct' : '${user.loginAct}'
			},function(data){
				if(!data.ok){
					layer.alert(data.message, {icon: 5});
				}
			},'json');
		});

		//更新密码和头像
		function updatePwd() {
			$.post("/crm/settings/user/updatePwd",{
				'loginPwd' : $('#newPwd').val(),
				'img' : $('#pho').val()
			},function(data){
				if(data.ok){
					layer.alert(data.message, {icon: 6});
				}
			},'json');
		}
	</script>
</body>
</html>