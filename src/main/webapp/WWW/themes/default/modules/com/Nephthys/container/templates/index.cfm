<cfoutput>
<div class="<cfif attributes.options.keyExists('fullSize') AND attributes.options.fullSize EQ true>container-fluid<cfelse>container</cfif> p-t-lg p-b-lg<cfif attributes.options.keyExists('background-class')> #attributes.options['background-class']#</cfif>">
    #attributes.childContent#
</div>
</cfoutput>