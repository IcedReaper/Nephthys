nephthysAdminApp
    .controller('serverSettingsDetailCtrl', ["$scope", "$q", "serverSettingsService", function ($scope, $q, serverSettingsService) {
        $scope.load = function () {
            $q.all([
                serverSettingsService.get(),
                serverSettingsService.getModuleList()
            ])
            .then($q.spread(function (settings, moduleList) {
                $scope.settings = settings;
                $scope.module   = moduleList;
            }));
        };
        
        $scope.save = function() {
            serverSettingsService
                .save($scope.settings);
        }
        
        $scope.settings = [];
        $scope.module = {};
        $scope.filter = {
            moduleName: "!!"
        };
        $scope.load();
    }]);