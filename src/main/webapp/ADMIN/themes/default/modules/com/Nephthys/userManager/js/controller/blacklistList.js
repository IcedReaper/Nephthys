nephthysAdminApp
    .controller("blacklistListCtrl", ["$scope", "userService", function($scope, userService) {
        $scope.reload = function () {
            userService
                .getBlacklist()
                .then(function (blacklist) {
                    $scope.blacklist = blacklist;
                });
        };
        
        $scope.delete = function (blacklistId) {
            userService
                .deleteBlacklistEntry(blacklistId)
                .then($scope.reload);
        };
        
        $scope.blacklist = [];
        $scope.reload();
    }]);