<cfoutput>
    <article class="galleryLayout-1 <cfif galleryIndex GT 1> m-t-3</cfif>">
        <header>
            <h2><a href="#request.page.getLink()##attributes.galleries[galleryIndex].getLink()#">#attributes.galleries[galleryIndex].getHeadline()#</a></h2>
            <p><small>Diese Gallerie enthält #attributes.galleries[galleryIndex].getPictureCount()# Bilder</small></p>
        </header>
        <section>
            <p>#attributes.galleries[galleryIndex].getIntroduction()#</p>
            <cfset pictures = attributes.galleries[galleryIndex].getPictures()>
            <cfset pictureIndex = 0>
            
            <cfif pictures.len() GTE 8>
                <cfif pictures.len() GTE 12>
                    <cfset colMax = 3>
                <cfelseif pictures.len() LT 12 AND pictures.len() GTE 8>
                    <cfset colMax = 2>
                </cfif>
                
                <div class="row pictures">
                    <cfloop from="1" to="#colMax#" index="colIndex">
                        <div class="col-md-#(12 / colMax)#">
                            <cfloop from="1" to="4" index="pictureTmpIndex">
                                <cfset ++pictureIndex>
                                <cfif colIndex NEQ 2>
                                    <cfif pictureTmpIndex NEQ 4>
                                        <cfif pictureTmpIndex EQ 1>
                                            <div class="row">
                                        </cfif>
                                        <div class="col-sm-4 col-md-4">
                                            <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                        </div>
                                    <cfelse>
                                        </div>
                                        <div class="row m-t-1">
                                            <div class="col-md-12">
                                                <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                            </div>
                                        </div>
                                    </cfif>
                                <cfelse>
                                    <cfif pictureTmpIndex EQ 1>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                            </div>
                                        </div>
                                        <div class="row m-t-1">
                                    <cfelse>
                                        <div class="col-sm-4 col-md-4">
                                            <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                        </div>
                                    </cfif>
                                </cfif>
                            </cfloop>
                            <cfif colIndex EQ 2>
                                </div>
                            </cfif>
                        </div>
                    </cfloop>
                </div>
            <cfelseif pictures.len() LT 8>
                <div class="row">
                    <cfloop from="1" to="#pictures.len() GT 4 ? 4 :pictures.len()#" index="pictureIndex">
                        <div class="col-sm-3 col-md-3">
                            <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                        </div>
                    </cfloop>
                </div>
            </cfif>
        </section>
        <footer>
            <p><small>Diese Gallerie wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.galleries[galleryIndex].getCreationDate())# von <a href="/User/#attributes.galleries[galleryIndex].getCreator().getUsername()#">#attributes.galleries[galleryIndex].getCreator().getUsername()#</a> erstellt.</small></p>
            <cfset categories = attributes.galleries[galleryIndex].getCategories()>
            <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
            </cfloop>
        </footer>
    </article>
</cfoutput>