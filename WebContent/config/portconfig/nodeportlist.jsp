<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@page import="java.util.List"%>
<%@page import="com.afunms.system.model.*" %>
<%@page import="com.afunms.config.model.Portconfig"%>
<%@ include file="/include/globe.inc"%>
<% 
 
String[] memoryItem={"AllSize","UsedSize","Utilization"};
String[] memoryItemch={"总容量","已用容量","当前利用率","最大利用率"};
String[] sysItem={"sysName","sysUpTime","sysContact","sysLocation","sysServices","sysDescr"};
String[] sysItemch={"设备名","设备启动时间","设备联系","设备位置","设备服务","设备描述"};

  String rootPath = request.getContextPath(); 
  List list = (List)request.getAttribute("list");
  String id = (String)request.getAttribute("id");
  //Host host = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(id));
  String ipaddress = (String)request.getAttribute("ipaddress");
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM-dd HH:mm");					  	 
         
%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/wfm.js"></script>
<link href="<%=rootPath%>/resource/css/global/global.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="gb2312" />
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="gb2312"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="gb2312"></script>
<script type="text/javascript" 	src="<%=rootPath%>/application/resource/js/timeShareConfigdiv.js" charset="gb2312"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
<link href="<%=rootPath%>/resource/css/detail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=rootPath%>/resource/css/style.css" type="text/css">
<link href="<%=rootPath%>/include/mainstyle.css" rel="stylesheet" type="text/css">
<LINK href="<%=rootPath%>/resource/css/itsm_style.css" type="text/css" rel="stylesheet">
<link href="<%=rootPath%>/include/navbar.css" rel="stylesheet" type="text/css" />
<LINK href="<%=rootPath%>/resource/css/style.css" type="text/css" rel="stylesheet">

<script language="JavaScript" type="text/javascript">

function doNodeFromlastoconfig()
  {  
     mainForm.action = "<%=rootPath%>/portconfig.do?action=fromnodelasttoconfig";
     mainForm.submit();
  }  
  
function CreateWindow(url)
{
	
msgWindow=window.open(url,"protypeWindow","toolbar=no,width=600,height=400,directories=no,status=no,scrollbars=yes,menubar=no")
}    

function setReceiver(eventId){
	var event = document.getElementById(eventId);
	return CreateWindow('<%=rootPath%>/user.do?action=setReceiver&event='+event.id+'&value='+event.value);
}
function chkall()
		  	{
		    	if ( mainForm.checkflag.length == null ) {
			        if( mainForm.checkall.checked )
			           mainForm.checkflag.checked = true;
			        else
			           mainForm.checkflag.checked = false;
		     	} else {
		        	if(mainForm.checkall.checked) {
		           	for( var i=0; i < mainForm.checkflag.length; i++ ){
		           		mainForm.checkflag[i].checked = true;
		        	}
		   		} else {
		           for( var i=0; i < mainForm.checkflag.length; i++ ){
		              mainForm.checkflag[i].checked = false;
		           }
		        }
		     }
		  }
<!--wxy add-->
function editNodePort(id,sms)
  {
 
      $.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=editnodeport&id="+id+"&sms="+sms+"&nowtime="+(new Date()),
			success:function(data){
			
			if(data.flagStr==3){
			alert("修改失败！！！");
			}else if(data.flagStr==0){
			var smsId =document.getElementById("smsFlag"+id);
		    smsId.innerHTML ="<span style='cursor:hand' onclick='editNodePort("+id+",1)'><font color=#skyblue>监视</font></span>";
			}else if(data.flagStr==1){
			var smsId =document.getElementById("smsFlag"+id);
		    smsId.innerHTML ="<span style='cursor:hand' onclick='editNodePort("+id+",0)'><font color=#green>取消监视</font></span>";
			}
			}
		});
  }
  <!--wxy add-->
  function editNodePortForReport(id,reportFlag)
  {
  
      $.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=editnodeport&id="+id+"&reportflag="+reportFlag+"&nowtime="+(new Date()),
			success:function(data){
		
			if(data.flagStr==3){
			alert("修改失败！！！");
			}else if(data.flagStr==0){
			var reportId =document.getElementById("reportflag"+id);
		    reportId.innerHTML ="<span style='cursor:hand' onclick='editNodePortForReport("+id+",1)'><font color=#skyblue>显示于报表</font></span>";
			}else if(data.flagStr==1){
			var reportId =document.getElementById("reportflag"+id);
		    reportId.innerHTML ="<span style='cursor:hand' onclick='editNodePortForReport("+id+",0)'><font color color=#green>取消显示于报表</font></span>";
			}
			}
		});
  }
