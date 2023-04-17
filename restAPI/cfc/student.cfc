<cfcomponent hint="studentSpacific methods" displayName="student">
    <cffunction  name="init" hint="constroctor of student">
        <cfargument  name="dsn" default="#application.dsn#">
        <cfset this.dsn = arguments.dsn>
    </cffunction>
    <cfscript>
        studentDAO = createObject("component","studentDAO").init("restdb");
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
    <cffunction  name="studentData"  returnType="struct" output="true" access="public" returnFormat="json">
        <cfargument  name="limit" type="any" required="true">
        <cfargument  name="offset" type="any" required="true">
        <cfset  local.studentData = studentDAO.getStudentData(limit= arguments.limit, offset = arguments.offset)>
        <cfif local.studentData.items.recordcount gt 0>
            <cfset local.studentDataArray = util.QueryToArray(local.studentData.items)>
            <cfset resObj["success"] = true>
            <cfset resObj["message"] = "Student Details Fetched successfully...!">
            <cfset resObj["data"]['items'] = local.studentDataArray>
            <cfset resObj["data"]['count'] = arguments.limit>
            <cfset resObj["data"]['hasMore'] = (local.studentData.count gt arguments.offset)? "YES" : "NO">
            <cfset resObj["data"]['limit'] = arguments.limit>
            <cfset resObj["data"]['totelResult'] = local.studentData.count>
            <cfset resObj["data"]['offset'] = ( arguments.offset + arguments.limit)>
        <cfelse>
            <cfset resObj["success"] = false>
            <cfset resObj["message"] = "Student Details not found...!">
            <cfset resObj["data"]['items'] = []>
            <cfset resObj["data"]['count'] = "">
            <cfset resObj["data"]['hasMore'] = "">
            <cfset resObj["data"]['limit'] = "">
            <cfset resObj["data"]['totelResult'] = "">
            <cfset resObj["data"]['offset'] = "">
        </cfif>
        <cfreturn resObj>
        <!--- <cfset  local.studentData = orderDao.getStudentData(limit= local.limit, offset = local.offset)>
  
        -- <cfif local.studentData.items.recordcount gt 0>
        --     <cfset local.studentDataArray = orderDao.QueryToArray(local.studentData.items)>
        --     <cfset resObj["success"] = true>
        --     <cfset resObj["message"] = "Student Details Fetched successfully...!">
        --     <cfset resObj["data"]['items'] = local.studentDataArray>
        --     <cfset resObj["data"]['count'] = local.limit>
        --     <cfset resObj["data"]['hasMore'] = (local.studentData.count gt local.offsetVal)? "YES" : "NO">
        --     <cfset resObj["data"]['limit'] = local.limit>
        --     <cfset resObj["data"]['totelResult'] = local.studentData.count>
        --     <cfset resObj["data"]['offset'] = (local.offset + local.limit)>
        -- <cfelse>
        --     <cfset resObj["success"] = false>
        --     <cfset resObj["message"] = "Student Details not found...!">
        --     <cfset resObj["data"]['items'] = []>
        --     <cfset resObj["data"]['count'] = "">
        --     <cfset resObj["data"]['hasMore'] = "">
        --     <cfset resObj["data"]['limit'] = "">
        --     <cfset resObj["data"]['totelResult'] = "">
        --     <cfset resObj["data"]['offset'] = "">
        -- </cfif>
        -- <cfreturn resObj> --->
    </cffunction>
 
</cfcomponent>