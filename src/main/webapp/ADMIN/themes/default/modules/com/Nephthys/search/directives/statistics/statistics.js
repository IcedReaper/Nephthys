angular.module("com.nephthys.search.statistics", ["chart.js",
                                                "ui.bootstrap",
                                                "com.nephthys.global.datePicker"])
    .service("comNephthysSearchStatisticsService", function($http) {
        return {
            getSearchStatistics: function(sortOrder, fromDate, toDate, total) {
                return $http.get('/ajax/com/Nephthys/search/getSearchStatistics', {
                    params: {
                        sortOrder: sortOrder,
                        fromDate:  fromDate.toAjaxFormat(),
                        toDate:    toDate.toAjaxFormat(),
                        total:     total
                    }
                });
            }
        };
    })
    .controller('comNephthysSearchStatisticsController', ["$rootScope", "$scope", "$q", "comNephthysSearchStatisticsService", function ($rootScope, $scope, $q, service) {
        var actualView = "perDay", // perYear | perMonth | perDay | perHour
            
            renderChart = function (searchChartData) {
                $scope.chart.labels = searchChartData.labels;
                $scope.chart.data   = searchChartData.data;
                if(searchChartData.series) {
                    $scope.chart.series = searchChartData.series;
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
                            tooltips: {
                                mode: 'label'
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
            if($scope.selectedDate.fromDate && $scope.selectedDate.toDate) {
                $scope.chart.labels = [];
                $scope.chart.data   = [];
                
                service.getSearchStatistics($scope.sortOrder,
                                           $scope.selectedDate.fromDate,
                                           $scope.selectedDate.toDate,
                                           $scope.total)
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
            series: ["Suchanfrgen"]
        };
        
        // init dates
        if($scope.total === undefined) {
            $scope.total = true;
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
        
        if($scope.showDatePicker === undefined) {
            $scope.showDatePicker = true;
        }
        if($scope.showRefreshButton === undefined) {
            $scope.showRefreshButton = true;
        }
        
        if($scope.showDatePicker) {
            if(! $scope.selectedDate.fromDate) {
                var now = new Date();
                $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
            }
            if(! $scope.selectedDate.toDate) {
                $scope.selectedDate.toDate = new Date();
                $scope.selectedDate.toDate.setMonth($scope.selectedDate.fromDate.getMonth() + 1);
                $scope.selectedDate.toDate.setDate(0);
            }
        }
        
        $scope.$watchGroup(["chartOptions", "chartType", "requestType", "total"], function(newValues, oldValues) {
            var changed = false;
            if(newValues[1] && newValues[1] !== oldValues[1]) {
                $scope.chart.type = newValues[1];
                changed = true;
            }
            
            if(newValues[0] && newValues[0] !== oldValues[0]) {
                $scope.chart.options = newValues[0];
                changed = true;
            }
            else {
                if(! newValues[0] && oldValues[0]) {
                    setDefaultChartOptions();
                    changed = true;
                }
            }
            
            if(newValues[2] && newValues[2] !== oldValues[2]) {
                changed = true;
            }
            
            if(newValues[3] && newValues[3] !== oldValues[3]) {
                changed = true;
            }
            
            if(changed) {
                $scope.refresh();
            }
        });
        
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
            if($scope.selectedDate.fromDate !== data.fromDate || $scope.selectedDate.toDate !== data.toDate) {
                $scope.selectedDate.fromDate = data.fromDate;
                $scope.selectedDate.toDate   = data.toDate;
            }
        });
        var refreshEvent = $rootScope.$on('nephthys-statistics-refresh', $scope.refresh);
        
        $scope.$on('$destroy', function() {
            dateChangedEvent();
            refreshEvent();
        });
        
        $scope.refresh();
    }])
    .directive("nephthysSearchStatistics", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "comNephthysSearchStatisticsController",
            scope: {
                total: "=?",
                chartType: "=?",
                chartOptions: "=?",
                sortOrder: "@",
                headline: "@",
                showDatePicker: "=?",
                showRefreshButton: "=?",
                selectedDate: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/search/directives/statistics/statistics.html"
        };
    });