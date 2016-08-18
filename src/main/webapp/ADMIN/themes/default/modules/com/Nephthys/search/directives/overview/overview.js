angular.module("com.Nephthys.search.overview", ["ui.bootstrap",
                                                "com.Nephthys.global.datePicker"])
    .service("comNephthysSearchOverviewService", function($http) {
        return {
            getSearchOverview: function(fromDate, toDate) {
                return $http.get('/ajax/com/Nephthys/search/getSearchOverview', {
                    params: {
                        fromDate:  fromDate.toAjaxFormat(),
                        toDate:    toDate.toAjaxFormat()
                    }
                });
            }
        };
    })
    .controller('comNephthysSearchOverviewController', ["$rootScope", "$scope", "$q", "comNephthysSearchOverviewService", function ($rootScope, $scope, $q, service) {
        $scope.refresh = function () {
            if($scope.selectedDate.fromDate && $scope.selectedDate.toDate) {
                service.getSearchOverview($scope.selectedDate.fromDate,
                                          $scope.selectedDate.toDate)
                    .then(function(searchStatements) {
                        $scope.searchStatements = searchStatements;
                        $scope.pagination.totalPages = Math.ceil(searchStatements.length / $scope.pagination.entriesPerPage);
                        $scope.pagination.currentPage = 1;
                    });
            }
        };
        
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
        
        $scope.pagination = {};
        $scope.pagination.totalPages = 1;
        $scope.pagination.currentPage = 1;
        $scope.pagination.entriesPerPage = 10;
        $scope.searchStatements = [];
        
        $scope.refresh();
    }])
    .directive("nephthysSearchOverview", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "comNephthysSearchOverviewController",
            scope: {
                total: "=?",
                headline: "@",
                showDatePicker: "=?",
                showRefreshButton: "=?",
                selectedDate: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/search/directives/overview/overview.html"
        };
    })
    .filter('startFrom', function() {
        return function(input, start) {
            start = +start; //parse to int
            return input.slice(start);
        }
    });