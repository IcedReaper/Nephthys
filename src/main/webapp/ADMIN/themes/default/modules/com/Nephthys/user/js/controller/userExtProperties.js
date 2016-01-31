nephthysAdminApp
    .controller('userExtPropertiesCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "userService", function ($scope, $rootScope, $routeParams, $q, userService) {
        var userId = null;
        
        $scope.load = function () {
            if(userId !== null) {
                $q.all([
                    userService.getExtProperties($routeParams.userId)
                ])
                // and merging them
                .then($q.spread(function (extProperties) {
                    $scope.extProperties = extProperties;
                }));
            }
        };
        
        $scope.save = function () {
            userService
                .saveExtProperties(userId, $scope.extProperties)
                .then($scope.load);
        };
        
        $rootScope.$on('user-loaded', function(event, userData) {
            userId = userData.userId;
            
            $scope.load();
        });
    }]);