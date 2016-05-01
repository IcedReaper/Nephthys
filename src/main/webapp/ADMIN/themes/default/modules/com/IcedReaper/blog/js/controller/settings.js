nephthysAdminApp
    .controller('settingsCtrl', ["$scope", "settingsService", function ($scope, settingsService) {
        $scope.load = function () {
            settingsService
                .get()
                .then(function (settings) {
                    $scope.settings = settings;
                });
        };
        
        $scope.save = function() {
            settingsService
                .save($scope.settings);
        }
        
        $scope.settings = {};
        $scope.load();
    }]);