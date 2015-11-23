<cfoutput>
    <div class="com-IcedReaper-gallery">
        <div class="row">
            <div class="col-md-12">
                <h1>#attributes.gallery.getHeadline()#</h1>
                <cfif attributes.gallery.getIntroduction() NEQ "">
                    <p>#attributes.gallery.getIntroduction()#</p>
                </cfif>
                #attributes.gallery.getStory()#
            </div>
        </div>
        
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
        
        <p><small>Diese Gallerie wurde am #application.tools.formatter.formatDate(attributes.gallery.getCreationDate())# von <a href="/User/#attributes.gallery.getCreator().getUsername()#">#attributes.gallery.getCreator().getUsername()#</a> erstellt.</small></p>
        
        <cfset categories = attributes.gallery.getCategories()>
        <cfloop from="1" to="#categories.len()#" index="categoryIndex">
            <a class="label label-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
        </cfloop>
        
        <!--- overlay  --->
        <div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" data-use-bootstrap-modal="false">
            <!-- The container for the modal slides -->
            <div class="slides"></div>
            <!-- Controls for the borderless lightbox -->
            <h3 class="title"></h3>
            <a class="prev">‹</a>
            <a class="next">›</a>
            <a class="close">×</a>
            <a class="play-pause"></a>
            <ol class="indicator"></ol>
            <!-- The modal dialog, which will be used to wrap the lightbox content -->
            <div class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" aria-hidden="true">&times;</button>
                            <h4 class="modal-title"></h4>
                        </div>
                        <div class="modal-body next"></div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left prev">
                                <i class="glyphicon glyphicon-chevron-left"></i>
                                Previous
                            </button>
                            <button type="button" class="btn btn-primary next">
                                Next
                                <i class="glyphicon glyphicon-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>