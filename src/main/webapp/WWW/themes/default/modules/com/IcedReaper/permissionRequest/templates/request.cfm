<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <div class="row">
        <div class="col-md-12">
            <cf_userLink userName="#request.user.getUserName()#" deepLink="/permissionRequest/overview" class="btn btn-primary pull-right"><i class="fa fa-list"></i> Übersicht</cf_userLink>
            
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
                    #attributes.request.getPermissionRole().getName()#
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    Begründung
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
    </div>
</div>
</cfoutput>