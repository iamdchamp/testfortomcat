<!-- 
	This file is created for auditing team. 
	This jsp is similar to index.jsp but it provide the functionality to generate the changelog between two dates.
-->

<%@page import="functionality.SvnUtility"%>
<%@page import="functionality.GitUtility"%>
<%@page import="functionality.CommonUtility"%>
<%@ page errorPage="error.jsp"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/mystyle.css">
<script type="text/javascript" src="js/Interactive2.js"></script>
<meta charset="ISO-8859-1">
<title>ChangeLogGenerator</title>
</head>

<body>
<div id="form">


<form name="generator" id="generator" action="OperationServlet" method="post">


		<label>Select Output</label>
		<select id="outputType" name="outputType" onchange="populateInputType()">
			<option value="selectOutput" id="generateChangeLog">Select Output</option>
			<option value="generateChangeLog" id="generateChangeLog">Generate ChangeLog</option>
			<option value="getJira" id="getJira">Get Jira</option>
		</select> 
		<br><br>
		<label>Select Version Control System</label> 
		<select id="vcs" name="vcs" onchange="getProject(); changeLabelText()">
			<option>Select Version Control System</option>
			<option value="git" id="git">GIT</option>
			<option value="svn" id="svn">SVN</option>
		</select> 
		<br> 
		<br> 
		<label name="lblselectprojectname">Select	Project Name</label> 
		<select id="projectlist" name="projectlist" onchange="getRepo(); getBranches();">
		<option value="SelectProjectName">Select Project Name</option>
		</select> 
		<br> 
		<br> 
		<label id="lblselectrepotname">Select Repository Name</label> 
			<select id="repolist" name="repolist">
			<option	value="SelectRepoName">Select Repository Name</option>
		</select> <br> <br> <label name="typeofinput">Type of inputs</label>

		<select id="inputtype" name="inputtype" onchange="changeLabelText() ; getBranches()">
		
		</select> 
		<br> 
		<br> 
		<div div id="commit" name="commit">
		<label id="label1">Enter First Commit</label> 
		<input type="text" name="input1" id="input1" value="" placeholder="" /> <br>
		<br> 
		<label id="label2">Enter Second Commit</label> 
		<input	type="text" name="input2" id="input2" value="" placeholder="" /> <br>
		<br> 
		<br> 
		</div>
		<div id="tag" name="tag" style="display: none">
		<label id="label1">Select First Tag</label> 
		<select name="tag1" id="tag1">
			<option	value="selectTag1">Select Tag</option>
		</select> 
		<br>
		<br> 
		<label id="label2">Select Second Tag</label> 
		<select name="tag2" id="tag2">
		<option	value="selectTag1">Select Tag</option>
		</select> 
		<br>
		<br> 
		<br> 
		</div>		
		<input type="button" id="generatelog" name="generatelog" value="Generate Output" onClick="submission()" />
		</form>
	</div>
	<div id="loader" class="loader" style="display: none;"></div>
</body>

<script>
 function getGitTag(){
	var selectProject = document.getElementById("projectlist");
	project=selectProject.options[selectProject.selectedIndex].text;
	var tagselect1=document.getElementById("tag1");
	var tagselect2=document.getElementById("tag2");
	tagselect1.innerText = null;
	tagselect2.innerText = null;
	tagselect1.add(new Option("Select Tag", "SelectTag"));
	tagselect2.add(new Option("Select Tag", "SelectTag"));	
	<%	
	GitUtility gitUtility=new GitUtility("EMR");
	List<String> gitEMRTags=gitUtility.getGitTag("EMR","emr");
	List<String> gitHEALTags=gitUtility.getGitTag("HEAL","healowinsights");
	%>
	if(project=="EMR"){
	<%
		for(String tag:gitEMRTags)
	{%>		
		tagselect1.add(new Option("<%=tag%>", "<%=tag%>"));
		tagselect2.add(new Option("<%=tag%>", "<%=tag%>"));			
	<%}
		%>
	} else if(project=="HEAL"){
		<%
		for(String tag:gitHEALTags)
	{%>		
		tagselect1.add(new Option("<%=tag%>", "<%=tag%>"));
		tagselect2.add(new Option("<%=tag%>", "<%=tag%>"));			
	<%}
		%>
		
	}
}



<%-- function getSvnTag(){
	var tagselect1=document.getElementById("tag1");
	var tagselect2=document.getElementById("tag2");
	tagselect1.innerText = null;
	tagselect2.innerText = null;
	tagselect1.add(new Option("Select Tag", "SelectTag"));
	tagselect2.add(new Option("Select Tag", "SelectTag"));	
	<%
		SvnUtility svnUtility=new SvnUtility();
		List<String> svnTags=svnUtility.getSvnTags();
		for(String tag:svnTags)
		{%>
			tagselect1.add(new Option("<%=tag.trim()%>", "<%=tag.trim()%>"));
			tagselect2.add(new Option("<%=tag.trim()%>", "<%=tag.trim()%>"));	
		<%}
	%>
	} --%>
	
function fillTag(vcs)
{
	var inputtype=document.getElementById("inputtype");
	if(inputtype.options[inputtype.selectedIndex].text=="Between Two Tags"){
		if(vcs=="SVN"){
			//getSvnTag();			
		}else if(vcs=="GIT"){
			getGitTag();
		}
	}
}

function getBranches(){
	var inputtype=document.getElementById("inputtype");
	if(inputtype.options[inputtype.selectedIndex].text=="Between Two Branches")
	{
		var selectProject = document.getElementById("projectlist");
		project=selectProject.options[selectProject.selectedIndex].text;
		var tagselect1=document.getElementById("tag1");
		var tagselect2=document.getElementById("tag2");
		tagselect1.innerText = null;
		tagselect2.innerText = null;
		<%
			ArrayList<HashMap<String, String>> EMRbranches=gitUtility.getGitBranches("EMR");
			ArrayList<HashMap<String, String>> HEALbranches=gitUtility.getGitBranches("HEAL");
		%>
	
		if(project=="EMR"){
			<%
		
			for (HashMap<String, String> branch : EMRbranches) {   
		    	if(branch.containsKey("EMR")){		    	
		    		%>	
		    			addOptionInDropDown("tag1","<%=branch.get("EMR")%>");
		    			addOptionInDropDown("tag2","<%=branch.get("EMR")%>");	
		    		<%
		    	}
			}
		
			%>		
		
		} else if (project=="HEAL"){
			<%
			for (HashMap<String, String> branch : HEALbranches) {   
		    	if(branch.containsKey("HEAL")){		    	
		    		%>	
		    			addOptionInDropDown("tag1","<%=branch.get("HEAL")%>");		    
		    			addOptionInDropDown("tag2","<%=branch.get("HEAL")%>");		 
		    		<%
		    	}
			}		
			%>
		
		}	
	}
	else if(inputtype.options[inputtype.selectedIndex].text=="Between Two Tags"){
		var vcs = document.getElementById("vcs");
		var selectedvcs = vcs.options[vcs.selectedIndex].text;
		fillTag(selectedvcs);
	}
}
</script>

</html>