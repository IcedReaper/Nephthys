<cfoutput>
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
    
    <cfloop from="1" to="#attributes.galleries.len()#" index="galleryIndex">
        <div class="row">
            <div class="col-md-12">
                <h2><a href="#request.page.getLink()##attributes.galleries[galleryIndex].getLink()#">#attributes.galleries[galleryIndex].getHeadline()#</a></h2>
                <p><small>Diese Gallerie enthält #attributes.galleries[galleryIndex].getPictureCount()# Bilder</small></p>
                
                <p>#attributes.galleries[galleryIndex].getIntroduction()#</p>
                
                <cfset pictures = attributes.galleries[galleryIndex].getPictures()> <!--- check if there is a better solution --->
                <cfloop from="1" to="#(pictures.len() GT 6 ? 6 : pictures.len())#" index="pictureIndex">
                    <cfif pictureIndex EQ 1>
                        <div class="row">
                    <cfelseif pictureIndex EQ 4>
                        </div><div class="row">
                    </cfif>
                    <div class="col-md-4">
                        <div class="thumbnail">
                            <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#">
                            <cfif pictures[pictureIndex].getCaption() NEQ "">
                                <div class="caption">
                                    #pictures[pictureIndex].getCaption()#
                                </div>
                            </cfif>
                        </div>
                    </div>
                </cfloop>
                </div>
                <p><small>Diese Gallerie wurde am #application.tools.formatter.formatDate(attributes.galleries[galleryIndex].getCreationDate())# von <a href="/User/#attributes.galleries[galleryIndex].getCreator().getUsername()#">#attributes.galleries[galleryIndex].getCreator().getUsername()#</a> erstellt.</small></p>
                <cfset categories = attributes.galleries[galleryIndex].getCategories()>
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
</cfoutput>