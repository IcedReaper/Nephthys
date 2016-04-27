nephthysAdminApp
    .controller('pageCtrl', ["$scope", "$q", "$uibModal", "visitService", function ($scope, $q, $uibModal, visitService) {
        var filter = {
                "actualChartType": "dayCount",
                "forDay":          null,
                "dayCount":        60,
                "forMonth":        null,
                "forYear":         null,
                "forTimeFrame":    null
            },
            
            renderChart = function (pageRequestData) {
                $scope.chartData.type   = "HorizontalBar";
                $scope.chartData.labels =  pageRequestData.labels;
                $scope.chartData.data   = [pageRequestData.data];
            };
        
        $scope.refresh = function () {
            $scope.chartData = {
                labels: [],
                data:   []
            };
            
            switch(filter.actualChartType) {
                case "dayCount": {
                    visitService
                        .getVisitsForDayCount(filter.dayCount)
                        .then(renderChart);
                    break;
                }
                case "forMonth": {
                    visitService
                        .getVisitsForMonth(filter.forMonth.month,
                                           filter.forMonth.year)
                        .then(renderChart);
                    break;
                }
                case "forYear": {
                    visitService
                        .getVisitsForYear(filter.forYear)
                        .then(renderChart);
                    break;
                }
                case "forTimeFrame": {
                    visitService
                        .getVisitsForTimeFrame(filter.forTimeFrame.startDate,
                                               filter.forTimeFrame.endDate)
                        .then(renderChart);
                    break;
                }
                case "forDay": {
                    visitService
                        .getVisitsForDay(filter.forDay)
                        .then(renderChart);
                    break;
                }
                default: {
                    console.error("Wrong chart type");
                }
            }
        };
        
        $scope.handleClick = function (object, event) {
            switch(filter.actualChartType) {
                case "dayCount":
                case "forTimeFrame":
                case "forMonth": {
                    $scope.setActualChartType('forDay');
                    var dateParts = object[0].label.split(".");
                    filter.forDay = new Date(dateParts[2], dateParts[1], dateParts[0]);
                    
                    $scope.refresh();
                    
                    break;
                }
                case "forYear": {
                    break;
                }
                case "forDay": {
                    break;
                }
                default: {
                    console.error("Wrong chart type");
                }
            }
        };
        
        $scope.setActualChartType = function (name) {
            switch(filter.actualChartType) {
                case "dayCount":
                case "forMonth":
                case "forYear":
                case "forTimeFrame":
                case "forDay": {
                    filter.actualChartType = name;
                    break;
                }
                default: {
                    console.error("Wrong chart type");
                }
            }
        };
        
        $scope.openDatePickerDialog = function () {
            $uibModal.open({
                controller:     "datePickerModalCtrl",
                templateUrl:    "/themes/default/modules/com/Nephthys/dashboard/partials/datePickerModal.html",
                windowTopClass: "datePickerModal",
                resolve: {
                    items: function () {
                        var fromDate = new Date();
                        var toDate   = new Date();
                        
                        fromDate.setDate(fromDate.getDate() - 60);
                        
                        return {
                            'fromDate': fromDate,
                            'toDate':   toDate
                        };
                    }
                }
            }).result.then(function (modalResult) {
                
                $scope.setActualChartType(modalResult.type);
                $scope.fromDate = modalResult.fromDate;
                $scope.toDate   = modalResult.toDate;
                
                filter.forTimeFrame = {
                    startDate: $scope.fromDate,
                    endDate:   $scope.toDate
                };
                
                $scope.refresh();
            });
        };
        
        $scope.refresh();
        
        $scope.fromDate = new Date();
        $scope.toDate   = new Date();
        $scope.fromDate.setDate($scope.fromDate.getDate() - filter.dayCount);
    }]);