<cfcomponent hint="studentSpacific methods" displayName="student">
    <cffunction  name="init" hint="constroctor of student">
        <cfargument  name="dsn" default="#application.dsn#">
        <cfset this.dsn = arguments.dsn>
    </cffunction>
    <cfscript>
        studentDAO = createObject("component","studentDAO").init("restAPI");
        util = createObject("component","util");
    </cfscript>

    <cffunction  name="registerStudent" returnType="any" access="public">
        <cfargument  name="studentStruct" type="any" required="true">
        <cfreturn studentDAO.registerStudent(arguments.studentStruct)>
    </cffunction>

    <cffunction  name="loginStudent" returnType="any" output="true" access="public">
        <cfargument  name="studentStruct" type="any" required="true">
        <cfset var resObj = {}>
        <cfset local.studentData = studentDAO.loginStudent(arguments.studentStruct)>
    <!--- <cfquery> to check student credentials --->

    <cfif local.studentData.recordcount gt 0> <!--- if student credentials are valid --->
      <cfset studentDataArray = util.QueryToArray(local.studentData)>
      <cfset expdt =  dateAdd("n",30,now())>
      <cfset utcDate = dateDiff('s', dateConvert('utc2Local', createDateTime(1970, 1, 1, 0, 0, 0)), expdt) />

      <cfset jwt = new jwt(Application.jwtkey)>
      <cfset payload = {"iss" = "studentAPI", "exp" = utcDate, "sub": "JWT Token"}>
      <cfset token = jwt.encode(payload)>

      <cfset resObj["success"] = true>
      <cfset resObj["message"] = "Login Successful">
      <cfset resObj["token"] = token>
    <cfelse> <!--- if student credentials are invalid --->
      <cfset resObj["success"] = false>
      <cfset resObj["message"] = "Incorrect login credentials.">
    </cfif>

    <cfreturn resObj>
    </cffunction>
    <cffunction  name="studentDetails"  returnType="any" output="true" access="public">
        <cfargument  name="email" type="any" required="true">
        <cfset local.studentData = studentDAO.getstudentDetails(arguments.email)>
        <cfif local.studentData.recordcount gt 0>
            <cfset local.studentDataArray = util.QueryToArray(local.studentData)>
            <cfset resObj["success"] = true>
            <cfset resObj["message"] = "Student Details Fetched successfully...!">
            <cfset resObj["data"] = serializeJSON(local.studentDataArray)>
        <cfelse>
            <cfset resObj["success"] = false>
            <cfset resObj["message"] = "Student Details not foundy...!">
            <cfset resObj["data"] = "">
        </cfif>
        <cfreturn resObj>
    </cffunction>
 
</cfcomponent>