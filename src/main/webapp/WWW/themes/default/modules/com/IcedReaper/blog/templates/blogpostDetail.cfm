<cfoutput>
    <div class="row">
        <div class="col-md-12">
            <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
            
            <p>#attributes.blogpost.getStory()#</p>
            
            <p><small>Dieser Blogeintrag wurde am #application.tools.formatter.formatDate(attributes.blogpost.getCreationDate())# von <a href="/User/#attributes.blogpost.getCreator().getUsername()#">#attributes.blogpost.getCreator().getUsername()#</a> erstellt.</small></p>
            <cfset categories = attributes.blogpost.getCategories()>
            <p>
                <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                    <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                </cfloop>
            </p>
        </div>
    </div>
    
    <cfif attributes.blogpost.getCommentsActivated()>
        <div class="row">
            <div class="col-md-12">
                <h3>Kommentare</h3>
            </div>
        </div>
    <cfelse>
        <div class="row">
            <div class="col-md-12">
                <div class="alert alert-info" role="alert">
                    Die Kommentare wurden bei diesem Blogeintrag leider deaktiviert.
                </div>
            </div>
        </div>
    </cfif>
</cfoutput>