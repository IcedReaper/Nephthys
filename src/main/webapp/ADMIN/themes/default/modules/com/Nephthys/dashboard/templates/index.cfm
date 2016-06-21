<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>

<script type="text/javascript" src='/themes/default/assets/angularUI/ui-bootstrap-tpls-1.3.2.min.js'></script>

<script type="text/javascript" src="/themes/default/directive/nephthysLoadingBar/nephthysLoadingBar.js"></script>
<script type="text/javascript" src="/themes/default/directive/nephthysUserInfo/nephthysUserInfo.js"></script>
<script type="text/javascript" src="/themes/default/directive/nephthysDatePicker/nephthysDatePicker.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/directives/statistics/statistics.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/directives/tasklist/tasklist.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/directives/loginLog/loginLog.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/directives/statistics/statistics.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/dashboardApp.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/controller/serverInfo.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/controller/news.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/dashboard/js/service/dashboard.js"></script>

<nephthys-loading-bar></nephthys-loading-bar>
<div class="com-Nephthys-dashboard">
    <h1>Willkommen</h1>
    
    <div class="row">
        <div class="col-md-12">
            <div class="card card-block" ng-include="'/themes/default/modules/com/Nephthys/dashboard/partials/serverInfo.html'"></div>
        </div>
    </div>
    
    <div class="row" ng-controller="newsCtrl">
        <div class="col-md-12">
            <div class="card card-block">
                <button class="btn btn-primary pull-right"
                        ng-click="refresh();"><i class="fa fa-refresh"></i> refresh</button>
                <h3>Aktuelles</h3>
                
                <nephthys-date-picker from-date = "selectedDate.fromDate"
                                      to-date   = "selectedDate.toDate"
                                      format    = "dd.MM.yyyy"></nephthys-date-picker>
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-12">
                                <nephthys-user-statistics chart-type          = "'line'"
                                                          selected-date       = "selectedDate"
                                                          show-date-picker    = "options.showDatePicker"
                                                          show-refresh-button = "options.showRefreshButton"></nephthys-user-statistics>
                            </div>
                        </div>
                        <div class="row m-t-1">
                            <div class="col-md-12">
                                <nephthys-page-statistics request-type        = "'perPage'"
                                                          selected-date       = "selectedDate"
                                                          chart-type          = "'line'"
                                                          sort-order          = "ASC"
                                                          show-date-picker    = "options.showDatePicker"
                                                          show-refresh-button = "options.showRefreshButton"></nephthys-page-statistics>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <nephthys-page-statistics request-type        = "'total'"
                                                  selected-date       = "selectedDate"
                                                  sort-order          = "DESC"
                                                  show-date-picker    = "options.showDatePicker"
                                                  show-refresh-button = "options.showRefreshButton"></nephthys-page-statistics>
                    </div>
                </div>
            </div>
            
            
        </div>
    </div>
    <cfif request.user.hasPermission("com.Nephthys.user", "user")>
        <div class="row">
            <div class="col-md-12">
                <div class="card card-block">
                    <h2>Aufgabenliste</h2>
                    <nephthys-page-tasklist class="tasklist-sm"
                                            show-page-button="'false'"
                                            combine-next-status-button="'true'"></nephthys-page-tasklist>
                </div>
            </div>
        </div>
    </cfif>
</div>