(function (angular) {
    var dashboardApp = angular.module("dashboardApp", ["visitCtrl", "loginStatisticsCtrl"]);
    
    dashboardApp
        .config(["$httpProvider", globalAngularAjaxSettings]);
}(window.angular));