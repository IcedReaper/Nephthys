<cfoutput>
    <section class="com-IcedReaper-blog">
        <cfif attributes.blogposts.len() GT 0>
            <div class="row">
                <div class="col-sm-8">
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
                        <article<cfif blogpostIndex GT 1> class="m-t-3"</cfif>>
                            <header>
                                <h2><a href="#request.page.getLink()##attributes.blogposts[blogpostIndex].getLink()#">#attributes.blogposts[blogpostIndex].getHeadline()#</a></h2>
                            </header>
                            <section class="story">    
                                #attributes.blogposts[blogpostIndex].getStory()#
                            </section>
                            <footer>
                                <p><small>Dieser Blogeintrag wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.blogposts[blogpostIndex].getCreationDate())# von <a href="#attributes.userPage#/#attributes.blogposts[blogpostIndex].getCreator().getUsername()#">#attributes.blogposts[blogpostIndex].getCreator().getUsername()#</a> erstellt.</small></p>
                                <cfset categories = attributes.blogposts[blogpostIndex].getCategories()>
                                <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                                    <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                                </cfloop>
                                
                                <p>Dieser Blogeintrag hat #attributes.blogposts[blogpostIndex].getComments().len()# Kommentare</p>
                            </footer>
                        </article>
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
                <div class="col-sm-4">
                    <cfif attributes.categories.len() GT 0>
                        <aside>
                            <h4>Kategorien</h4>
                            <div class="list-group">
                                <cfloop from="1" to="#attributes.categories.len()#" index="categoryIndex">
                                    <a href="#request.page.getLink()#/Kategorie/#attributes.categories[categoryIndex].getName()#" class="list-group-item<cfif attributes.categories[categoryIndex].getName() EQ attributes.activeCategory> active</cfif>">
                                        #attributes.categories[categoryIndex].getName()#
                                        <span class="label label-primary label-pill pull-right">#attributes.categories[categoryIndex].getUseCount()#</span>
                                    </a>
                                </cfloop>
                            </div>
                        </aside>
                    </cfif>
                </div>
            </div>
        <cfelse>
            <h2>Wir konnten leider aktuell keine Blogposts finden</h2>
            <p>Es tut uns leid und würden Dich bitten später noch einmal vorbeizuschauen</p>
        </cfif>
    </section>
</cfoutput>