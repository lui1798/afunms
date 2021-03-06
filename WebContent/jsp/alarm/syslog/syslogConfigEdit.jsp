<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat,java.util.Date;"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Syslog过滤规则编辑</title>
<link href="<%=basePath%>css/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath%>css/ligerui-icons.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath%>css/Gray/css/all.css" rel="stylesheet" />
<script src="<%=basePath%>js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="<%=basePath%>js/base.js" type="text/javascript"></script>
<script src="<%=basePath%>js/ligerui.all.js" type="text/javascript"></script>
<script src="<%=basePath%>js/ligerGrid.js" type="text/javascript"></script>
<script src="<%=basePath%>js/ligerDialog.js" type="text/javascript"></script>
<script src="<%=basePath%>js/ligerButton.js" type="text/javascript"></script>
<script src="<%=basePath%>js/ligerComboBox.js" type="text/javascript"></script>
<script src="js/syslogConfigEdit.js"></script>
<script src="<%=basePath%>jsp/js/commonMethod.js"></script>

<style type="text/css">
body {
	font-size: 12px;
}

.l-table-label-td {
	width: 90px;
	text-align: right;
}

.groupTitle {
	font-size: 12px;
	font-weight: bold;
	margin: 4px;
	padding-left: 20px;
	float: left;
	width: 95%;
	height: 28px;
	line-height: 28px;
	border-bottom: 1px solid #D6D6D6;
	background: url('<%=basePath%>css/icons/communication.gif') no-repeat;
	background-position: 0% 33.33333%;
}

.l-table-edit-td {
	padding: 4px;
}

.l-button-submit {
	width: 60px;
	float: left;
	margin-left: 10px;
	padding-bottom: 2px;
}

#keyContainer {
	float: left;
	width: 100%;
}

#keyConfigGrid {
	margin: 3px 0 0 0;
}

#keyConfigDiv {
	display: none;
	margin: 5px 0 0 0;
}

.btDiv {
	text-align: center;
	margin: 10px 0 0 0;
	border-top: 1px dotted black;
	padding: 5px 0 0 0;
}
</style>

</head>
<body>
	<input id="basePath" type="hidden" value="<%=basePath%>" />
	<input id="id" type="hidden" value="<%=id%>" />
	<form id="form">
		<div>
			<div class="groupTitle">SysLog</div>
			<div>
				<table cellpadding="0" cellspacing="0" class="l-table-edit">
					<tr>
						<td class="l-table-label-td">接收等级:</td>
						<td>
							<div id="sysLogCheckBoxList"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div>
			<div class="groupTitle">告警条件</div>
			<div id="keyContainer">

				<div class="op">
					<table>
						<tr>
							<td><input type="checkbox" id="keyCheck" /></td>
							<td>关键字</td>
						</tr>
					</table>
				</div>

				<div id="keyConfigDiv">
					<table>
						<tr>
							<td><div class="btAdd" id="keyBtAdd"></div></td>
							<td style="padding-left: 5px;"><div class="btDel" id="keyBtDel"></div></td>
						</tr>
					</table>
					<div id="keyConfigGrid" class="grid"></div>
				</div>

				<div class="btDiv">
					<input type="button" value="修改" id="submit" class="l-button" />
				</div>
			</div>
		</div>
	</form>
</body>