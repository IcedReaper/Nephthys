nephthysAdminApp
    .controller('pageCtrl', ["$scope", "$q", "visitService", function ($scope, $q, visitService) {
        $scope.refresh = function () {
            $scope.chartData = {
                labels: [],
                data:   []
            };
            
            visitService
                .getVisitsForDayCount(60)
                .then(function (pageRequestData) {
                    $scope.chartData.type   = "HorizontalBar";
                    $scope.chartData.labels =  pageRequestData.labels;
                    $scope.chartData.data   = [pageRequestData.data];
                });
        };
        
        $scope.refresh();
        
        $scope.chartData.options = {
            
        };
        
        $scope.handleClick = function(object, event) {
            console.log(object, event);
        }
    }]);