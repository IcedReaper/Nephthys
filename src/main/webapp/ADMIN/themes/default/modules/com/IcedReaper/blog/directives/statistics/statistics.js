angular.module("com.IcedReaper.blog.statistics", ["chart.js",
                                                  "ui.bootstrap",
                                                  "com.Nephthys.global.datePicker"])
    .service("comIcedReaperBlogStatisticsService", function($http) {
        return {
            getBlogStatistics: function(sortOrder, fromDate, toDate, blogpostId) {
                return $http.get('/ajax/com/IcedReaper/blog/getBlogStatistics', {
                    params: {
                        blogpostId: blogpostId,
                        sortOrder: sortOrder,
                        fromDate:  fromDate.toAjaxFormat(),
                        toDate:    toDate.toAjaxFormat()
                    }
                });
            },
            getStatisticsSeparatedByBlog: function(sortOrder, fromDate, toDate) {
                return $http.get('/ajax/com/IcedReaper/blog/getStatisticsSeparatedByBlog', {
                    params: {
                        sortOrder: sortOrder,
                        fromDate:  fromDate.toAjaxFormat(),
                        toDate:    toDate.toAjaxFormat()
                    }
                });
            }
        };
    })
    .controller('comIcedReaperBlogStatisticsController', ["$rootScope", "$scope", "$q", "comIcedReaperBlogStatisticsService", function ($rootScope, $scope, $q, service) {
        var actualView = "perDay", // perYear | perMonth | perDay | perHour
            
            renderChart = function (blogVisitStatisticsData) {
                $scope.chart.labels = blogVisitStatisticsData.labels;
                $scope.chart.data   = blogVisitStatisticsData.data;
                if(blogVisitStatisticsData.series) {
                    $scope.chart.series = blogVisitStatisticsData.series;
                }
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
            $scope.chart.labels = [];
            $scope.chart.data   = [];
            
            var method = null;
            switch($scope.requestType) {
                case "total": {
                    method = service.getBlogStatistics;
                    break;
                }
                case "perBlog": {
                    method = service.getStatisticsSeparatedByBlog;
                    break;
                }
            }
            
            if(method) {
                method($scope.sortOrder,
                       $scope.selectedDate.fromDate,
                       $scope.selectedDate.toDate,
                       $scope.blogpostId)
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
            series: ["Aufrufe"]
        };
        
        // init dates
        if(! $scope.blogpostId) {
            $scope.blogpostId = null;
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
        
        if(! $scope.fromDate && ! $scope.selectedDate.fromDate) {
            var now = new Date();
            $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        }
        else {
            if($scope.fromDate instanceof Date) {
                $scope.selectedDate.fromDate = $scope.fromDate;
            }
            else if (! $scope.selectedDate.fromDate) {
                console.error("from date is not a date!");
            }
        }
        if(! $scope.toDate && ! $scope.selectedDate.toDate) {
            $scope.selectedDate.toDate = new Date();
            $scope.selectedDate.toDate.setMonth($scope.selectedDate.fromDate.getMonth() + 1);
            $scope.selectedDate.toDate.setDate(0);
        }
        else {
            if($scope.toDate instanceof Date) {
                $scope.selectedDate.toDate = $scope.toDate;
            }  
            else if (! $scope.selectedDate.toDate) {
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
        
        if($scope.showDatePicker === undefined) {
            $scope.showDatePicker = true;
        }
        if($scope.showRefreshButton === undefined) {
            $scope.showRefreshButton = true;
        }
        
        $scope.$watchGroup(["chartOptions", "chartType", "requestType", "blogpostId"], function(newValues, oldValues) {
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
                if(! newValues[0]) {
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
            $scope.selectedDate.fromDate = data.fromDate;
            $scope.selectedDate.toDate   = data.toDate;
        });
        var refreshEvent = $rootScope.$on('nephthys-statistics-refresh', $scope.refresh);
        
        $scope.$on('$destroy', function() {
            dateChangedEvent();
            refreshEvent();
        });
    }])
    .directive("icedreaperBlogStatistics", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "comIcedReaperBlogStatisticsController",
            scope: {
                blogpostId: "=?",
                fromDate: "=?",
                toDate: "=?",
                chartType: "=?",
                chartOptions: "=?",
                sortOrder: "@",
                headline: "@",
                requestType: "=?",
                showDatePicker: "=?",
                showRefreshButton: "=?",
                selectedDate: "=?"
            },
            templateUrl : "/themes/default/modules/com/IcedReaper/blog/directives/statistics/statistics.html"
        };
    });