<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>

<script src='/themes/default/assets/angularUI/ui-bootstrap-tpls-1.3.2.min.js'></script>

<script type="text/javascript" src="/themes/default/directive/nephthysDatePicker/nephthysDatePicker.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/directives/nephthysPageVisit/nephthysPageVisit.js"></script>


<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/dashboardApp.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/service/visitService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/controller/visitCtrl.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/service/loginStatisticsService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/controller/loginStatisticsCtrl.js"></script>

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
            
            <div>
                <div class="card card-block">
                    <div ng-controller="visitCtrl">
                        <div class="container-fluid">
                            <div class="col-sm-12">
                                <button ng-click="refresh()" class="btn btn-primary pull-right"><i class="fa fa-refresh"></i> refresh</button>
                                <h2>Seitenbesuchsstatistiken</h2>
                            </div>
                        </div>
                        
                        <div class="container-fluid">
                            <div class="col-lg-6 col-md-12">
                                <h3>Heutige Aufrufe <small>Top 20</small></h3>
                                <canvas chart-options="todayVisitChart.options" chart-series="todayVisitChart.series" chart-labels="todayVisitChart.labels" chart-data="todayVisitChart.data" class="chart chart-bar ng-isolate-scope"></canvas>
                                
                                <ul class="m-b-1 container-fluid">
                                    <li ng-repeat="legend in todayVisitChartLegend" class="col-md-6"><a href="{{legend.link}}" target="_blank">{{legend.label}}</a></li>
                                </ul>
                            </div>
                            <div class="col-lg-6 col-md-12">
                                <h3>Gestrige Aufrufe <small>Top 20</small></h3>
                                <canvas chart-options="yesterdayVisitChart.options" chart-series="yesterdayVisitChart.series" chart-labels="yesterdayVisitChart.labels" chart-data="yesterdayVisitChart.data" class="chart chart-bar ng-isolate-scope"></canvas>
                                
                                <ul class="container-fluid">
                                    <li ng-repeat="legend in yesterdayVisitChartLegend" class="col-md-6"><a href="{{legend.link}}" target="_blank">{{legend.label}}</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card card-block">
                    <div ng-controller="loginStatisticsCtrl">
                        <div class="container-fluid">
                            <div class="col-sm-12">
                                <button ng-click="refresh()" class="btn btn-primary pull-right"><i class="fa fa-refresh"></i> refresh</button>
                                <h2>Loginstatistiken</h2>
                            </div>
                        </div>
                        
                        <div class="container-fluid">
                            <div class="col-lg-6 col-md-12">
                                <h3>Letzte erfolgreiche Logins</h3>
                                <ul>
                                    <li ng-repeat="login in successfulLogins">{{login.username}} - {{login.loginDate}}</li>
                                </ul>
                            </div>
                            <div class="col-lg-6 col-md-12">
                                <h3>Letzte fehlgeschlagene Logins</h3>
                                <ul>
                                    <li ng-repeat="login in failedLogins">{{login.username}} - {{login.loginDate}}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-block">
                <nephthys-page-visit sort-order="DESC"></nephthys-page-visit>
            </div>
        </div>
    </div>
</div>
</cfoutput>