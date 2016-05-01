nephthysAdminApp
    .controller('errorLogListCtrl', ["$scope", "errorLogService", function ($scope, errorLogService) {
        $scope.refresh = function () {
            errorLogService
                .getList()
                .then(function (errorList) {
                    $scope.errorList = errorList;
                });
        };
        
        $scope.errorList = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    }]);