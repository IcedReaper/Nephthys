<cfoutput>
    <div class="com-IcedReaper-gallery">
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#request.page.getLink()#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#request.page.getLink()#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#request.page.getLink()#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
        
        <cfloop from="1" to="#attributes.blogposts.len()#" index="blogpostIndex">
            <div class="row <cfif blogpostIndex GT 1>m-t</cfif>">
                <div class="col-md-12">
                    <h2><a href="#request.page.getLink()##attributes.blogposts[blogpostIndex].getLink()#">#attributes.blogposts[blogpostIndex].getHeadline()#</a></h2>
                    
                    <p>#attributes.blogposts[blogpostIndex].getStory()#</p>
                    
                    <p><small>Dieser Blogeintrag wurde am #application.tools.formatter.formatDate(attributes.blogposts[blogpostIndex].getCreationDate())# von <a href="/User/#attributes.blogposts[blogpostIndex].getCreator().getUsername()#">#attributes.blogposts[blogpostIndex].getCreator().getUsername()#</a> erstellt.</small></p>
                    <cfset categories = attributes.blogposts[blogpostIndex].getCategories()>
                    <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                        <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                    </cfloop>
                </div>
            </div>
        </cfloop>
        
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#request.page.getLink()#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#request.page.getLink()#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#request.page.getLink()#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
    </div>
</cfoutput>