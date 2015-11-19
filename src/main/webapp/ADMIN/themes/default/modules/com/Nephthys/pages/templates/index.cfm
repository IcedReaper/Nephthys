<script type="text/javascript" src="/themes/default/assets/angularJs/angular.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/angular-route.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/angular-sanitize.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/$QDecorator.js"></script>

<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>

<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>
<link rel="stylesheet" href="/themes/default/assets/angular-chart/angular-chart.min.css"></script>
<!--- check if this works - overwise implement resource handler - then refactor resource handler to work with website and admin panel --->

<script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/js/pagesApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/js/service/pagesService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/js/controller/pagesList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/js/controller/pagesDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/pages/js/controller/pagesStatistics.js"></script>

<div ng-app="pagesAdmin">
    <div ng-view></div>
</div>