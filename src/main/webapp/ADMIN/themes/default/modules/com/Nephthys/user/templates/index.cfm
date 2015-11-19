<script type="text/javascript" src="/themes/default/assets/angularJs/angular.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/angular-route.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/$QDecorator.js"></script>

<!--- file upload --->
<script type="text/javascript" src="/themes/default/assets/angular-fileUpload/ng-file-upload-shim.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-fileUpload/ng-file-upload.js"></script>

<script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/js/userApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/js/service/userService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/js/controller/userList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/js/controller/userDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/Nephthys/user/js/controller/userPermission.js"></script>

<div ng-app="userAdmin">
    <div ng-view></div>
</div>