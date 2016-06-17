<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>

<script src='/themes/default/assets/angularUI/ui-bootstrap-tpls-1.3.2.min.js'></script>

<script type="text/javascript" src="/themes/default/directive/nephthysUserInfo/nephthysUserInfo.js"></script>
<script type="text/javascript" src="/themes/default/directive/nephthysDatePicker/nephthysDatePicker.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/directives/statistics/statistics.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/directives/tasklist/tasklist.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/directives/loginLog/loginLog.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/dashboardApp.js"></script>

<cfoutput>
<div class="com-Nephthys-dashboard">
    <h1>Willkommen im Adminpanel <small>#request.user.getUsername()#</small></h1>
    
    <div class="row">
        <div class="col-md-8">
            <div class="card card-block">
                <h2>Serverinformationen</h2>
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Status</strong>
                    </div>
                    <div class="col-md-9">
                        <cfif attributes.serverStatus.getValueOfKey("active") EQ 1>
                            <p class="text-success"><strong>Online</strong></p>
                        <cfelse>
                            <p class="text-danger"><strong>Offline</strong></p>
                        </cfif>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Wartungsmodus</strong>
                    </div>
                    <div class="col-md-9">
                        <cfif attributes.serverStatus.getValueOfKey("maintenanceMode") EQ 1>
                            <p class="text-danger"><strong>Aktiv</strong></p>
                        <cfelse>
                            <p class="text-success"><strong>Inaktiv</strong></p>
                        </cfif>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Installationsdatum</strong>
                    </div>
                    <div class="col-md-9">
                        <p>#application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.serverStatus.getValueOfKey("installDate"))#</p>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Aktuell installierte Nephthys-Version</strong>
                    </div>
                    <div class="col-md-9">
                        <p>#attributes.serverStatus.getValueOfKey("nephthysVersion")#</p>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-3 text-right">
                        <strong>Aktuelle Speicherauslastung</strong>
                    </div>
                    <div class="col-md-6">
                        #attributes.memory.used#MB / #attributes.memory.total#MB<br>
                        <progress class="progress <cfif attributes.memory.percentageUsed LT 50>progress-success<cfelseif attributes.memory.percentageUsed LT 80>progress-warning<cfelse>progress-danger</cfif>" value="#attributes.memory.used#" max="#attributes.memory.total#">#attributes.memory.percentageUsed#%</progress>
                    </div>
                </div>
            </div>
            
            <div class="card card-block">
                <nephthys-user-login-log></nephthys-user-login-log>
            </div>
            
            <div class="card card-block">
                <div class="row">
                    <div class="col-md-12">
                        <h2>Aufgabenliste</h2>
                    </div>
                </div>
                <nephthys-page-tasklist class="tasklist-sm"
                                        show-page-button="false"
                                        combine-next-status-button="true"
                                        show-page-putton="false"></nephthys-page-tasklist>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-block">
                <nephthys-page-statistics request-type="'total'"
                                          sort-order="DESC"
                                          headline="Verlauf von Seitenaufrufen"></nephthys-page-statistics>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-block">
                <nephthys-page-statistics request-type="'perPage'"
                                          chart-type="'line'"
                                          sort-order="ASC"></nephthys-page-statistics>
            </div>
        </div>
    </div>
</div>
</cfoutput>