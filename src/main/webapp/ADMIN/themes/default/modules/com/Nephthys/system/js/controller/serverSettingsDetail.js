/*(function(angular) {
    var serverSettingsDetailCtrl = angular.module('serverSettingsDetailCtrl', ["serverSettingsAdminService"]);
    
    serverSettingsDetailCtrl.controller('serverSettingsDetailCtrl', function ($scope, $q, serverSettingsService) {
        $q.all([
                serverSettingsService.getDetails(),
                serverSettingsService.getEncryptionMethods()
            ])
            // and merging them
            .then($q.spread(function (serverSettings, encryptionMethods) {
                    $scope.serverSettings   = serverSettings.data;
                    $scope.encryptionMethod = encryptionMethods.data;
                }));
        
        $scope.save = function () {
            serverSettingsService
                .save($scope.serverSettings);
        };
        
        $scope.showExtended = false;
    });
}(window.angular));*/
(function(angular) {
    var serverSettingsDetailCtrl = angular.module('serverSettingsDetailCtrl', ["serverSettingsAdminService"]);
    
    serverSettingsDetailCtrl.controller('serverSettingsDetailCtrl', function ($scope, serverSettingsService) {
        $scope.load = function () {
            serverSettingsService
                .get()
                .then(function (settings) {
                    $scope.settings = settings.data;
                });
        };
        
        $scope.save = function() {
            serverSettingsService
                .save($scope.settings);
        }
        
        $scope.settings = {};
        $scope.load();
    });
}(window.angular));