nephthysAdminApp
    .controller('errorLogListCtrl', ["$rootScope", "$scope", "errorLogService", function ($rootScope, $scope, errorLogService) {
        $scope.refresh = function () {
            errorLogService
                .getList($scope.selectedDate.fromDate,
                         $scope.selectedDate.toDate)
                .then(function (errorList) {
                    $scope.errorList = errorList;
                });
        };
        
        $scope.errorList = [];
        $scope.search = {
            active: ""
        };
        
        var now = new Date();
        $scope.selectedDate = {};
        $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        $scope.selectedDate.toDate = new Date();
        $scope.selectedDate.toDate.setMonth($scope.selectedDate.fromDate.getMonth() + 1);
        $scope.selectedDate.toDate.setDate(0);
        
        $scope.$watch(function () {
            return {
                fromDate: $scope.selectedDate.fromDate,
                toDate: $scope.selectedDate.toDate
            };
        }, function(newValues, oldValues) {
            if(oldValues.fromDate !== newValues.fromDate || oldValues.toDate !== newValues.toDate) {
                $scope.refresh();
            }
        }, true);
        
        var dateChangedEvent = $rootScope.$on('nephthys-date-picker-date-changed', function(evt, data) {
            $scope.selectedDate.fromDate = data.fromDate;
            $scope.selectedDate.toDate   = data.toDate;
        });
        var refreshEvent = $rootScope.$on('nephthys-statistics-refresh', $scope.refresh);
        
        $scope.$on('$destroy', function() {
            dateChangedEvent();
            refreshEvent();
        });
        
        $scope.refresh();
    }]);