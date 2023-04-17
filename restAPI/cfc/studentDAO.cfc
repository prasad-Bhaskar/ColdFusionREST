<cfcomponent>
    <cffunction name="init" returnType="any">
        <cfargument name="dsn" default="#application.dsn#">
        <cfset this.dsn = arguments.dsn>
        <cfreturn this>
    </cffunction>
    <cffunction name="registerStudent" access="public" returntype="struct"> 
        <cfargument name="studentData" type="struct" required="true">
        <cfset local.id = createUUID()>
        <cfset result = {}>
        <cftry>
            <cfquery name="insertStudent" datasource="#application.datasource#" result="studentAdd">
                INSERT INTO student(id, NAME, email)VALUES(
                    <cfqueryparam value="#local.id#" cfsqltype="CF_SQL_VARCHAR">
                    ,<cfqueryparam value="#arguments.studentData.name#" cfsqltype="CF_SQL_VARCHAR">
                    ,<cfqueryparam value="#arguments.studentData.email#" cfsqltype="CF_SQL_VARCHAR">
                )
            </cfquery>
            <cfset result.success = true>
            <cfset result.massage = "New Student created Successfully..!">
        <cfcatch type="any">
            <cfset result.success = false>
            <cfset result.massage = cfcatch.message>
        </cfcatch>
        </cftry>
    <cfreturn result>
</cffunction>

    <cffunction  name="loginStudent" access="public" returnType="query">
        <cfargument  name="studentData" type="struct" required="true">
        <cfquery name="getStudent" datasource="#this.dsn#" >
            SELECT * FROM students WHERE email = <cfqueryparam value="#arguments.studentData.email#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn getStudent>
    </cffunction>
     
    <cffunction  name="getStudentData" access="public" returnType="any">
        <cfargument  name="limit" type="any" required="true">
        <cfargument  name="offset" type="any" required="true">
  
        <cfset local.response = {}>
        <cfquery name="studentCount" datasource="#application.datasource#" >
            SELECT count(*) AS total FROM students 
        </cfquery>
  
        <cfquery name="getStudent" datasource="#application.datasource#" >
            SELECT * FROM students 
            order by id 
            OFFSET #arguments.offset# ROWS
            FETCH NEXT #arguments.limit# ROWS ONLY
        </cfquery>
        
        <cfset local.response.count = studentCount.total>
        <cfset local.response.items = getStudent>
        <cfreturn local.response>
    </cffunction> 
</cfcomponent>