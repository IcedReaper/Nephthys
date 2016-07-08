<script type="text/javascript" src="/themes/default/directive/nephthysLoadingBar/nephthysLoadingBar.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/tileDashboardApp.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/controller/tileDashboard.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/tileDashboard/js/service/tileDashboard.js"></script>

<nephthys-loading-bar></nephthys-loading-bar>
<div class="com-IcedReaper-tileDashboard" ng-Controller="tileDashboardCtrl">
    <h1>Übersicht</h1>
    <div class="tile-wrapper">
        <div class="tile">
            <div>
                <h3>Seitenaufrufe</h3>
                <p>{{pageRequests}}</p>
            </div>
        </div>
        <div class="tile tile-success">
            <div>
                <h3>Topseite</h3>
                <p>{{topPage.title}}</p>
                <p>{{topPage.requests}}</p>
            </div>
        </div>
        <div class="tile tile-warning">
            <div>
                <h3>Uptime</h3>
                <p>{{uptime.formatAsTimeSince()}}</p>
            </div>
        </div>
        <div class="tile tile-danger">
            <div>
                <h3>Neue Registrierungen</h3>
                <p>{{newRegistrations}}</p>
            </div>
        </div>
        <div class="tile tile-primary">
            <div>
                <h3>Aufgaben</h3>
                <p>{{tasks.count}}</p>
            </div>
        </div>
        <div class="tile tile-info">
            <div>
                <h3>Fehler</h3>
                <p>{{errors.count}}</p>
            </div>
        </div>
        <div class="tile wide">
            <div>
                <h3>Seitenaufrufe</h3>
                <p>Chart hier...</p>
            </div>
        </div>
    </div>
</div>