</script>

<script language="JavaScript" type="text/JavaScript">
var show = true;
var hide = false;
//修改菜单的上下箭头符号
function my_on(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="on";
}
function my_off(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="off";
}
//添加菜单	
function initmenu()
{
	var idpattern=new RegExp("^menu");
	var menupattern=new RegExp("child$");
	var tds = document.getElementsByTagName("div");
	for(var i=0,j=tds.length;i<j;i++){
		var td = tds[i];
		if(idpattern.test(td.id)&&!menupattern.test(td.id)){					
			menu =new Menu(td.id,td.id+"child",'dtu','100',show,my_on,my_off);
			menu.init();		
		}
	}
	timeShareConfiginit(); // nielin add for time-sharing at 2010-01-04
}

//修改警告级别
function modifyalarmlevelajax(id){
	var t = document.getElementById("alarmlevel"+id);
	var alarmvalue = t.selectedIndex;//获取下拉框的值
	$.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=modifyAlarmlevel&id="+id+"&alarmvalue="+alarmvalue+"&nowtime="+(new Date()),
			success:function(data){
				window.alert("修改成功！");
			}
		});
}

</script>

<script>
 function update(){
      mainForm.action = "<%=rootPath%>"+"/portconfig.do?action=updateportflag";
      mainForm.submit();
   }
   
   function updateflag(){     
     var ipaddress="<%=ipaddress%>";     
     var test=document.getElementsByName("checkflag");
     var portArray="";
     for (i = 0; i < test.length ; i ++ )
		{
			if(test[i].checked){
               portArray+=test[i].value+",";			  
              }		
		}
     
     $.ajax({
					type:"POST",
					dataType:"json",
					url:"<%=rootPath%>/PortConfigAjaxManager.ajax?action=updateflag",	
					data:"ipaddress="+ipaddress+"&portArray="+portArray,				
					success:function(data){
						if(data.isSuccess==1){
							alert("数据更新成功!");							
						}else{
						    alert("对不起,数据更新失败!");
						}
					}
				});				
	}  
//-- nielin add for timeShareConfig 2010-01-03 end-------------------------------------------------------------
	/*
	* 此方法用于短信分时详细信息
	* 需引入 /application/resource/js/timeShareConfigdiv.js 
	*/
	//接受用户的列表
	var action = "<%=rootPath%>/user.do?action=setReceiver";
	// 获取短信分时详细信息的div
	function timeShareConfiginit(){
		var rowNum = document.getElementById("rowNum");
		rowNum.value = "0";
		// 获取设备或服务的分时数据列表,
		var timeShareConfigs = new Array();
		var smsConfigs = new Array();
		var phoneConfigs = new Array();
		<%	
			List timeShareConfigList = (List) request.getAttribute("timeShareConfigList");
			if(timeShareConfigList!=null&&timeShareConfigList.size()>=0){
			for(int i = 0 ; i < timeShareConfigList.size(); i++){	        
	            TimeShareConfig timeShareConfig = (TimeShareConfig) timeShareConfigList.get(i);
	            int timeShareConfigId = timeShareConfig.getId();
	            String timeShareType = timeShareConfig.getTimeShareType();
	            String timeShareConfigbeginTime = timeShareConfig.getBeginTime();
	            String timeShareConfigendTime = timeShareConfig.getEndTime();
	            String timeShareConfiguserIds = timeShareConfig.getUserIds();
	            
	    %>
	            timeShareConfigs.push({
	                timeShareConfigId:"<%=timeShareConfigId%>",
	                timeShareType:"<%=timeShareType%>",
	                beginTime:"<%=timeShareConfigbeginTime%>",
	                endTime:"<%=timeShareConfigendTime%>",
	                userIds:"<%=timeShareConfiguserIds%>"
	            });
	    <%
	        }
	        }
	    %>   
	    for(var i = 0; i< timeShareConfigs.length; i++){
	    	var item = timeShareConfigs[i];
	    	if(item.timeShareType=="sms"){
	    		smsConfigs.push({
	                timeShareConfigId:item.timeShareConfigId,
	                timeShareType:item.timeShareType,
	                beginTime:item.beginTime,
	                endTime:item.endTime,
	                userIds:item.userIds
	            });
	    	}
	    	if(item.timeShareType=="phone"){
	    		phoneConfigs.push({
	                timeShareConfigId:item.timeShareConfigId,
	                timeShareType:item.timeShareType,
	                beginTime:item.beginTime,
	                endTime:item.endTime,
	                userIds:item.userIds
	            });
	    	}
	    }
		timeShareConfig("smsConfigTable",smsConfigs);
		timeShareConfig("phoneConfigTable",phoneConfigs);
	}
