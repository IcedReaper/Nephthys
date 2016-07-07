<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <h1>Deine Anfrage <small>#attributes.request.getRequestId()#</small></h1>
    <div class="row">
        <div class="col-md-2">
            Modul
        </div>
        <div class="col-md-10">
            #attributes.request.getModule().getModuleName()#
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            Rolle
        </div>
        <div class="col-md-10">
            #attributes.request.getRole().name#
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            Kommentar
        </div>
        <div class="col-md-10">
            #application.system.settings.getValueOfKey("xssProtector").encodeForHTML(attributes.request.getReason())#
        </div>
    </div>
    <div class="row">
        <div class="col-md-2">
            Status
        </div>
        <div class="col-md-10">
            <cfif attributes.request.getStatus() EQ -1>
                <span class="text-danger">Abgelehnt</span>
            <cfelseif attributes.request.getStatus() EQ 1>
                <span class="text-success">Akzeptiert</span>
            <cfelse>
                Offen
            </cfif>
        </div>
    </div>
    <cfif attributes.request.getStatus() NEQ 0 AND attributes.request.getComment() NEQ "">
        <div class="row">
            <div class="col-md-2">
                Antwort
            </div>
            <div class="col-md-10">
                #application.system.settings.getValueOfKey("xssProtector").encodeForHTML(attributes.request.getComment())#
            </div>
        </div>
    </cfif>
</div>
</cfoutput>