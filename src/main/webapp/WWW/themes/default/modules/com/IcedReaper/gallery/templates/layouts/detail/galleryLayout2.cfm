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
            <cfset sliderId = createUUID()>
            <div id="#sliderId#" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                        <li data-target="###sliderId#" data-slide-to="#pictureIndex - 1#"<cfif pictureIndex EQ 1> class="active"</cfif>></li>
                    </cfloop>
                </ol>
                <div class="carousel-inner" role="listbox">
                    <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                        <div class="carousel-item<cfif pictureIndex EQ 1> active</cfif>">
                            <img src="#attributes.gallery.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" alt="#pictures[pictureIndex].getCaption()#">
                            <div class="carousel-caption">
                                <p>#pictures[pictureIndex].getCaption()#</p>
                            </div>
                        </div>
                    </cfloop>
                </div>
                <a class="left carousel-control" href="###sliderId#" role="button" data-slide="prev">
                    <span class="icon-prev" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="###sliderId#" role="button" data-slide="next">
                    <span class="icon-next" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
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