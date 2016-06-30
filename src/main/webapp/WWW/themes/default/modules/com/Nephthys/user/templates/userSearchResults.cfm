<cfoutput>
<section>
    <header>
        <h1>Suchergebnisse für <small>&ldquo;#HTMLEditFormat(attributes.searchQuery)#&rdquo;</small></h1>
    </header>

    <cfif attributes.results.len() GT 0>
        <cfloop from="1" to="#attributes.results.len()#" index="userIndex">
            <section class="m-t-1">
                <div class="card userDetails p-a-1">
                    <div class="card-block">
                        <h4 class="card-title"><a href="#attributes.userPage#/#attributes.results[userIndex].getUsername()#">#attributes.results[userIndex].getUsername()#</a></h4>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <img class="avatar img-rounded" alt="#attributes.results[userIndex].getUsername()# Avatar" src="#attributes.results[userIndex].getAvatarPath()#">
                        </div>
                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-3 text-right">
                                    <strong>Registriert am:</strong>
                                </div>
                                <div class="col-md-9">
                                    #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.results[userIndex].getRegistrationDate())#
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </cfloop>
    <cfelse>
        <div class="alert alert-danger" role="alert">
            Es konnte kein user mit dem Teil &ldquo;#HTMLEditFormat(attributes.searchQuery)#&rdquo; gefunden werden.
            
            <a href="#attributes.userPage#">Zurück zur Suche</a>
        </div>
    </cfif>
</section>
</cfoutput>