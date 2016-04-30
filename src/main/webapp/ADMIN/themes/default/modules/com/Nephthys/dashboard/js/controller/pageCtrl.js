nephthysAdminApp
    .controller('pageCtrl', ["$scope", "$q", "$uibModal", "visitService", function ($scope, $q, $uibModal, visitService) {
        var actualView = "perDay", // perYear | perMonth | perDay | perHour
            
            renderChart = function (pageRequestData) {
                $scope.chartData.labels =  pageRequestData.labels;
                $scope.chartData.data   = [pageRequestData.data];
            },
            today = function() {
                var now = new Date();
                
                return new Date(now.getFullYear(), now.getMonth(), now.getDate());
            };
        
        $scope.refresh = function () {
            var dateStringOptions = {
                month: "2-digit",
                day:   "2-digit",
                year:  "numeric"
            };
            
            $scope.chartData = {
                labels: [],
                data:   []
            };
            
            visitService
                .getPageRequests($scope.fromDate.toLocaleDateString('de-DE', dateStringOptions),
                                 $scope.toDate.toLocaleDateString('de-DE', dateStringOptions))
                .then(function(res) {
                    actualView = res.actualView;
                    
                    return res;
                })
                .then(renderChart);
        };
        
        $scope.handleClick = function (object, event) {
            switch(actualView) {
                case "perYear": {
                    $scope.fromDate = new Date(object[0].label, 0, 1);
                    $scope.toDate   = new Date(object[0].label + 1, 0, 0);
                    
                    if($scope.toDate > today()) {
                        $scope.toDate = today();
                    }
                    
                    break;
                }
                case "perMonth": {
                    var monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
                    
                    var month = monthNames.indexOf(object[0].label);
                    
                    if(month !== -1) {
                        $scope.fromDate = new Date($scope.fromDate.getFullYear(), month, 1);
                        $scope.toDate   = new Date($scope.fromDate.getFullYear(), month, 1);
                        $scope.toDate.setMonth($scope.toDate.getMonth() + 1);
                        $scope.toDate.setDate(0);
                    }
                    else {
                        console.warn("Could not find month!");
                        return;
                    }
                    
                    break;
                }
                case "perDay": {
                    var d = object[0].label.split(".");
                    
                    $scope.fromDate = new Date(d[2], d[1] - 1, d[0]);
                    $scope.toDate   = new Date(d[2], d[1] - 1, d[0]);
                    
                    break;
                }
                default: {
                    return;
                }
            }
            
            $scope.refresh();
        };
        
        $scope.openDatePickerDialog = function () {
            $uibModal.open({
                controller:     "datePickerModalCtrl",
                templateUrl:    "/themes/default/modules/com/Nephthys/dashboard/partials/datePickerModal.html",
                windowTopClass: "datePickerModal",
                resolve: {
                    items: function () {
                        return {
                            'fromDate': $scope.fromDate,
                            'toDate':   $scope.toDate
                        };
                    }
                }
            }).result.then(function (modalResult) {
                $scope.fromDate = modalResult.fromDate;
                $scope.toDate   = modalResult.toDate;
                
                $scope.refresh();
            });
        };
        
        $scope.getActualFilterType = function () {
            return actualView;
        }
        
        $scope.chartType = "HorizontalBar";
        
        // init dates
        var now = new Date();
        $scope.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        $scope.toDate   = new Date();
        $scope.toDate.setMonth($scope.fromDate.getMonth() + 1);
        $scope.toDate.setDate(0);
        
        $scope.refresh();
    }]);