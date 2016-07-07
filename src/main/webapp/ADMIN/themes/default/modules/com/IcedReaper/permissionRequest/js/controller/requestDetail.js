nephthysAdminApp
    .controller("requestDetailCtrl", ["$scope", "$routeParams", "requestService", function($scope, $routeParams, service) {
        $scope.approve = function () {
            service
                .approve($routeParams.requestId,
                         $scope.response.comment)
                .then(function () {
                    $scope.request.status = 1;
                    $scope.request.comment = $scope.response.comment;
                });
        };
        
        $scope.decline = function (requestId) {
            service
                .decline($routeParams.requestId,
                         $scope.response.comment)
                .then(function () {
                    $scope.request.status = -1;
                    $scope.request.comment = $scope.response.comment;
                });
        };
        
        $scope.request = {};
        $scope.response = {};
        
        service
            .getRequest($routeParams.requestId)
            .then(function (request) {
                $scope.request = request;
            })
    }]);