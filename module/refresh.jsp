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
				java.text.SimpleDateFormat,
				java.io.*,
				java.net.URL"
%>
<%@ taglib uri="/bbData" prefix="bbData"%>
<%@ taglib uri="/bbUI" prefix="bbUI"%>
<%@page import="blackboard.platform.plugin.PlugInUtil"%>




<div style="overflow-y:auto; overflow:auto; max-height: 300px; height: 300px">
<a href="https://octet1.csr.oberlin.edu/wp/OCTET/programmingwt2014/" target="_blank">More Info</a>
<br><br>
<bbData:context id="userCtxAvail" >
<%
String URL = PlugInUtil.getUri("octt", "octetwhosonBb", "module");
BufferedReader reader = new BufferedReader(new FileReader(URL+"OptOut.txt"));
String data="";
String nextLine;

while((nextLine = reader.readLine())!= null){
    data += nextLine+"\n";
}
//File file = new File("OptOut.txt");
//Scanner test = new Scanner(file);
//String data = "";
//while(test.hasNextLine()) {
//	data += test.nextLine();
//}

%>
<%@include file="OptOut.txt" %>
<%-- 
<div><%=data%></div>
--%>
<%
List<Course> courses = null;

//getting a list of all current active sessions on Blackboard
BbSessionManagerService sessionService = BbServiceManager.getSessionManagerService();   
List sessionList = sessionService.getActiveSessionList();

//making a list of users given by their usernames from the sessionList
ArrayList<String> noDuplicates = new ArrayList<String>();
for (Object o: sessionList){
	BbSession sesh = (BbSession) o;  //Casting as a session
	String seshName = sesh.getUserName(); //Getting the online user from the session
	if (noDuplicates.contains(seshName)==false){
		noDuplicates.add(seshName); //Eliminates duplicates of users who are online in more than one browser
	}
}

Calendar c = Calendar.getInstance();
%>
<%-- To show the last time this module updated:

<% SimpleDateFormat sdf = new SimpleDateFormat("hh:mm:ss"); %>
 <div>Last updated at <%=sdf.format(c.getTime()) %></div>
<br>

--%>
<% 


User currentUser = userCtxAvail.getUser();

Id currId = currentUser.getId();

courses = CourseDbLoader.Default.getInstance().loadByUserId(currentUser.getId()); 

for (Course currentCourse: courses) {
	boolean anyOnline = false;
	Id id = currentCourse.getId();
	String courseID = currentCourse.getCourseId();
	if(courseID.length() <6){
		continue;
	}
	String courseTerm = courseID.substring(0, 6);
	String courseName = currentCourse.getTitle();
	Calendar endDate = currentCourse.getEndDate();
	Calendar startDate = currentCourse.getStartDate();
	BbPersistenceManager bbPm = BbServiceManager.getPersistenceService().getDbPersistenceManager();
	CourseMembershipDbLoader cmLoader = (CourseMembershipDbLoader)bbPm.getLoader( CourseMembershipDbLoader.TYPE );
	
	int month = c.get(Calendar.MONTH);
	if (month<7){
		month = 2;
	}
	else if (month>8){
		month = 9;
	}
	String newMonth = Integer.toString(month);
	int year = c.get(Calendar.YEAR);
	String newYear = Integer.toString(year);
	
	
	if (courseTerm.contains(newYear) && courseTerm.endsWith(newMonth)){ //filters out classes from previous or future semesters
		UserDbLoader loader = (UserDbLoader) bbPm.getLoader( UserDbLoader.TYPE );
		blackboard.base.BbList userlist = null;
		userlist = loader.loadByCourseId(id);
		BbList.Iterator userIter = userlist.getFilteringIterator();
		%>
		<div><b><%=courseName%>:</b> </div>
		<% 
		while (userIter.hasNext()){
			User classMate = (User) userIter.next();
			CourseMembership cmData = cmLoader.loadByCourseAndUserId(id, classMate.getId());
			Id classMateId = classMate.getId();
			if (classMateId.equals(currId)==false && cmData.getRole() == cmData.getRole().STUDENT){
				String classMateUserName = classMate.getUserName();
				if (noDuplicates.contains(classMateUserName)){
				 	anyOnline = true;
				 	String userName = classMate.getUserName();
					String fname = classMate.getGivenName();
					String lname = classMate.getFamilyName();
					String email = classMate.getEmailAddress();
					%>
					<img src="https://octet1.csr.oberlin.edu/octet/Bb/Photos/expo/<%=userName%>/profileImage" alt=""  width="35"/>
					<a href="mailto:<%=email %>" ><%=fname + " "+ lname %></a>
					<br>
					<%
				
			}
			 }
		}
	
	
	 if (anyOnline==false){
			%>
			<div>Nobody is online right now. </div>
			<%
	 }
	 }
	
 } 
 
 
  %>



 
</bbData:context>
</div>
