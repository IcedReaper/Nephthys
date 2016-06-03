<cfoutput>
    <section class="com-IcedReaper-review">
        <cfif attributes.options.keyExists("actualFilter")>
            <section>
                <h3>Aktueller Filter: #attributes.options.actualFilter.type# - #attributes.options.actualFilter.value#</h3>
            </section>
        </cfif>
        
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#attributes.options.link#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#attributes.options.link#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#attributes.options.link#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
        
        <cfloop from="1" to="#attributes.reviews.len()#" index="reviewIndex">
            <article<cfif reviewIndex GT 1> class="m-t-2"</cfif>>
                <header>
                    <!-- todo optimize -->
                    <p class="pull-right">
                        <cfif attributes.reviews[reviewIndex].getRating() EQ 0.5>
                            <i class="fa fa-star-half-o"></i>
                        <cfelseif  attributes.reviews[reviewIndex].getRating() GTE 1>
                            <i class="fa fa-star"></i>
                        </cfif>
                        <cfif attributes.reviews[reviewIndex].getRating() EQ 1.5>
                            <i class="fa fa-star-half-o"></i>
                        <cfelseif  attributes.reviews[reviewIndex].getRating() GTE 2>
                            <i class="fa fa-star"></i>
                        </cfif>
                        <cfif attributes.reviews[reviewIndex].getRating() EQ 2.5>
                            <i class="fa fa-star-half-o"></i>
                        <cfelseif  attributes.reviews[reviewIndex].getRating() GTE 3>
                            <i class="fa fa-star"></i>
                        </cfif>
                        <cfif attributes.reviews[reviewIndex].getRating() EQ 3.5>
                            <i class="fa fa-star-half-o"></i>
                        <cfelseif  attributes.reviews[reviewIndex].getRating() GTE 4>
                            <i class="fa fa-star"></i>
                        </cfif>
                        <cfif attributes.reviews[reviewIndex].getRating() EQ 4.5>
                            <i class="fa fa-star-half-o"></i>
                        <cfelseif  attributes.reviews[reviewIndex].getRating() EQ 5>
                            <i class="fa fa-star"></i>
                        </cfif>
                    </p>
                    <h2><a href="#request.page.getLink()##attributes.reviews[reviewIndex].getLink()#">#attributes.reviews[reviewIndex].getHeadline()#</a></h2>
                </header>
                <section>
                    <cfif attributes.reviews[reviewIndex].getImagePath() NEQ "">
                        <figure>
                            <img src="#attributes.reviews[reviewIndex].getImagePath()#" alt="#attributes.reviews[reviewIndex].getHeadline()#">
                        </figure>
                    </cfif>
                    
                    #attributes.reviews[reviewIndex].getIntroduction()#
                </section>
                <footer>
                    <p>
                        <small>Diese Bewertung wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.reviews[reviewIndex].getCreationDate())# von <a href="/User/#attributes.reviews[reviewIndex].getCreator().getUsername()#">#attributes.reviews[reviewIndex].getCreator().getUsername()#</a> in der Kategorie <a href="#request.page.getLink()#/Kategorie/#attributes.reviews[reviewIndex].getType().getName()#">#attributes.reviews[reviewIndex].getType().getName()#</a> erstellt.</small>
                    </p>
                    <cfset genre = attributes.reviews[reviewIndex].getGenre()>
                    <p>
                        <strong>Genre:</strong>
                        <cfloop from="1" to="#genre.len()#" index="genreIndex">
                            <a class="label label-primary" href="#request.page.getLink()#/Genre/#genre[genreIndex].getName()#">#genre[genreIndex].getName()#</a>
                        </cfloop>
                    </p>
                </footer>
            </article>
        </cfloop>
        
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#attributes.options.link#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#attributes.options.link#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#attributes.options.link#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
    </section>
</cfoutput>