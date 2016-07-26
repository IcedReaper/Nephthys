nephthysAdminApp
    .controller("blacklistEntryCtrl", ["$scope", "$routeParams", "$route", "$location", "userService", function($scope, $routeParams, $route, $location, userService) {
        $scope.load = function () {
            userService
                .getBlacklistEntry($scope.blacklistId)
                .then(function (blacklist) {
                    $scope.blacklist = blacklist;
                });
        };
        
        $scope.save = function () {
            userService
                .saveBlacklistEntry($scope.blacklist)
                .then(function (newBlacklistId) {
                    if($scope.blacklistId != newBlacklistId) {
                        $route.updateParams({
                            blacklistId: newBlacklistId
                        });
                    }
                });
        };
        
        $scope.delete = function () {
            userService
                .deleteBlacklistEntry($scope.blacklistId)
                .then(function () {
                    $location.path("/blacklist/list");
                });
        };
        
        $scope.blacklist = {};
        $scope.blacklistId = $routeParams.blacklistId;
        $scope.load();
    }]);