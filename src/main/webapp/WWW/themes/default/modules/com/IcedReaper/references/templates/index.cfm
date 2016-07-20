<cfswitch expression="#attributes.options.layout#">
    <cfcase value="1">
        <cfinclude template="layouts/compact.cfm">
    </cfcase>
    <cfcase value="2">
        <cfinclude template="layouts/detailed.cfm">
    </cfcase>
</cfswitch>