<cfoutput>
    <ul class="nav nav-sidebar">
        <cfloop from="1" to="#attributes.modules.len()#" index="moduleIndex">
            <li <cfif attributes.modules[moduleIndex].getModuleName() EQ request.moduleController.getName()>class="active"</cfif>>
                <a href="/#attributes.modules[moduleIndex].getModuleName()#">#attributes.modules[moduleIndex].getDescription()# <cfif attributes.modules[moduleIndex].getModuleName() EQ request.moduleController.getName()><span class="sr-only">(current)</span></cfif></a>
            </li>
        </cfloop>
    </ul>
</cfoutput>