//---- nielin add for timeShareConfig 2010-01-03 end-------------------------------------------------------------------------
</script>

<script type="text/javascript" src="<%=rootPath%>/topology/network/js/wincloseoverride.js"></script>
</head>
<body id="body" class="body" onload="initmenu();">

<!-- 这里用来定义需要显示的右键菜单 -->
	<div id="itemMenu" style="display: none";>
	<table border="1" width="100%" height="100%" bgcolor="#F1F1F1"
		style="border: thin;font-size: 12px" cellspacing="0">
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.edit()">修改信息</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.detail();">监视信息</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.cancelmanage()">取消监视</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.addmanage()">添加监视</td>
		</tr>		
	</table>
	</div>
	<!-- 右键菜单结束-->
   <form name="mainForm" method="post">
   <input type=hidden name="id" value="<%=id%>">
   <input type=hidden name="ipaddress" value="<%=ipaddress%>">
		<table id="body-container" class="body-container">
			<tr>
				
				<td class="td-container-main">
					<table id="container-main" class="container-main">
						<tr>
							<td class="td-container-main-add">
								<table id="container-main-add" class="container-main-add">
									<tr>
										<td>
											<table id="add-content" class="add-content">
												<tr>
													<td>
														<table id="add-content-header" class="add-content-header">
										                	<tr>
											                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
											                	<td class="add-content-title">设备端口配置息 >> <%=ipaddress%></td>
											                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
											       			</tr>
											        	</table>
				        							</td>
				        						</tr>
				        						<tr >
													<td>
														<table id="add-content-header" class="add-content-header" width="100%">
										                	<tr >
											                	<td align="right" width="">
											                	<INPUT type="button" class="formStyle" value="提交更新" onclick="updateflag()"/>
											                	   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											                	   <INPUT type="button" class="formStyle" value="刷 新" onclick="doNodeFromlastoconfig()"/>
											                	   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											                	</td>	
											       			</tr>
											        	</table>
				        							</td>
				        						</tr>
				        						<tr>
				        							<td>
				        								<table id="detail-content-body" class="detail-content-body">
				        									<tr>
				        										<td>
				        										
				        												<table border="0" id="table1" cellpadding="0" cellspacing="1" width="100%">
																	<TBODY>
																	<tr>
							      											<th width='4%'   class="report-data-body-title" align="center" bgcolor=#F1F1F1>序号</th>				
							      											<th width='15%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>设备名称(ip)</th>
							      											<th width='6%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>端口</th>
							      											<th width='12%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>描述</th>      
							      											<th width='14%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>端口应用</th>
							      											<th width='6%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>速率(kb/s)</th>
							      											<th width='6%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>Trap监视</th>
							      											<th width='10%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>报警级别</th>
							      											<th width='10%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>是否监视速率
							      											<INPUT type="checkbox" id="checkall" name="checkall" onclick="javascript:chkall()" class="noborder">																				
							      											</th>	
							      											<th width='8%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>报表显示操作</th>
							      											<th width='5%' class="report-data-body-title" align="center" bgcolor=#F1F1F1>操作</th>
							      											
																	</tr>

