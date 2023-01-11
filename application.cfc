<cfcomponent output="false">
    <cfset this.name = "UsersAPI">
    <cfset this.restsetting = {
        cflocation :"./",
        skipcfcerror:true
    }>
    <cfset this.mappings = structNew()>
    <cfset this.mappings["/cfc"] = expandPath("/UsersAPI/restAPI/cfc")>
    <cffunction  name="onApplicationStart" returntype="boolean">
        <cfset application.dsn = "restAPI">
        <cfset application.jwtKey = "%ng@dkdbW">
        <cfset application.studentServises = new cfc.student(application.dsn)>
        <cfset application.studentDAO = new cfc.studentDAO(application.dsn)>
        <cfset application.utilServises = new cfc.util()>
        <cfset restInitApplication(getDirectoryFromPath(getCurrentTemplatePath())&"restAPI", "API")>
        <cfreturn true>
    </cffunction>
    
    <cffunction  name="onRequestStart" returntype="void">
        <cfif isDefined("url.init") and url.init gt 0>
            <cfset onApplicationStart()>
            <cfhtmlhead  text="<script>alert('application is refreshed')</script>">
        </cfif>
    </cffunction>
</cfcomponent>