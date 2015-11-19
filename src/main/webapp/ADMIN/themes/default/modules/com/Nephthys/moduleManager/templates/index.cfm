<script type="text/javascript" src="/themes/default/assets/angularJs/angular.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/angular-route.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/$QDecorator.js"></script>

<script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/moduleManagerApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/service/moduleManagerService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/controller/moduleManagerList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/controller/moduleManagerDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/controller/moduleManagerPermissions.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/moduleManager/js/controller/moduleManagerDBDump.js"></script>

<div ng-app="moduleManagerAdmin">
    <div ng-view></div>
</div>