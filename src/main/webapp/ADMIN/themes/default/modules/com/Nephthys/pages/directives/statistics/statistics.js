angular.module("com.nephthys.page.statistics", ["chart.js",
                                               "ui.bootstrap",
                                               "nephthys.datePicker"])
    .service("statisticsService", function($http) {
        return {
            getPageRequests: function(sortOrder, fromDate, toDate, pageId) {
                return $http.get('/ajax/com/Nephthys/pages/getPageRequests', {
                    params: {
                        pageId:    pageId,
                        sortOrder: sortOrder,
                        fromDate:  fromDate,
                        toDate:    toDate
                    }
                });
            },
            getPageRequestsSeperatedByPage: function(sortOrder, fromDate, toDate) {
                return $http.get('/ajax/com/Nephthys/pages/getPageRequestsSeperatedByPage', {
                    params: {
                        sortOrder: sortOrder,
                        fromDate:  fromDate,
                        toDate:    toDate
                    }
                });
            },
            getPageRequestsSeperatedByLink: function(sortOrder, fromDate, toDate, pageId) {
                return $http.get('/ajax/com/Nephthys/pages/getPageRequestsSeperatedByLink', {
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
    .controller('statisticsController', ["$rootScope", "$scope", "$q", "statisticsService", function ($rootScope, $scope, $q, service) {
        var actualView = "perDay", // perYear | perMonth | perDay | perHour
            
            renderChart = function (pageVisitStatisticsData) {
                $scope.chart.labels = pageVisitStatisticsData.labels;
                $scope.chart.data   = pageVisitStatisticsData.data;
                if(pageVisitStatisticsData.series) {
                    $scope.chart.series = pageVisitStatisticsData.series;
                }
            },
            today = function () {
                var now = new Date();
                
                return new Date(now.getFullYear(), now.getMonth(), now.getDate());
            },
            setDefaultChartOptions = function () {
                switch($scope.chart.type) {
                    case "horizontalBar": {
                        $scope.chart.options = {
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
                    case "line": {
                        $scope.chart.options = {
                            fixedHeight: true,
                            height: 450,
                            legend: {
                                display: true
                            },
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
            };
        
        $scope.refresh = function () {
            var dateStringOptions = {
                month: "2-digit",
                day:   "2-digit",
                year:  "numeric"
            };
            
            $scope.chart.labels = [];
            $scope.chart.data   = [];
            
            var method = null;
            switch($scope.requestType) {
                case "total": {
                    method = service.getPageRequests;
                    break;
                }
                case "perPage": {
                    method = service.getPageRequestsSeperatedByPage;
                    break;
                }
                case "splitPerPage": {
                    method = service.getPageRequestsSeperatedByLink;
                    break;
                }
            }
            
            if(method) {
                method($scope.sortOrder,
                       $scope.selectedDate.fromDate.toLocaleDateString('de-DE', dateStringOptions),
                       $scope.selectedDate.toDate.toLocaleDateString('de-DE', dateStringOptions),
                       $scope.pageId)
                    .then(function(res) {
                        actualView = res.actualView;
                        
                        return res;
                    })
                    .then(renderChart);
            }
        };
        
        $scope.handleClick = function (object, event) {
            if(object.length === 0) {
                return;
            }
            
            var getClickedDate = function() {
                return object[0]._chart.config.data.labels[object[0]._index];
            }
            
            switch(actualView) {
                case "perYear": {
                    $scope.selectedDate.fromDate = new Date(getClickedDate(), 0, 1);
                    $scope.selectedDate.toDate   = new Date(getClickedDate() + 1, 0, 0);
                    
                    if($scope.selectedDate.toDate > today()) {
                        $scope.selectedDate.toDate = today();
                    }
                    
                    break;
                }
                case "perMonth": {
                    var monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
                    
                    var month = monthNames.indexOf(getClickedDate());
                    
                    if(month !== -1) {
                        $scope.selectedDate.fromDate = new Date($scope.selectedDate.fromDate.getFullYear(), month, 1);
                        $scope.selectedDate.toDate   = new Date($scope.selectedDate.fromDate.getFullYear(), month, 1);
                        $scope.selectedDate.toDate.setMonth($scope.selectedDate.toDate.getMonth() + 1);
                        $scope.selectedDate.toDate.setDate(0);
                    }
                    else {
                        console.warn("Could not find month!");
                        return;
                    }
                    
                    break;
                }
                case "perDay": {
                    var d = getClickedDate().split(".");
                    
                    $scope.selectedDate.fromDate = new Date(d[2], d[1] - 1, d[0]);
                    $scope.selectedDate.toDate   = new Date(d[2], d[1] - 1, d[0]);
                    
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
        
        $scope.chart = {
            series: ["Seitenaufrufe"]
        };
        
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
            setDefaultChartOptions();
        }
        else {
            $scope.chart.options = $scope.chartOptions;
        }
        
        $scope.selectedDate = {};
        
        if(! $scope.fromDate) {
            var now = new Date();
            $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        }
        else {
            if($scope.fromDate instanceof Date) {
                $scope.selectedDate.fromDate = $scope.fromDate;
            }
            else {
                console.error("from date is not a date!");
            }
        }
        if(! $scope.toDate) {
            $scope.selectedDate.toDate = new Date();
            $scope.selectedDate.toDate.setMonth($scope.selectedDate.fromDate.getMonth() + 1);
            $scope.selectedDate.toDate.setDate(0);
        }
        else {
            if($scope.toDate instanceof Date) {
                $scope.selectedDate.toDate = $scope.toDate;
            }
            else {
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
        
        if(! $scope.requestType) {
            $scope.requestType = "total";
        }
        
        $scope.$watchGroup(["chartOptions", "chartType", "requestType"], function(newValues, oldValues) {
            if(newValues[1] && newValues[1] !== oldValues[1]) {
                $scope.chart.type = newValues[1];
            }
            
            if(newValues[0] && newValues[0] !== oldValues[0]) {
                $scope.chart.options = newValues[0];
            }
            else {
                if(! newValues[0]) {
                    setDefaultChartOptions();
                }
            }
            
            if(newValues[2] && newValues[2] !== oldValues[2]) {
                $scope.requestType = newValues[2];
            }
            
            $scope.refresh();
        });
        
        var unregister = $rootScope.$on('nephthys-date-picker-date-changed', function(evt, data) {
            $scope.selectedDate.fromDate = data.fromDate;
            $scope.selectedDate.toDate   = data.toDate;
            
            $scope.refresh();
        });
        
        $scope.$on('$destroy', function() {
            unregister();
        });
    }])
    .directive("nephthysPageStatistics", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "statisticsController",
            scope: {
                pageId: "=?",
                fromDate: "=?",
                toDate: "=?",
                chartType: "=?",
                chartOptions: "=?",
                sortOrder: "@",
                headline: "@",
                requestType: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/pages/directives/statistics/statistics.html"
        };
    });