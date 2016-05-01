nephthysAdminApp
    .controller('serverSettingsDetailCtrl', ["$scope", "serverSettingsService", function ($scope, serverSettingsService) {
        $scope.load = function () {
            serverSettingsService
                .get()
                .then(function (settings) {
                    $scope.settings = settings;
                });
        };
        
        $scope.save = function() {
            serverSettingsService
                .save($scope.settings);
        }
        
        $scope.settings = {};
        $scope.load();
    }]);