(function(angular) {
    var settingsCtrl = angular.module('settingsCtrl', ["blogSettingsService"]);
    
    settingsCtrl.controller('settingsCtrl', function ($scope, settingsService) {
        $scope.load = function () {
            settingsService
                .get()
                .then(function (settings) {
                    $scope.settings = settings.data;
                });
        };
        
        $scope.save = function() {
            settingsService
                .save($scope.settings);
        }
        
        $scope.settings = {};
        $scope.load();
    });
}(window.angular));