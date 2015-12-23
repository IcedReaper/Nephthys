(function(angular) {
    var statusListCtrl = angular.module('statusListCtrl', ["pageStatusService"]);
    
    statusListCtrl.controller('statusListCtrl', function ($scope, pageStatusService) {
        $scope.activate = function (pageStatusId) {
            pageStatusService
                .activate(pageStatusId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (pageStatusId) {
            pageStatusService
                .deactivate(pageStatusId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (pageStatusId) {
            pageStatusService
                .delete(pageStatusId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function() {
            pageStatusService
                .getList()
                .then(function (pageStatusList) {
                    $scope.pageStatus = pageStatusList.data;
                });
        }
        
        $scope.pageStatus = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    });
}(window.angular));