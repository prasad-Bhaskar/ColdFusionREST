<cfcomponent rest="true" restpath="studentAPI">
  <!--- Creating student object --->
  <cfobject name="student" component="cfc.student">
  <cfobject name="courses" component="cfc.courses">

<!---  Student Spasific functions start from here... --->
  <!--- Function to validate token--->
<!---   <cffunction name="authenticate" returntype="any"> 
    <cfset var response = {}>
    <cfset requestData = GetHttpRequestData()>
    <cfif StructKeyExists( requestData.Headers, "authorization" )>
      <cfset token = GetHttpRequestData().Headers.authorization>
      <cftry>
        <cfset jwt = new cfc.jwt(Application.jwtkey)>
        <cfset result = jwt.decode(token)>
        <cfset response["success"] = true>
        <cfcatch type="Any">
          <cfset response["success"] = false>
          <cfset response["message"] = cfcatch.message>
          <cfreturn response>
        </cfcatch>
      </cftry>
    <cfelse>
      <cfset response["success"] = false>
      <cfset response["message"] = "Authorization token invalid or not present.">
    </cfif>
    <cfreturn response>
  </cffunction>--->

  <cffunction name="registerStudent" access="remote" returntype="any" httpmethod="post" restpath="register" produces="application/json">
      <cfargument name="structForm" type="any" required="true">

      <cfset local.response = structNew()>
      <cfset local.response = student.registerStudent(arguments.structForm)>
      <cfreturn local.response>
  </cffunction> 

  <cffunction name="loginStudent" restpath="login" access="remote" returntype="struct" httpmethod="POST" produces="application/json">
      <cfargument name="structform" type="any" required="yes">
<!---       <cfdump  var="#structform#" abort="true"> --->
  
      <cfset var response = {}>
      <cfset response = student.loginStudent(structform)>
      <cfreturn response>
  
  </cffunction>

  <!--- student specific functions --->
  <cffunction name="getStudentData" restpath="studentDetail" access="remote" returntype="struct" httpmethod="GET" produces="application/json">
    <cfset local.limit = url.limit>
    <cfset local.offset = url.offset>
    <cfset var response = {}>
    <cfset response = student.studentData(limit = local.limit, offset = local.offset)>
    <cfreturn response>
  </cffunction>
<!---  Student Spasific functions ends from here... --->

<!---  Courses Spasific functions start from here... --->
<cffunction  name="getCourses" access="remote" returntype="any" httpmethod="post" restpath="getCourses" produces="application/json">
  <cfargument name="structForm" type="any" required="true">
  <cfset local.response = {}>
  <cfset local.response = courses.getCourses(arguments.structForm)>
  <cfreturn local.response>
</cffunction>
<!---  Courses Spasific functions ends from here... --->   



<cffunction  name="test" access="remote" returntype="any" httpmethod="get" restpath="test" produces="application/json">
  <cfset response = {}>
  <cfset response.status = 200>
  <cfset response.message = 'testing'>
  <cfreturn response>
</cffunction>

</cfcomponent>