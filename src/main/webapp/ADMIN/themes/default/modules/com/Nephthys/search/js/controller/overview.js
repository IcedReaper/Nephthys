nephthysAdminApp
    .controller("overviewCtrl", ["$rootScope", "$scope", function($rootScope, $scope) {
        var now = new Date();
        $scope.selectedDate = {};
        $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        $scope.selectedDate.toDate = new Date();
        $scope.selectedDate.toDate.setMonth($scope.selectedDate.fromDate.getMonth() + 1);
        $scope.selectedDate.toDate.setDate(0);
        
        $scope.options = {
            showDatePicker:    false,
            showRefreshButton: false
        };
        
        $scope.refresh = function () {
            $rootScope.$broadcast("nephthys-statistics-refresh");
        };
    }]);