nephthysAdminApp
    .controller('pagesStatisticsCtrl', ["$scope", "$routeParams", "pagesService", function ($scope, $routeParams, pagesService) {
        $scope.refresh = function () {
            pagesService
                .loadStatistics($routeParams.pageId)
                .then(function (result) {
                    $scope.chart = {
                        labels: result.chart.labels,
                        data:   [result.chart.data]
                    };
                    
                    $scope.chartWithParameter = {
                        labels: result.chartWithParameter.labels,
                        series: result.chartWithParameter.series,
                        data:   result.chartWithParameter.data
                    };
                    
                    $scope.useDynamicSuffixes = result.useDynamicSuffixes;
                });
        };
        
        $scope.refresh();
    }]);