<cfoutput>
    <article<cfif galleryIndex GT 1> class="m-t-2"</cfif>>
        <header>
            <h2><a href="#request.page.getLink()##attributes.galleries[galleryIndex].getLink()#">#attributes.galleries[galleryIndex].getHeadline()#</a></h2>
            <p><small>Diese Gallerie enthält #attributes.galleries[galleryIndex].getPictureCount()# Bilder</small></p>
        </header>
        <section>
            <p>#attributes.galleries[galleryIndex].getIntroduction()#</p>
            <cfset pictures = attributes.galleries[galleryIndex].getPictures()> <!--- check if there is a better solution --->
            <cfloop from="1" to="#(pictures.len() GT 6 ? 6 : pictures.len())#" index="pictureIndex">
                <cfif pictureIndex EQ 1>
                    <div class="row">
                <cfelseif pictureIndex EQ 4>
                    </div><div class="row">
                </cfif>
                <div class="col-md-4">
                    <div class="card">
                        <img src="#attributes.galleries[galleryIndex].getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="card-img-top">
                        <cfif pictures[pictureIndex].getCaption() NEQ "">
                            <div class="card-block">
                                <p class="card-text">#pictures[pictureIndex].getCaption()#</p>
                            </div>
                        </cfif>
                    </div>
                </div>
            </cfloop>
            </div>
        </section>
        <footer>
            <p><small>Diese Gallerie wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.galleries[galleryIndex].getCreationDate())# von <a href="#attributes.userPage#/#attributes.galleries[galleryIndex].getCreator().getUsername()#">#attributes.galleries[galleryIndex].getCreator().getUsername()#</a> erstellt.</small></p>
            <cfset categories = attributes.galleries[galleryIndex].getCategories()>
            <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
            </cfloop>
        </footer>
    </article>
</cfoutput>