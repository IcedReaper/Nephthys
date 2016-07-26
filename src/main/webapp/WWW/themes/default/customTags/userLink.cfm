<cfif thisTag.executionMode EQ "start">
    <cfscript>
        param name = "attributes.userName" param = "";
        param name = "attributes.title"    param = "";
        param name = "attributes.deepLink" param = "";
        param name = "attributes.class"    param = "";
        param name = "attributes.target"   param = "";
        
        param name = "thisTag.generatedContent" param = "";
        
        thisTag.pages = createObject("component", "API.modules.com.Nephthys.pageManager.filter").init().setFor("pageWithModule")
                                                                                                       .setModuleName("com.Nephthys.userManager")
                                                                                                       .execute()
                                                                                                       .getResult();
        
        if(thisTag.pages.len() > 0) {
            thisTag.userPage = thisTag.pages[1].getLink();
        }
        else {
            thisTag.userPage = "";
        }
    </cfscript>
</cfif>
<cfif thisTag.userPage NEQ "" AND (thisTag.executionMode EQ "end" OR NOT thisTag.hasEndTag)>
    <cfoutput>
    <a href="#thisTag.userPage#/#attributes.userName##attributes.deepLink#"
       <cfif attributes.title NEQ "">title="#attributes.title#"</cfif>
       <cfif attributes.class NEQ "">class="#attributes.class#"</cfif>
       <cfif attributes.target NEQ "">title="#attributes.target#"</cfif>
       >#thisTag.generatedContent#</a>
    </cfoutput>
    <cfset thisTag.generatedContent = "">
</cfif>