<cfoutput>
    <p><small>Dieser Blogeintrag wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.blogpost.getCreationDate())# von <cf_userLink userName="#attributes.blogpost.getCreator().getUsername()#">#attributes.blogpost.getCreator().getUsername()#</cf_userLink> erstellt und bisher #attributes.blogpost.getViewCounter()# Mal aufgerufen.</small></p>
    <cfset categories = attributes.blogpost.getCategories()>
    <p>
        <cfloop from="1" to="#categories.len()#" index="categoryIndex">
            <a class="tag tag-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
        </cfloop>
    </p>
</cfoutput>