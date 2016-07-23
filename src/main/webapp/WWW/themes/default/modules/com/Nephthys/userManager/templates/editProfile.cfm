<h1>Profil editieren</h1>
<cfoutput>
<div class="com-nephthys-userManager">
    <cfif attributes.result.error>
        <div class="alert alert-danger" role="alert">
            <h2><i class="fa fa-exclamation" aria-hidden="true"></i> Fehler während der Eingabe</h2>
            <p>Einige Eingaben waren nicht valide.</p>
        </div>
    </cfif>
    <cfif attributes.result.success>
        <div class="alert alert-success" role="alert">
            <h2><i class="fa fa-check" aria-hidden="true"></i> Speichern erfolgreich</h2>
            <p>Dein Profil wurde erfolgreich aktualisiert</p>
        </div>
    </cfif>
    
    <div class="row">
        <div class="col-sm-12">
            <form method="POST" action="?" enctype="multipart/form-data">
                <div class="row">
                    <div class="col-md-6">
                        <h3>Allgemeine Angaben</h3>
                        <input type="hidden" name="name" value="com.Nephthys.userManager.edit">
                        <div class="form-group">
                            <label class="col-md-4 form-control-label p-l-0">Benutzername</label>
                            <div class="col-md-8">
                                <p class="form-control-static">#request.user.getUsername()#</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 form-control-label p-l-0" title="Wenn Du deine Email-Adresse ändern möchtest, nutze bitte das Kontaktformular. Ein Admin wird deine Email-Adresse dann ändern. Danke">Email Adresse</label>
                            <div class="col-md-8">
                                <p class="form-control-static">#request.user.getEmail()#</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-control-label" for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" value="      ">
                        </div>
                        <div class="form-group <cfif attributes.result.errors.theme> has-danger</cfif>">
                            <label class="form-control-label" for="themeId">Theme der Website</label>
                            <select class="form-control <cfif attributes.result.errors.theme> form-control-danger</cfif>" id="themeId" name="themeId">
                                <cfloop from="1" to="#attributes.themes.len()#" index="themeIndex">
                                    <option value="#attributes.themes[themeIndex].getThemeId()#" <cfif attributes.themes[themeIndex].getThemeId() EQ request.user.getWwwTheme().getThemeId()> selected="selected"</cfif>>
                                        #attributes.themes[themeIndex].getName()#
                                    </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-6">
                                    <h4>Aktuelles Avatar</h4>
                                    <img class="img-rounded img-fluid" alt="#request.user.getUsername()# Avatar" src="#request.user.getAvatarPath()#">
                                </div>
                                <div class="col-md-6">
                                    <h4>Neues Avatar</h4>
                                    
                                    <input type="file" name="avatar" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h3>Erweiterte Angaben</h3>
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Beschreibung</th>
                                    <th>Wert</th>
                                    <th>Öffentlich</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop from="1" to="#attributes.extProperties.len()#" index="epIndex">
                                    <tr class="form-group">
                                        <td>
                                            #attributes.extProperties[epIndex].getExtPropertyKey().getDescription()#
                                        </td>
                                        <td>
                                            <cfswitch expression="#attributes.extProperties[epIndex].getExtPropertyKey().getType()#">
                                                <cfcase value="date">
                                                    <input type="date" name="extProperties_#attributes.extProperties[epIndex].getExtPropertyKey().getExtPropertyKeyId()#_#attributes.extProperties[epIndex].getExtPropertyId()#_value" value="#replace(attributes.extProperties[epIndex].getValue(), '/', '-', 'ALL')#" class="form-control" max="#dateFormat(now(), 'yyyy-mm-dd')#">
                                                </cfcase>
                                                <cfdefaultcase>
                                                    <input type="text" name="extProperties_#attributes.extProperties[epIndex].getExtPropertyKey().getExtPropertyKeyId()#_#attributes.extProperties[epIndex].getExtPropertyId()#_value" maxlength="255" value="#attributes.extProperties[epIndex].getValue()#" class="form-control">
                                                </cfdefaultcase>
                                            </cfswitch>
                                        </td>
                                        <td>
                                            <select class="form-control" name="extProperties_#attributes.extProperties[epIndex].getExtPropertyKey().getExtPropertyKeyId()#_#attributes.extProperties[epIndex].getExtPropertyId()#_public">
                                                <option value="true" <cfif attributes.extProperties[epIndex].getPublic()>selected="selected"</cfif>>Ja</option>
                                                <option value="false" <cfif NOT attributes.extProperties[epIndex].getPublic()>selected="selected"</cfif>>Nein</option>
                                            </select>
                                        </td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <button type="submit" class="btn btn-success"><i class="fa fa-floppy-o"></i> Profil aktualisieren</button>
                    </div>
                    <div class="col-md-6 text-md-right">
                        <a href="#attributes.userPage#/#request.user.getUsername()#/delete" onClick="confirm('Bist Du Dir sicher, dass Du dein Profil löschen möchtest?');" class="btn btn-danger"><i class="fa fa-trash"></i> Mein Profil löschen</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</cfoutput>