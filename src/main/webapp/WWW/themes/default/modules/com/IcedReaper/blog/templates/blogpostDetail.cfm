<cfoutput>
    <article class="com-IcedReaper-blog">
        <header>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
                    </div>
                </div>
            </div>
        </header>
        <section class="story">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <p>#attributes.blogpost.getStory()#</p>
                    </div>
                </div>
            </div>
            <cfset pictures = attributes.blogpost.getPictures()>
            <cfif pictures.len() GT 0>
                <div class="m-y-2 container-fluid background static-background-1 p-a-1">
                    <div class="center-block">
                        <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                            <div class="thumbnail">
                                <a href="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="img-fluid" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                    <img src="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                </a>
                            </div>
                        </cfloop>
                    </div>
                </div>
            </cfif>
        </section>
        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <p><small>Dieser Blogeintrag wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.blogpost.getCreationDate())# von <a href="#attributes.userPage#/#attributes.blogpost.getCreator().getUsername()#">#attributes.blogpost.getCreator().getUsername()#</a> erstellt und bisher #attributes.blogpost.getViewCounter()# Mal aufgerufen.</small></p>
                        <cfset categories = attributes.blogpost.getCategories()>
                        <p>
                            <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                                <a class="tag tag-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                            </cfloop>
                        </p>
                    </div>
                </div>
            </div>
        </footer>
        
        <section>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <cfset comments = attributes.blogpost.getComments()>
                        <div class="row">
                            <cfif attributes.blogpost.getCommentsActivated()>
                                <div class="col-md-12">
                                    <h3>Kommentare</h3>
                                    <ul class="media-list">
                                        <cfloop from="1" to="#comments.len()#" index="commentIndex">
                                            <cfif comments[commentIndex].isPublished()>
                                                <li class="media">
                                                    <div class="media-left">
                                                        <a href="##">
                                                            <img class="media-object" src="#comments[commentIndex].getCreator().getAvatarPath()#">
                                                        </a>
                                                    </div>
                                                    <div class="media-body">
                                                        <h5 class="media-heading">
                                                            <cfif comments[commentIndex].fromRegistrated()>
                                                                <a href="#attributes.userPage#/#comments[commentIndex].getUsername()#">#comments[commentIndex].getUsername()#</a>
                                                            <cfelse>
                                                                #comments[commentIndex].getUsername()#
                                                            </cfif>
                                                        </h5>
                                                        <p>#application.system.settings.getValueOfKey("xssProtector").encodeForHTML(comments[commentIndex].getComment())#</p>
                                                        <small>Geschrieben am #dateFormat(comments[commentIndex].getCreationDate(), "dd.mmm yyyy")# um #timeFormat(comments[commentIndex].getCreationDate(), "HH:MM:SS")# Uhr.</small>
                                                    </div>
                                                </li>
                                            </cfif>
                                        </cfloop>
                                    </ul>
                                    <!--- new comment --->
                                    <hr>
                                    <cfif attributes.commentAdded EQ true>
                                        <cfif attributes.blogpost.getCommentsNeedToGetPublished()>
                                            <div class="alert alert-success" role="alert">
                                                <i class="fa fa-exclamation-triangle"></i> Ihr Kommentar wurde hinzugefügt, muss aber leider noch geprüft werden.
                                            </div>
                                        <cfelse>
                                            <div class="alert alert-success" role="alert">
                                                Ihr Kommentar wurde hinzugefügt.
                                            </div>
                                        </cfif>
                                    <cfelse>
                                        <cfif request.user.getUserId() != 0 || attributes.blogpost.getAnonymousCommentAllowed()>
                                            <h5>Kommentieren</h5>
                                            <form method="POST" action="?">
                                                <div class="row m-t-1">
                                                    <cfif request.user.getUserId() == 0>
                                                        <div class="col-md-6">
                                                            <fieldset class="form-group">
                                                                <label for="anonymousUsername">Name</label>
                                                                <input type="text" class="form-control form-control-sm" id="anonymousUsername" name="anonymousUsername" placeholder="Benutzername">
                                                            </fieldset>
                                                            <fieldset class="form-group">
                                                                <label for="anonymousEmail">Email address</label>
                                                                <input type="email" class="form-control form-control-sm" id="anonymousEmail" name="anonymousEmail" placeholder="E-Mailadresse">
                                                                <small class="text-muted">Deine E-Mail Adresse wird auf der Webseite nicht dargestellt werden.</small>
                                                            </fieldset>
                                                        </div>
                                                    </cfif>
                                                    <div class="col-md-6">
                                                        <fieldset class="form-group">
                                                            <label for="comment">Ihr Kommentar</label>
                                                            <textarea class="form-control" id="comment" name="comment" rows="3"></textarea>
                                                            <small class="text-muted">Du hast insgesamt 500 Zeichen für deinen Kommentar zur Verfügung, davon sind noch <span id="remaining">500</span> übrig.</small>
                                                        </fieldset>
                                                    </div>
                                                </div>
                                                <button type="submit" class="btn btn-success"><i class="fa fa-floppy-o"></i> Submit</button>
                                            </form>
                                        <cfelse>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="alert alert-info" role="alert">
                                                        Sie sind leider ausgeloggt und daher nicht berechtigt diesen Beitrag zu kommentieren.<br>
                                                        Bitte loggen Sie sich ein um diesen Beitrag zu kommentieren.
                                                    </div>
                                                </div>
                                            </div>
                                        </cfif>
                                    </cfif>
                                </div>
                            </div>
                        <cfelse>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="alert alert-info" role="alert">
                                        Die Kommentare wurden bei diesem Blogeintrag leider deaktiviert.
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>
        </section>
        
        <script>
            $(function() {
                $('textarea##comment').on('change', function() {
                    $('##remaining').text(500 - parseInt($(this).val().length, 10));
                });
            });
        </script>
    </section>
    
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
                            <i class="fa fa-chevron-left"></i>
                            Previous
                        </button>
                        <button type="button" class="btn btn-primary next">
                            Next
                            <i class="fa fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>