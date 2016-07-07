<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <div class="row">
        <div class="col-md-12">
            <a href="new" class="btn btn-secondary pull-right">
                <i class="fa fa-key"></i> Neue Berechtigung anfragen
            </a>
            
            <h1>Übersicht der Berechtigungsanfragen</h1>
            
            <cfif attributes.requests.len() GT 0>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Modul</th>
                            <th>Rolle</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop from="1" to="#attributes.requests.len()#" index="requestIndex">
                            <tr class="clickable<cfif attributes.requests[requestIndex].isApproved()> table-success<cfelseif attributes.requests[requestIndex].isDeclined()> table-danger</cfif>" onClick="window.location='request/#attributes.requests[requestIndex].getRequestId()#'">
                                <td>#attributes.requests[requestIndex].getRequestId()#</td>
                                <td>#attributes.requests[requestIndex].getModule().getModuleName()#</td>
                                <td>#attributes.requests[requestIndex].getRole().name#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            <cfelse>
                <p class="text-warning">Wir konnten keine Berechtigungsanfragen finden, die Du gestellt hast.</p>
                <p>Stelle jetzt eine <a href="new">neue Berechtigungsanfrage</a>.</p>
            </cfif>
        </div>
    </div>
</div>
</cfoutput>