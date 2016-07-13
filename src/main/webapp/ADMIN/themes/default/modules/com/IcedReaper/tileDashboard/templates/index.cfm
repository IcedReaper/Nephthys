<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>

<script type="text/javascript" src="/themes/default/directive/nephthysLoadingBar/nephthysLoadingBar.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/tileDashboardApp.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/controller/tileDashboard.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/service/tileDashboard.js"></script>

<nephthys-loading-bar></nephthys-loading-bar>
<div class="com-IcedReaper-tileDashboard" ng-Controller="tileDashboardCtrl">
    <h1>Übersicht</h1>
    <div class="tile-wrapper">
        <div class="tile" ng-class="status.online ? status.maintenanceMode ? 'tile-warning' : 'tile-success' : 'tile-danger'">
            <div>
                <h3>Status</h3>
                <p>{{status.online ? status.maintenanceMode ? 'Wartungsmodus' : 'Online' : 'Offline'}}</p>
            </div>
        </div>
        <div class="tile tile-warning">
            <div>
                <h3>Uptime</h3>
                <p>{{uptime.formatAsTimeSince()}}</p>
            </div>
        </div>
        <div class="tile tile-primary clickable" onClick="window.location='/com.Nephthys.pages#/statistic'">
            <div>
                <h3>Seitenaufrufe</h3>
                <p>{{pageRequests}}</p>
            </div>
        </div>
        <div class="tile tile-success clickable" onClick="window.location='/com.Nephthys.pages#/statistic'">
            <div>
                <h3>Topseite</h3>
                <p>{{topPage.title}}</p>
                <p>{{topPage.requests}}</p>
            </div>
        </div>
        <div class="tile tile-danger clickable" onClick="window.location='/com.Nephthys.user'">
            <div>
                <h3>Neue Registrierungen</h3>
                <p>{{newRegistrations}}</p>
            </div>
        </div>
        <div class="tile tile-info">
            <div>
                <h3>Fehler</h3>
                <p>{{errors.count}}</p>
            </div>
        </div>
        <div class="tile wide lg-complete hidden-sm-down">
            <div>
                <canvas chart-options="last24HourChart.options"
                        chart-series="last24HourChart.series"
                        chart-labels="last24HourChart.labels"
                        chart-data="last24HourChart.data"
                        chart-type="last24HourChart.type"
                        class="chart chart-base"></canvas>
            </div>
        </div>
    </div>
</div>