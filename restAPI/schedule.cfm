
<cfset variables.offset = 0>
<cfset variables.limit = 2>
<cfset variables.hasMoreData = true>

<cfloop condition="variables.hasMoreData eq true">
    <cfsetting requestTimeout="7200">

    <!--- Get Student data  --->
<!---     <cfhttp result="getStudentData" method="GET" url="local.restapi/rest/controller/routes/studentDetail?limit=#variables.limit#&offset=#variables.offset#"> 
        <cfhttpparam type="Header" name="Content-Type" value="application/json"/>
    </cfhttp>
    <cfset variables.resultData = "#deserializeJSON(getStudentData.filecontent)#">
--->

<cfhttp result="getStudentData" method="GET" url="http://127.0.0.1:8500/rest/restAPI/studentAPI/studentDetail?limit=#variables.limit#&offset=#variables.offset#">
    <cfhttpparam type="Header" name="Content-Type" value="application/json"/>
</cfhttp>
<cfset variables.resultData = "#deserializeJSON(getStudentData.filecontent)#">

    <cfif isDefined('resultData.data.items') >
        <cfloop array="#resultData.data.items#" item="item">
            <cfstoredproc procedure="addToTempTable" datasource="#application.datasource#"> 
                <cfprocparam cfsqltype="cf_sql_varchar" value="#item.name#"> 
                <cfprocparam cfsqltype="cf_sql_varchar" value="#item.email#"> 
                <cfprocparam cfsqltype="cf_sql_integer" value="#item.roll_no#"> 
            </cfstoredproc>
        </cfloop> 
    </cfif>

    <cfif isDefined('variables.resultData.data') AND  structKeyExists(variables.resultData.data, 'hasMore') AND variables.resultData.data.hasMore eq true>
        <cfset variables.offset = variables.resultData.data.offset>
        <cfset variables.limit = variables.resultData.data.limit>
        <cfset variables.hasMoreData = variables.resultData.data.hasMore>
    <cfelse>
        <cfset variables.hasMoreData = false> 
    </cfif>
</cfloop>

<!--- <cfstoredproc procedure="tempToActualTable" datasource="#application.datasource#" />  --->
<cfstoredproc procedure="tempToActual" datasource="#application.datasource#" /> 
<cfdump  var="done...">

