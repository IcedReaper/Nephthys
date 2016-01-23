(function(angular) {
    var errorLogListCtrl = angular.module('errorLogListCtrl', ["errorLogAdminService"]);
    
    errorLogListCtrl.controller('errorLogListCtrl', function ($scope, errorLogService) {
        $scope.refresh = function () {
            errorLogService
                .getList()
                .then(function (result) {
                    $scope.errorList = result.errorList;
                });
        };
        
        $scope.errorList = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    });
}(window.angular));