<cfoutput>
    <div class="container">
        <section class="com-IcedReaper-blog">
            <div class="row">
                <div class="col-sm-12">
                    <cfloop from="1" to="#attributes.blogposts.len()#" index="blogpostIndex">
                        <article<cfif blogpostIndex GT 1> class="m-t-2"</cfif>>
                            <header>
                                <h3><a href="#request.page.getLink()##attributes.blogposts[blogpostIndex].getLink()#">#attributes.blogposts[blogpostIndex].getHeadline()#</a></h3>
                            </header>
                            <section class="story">    
                                #attributes.blogposts[blogpostIndex].getStory()#
                            </section>
                            <footer>
                                <p><small>Dieser Blogeintrag wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.blogposts[blogpostIndex].getCreationDate())# von <a href="#attributes.userPage#/#attributes.blogposts[blogpostIndex].getCreator().getUsername()#">#attributes.blogposts[blogpostIndex].getCreator().getUsername()#</a> erstellt.</small></p>
                                <cfset categories = attributes.blogposts[blogpostIndex].getCategories()>
                                <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                                    <a class="tag tag-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                                </cfloop>
                                
                                <p>Dieser Blogeintrag hat #attributes.blogposts[blogpostIndex].getComments().len()# Kommentare</p>
                            </footer>
                        </article>
                    </cfloop>
                </div>
            </div>
        </section>
    </div>
</cfoutput>