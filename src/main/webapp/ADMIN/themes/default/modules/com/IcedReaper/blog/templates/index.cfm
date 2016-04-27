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
<script src='/themes/default/assets/angularUI/ui-bootstrap-1.3.2.min.js'></script>
<!--- required for the modal directive --->
<script type="text/ng-template" id="backdrop.html">
<div class="modal-backdrop"
     uib-modal-animation-class="fade"
     modal-in-class="in"
     ng-style="{'z-index': 1040 + (index && 1 || 0) + index*10}"
></div>
</script>

<script type="text/ng-template" id="window.html">
<div modal-render="{{$isRendered}}" tabindex="-1" role="dialog" class="modal"
    uib-modal-animation-class="fade"
    modal-in-class="in"
    ng-style="{'z-index': 1050 + index*10, display: 'block'}">
    <div class="modal-dialog {{size ? 'modal-' + size : ''}}"><div class="modal-content" uib-modal-transclude></div></div>
</div>
</script>

<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/blogApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/service/blogService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/service/categoryService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/service/settingsService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogCategory.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogStatistics.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/blogComments.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/UploadImageModal.js"></script> <!--- Image Add Dialog --->

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/categoryList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/categoryDetail.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/blog/js/controller/settings.js"></script>

<div ng-view></div>