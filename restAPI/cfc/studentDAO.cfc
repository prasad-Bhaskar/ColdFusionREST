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
            <cfquery name="insertStudent" datasource="#this.dsn#" result="studentAdd">
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
            SELECT * FROM student WHERE email = <cfqueryparam value="#arguments.studentData.email#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn getStudent>
    </cffunction>
     
    <cffunction  name="getStudentDetails" access="public" returnType="query">
        <cfargument  name="email" type="any" required="true">
        <cfquery name="getStudent" datasource="#this.dsn#" >
            SELECT * FROM student WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR">
        </cfquery>
        <cfreturn getStudent>
    </cffunction> 
</cfcomponent>