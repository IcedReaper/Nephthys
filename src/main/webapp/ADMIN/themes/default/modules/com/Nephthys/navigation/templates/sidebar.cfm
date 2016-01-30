<cfoutput>
    <ul class="nav nav-sidebar">
        <cfloop from="1" to="#attributes.modules.len()#" index="moduleIndex">
            <li <cfif attributes.modules[moduleIndex].getModuleName() EQ request.moduleController.getName()>class="active"</cfif>>
                <a <cfif attributes.modules[moduleIndex].getModuleName() EQ request.moduleController.getName()>href="##/"<cfelse>href="/#attributes.modules[moduleIndex].getModuleName()#"</cfif>>#attributes.modules[moduleIndex].getDescription()#</a>
            </li>
        </cfloop>
    </ul>
</cfoutput>