<%@page import="restfunctionality.RestApiCaller"%>
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
<script type="text/javascript" src="js/InteractiveRest.js"></script>
<meta charset="ISO-8859-1">
<title>ChangeLogGenerator</title>
</head>

<body>
<div id="form">

<%
	RestApiCaller caller=new RestApiCaller();
%>
<form name="generator" id="generator" action="Result.jsp" method="post">

		
		<label>Select Output</label>
		<select id="outputType" name="outputType">
			<option value="selectOutput" id="generateChangeLog">Select Output</option>
			<option value="generateChangeLog" id="generateChangeLog">Generate ChangeLog</option>
			<option value="getJira" id="getJira">Get Jira</option>
		</select> 
		<br><br>
		<label>Select Version Control System</label> 
		<select id="vcs" name="vcs" onchange="project1(); populateInputType()">
			<option>Select Version Control System</option>
			<option value="git" id="git">GIT</option>
			<option value="svn" id="svn">SVN</option>
		</select> 
		<br> 
		<br> 
		<label name="lblselectprojectname">Select	Project Name</label> 
		<select id="projectlist" name="projectlist" onchange="repo1()">
		<option value="SelectProjectName">Select Project Name</option>
		</select> 
		<br> 
		<br> 
		<label id="lblselectrepotname">Select Repository Name</label> 
			<select id="repolist" name="repolist" onchange="gettag()">
			<option	value="SelectRepoName">Select Repository Name</option>
		</select> <br> <br> <label name="typeofinput">Type of inputs</label>

		<select id="inputtype" name="inputtype" onchange="inputController()">
		
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
<%-- function getGitTag(){
	var selectProject = document.getElementById("projectlist");
	project=selectProject.options[selectProject.selectedIndex].text;
	var tagselect1=document.getElementById("tag1");
	var tagselect2=document.getElementById("tag2");
	tagselect1.innerText = null;
	tagselect2.innerText = null;
	tagselect1.add(new Option("Select Tag", "SelectTag"));
	tagselect2.add(new Option("Select Tag", "SelectTag"));	
	<%	
	GitUtility gitUtility=new GitUtility();
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



function getSvnTag(){
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
	}
	
function fillTag(vcs)
{
	var inputtype=document.getElementById("inputtype");
	if(inputtype.options[inputtype.selectedIndex].text=="Between Two Tags"){
		if(vcs=="SVN"){
			getSvnTag();			
		}else if(vcs=="GIT"){
			getGitTag();
		}
	}
} --%>


function project1(){
	var selectproject = document.getElementById("projectlist");
	selectproject.innerText = null;
	var xhttp = new XMLHttpRequest();	
	xhttp.open("GET", "http://10.210.22.86:8000/GUI_Testing/Operational.jsp?api=project", true);
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {	       
	    	var jsons1=this.response.trim();
	    	var js=JSON.parse(jsons1);
	       	var totalRepoCount=Object.keys(js.values).length;	    	
	    	for(var i=0;i<totalRepoCount;i++){	    		
	    		addOptionInDropDown('projectlist',js.values[i].key)
	    	}
	    }
	};
	xhttp.send();
} 

function repo1(){	
	var selectrepo = document.getElementById("repolist");
	var selectproject = document.getElementById("projectlist");
	var project=selectproject.options[selectproject.selectedIndex].text;
	
	selectrepo.innerText = null;
	var xhttp = new XMLHttpRequest();	
	xhttp.open("GET", "http://10.210.22.86:8000/GUI_Testing/Operational.jsp?api=repo&projectname="+project, true);
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {	       
	    	var jsons1=this.response.trim();
	    	var js=JSON.parse(jsons1);
	       	var totalRepoCount=Object.keys(js.values).length;	    	
	    	for(var i=0;i<totalRepoCount;i++){	    		
	    		addOptionInDropDown('repolist',js.values[i].name)
	    	}
	    }
	};
	xhttp.send();
}

function inputController(){
	
	changeLabelText();
	var selectrepo = document.getElementById("repolist");
	var selectproject = document.getElementById("projectlist");
	var project=selectproject.options[selectproject.selectedIndex].text;
	var repo=selectrepo.options[selectrepo.selectedIndex].text;
	
	var selectInput = document.getElementById("inputtype");
	var selectedInputType=selectInput.options[selectInput.selectedIndex].text;
	if(selectedInputType=="Between Two Tags"){
		gettag(project,repo);
	} else if(selectedInputType=="Between Two Commits"){
		
	} else if(selectedInputType=="Between Two Branches"){
		fillgitBranches(project,repo);		
	}
	
}

function gettag(projectName,repoName){
	var selectvcs = document.getElementById("vcs");
	var vcs=selectvcs.options[selectvcs.selectedIndex].text;
	if(vcs=="GIT"){
		fillgittag(projectName,repoName)
	}else if(vcs=="SVN"){
		
	}
}

function fillgittag(projectName,repoName){
	
	var tagselect1=document.getElementById("tag1");
	var tagselect2=document.getElementById("tag2");
	tagselect1.innerText = null;
	tagselect2.innerText = null;	
	var xhttp = new XMLHttpRequest();	
	xhttp.open("GET", "http://10.210.22.86:8000/GUI_Testing/Operational.jsp?api=gitag&projectname="+projectName+"&reponame="+repoName, true);
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {	       
	    	var jsons1=this.response.trim();
	    	var js=JSON.parse(jsons1);
	       	var totalRepoCount=Object.keys(js.values).length;	    	
	    	for(var i=0;i<totalRepoCount;i++){	    		
	    		addOptionInDropDown('tag1',js.values[i].displayId)
	    		addOptionInDropDown('tag2',js.values[i].displayId)
	    	}
	    }
	};
	xhttp.send();
	
}

function fillgitBranches(projectName,repoName){
	
	var tagselect1=document.getElementById("tag1");
	var tagselect2=document.getElementById("tag2");
	tagselect1.innerText = null;
	tagselect2.innerText = null;
	var xhttp = new XMLHttpRequest();	
	xhttp.open("GET", "http://10.210.22.86:8000/GUI_Testing/Operational.jsp?api=gitbranches&projectname="+projectName+"&reponame="+repoName, true);
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {	       
	    	var jsons1=this.response.trim();
	    	var js=JSON.parse(jsons1);
	       	var totalRepoCount=Object.keys(js.values).length;	    	
	    	for(var i=0;i<totalRepoCount;i++){	    		
	    		addOptionInDropDown('tag1',js.values[i].displayId)
	    		addOptionInDropDown('tag2',js.values[i].displayId)
	    	}
	    }
	};
	xhttp.send();
	
}

function fillSvnTag(projectName,repoName){
	
	
}



</script>


</html>