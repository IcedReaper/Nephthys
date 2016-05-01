<cfoutput>
    <cfif NOT attributes.options.keyExists("galleryLayout")>
        <cfinclude template="layouts/detail/default.cfm" />
    <cfelse>
        <cfswitch expression="#attributes.options.galleryLayout#">
            <cfcase value="1">
                <cfinclude template="layouts/detail/galleryLayout1.cfm" />
            </cfcase>
            <cfcase value="2">
                <cfinclude template="layouts/detail/galleryLayout2.cfm" />
            </cfcase>
        </cfswitch>
    </cfif>
</cfoutput>