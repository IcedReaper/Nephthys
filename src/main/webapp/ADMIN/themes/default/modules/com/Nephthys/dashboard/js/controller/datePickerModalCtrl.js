nephthysAdminApp
    .controller('datePickerModalCtrl', ["$scope", "$uibModalInstance", "items", function ($scope, $uibModalInstance, items) {
        $scope.fromDate = items.fromDate;
        $scope.toDate   = items.toDate;
        
        $scope.fromDateOptions = {
            startingDay: 1
        };
        $scope.toDateOptions = {
            startingDay: 1
        };
        
        $scope.fromDatePicker = {
            opened: false
        };
        $scope.toDatePicker = {
            opened: false
        };
        
        $scope.openDatePicker = function (datePicker) {
            if($scope[datePicker]) {
                $scope[datePicker].opened = true;
            }
        };
        
        $scope.selectDates = function () {
            $uibModalInstance.close({
                type:     "forTimeFrame",
                fromDate: $scope.fromDate,
                toDate:   $scope.toDate
            });
        };
    }]);