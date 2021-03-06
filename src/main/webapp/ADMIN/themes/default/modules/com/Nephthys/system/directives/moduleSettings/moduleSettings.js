angular.module("com.Nephthys.system.moduleSettings", [])
    .service("settingsService", function($http) {
        return {
            get: function (moduleName) {
                return $http.get('/ajax/com/Nephthys/system/getModuleSettings', {
                    params: {
                        moduleName: moduleName
                    }
                });
            },
            
            save: function (moduleName, settings) {
                return $http.post('/ajax/com/Nephthys/system/saveModuleSettings', {
                    moduleName: moduleName,
                    settings: JSON.stringify(settings)
                });
            }
        };
    })
    .controller("nephthysSystemModuleSettingsController", ["$scope", "settingsService", function($scope, service) {
        $scope.load = function () {
            service
                .get($scope.moduleName)
                .then(function (settings) {
                    $scope.settings = settings;
                    $scope.settingCount = Object.keys(settings).length;
                });
        };
        
        $scope.save = function() {
            service.save($scope.moduleName, $scope.settings);
        };
        
        $scope.settings = {};
        $scope.settingCount = 0;
        if($scope.moduleName) {
            $scope.load();
        }
        
        $scope.$watch("moduleName", function(newValue, oldValue) {
            if(newValue != oldValue) {
                $scope.load();
            }
        });
    }])
    .directive("nephthysSytemModulesettings", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "nephthysSystemModuleSettingsController",
            scope: {
                moduleName: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/system/directives/moduleSettings/moduleSettings.html"
        };
    })