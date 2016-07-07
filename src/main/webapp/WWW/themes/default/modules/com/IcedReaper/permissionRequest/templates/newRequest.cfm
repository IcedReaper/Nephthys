<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <div class="row">
        <div class="col-md-12">
            <a href="overview" class="btn btn-primary pull-right"><i class="fa fa-chevron-left"></i> Zurück zur Übersicht</a>
            <h2>Neue Berechtigung anfragen</h2>
            
            <cfif attributes.result.successful>
                <div class="row">
                    <div class="col-md-8">
                        <div class="alert alert-success" role="alert">
                            <h2><span class="fa fa-check" aria-hidden="true"></span> Vielen Dank</h2>
                            <p>Deine Anfrage wurde erfolgreich gespeichert.</p>
                            <p>Bitte hab etwas geduld, bis ein Administrator die Anfrage bearbeitet hat.</p>
                            <p>Du kannst jederzeit Deine Anfragen in der <a href="overview" class="btn btn-link">Übersicht</a> einsehen.</p>
                        </div>
                    </div>
                </div>
            <cfelse>
                <cfif attributes.result.error>
                    <div class="alert alert-danger" role="alert">
                        <h2><span class="fa fa-exclamation" aria-hidden="true"></span> Fehler während der Eingabe</h2>
                        <p>
                            Es gab Fehler während Verarbeitung der Eingabe. Bitte stell sicher, dass Du alle Eingaben richtig hast.
                        </p>
                    </div>
                </cfif>
                <form method="POST" autocomplete="off" action="#attributes.userPage#/#request.user.getUserName()#/permissionRequest/new" class="m-t-1">
                    <input type="hidden" name="name" value="com.IcedReaper.permissionRequest">
                    <div class="form-group row<cfif attributes.result.errors.module> has-danger</cfif>">
                        <label class="form-label col-md-3" for="moduleId">Modul</label>
                        <div class="col-md-9">
                            <select id="moduleId" name="moduleId" class="form-control<cfif attributes.result.errors.module> with-danger</cfif>">
                                <cfloop from="1" to="#attributes.modules.len()#" index="moduleIndex">
                                    <option value="#attributes.modules[moduleIndex].getModuleId()#"<cfif attributes.result.error && form.moduleId EQ attributes.modules[moduleIndex].getModuleId()>selected="selected"</cfif>>#attributes.modules[moduleIndex].getModuleName()#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row<cfif attributes.result.errors.role> has-danger</cfif>">
                        <label class="form-label col-md-3" for="roleId">Rolle</label>
                        <div class="col-md-9">
                            <select id="roleId" name="roleId" class="form-control<cfif attributes.result.errors.role> with-danger</cfif>">
                                <cfloop from="1" to="#attributes.roles.len()#" index="roleIndex">
                                    <option value="#attributes.roles[roleIndex].roleId#"<cfif attributes.result.error && form.roleId EQ attributes.roles[roleIndex].roleId>selected="selected"</cfif>>#attributes.roles[roleIndex].name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="form-label col-md-3" for="reason">Wieso möchtest Du diese Berechtigung?</label>
                        <div class="col-md-9">
                            <textarea name="reason" class="form-control" placeholder="Dein Kommentar" maxlength="500"><cfif attributes.result.error>#form.reason#</cfif></textarea>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success"><i class="fa fa-key"></i> Berechtigungsanfrage abschicken</button>
                </form>
            </cfif>
        </div>
    </div>
</div>
</cfoutput>