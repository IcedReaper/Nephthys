<cfoutput>
<h1>Suchergebnisse für <small>#HTMLEditFormat(attributes.searchQuery)#</small></h1>

<cfif attributes.results.len() GT 0>
    <cfloop from="1" to="#attributes.results.len()#" index="userIndex">
        <div class="well userDetails">
            <h4><a href="/user/#attributes.results[userIndex].getUsername()#">#attributes.results[userIndex].getUsername()#</a></h4>
            <div class="row">
                <div class="col-md-3">
                    <img class="avatar img-rounded" alt="#attributes.results[userIndex].getUsername()# Avatar" src="/upload/com.Nephthys.user/avatar/#attributes.results[userIndex].getAvatarFilename()#">
                </div>
                <div class="col-md-9">
                    <div class="row">
                        <div class="col-md-3 text-right">
                            <strong>Registriert am:</strong>
                        </div>
                        <div class="col-md-9">
                            #application.tools.formatter.formatDate(attributes.results[userIndex].getRegistrationDate())#
                        </div>
                    </div>
                    <!--- todo: check further information --->
                </div>
            </div>
        </div>
    </cfloop>
<cfelse>
    <div class="alert alert-danger" role="alert">
        Es konnte kein user gefunden werden.
        
        <a href="/user">Zurück zur Suche</a>
    </div>
</cfif>
</cfoutput>