<cfoutput>
    <article class="com-IcedReaper-gallery">
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
            <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                <cfif pictureIndex % 3 EQ 1>
                    <cfif pictureIndex NEQ 1>
                        </div>
                    </cfif>
                    <div class="row">
                </cfif>
                <div class="col-md-4">
                    <div class="card">
                        <a href="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="thumbnail" data-gallery title="#pictures[pictureIndex].getCaption()#">
                            <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="card-img-top">
                        </a>
                        <cfif pictures[pictureIndex].getCaption() NEQ "">
                            <div class="card-block">
                                <p class="card-text">#pictures[pictureIndex].getCaption()#</p>
                            </div>
                        </cfif>
                    </div>
                </div>
            </cfloop>
            </div> <!--- for row from loop --->
        </section>
        <footer>
            <p><small>Diese Gallerie wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.gallery.getCreationDate())# von <a href="#attributes.userPage#/#attributes.gallery.getCreator().getUsername()#">#attributes.gallery.getCreator().getUsername()#</a> erstellt und bisher #attributes.gallery.getViewCounter()# Mal aufgerufen.</small></p>
            
            <cfset categories = attributes.gallery.getCategories()>
            <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
            </cfloop>
        </footer>
        <cfinclude template="../general/blueimpGallery.cfm" />
    </article>
</cfoutput>