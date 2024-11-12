<%@page import="java.io.Console"%>
<%@page import="restfunctionality.RestApiCaller"%>

  <%   
  
  String val = request.getParameter("api"); 
  String projectname = request.getParameter("projectname"); 
  String repoName=request.getParameter("reponame");
  String selection = request.getParameter("inputtype");
  String vcs = request.getParameter("vcs");
  String input1 = request.getParameter("input1");
  String input2 = request.getParameter("input2");
  
  RestApiCaller caller=new RestApiCaller();
  String json=null;
  if(val.equals("project")){
	  json=caller.connect("https://bitbucket.eclinicalworks.com/rest/api/1.0/projects?limit=100");
  }else if(val.equals("repo")){
	  json=caller.connect("https://bitbucket.eclinicalworks.com/rest/api/1.0/projects/"+projectname+"/repos?limit=100");
  }else if(val.equals("gitag")){
	  json=caller.connect("https://bitbucket.eclinicalworks.com/rest/api/1.0/projects/"+projectname+"/repos/"+repoName+"/tags");
  } else if(val.equals("gitbranches")){
	  json=caller.connect("https://bitbucket.eclinicalworks.com/rest/api/1.0/projects/"+projectname+"/repos/"+repoName+"/branches?limit=1000");
  } else if(val.equals("generateGitLog")){
	  json=caller.connect("https://bitbucket.eclinicalworks.com/rest/api/1.0/projects/" + projectname	+ "/repos/" + repoName + "/compare/commits?from=" + input1 + "&to=" + input2 + "&limit=5000");
  }  
  
  
  out.print(json);
  %> 