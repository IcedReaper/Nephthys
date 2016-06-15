angular.module("com.nephthys.page.pageVisit", ["chart.js",
                                               "ui.bootstrap",
                                               "nephthys.datePicker"])
    .service("nephthysPageVisitService", function($http) {
        return {
            getPageRequests: function(pageId, sortOrder, fromDate, toDate) {
                return $http.get('/ajax/com/Nephthys/pages/getPageRequests', {
                    params: {
                        pageId:    pageId,
                        sortOrder: sortOrder,
                        fromDate:  fromDate,
                        toDate:    toDate
                    }
                });
            }
        };
    })
    .controller('nephthysPageVisitController', ["$rootScope", "$scope", "$q", "nephthysPageVisitService", function ($rootScope, $scope, $q, service) {
        var actualView = "perDay", // perYear | perMonth | perDay | perHour
            
            renderChart = function (pageRequestData) {
                $scope.chart.labels =  pageRequestData.labels;
                $scope.chart.data   = [pageRequestData.data];
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
            
            $scope.chart.labels = [];
            $scope.chart.data   = [];
            
            service
                .getPageRequests($scope.pageId,
                                 $scope.sortOrder,
                                 $scope.fromDate.toLocaleDateString('de-DE', dateStringOptions),
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
                    $scope.fromDate = new Date(object[0]._model.label, 0, 1);
                    $scope.toDate   = new Date(object[0]._model.label + 1, 0, 0);
                    
                    if($scope.toDate > today()) {
                        $scope.toDate = today();
                    }
                    
                    break;
                }
                case "perMonth": {
                    var monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
                    
                    var month = monthNames.indexOf(object[0]._model.label);
                    
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
                    var d = object[0]._model.label.split(".");
                    
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
        
        $scope.getActualFilterType = function () {
            return actualView;
        }
        
        $scope.chart = {};
        
        // init dates
        if(! $scope.pageId) {
            $scope.pageId = null;
        }
        
        if(! $scope.chartType) {
            $scope.chart.type = "horizontalBar";
        }
        else {
            $scope.chart.type = $scope.chartType;
        }
        
        if(! $scope.chartOptions) {
            switch($scope.chart.type) {
                case "horizontalBar": {
                    $scope.chart.options = {
                        responsive: false,
                        maintainAspectRatio: false,
                        fixedBarHeight: true,
                        barHeight: 40,
                        scales: {
                            xAxes: [{
                                ticks: {
                                    beginAtZero:true
                                }
                            }]
                        }
                    };
                    
                    break;
                }
                case "bar": {
                    $scope.chart.options = {
                        fixedHeight: true,
                        height: 450,
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero:true
                                }
                            }]
                        }
                    };
                    
                    break;
                }
            }
        }
        else {
            $scope.chart.options = $scope.chartOptions;
        }
        
        if(! $scope.fromDate) {
            var now = new Date();
            $scope.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        }
        else {
            if(! $scope.fromDate instanceof Date) {
                console.error("from date is not a date!");
            }
        }
        
        if(! $scope.toDate) {
            $scope.toDate = new Date();
            $scope.toDate.setMonth($scope.fromDate.getMonth() + 1);
            $scope.toDate.setDate(0);
        }
        else {
            if(! $scope.toDate instanceof Date) {
                console.error("from date is not a date!");
            }
        }
        
        if(! $scope.sortOrder) {
            $scope.sortOrder = "ASC";
        }
        else {
            if($scope.sortOrder.toUpperCase() != "ASC" && $scope.sortOrder.toUpperCase() != "DESC") {
                $scope.sortOrder = "ASC";
            }
        }
        
        var unregister = $rootScope.$on('nephthys-date-picker-date-changed', function(evt, data) {
            $scope.fromDate = data.fromDate;
            $scope.toDate   = data.toDate;
            
            $scope.refresh();
        });
        
        $scope.$on('$destroy', function() {
            unregister();
        });
        
        $scope.refresh();
    }])
    .directive("nephthysPageVisit", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "nephthysPageVisitController",
            scope: {
                pageId: "=?",
                fromDate: "=?",
                toDate: "=?",
                chartType: "@",
                chartOptions: "=?",
                sortOrder: "@"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/pages/directives/nephthysPageVisit/nephthysPageVisit.html"
        };
    });