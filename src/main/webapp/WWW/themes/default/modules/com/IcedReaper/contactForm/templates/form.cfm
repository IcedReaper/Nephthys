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
        <cfif attributes.errors.error>
            <div class="alert alert-danger" role="alert">
                <h2><span class="fa fa-exclamation" aria-hidden="true"></span> Fehler während der Eingabe</h2>
                <p>
                    Es gab Fehler während der Kontaktaufnahme.
                </p>
                <cfif attributes.errors.usernameUsed>
                    <p>Der Username ist schon vergeben. Sollte es deiner sein, log dich bitte ein.</p>
                </cfif>
                <cfif attributes.errors.emailUsed>
                    <p>Die E-Mail Adresse ist schon vergeben. Sollte es deine sein, log dich bitte ein.</p>
                </cfif>
            </div>
        </cfif>
        
        <form autocomplete="off" method="post" action="?">
            <input type="hidden" name="name" value="com.IcedReaper.contactForm">
            <cfif request.user.isActive()>
                <p>Anfrage wird von durch Ihren Account #request.user.getUsername()# verschickt.</p>
            <cfelse>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group<cfif attributes.errors.email OR attributes.errors.emailUsed> has-danger</cfif>">
                            <label class="sr-only" for="eMail">Email address</label>
                            <input type="email" class="form-control<cfif attributes.errors.email OR attributes.errors.emailUsed> form-control-danger</cfif>" id="eMail" name="email" placeholder="Email Adresse *wird nicht veröffentlicht"<cfif attributes.errors.error> value="#form.email#"</cfif>>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group<cfif attributes.errors.username OR attributes.errors.usernameUsed> has-danger</cfif>">
                            <label class="sr-only" for="username">Username</label>
                            <input type="text" class="form-control<cfif attributes.errors.username OR attributes.errors.usernameUsed> form-control-danger</cfif>" id="username" name="username" placeholder="Username *wird nicht veröffentlicht"<cfif attributes.errors.error> value="#form.username#"</cfif>>
                        </div>
                    </div>
                </div>
            </cfif>
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group<cfif attributes.errors.subject> has-danger</cfif>">
                        <label class="sr-only" for="subject">Thema</label>
                        <input type="text" class="form-control<cfif attributes.errors.subject> form-control-danger</cfif>" id="subject" name="subject" placeholder="Thema"<cfif attributes.errors.error> value="#form.subject#"</cfif>>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group<cfif attributes.errors.message> has-danger</cfif>">
                        <label class="sr-only" for="message">Mitteilung</label>
                        <textarea class="form-control<cfif attributes.errors.message> form-control-danger</cfif>" id="message" name="message" placeholder="Mitteilung"><cfif attributes.errors.error>#form.message#</cfif></textarea>
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