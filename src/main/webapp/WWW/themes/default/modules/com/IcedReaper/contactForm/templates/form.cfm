<cfoutput>
<div class="row">
    <div class="col-sm-12">
        <h1>Nehmen Sie Kontakt mit uns auf</h1>

        <p>Hier haben Sie die Möglichkeit mit dem Team hinter dem Nephthys CMS Kontakt aufzunehmen.</p>
        <p>Sie haben Fragen, Anregungen oder ein Problem? Lassen Sie es uns wissen. Wir werden versuchen Sie bei der Lösung zu unterstützen</p>
    </div>
</div>
<div class="row">
    <div class="col-md-8">
        <form autocomplete="off" method="post" action="?">
            <cfif request.user.isActive()>
                <p>Anfrage wird von durch Ihren Account #request.user.getUsername()# verschickt.</p>
            <cfelse>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="sr-only" for="eMail">Email address</label>
                            <input type="email" class="form-control" id="eMail" name="email" placeholder="Email Adresse *wird nicht veröffentlicht">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="sr-only" for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Username *wird nicht veröffentlicht">
                        </div>
                    </div>
                </div>
            </cfif>
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group">
                        <label class="sr-only" for="subject">Thema</label>
                        <input type="text" class="form-control" id="subject" name="subject" placeholder="Thema">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group">
                        <label class="sr-only" for="message">Mitteilung</label>
                        <textarea class="form-control" id="message" name="message" placeholder="Mitteilung"></textarea>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <button type="submit" class="btn btn-success"><i class="fa fa-floppy-o"></i> Kontakt aufnehmen</button>
                </div>
            </div>
        </form>
    </div>
    <div class="col-md-4">
        Weitere Kontaktmöglichkeiten
    </div>
</div>
</cfoutput>