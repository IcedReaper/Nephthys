<cfoutput>
    <cfif NOT attributes.options.keyExists("Layout")>
        <cfinclude template="layouts/lastEntry/default.cfm" />
    <cfelse>
        <cfswitch expression="#attributes.options.Layout#">
            <cfcase value="1">
                <cfinclude template="layouts/lastEntry/blogLayout1.cfm" />
            </cfcase>
            <cfcase value="2">
                <cfinclude template="layouts/lastEntry/blogLayout2.cfm" />
            </cfcase>
            <cfdefaultcase>
                <cfinclude template="layouts/lastEntry/default.cfm" />
            </cfdefaultcase>
        </cfswitch>
    </cfif>
</cfoutput>