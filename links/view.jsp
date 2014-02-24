<html>
<%@page import="java.util.*,
				java.lang.Integer,
				blackboard.base.*,
				blackboard.data.*,
                blackboard.data.user.*,
				blackboard.data.course.*,
                blackboard.persist.*,
                blackboard.persist.user.*,
				blackboard.persist.course.*,
                blackboard.platform.*,
                blackboard.platform.persistence.*,
				blackboard.portal.external.*,
				blackboard.platform.session.*,
				java.text.SimpleDateFormat"
%>
<%@ taglib uri="/bbData" prefix="bbData"%>
<%@ taglib uri="/bbUI" prefix="bbUI"%>

<%@page import="blackboard.platform.plugin.PlugInUtil"%>
<% String URL = PlugInUtil.getUri("octt", "octetwhosonline", "module"); %>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
     


<body>
  <div id="myDiv">
    
    <script>
//calls this function if the online classmate has no picture to display
function imageError(theImage)
{
theImage.src="http://octet1.csr.oberlin.edu/octet/Bb/Faculty/img/noimage.jpg";
theImage.onerror = null;
}
</script>


<bbData:context id="userCtxAvail" >
<%



List<Course> courses = null;

//getting a list of all current active sessions on Blackboard
BbSessionManagerService sessionService = BbServiceManager.getSessionManagerService();   
List sessionList = sessionService.getActiveSessionList();

//making a list of users given by their usernames from the sessionList
ArrayList<String> activeUsers = new ArrayList<String>();
for (Object o: sessionList){
	BbSession sesh = (BbSession) o;  //Casting as a session
	String username = sesh.getUserName(); //Getting the online user from the session
	if (!activeUsers.contains(username)){ //Eliminates duplicates of users who are online in more than one browser
		activeUsers.add(username);
	}
}

%> <div style="width:250;float:left;"> <%
for (int usr=0;usr<activeUsers.size();usr++){
	if (usr==(activeUsers.size()/4)+1 || usr==(activeUsers.size()/2)+1 || usr==(activeUsers.size()/2)+(activeUsers.size()/4)+1) {
			%> </div>
			<div style="width:250;float:left;"> <%
	}
		String username = activeUsers.get(usr);
		%> <div><img src="https://octet1.csr.oberlin.edu/octet/Bb/Photos/expo/<%=username%>/profileImage" alt="<%=username%>" width="35"></img>&nbsp;<%=username	 %></div> <%
	
}
%>
</div>
 
</bbData:context>

</div>
    
 </body>
</html>