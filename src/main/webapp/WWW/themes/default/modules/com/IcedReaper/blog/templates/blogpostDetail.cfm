<cfoutput>
    <article class="com-IcedReaper-blog">
        <header>
            <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
        </header>
        <section class="story">    
            <p>#attributes.blogpost.getStory()#</p>
        </section>
        <footer>
            <p><small>Dieser Blogeintrag wurde am #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.blogpost.getCreationDate())# von <a href="#attributes.userPage#/#attributes.blogpost.getCreator().getUsername()#">#attributes.blogpost.getCreator().getUsername()#</a> erstellt und bisher #attributes.blogpost.getViewCounter()# Mal aufgerufen.</small></p>
            <cfset categories = attributes.blogpost.getCategories()>
            <p>
                <cfloop from="1" to="#categories.len()#" index="categoryIndex">
                    <a class="tag tag-primary" href="#request.page.getLink()#/Kategorie/#categories[categoryIndex].getName()#">#categories[categoryIndex].getName()#</a>
                </cfloop>
            </p>
        </footer>
        
        <section>
            <cfif attributes.blogpost.getCommentsActivated()>
                <cfset comments = attributes.blogpost.getComments()>
                <div class="row">
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
        </section>
        
        <script>
            $(function() {
                $('textarea##comment').on('change', function() {
                    $('##remaining').text(500 - parseInt($(this).val().length, 10));
                });
            });
        </script>
    </section>
</cfoutput>