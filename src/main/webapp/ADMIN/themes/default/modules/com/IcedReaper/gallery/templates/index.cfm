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

<!--- tagsInput | for categories --->
<link rel='stylesheet' href='/themes/default/assets/angular-tagsInput/ng-tags-input.min.css'>
<script src='/themes/default/assets/angular-tagsInput/ng-tags-input.min.js'></script>

<script type="text/javascript" src="/themes/default/js/globalAngularAjaxSettings.js"></script>
<!--- app --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/galleryApp.js"></script>

<!--- services --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/service/galleryService.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/service/categoryService.js"></script>

<!--- controller --->
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/galleryList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/galleryDetail.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/galleryPicture.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/galleryCategory.js"></script>

<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/categoryList.js"></script>
<script type="text/javascript" src="/themes/default/modules/com/IcedReaper/gallery/js/controller/categoryDetail.js"></script>

<div ng-app="galleryAdmin">
    <div ng-view></div>
</div>