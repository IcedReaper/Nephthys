angular.module("com.nephthys.global.datePicker", ["ui.bootstrap"])
    .controller("nephthysDatePickerController", ["$rootScope", "$scope", "$uibModal", function ($rootScope, $scope, $uibModal) {
        $scope.openDatePickerDialog = function () {
            $uibModal.open({
                controller:     "datePickerModalController",
                templateUrl:    "/themes/default/directive/nephthysDatePicker/nephthysDatePickerModal.html",
                windowTopClass: "datePickerModal",
                resolve: {
                    fromDate: $scope.fromDate,
                    toDate:   $scope.toDate
                }
            }).result.then(function (modalResult) {
                $scope.fromDate = modalResult.fromDate;
                $scope.toDate   = modalResult.toDate;
                
                $rootScope.$broadcast("nephthys-date-picker-date-changed", {
                    fromDate: $scope.fromDate,
                    toDate: $scope.toDate
                });
            });
        };
        
        $scope.format = $scope.format || "dd.MM.yyyy";
    }])
    .controller("datePickerModalController", ["$scope", "$uibModalInstance", "fromDate", "toDate", function ($scope, $uibModalInstance, fromDate, toDate) {
        $scope.fromDate = fromDate;
        $scope.toDate   = toDate;
        
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
                case "this": {
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
                case "this": {
                    var now = new Date();
                    
                    $uibModalInstance.close({
                        fromDate: new Date(now.getFullYear(), now.getMonth(), 1),
                        toDate:   today()
                    });
                    
                    break;
                }
                case "last": {
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
    }])
    .directive("nephthysDatePicker", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "nephthysDatePickerController",
            scope: {
                fromDate: "=?",
                toDate: "=?",
                format: "@"
            },
            templateUrl : "/themes/default/directive/nephthysDatePicker/nephthysDatePicker.html"
        };
    });