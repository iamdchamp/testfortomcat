
<%@page import="restfunctionality.RestApiCaller"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
String selection = request.getParameter("inputtype");
String reponame = request.getParameter("repolist");
String projectname = request.getParameter("projectlist");
String vcs = request.getParameter("vcs");
String input1=null;
String input2=null;
String operationtype = request.getParameter("outputType");
if (selection.contains("Tags") || selection.contains("Branches")) {
	input1 = request.getParameter("tag1");
	input2 = request.getParameter("tag2");
} else {
	input1 = request.getParameter("input1");
	input2 = request.getParameter("input2");
}
RestApiCaller caller=new RestApiCaller();
%>

<form>
<textarea rows="40" cols="300" name="comment" id="comment">

</textarea>
</form>

</body>
</html>


<script type="text/javascript">
var selection="<%=selection%>"
var reponame="<%=reponame%>"
var projectname="<%=projectname%>"
var vcs="<%=vcs%>"
var operationtype="<%=operationtype%>"

var message="";
generateChangeLog();
function generateChangeLog(){
	var input1="<%=input1%>"
	var input2="<%=input2%>"
	var xhttp = new XMLHttpRequest();	
	xhttp.open("GET", "http://10.210.22.86:8000/GUI_Testing/Operational.jsp?api=generateGitLog&projectname="+projectname+"&reponame="+reponame+"&input1="+input1+"&input2="+input2, true);
	xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {	       
	    	var jsons1=this.response.trim();
	    	//alert(jsons1);
	    	var logsJson=JSON.parse(jsons1);
	       	var totalLogSize=Object.keys(logsJson.values).length;	    	
	       	alert(totalLogSize);
	    	for(var i=0;i<totalLogSize;i++){	
	    		//alert(logsJson.values[i].id);
	    		//alert(logsJson.values[i].author.name);
	    		//alert(logsJson.values[i].message);	
	    		message="========================================================================\n"
	    		message=message.concat("Commit ID :"+logsJson.values[i].id,"\n");
	    		message=message.concat(logsJson.values[i].author.name,"\n");
	    		message=message.concat(logsJson.values[i].message,"\n");	 
	    		message="========================================================================\n"
	    	}
	    	var comment = document.getElementById("comment");
	    	comment.value=message;
	    	console.log(message);
	    } else if (this.readyState == 4 && this.status != 200){
	    	
	    	console.log("Unable to Call URL")
	    }
	    
	};
	xhttp.send();
	
	
}

</script>