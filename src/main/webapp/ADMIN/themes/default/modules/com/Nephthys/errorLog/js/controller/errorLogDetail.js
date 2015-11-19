(function(angular) {
    var errorLogDetailCtrl = angular.module('errorLogDetailCtrl', ["errorLogAdminService"]);
    
    errorLogDetailCtrl.controller('errorLogDetailCtrl', function ($scope, $routeParams, errorLogService) {
        errorLogService
            .getDetails($routeParams.errorCode)
            .then(function (errorLogDetails) {
                $scope.errorLog = errorLogDetails.data;
            });
    });
}(window.angular));