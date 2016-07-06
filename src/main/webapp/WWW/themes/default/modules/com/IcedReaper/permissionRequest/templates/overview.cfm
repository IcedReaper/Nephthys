<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <div class="row">
        <div class="col-md-12">
            <a href="new" class="btn btn-secondary pull-right">
                <i class="fa fa-key"></i> Neue Berechtigung anfragen
            </a>
            
            <h1>Übersicht der Berechtigungsanfragen</h1>
            
            <cfif attributes.requests.len() GT 0>
                <cfloop from="1" to="#attributes.requests.len()#" index="requestIndex">
                    
                </cfloop>
            <cfelse>
                <p class="text-warning">Wir konnten keine Berechtigungsanfragen finden, die Du gestellt hast.</p>
                <p>Stelle jetzt eine <a href="new">neue Berechtigungsanfrage</a>.</p>
            </cfif>
        </div>
    </div>
</div>
</cfoutput>