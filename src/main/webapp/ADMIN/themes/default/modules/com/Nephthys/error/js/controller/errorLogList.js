nephthysAdminApp
    .controller('errorLogListCtrl', ["$scope", "errorLogService", function ($scope, errorLogService) {
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
    }]);