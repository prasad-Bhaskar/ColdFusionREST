<cfcomponent>
    <cffunction  name="init" hint="constroctor of student">
        <cfargument  name="dsn" default="#application.dsn#">
        <cfset this.dsn = arguments.dsn>
    </cffunction>
    <cfscript>
        coursesDAO = createObject("component","coursesDAO").init("restAPI");
        util = createObject("component","util");
    </cfscript>
    <cffunction  name="getCourses" returnType="any" access="public">
        <cfargument  name="coursesData" type="any" required="true">
        <cfreturn coursesDAO.registerStudent(arguments.coursesData)>       
    </cffunction>
</cfcomponent>