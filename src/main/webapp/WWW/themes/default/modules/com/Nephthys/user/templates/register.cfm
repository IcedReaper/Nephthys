<cfoutput>
<section>
    <header>
        <h1>Registrierung</h1>
    </header>

    <section>
        <cfif attributes.errors.registrationSuccessful>
            <div class="row">
                <div class="col-md-8">
                    <div class="alert alert-success" role="alert">
                        <h2><span class="fa fa-check" aria-hidden="true"></span> Vielen Dank</h2>
                        <p>Deine Registrierung war erfolgreich.</p>
                        <p>Bitte hab etwas geduld, bis ein Administrator die Registrierung bestätigt hat.</p>
                    </div>
                </div>
            </div>
        <cfelse>
            <div class="row">
                <div class="col-md-8">
                    <cfif attributes.errors.error>
                        <div class="alert alert-danger" role="alert">
                            <h2><span class="fa fa-exclamation" aria-hidden="true"></span> Fehler während der Eingabe</h2>
                            <p>
                                Es gab Fehler während der Registrierung.
                            </p>
                            <cfif attributes.errors.usernameUsed>
                                <p>Der Username ist schon vergeben</p>
                            </cfif>
                            <cfif attributes.errors.emailUsed>
                                <p>Die E-Mail Adresse ist schon vergeben</p>
                            </cfif>
                        </div>
                    </cfif>
                    
                    <form action="?register" autocomplete="off" method="POST">
                        <fieldset class="form-group<cfif attributes.errors.username OR attributes.errors.usernameUsed> has-danger</cfif>">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Enter Username" maxlength="20" required <cfif attributes.errors.error>value="#form.username#"</cfif>>
                        </fieldset>
                        <fieldset class="form-group<cfif attributes.errors.email OR attributes.errors.emailUsed> has-danger</cfif>">
                            <label for="eMail">E-Mail Adresse</label>
                            <input type="email" class="form-control" id="eMail" name="eMail" placeholder="Enter email" maxlength="128" required <cfif attributes.errors.error>value="#form.email#"</cfif>>
                            <small class="text-muted">We'll never share your email with anyone else.</small>
                        </fieldset>
                        <fieldset class="form-group<cfif attributes.errors.password> has-danger</cfif>">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required <cfif attributes.errors.error>value="#form.password#"</cfif>>
                        </fieldset>
                        
                        <button type="submit" class="btn btn-primary"><i class="fa fa-user-plus"></i> Abschicken</button>
                    </form>
                </div>
                <div class="col-md-4">
                    <h3>Ablauf Ihrer Registrierung</h3>
                    <p>Nach dem Du die Registrierung ausgefüllt hast, muss einer der Administratoren den Account noch freischalten, dass Du ihn benutzen kannst.</p>
                </div>
            </div>
        </cfif>
    </section>
</section>
</cfoutput>