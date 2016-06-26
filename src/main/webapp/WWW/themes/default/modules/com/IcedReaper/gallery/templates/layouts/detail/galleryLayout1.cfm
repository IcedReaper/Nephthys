<cfoutput>
    <article class="com-IcedReaper-gallery galleryLayout-1">
        <header>
            <h1>#attributes.gallery.getHeadline()#</h1>
            <cfif attributes.gallery.getIntroduction() NEQ "">
                <p>#attributes.gallery.getIntroduction()#</p>
            </cfif>
        </header>
        <section>
            #attributes.gallery.getStory()#
        </section>
        <section>
            <!--- images --->
            <cfset pictures = attributes.gallery.getPictures()> <!--- check if there is a better solution --->
            <cfset pictureIndex = 0>
            
            <cfloop from="1" to="#ceiling(pictures.len() / 12)#" index="pictureRowIndex">
                <cfset rowPictureCount = (pictures.len() - ((pictureRowIndex - 1) * 12) GT 12 ? 12 : pictures.len() - ((pictureRowIndex - 1) * 12))>
                
                <cfif rowPictureCount GTE 4>
                    <cfif rowPictureCount GT 8 AND rowPictureCount LTE 12>
                        <cfset colMax = 3>
                    <cfelseif rowPictureCount LT 8>
                        <cfset colMax = 2>
                        <cfset rowPictureCount = 12 - rowPictureCount>
                    </cfif>
                    
                    <div class="row pictures<cfif pictureRowIndex GT 1> m-t-1</cfif>">
                        <cfloop from="1" to="#colMax#" index="colIndex">
                            <div class="col-md-#(12 / colMax)#">
                                <cfloop from="1" to="4" index="pictureTmpIndex">
                                    <cfset ++pictureIndex>
                                    <cfif pictureIndex GT pictures.len()>
                                        <cfbreak>
                                    </cfif>
                                    
                                    <cfif colIndex NEQ 2>
                                        <cfif pictureTmpIndex NEQ 4>
                                            <cfif pictureTmpIndex EQ 1>
                                                <div class="row">
                                            </cfif>
                                            <div class="col-sm-4 col-md-4">
                                                <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                                    <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                                </a>
                                            </div>
                                        <cfelse>
                                            </div>
                                            <div class="row m-t-1">
                                                <div class="col-md-12">
                                                    <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                                        <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                                    </a>
                                                </div>
                                            </div>
                                        </cfif>
                                    <cfelse>
                                        <cfif pictureTmpIndex EQ 1>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                                        <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="row m-t-1">
                                        <cfelse>
                                            <div class="col-sm-4 col-md-4">
                                                <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                                    <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                                </a>
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
                </cfif>
                <cfif rowPictureCount LTE 4> <!--- Only for the last 4 --->
                    <div class="row<cfif pictureRowIndex GT 1> m-t-1</cfif>">
                        <cfloop from="1" to="#rowPictureCount#" index="pictureTmpIndex">
                            <cfset ++pictureIndex>
                            <div class="col-sm-#(12 / rowPictureCount)# col-md-#(12 / rowPictureCount)#">
                                <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                    <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                </a>
                            </div>
                        </cfloop>
                    </div>
                </cfif>
            </cfloop>
        </section>
        <footer>
            <div class="row">
                <div class="col-sm-12">
                    <p><small>Diese Gallerie wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.gallery.getCreationDate())# von <a href="/User/#attributes.gallery.getCreator().getUsername()#">#attributes.gallery.getCreator().getUsername()#</a> erstellt und bisher #attributes.gallery.getViewCounter()# Mal aufgerufen.</small></p>
                </div>
            </div>
            
            <cfset categories = attributes.gallery.getCategories()>
            <cfif categories.len() GT 0>
                <div class="row">
                    <div class="col-sm-12">
                        <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                            <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                        </cfloop>
                    </div>
                </div>
            </cfif>
            
            <cfif application.system.settings.getValueOfKey("com.IcedReaper.gallery.socialMediaSharing")>
                <div class="row m-t-2">
                    <div class="col-sm-12">
                        <h4>Gallerie teilen über</h4>
                        
                        <div class="btn-group btn-group-justified">
                            <cfif application.system.settings.getValueOfKey("com.IcedReaper.gallery.socialMediaSharing.facebook")>
                                <a onClick="window.open('https://www.facebook.com/sharer/sharer.php?u=#request.page.getEncodedDeepLink()#', 'facebook-share-dialog', 'width=626,height=436'); return false;" class="btn btn-facebook" href="##"><i class="fa fa-facebook"></i></a>
                            </cfif>
                            <cfif application.system.settings.getValueOfKey("com.IcedReaper.gallery.socialMediaSharing.googleplus")>
                                <a href="https://plus.google.com/share?url=#request.page.getEncodedDeepLink()#" class="btn btn-google-plus" target="_blank"><i class="fa fa-google-plus"></i></a>
                            </cfif>
                            <cfif application.system.settings.getValueOfKey("com.IcedReaper.gallery.socialMediaSharing.twitter")>
                                <a href="https://twitter.com/intent/tweet?original_referer=#request.page.getDeepLink()#&text=&url=#request.page.getEncodedDeepLink()#" target="_blank"class="btn btn-twitter"><i class="fa fa-twitter"></i></a>
                            </cfif>
                        </div>
                    </div>
                </div>
            </cfif>
        </footer>
        <cfinclude template="../general/blueimpGallery.cfm" />
    </article>
</cfoutput>