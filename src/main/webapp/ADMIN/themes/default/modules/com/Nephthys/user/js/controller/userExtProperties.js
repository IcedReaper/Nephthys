nephthysAdminApp
    .controller('userExtPropertiesCtrl', ["$scope", "$routeParams", "$q", "userService", function ($scope, $routeParams, $q, userService) {
        $scope.load = function () {
            if($routeParams.userId !== null && $routeParams.userId !== 0) {
                $q.all([
                    userService.getExtProperties($routeParams.userId)
                ])
                .then($q.spread(function (extProperties) {
                    $scope.extProperties = extProperties;
                }));
            }
        };
        
        $scope.save = function () {
            userService.saveExtProperties($routeParams.userId, $scope.extProperties);
        };
        
        $scope.load();
    }]);