<%
    Portconfig vo = null;
    for(int i=0;i<list.size();i++)
    {
       vo = (Portconfig)list.get(i);

          
%>
   										<tr bgcolor="#FFFFFF" >  
    											<td class="report-data-body-list"><font color='blue'>&nbsp;<%= 1+i%></font></td>
    											<td  class="report-data-body-list"><%=vo.getIpaddress()%></td>
    											<td  class="report-data-body-list"><%=vo.getPortindex()%></td>
    											<td  class="report-data-body-list"><%=vo.getName()%></td>
    											<td  class="report-data-body-list" id="linkUse<%=vo.getId()%>"><%=vo.getLinkuse()%></td>
    											<td  class="report-data-body-list"><%=vo.getSpeed()%></td>
    											<%
    												String smsbgcolor="skyblue";
    												String repbgcolor="skyblue";
    												String sms="<span style='cursor:hand' onclick='editNodePort("+vo.getId()+",0)'><font color=green>取消监视</font></span>";
    												if(vo.getSms()==0){
    													smsbgcolor="#FFFFFF";
    													sms="<span style='cursor:hand' onclick='editNodePort("+vo.getId()+",1)'><font color=#skyblue>监视</font></span>";
    												}
    												String reportflag = "<span style='cursor:hand' onclick='editNodePortForReport("+vo.getId()+",0)'><font color=green>取消显示于报表</font></span>";
    												if(vo.getReportflag()==0){
    													repbgcolor="#FFFFFF";
    													reportflag="<span style='cursor:hand' onclick='editNodePortForReport("+vo.getId()+",1)'><font color=#skyblue>显示于报表</font></span>";
    												}
    											%>
    											<td  align='center' class="report-data-body-list" id="smsFlag<%=vo.getId() %>"><%=sms%></td>
    											<% 
    											   String alarmlevel = vo.getAlarmlevel();
    											   //String varalarmlevel = "";
    											   if(alarmlevel == null || alarmlevel.equals("")) {
    												   alarmlevel = "0";
    											   }
    											%>
    											<td align="center" height=23>
													<select style="width:60px;" id="alarmlevel<%=vo.getId()%>">
    													<option  value="0" <%if(alarmlevel.equals("0")) {%>selected<%} %>>无</option>
    													<option  value="1" <%if(alarmlevel.equals("1")) {%>selected<%} %>>普通</option>
    													<option  value="2" <%if(alarmlevel.equals("2")) {%>selected<%} %>>重要</option>
    													<option  value="3" <%if(alarmlevel.equals("3")) {%>selected<%} %>>紧急</option>    													
    													</select>
     												<img href="#" src="<%= rootPath%>/resource/image/menu/xgmm.gif" style="cursor:hand" onclick="modifyalarmlevelajax('<%=vo.getId()%>');"/>
												</td>
											<td  align='center' class="report-data-body-list" id="countflag"><input id="<%=vo.getId()%>" name="checkflag" type="checkbox" value="<%=vo.getPortindex()%>"
																					<%
																					
																					 if( vo.getFlag() != null && vo.getFlag().equals("1")){
																					
																								%> checked="checked" <%
																								}
																						%> /></td>
											<td  align='center' class="report-data-body-list" id="reportflag<%=vo.getId() %>"><%=reportflag%></td>
											<td  class="report-data-body-list" align='center'><span style='cursor:hand' onClick='window.open("<%=rootPath%>/portconfig.do?action=showedit&id=<%=vo.getId()%>","_blank", "height=400, width= 500, top=200, left= 200")'>
											<img src="<%=rootPath%>/resource/image/menu/xgmm.gif" border="0"/></span></td>
        										
  										</tr>			
<% }%>            
            					</tbody>
            					</table>
            					<br>
			</TD>																			
			</tr>			
															
															<tr>
																<!-- nielin add (for timeShareConfig) start 2010-01-03 -->
																<td><input type="hidden" id="rowNum" name="rowNum"></td>
																<!-- nielin add (for timeShareConfig) end 2010-01-03 -->
															
															</tr>
															<tr>
																<TD nowrap colspan="4" align=center>
																
																	<input type="reset" style="width:50" value="关闭" onclick="javascript:window.close()">
																</TD>	
															</tr>		 							
										 							
				        								</table>
				        							</td>
				        						</tr>
				        						<tr>
				        							<td>
				        								<table id="detail-content-footer" class="detail-content-footer">
				        									<tr>
				        										<td>
				        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											                  			<tr>
											                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
											                    			<td></td>
											                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
											                  			</tr>
											              			</table>
				        										</td>
				        									</tr>
				        								</table>
				        							</td>
				        						</tr>
				        					</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
	</form>
</BODY>


</HTML>