nephthysAdminApp
    .controller('statusListCtrl', ["$scope", "statusService", function ($scope, statusService) {
        $scope.activate = function (statusId) {
            statusService
                .activate(statusId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (statusId) {
            statusService
                .deactivate(statusId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (statusId) {
            statusService
                .delete(statusId)
                .then($scope.refresh);
        };
        
        $scope.refresh = function() {
            statusService
                .getList()
                .then(function (statusList) {
                    $scope.status = statusList;
                });
        };
        
        $scope.status = {};
        $scope.filter = {
            active: '',
            canLogin: ''
        };
        $scope.refresh();
    }]);