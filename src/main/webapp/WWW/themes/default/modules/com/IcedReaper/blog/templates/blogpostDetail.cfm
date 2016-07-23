<cfoutput>
    <cfif NOT attributes.options.keyExists("Layout")>
        <cfinclude template="layouts/detail/default.cfm" />
    <cfelse>
        <cfswitch expression="#attributes.options.Layout#">
            <cfcase value="1">
                <cfinclude template="layouts/detail/blogLayout1.cfm" />
            </cfcase>
            <cfcase value="2">
                <cfinclude template="layouts/detail/blogLayout2.cfm" />
            </cfcase>
            <cfdefaultcase>
                <cfinclude template="layouts/detail/default.cfm" />
            </cfdefaultcase>
        </cfswitch>
    </cfif>
</cfoutput>