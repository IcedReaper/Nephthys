<cfoutput>
<div class="<cfif attributes.options.keyExists('fullWidth') AND attributes.options.fullWidth EQ true>container-fluid<cfelse>container</cfif> p-t-3 p-b-3<cfif attributes.options.keyExists('background-class')> #attributes.options['background-class']#</cfif>">
    <cfif attributes.options.keyExists("fullWidthOnlyBackground") AND attributes.options.fullWidthOnlyBackground EQ true>
        <div class="container">
    </cfif>
    #attributes.childContent#
    <cfif attributes.options.keyExists("fullWidthOnlyBackground") AND attributes.options.fullWidthOnlyBackground EQ true>
        </div>
    </cfif>
</div>
</cfoutput>