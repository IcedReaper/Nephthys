nephthysAdminApp
    .controller('datePickerModalCtrl', ["$scope", "$uibModalInstance", "items", function ($scope, $uibModalInstance, items) {
        var today = function() {
            var now = new Date();
            
            return new Date(now.getFullYear(), now.getMonth(), now.getDate());
        };
        
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
        
        $scope.selectDates = function() {
            $uibModalInstance.close({
                fromDate: $scope.fromDate,
                toDate:   $scope.toDate
            });
        };
        
        $scope.selectTotal = function () {
            $uibModalInstance.close({
                fromDate: new Date(2015, 9, 1),
                toDate:   today()
            });
        }
        
        $scope.selectYear = function (selector) {
            switch(selector) {
                case 'this': {
                    $uibModalInstance.close({
                        fromDate: new Date(today().getFullYear(), 0, 1),
                        toDate:   today()
                    });
                    
                    break;
                }
            }
        };
        
        $scope.selectMonth = function (selector) {
            switch(selector) {
                case 'this': {
                    var now = new Date();
                    
                    $uibModalInstance.close({
                        fromDate: new Date(now.getFullYear(), now.getMonth(), 1),
                        toDate:   today()
                    });
                    
                    break;
                }
                case 'last': {
                    var now = new Date();
                    
                    var fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
                    fromDate.setMonth(fromDate.getMonth() - 1);
                    var toDate   = new Date(now.getFullYear(), now.getMonth(), 0);
                    
                    $uibModalInstance.close({
                        fromDate: fromDate,
                        toDate:   toDate
                    });
                    
                    break;
                }
            }
        };
        
        $scope.selectDayCount = function (dayCount) {
            if(! isNaN(dayCount)) {
                var fromDate = today();
                fromDate.setDate(fromDate.getDate() - dayCount);
                
                $uibModalInstance.close({
                    fromDate: fromDate,
                    toDate:   today()
                });
            }
        };
    }]);