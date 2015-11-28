<script type="text/javascript" src="/themes/default/assets/angularJs/angular.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/angular-route.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angularJs/$QDecorator.js"></script>

<!--- file upload --->
<script type="text/javascript" src="/themes/default/assets/angular-fileUpload/ng-file-upload-shim.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-fileUpload/ng-file-upload.js"></script>

<!--- textAngular --->
<link rel='stylesheet' href='/themes/default/assets/angular-textAngular/textAngular.css'>
<script src='/themes/default/assets/angular-textAngular/textAngular-rangy.min.js'></script>
<script src='/themes/default/assets/angular-textAngular/textAngular-sanitize.min.js'></script>
<script src='/themes/default/assets/angular-textAngular/textAngular.min.js'></script>

<!--- Charts --->
<script type="text/javascript" src="/themes/default/assets/ChartJS/Chart.min.js"></script>
<script type="text/javascript" src="/themes/default/assets/angular-chart/angular-chart.min.js"></script>
<link rel="stylesheet" href="/themes/default/assets/angular-chart/angular-chart.min.css"></script>

<!--- tagsInput | for categories --->
<link rel='stylesheet' href='/themes/default/assets/angular-tagsInput/ng-tags-input.min.css'>
<script src='/themes/default/assets/angular-tagsInput/ng-tags-input.min.js'></script>

<!--- Angular UI --->
<script src='/themes/default/assets/angularUI/ui-bootstrap-custom-0.14.3.min.js'></script>
<script src='/themes/default/assets/angularUI/ui-bootstrap-custom-tpls-0.14.3.min.js'></script>

<script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/blogApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/service/blogService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/service/categoryService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogCategory.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogStatistics.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/categoryList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/categoryDetail.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/UploadImageModal.js"></script>

<div ng-app="blogAdmin">
    <div ng-view></div>
</div>