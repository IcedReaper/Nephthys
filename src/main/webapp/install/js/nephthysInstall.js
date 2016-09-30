angular.module("nephthysInstallApp", [])
    .service("nephthysInstallService", function ($http) {
        return {
            installAdminDatasource: function () {
                // TODO: make ajax call | sleep 1500 to test stuff
            },
            
            installWwwDatasource: function () {
                
            }
        }
    })
    .controller("nephthysInstallCtrl", ["$scope", "nephthysInstallService", function($scope, service) {
        $scope.actualStep  = 1;
        $scope.wizardSteps = ["Schritt 1", "Schritt 2", "Schritt 3", "Schritt 4", "Schritt 5"];
        $scope.actualView  = "/install/partials/step_1.html";
        
        $scope.actualTasks = [];
        
        var stepTasks = [
            function () { // step 1
                return true;
            },
            
            function () { // step 2
                $scope.actualTasks = [
                    {
                        description: "Initialisierung der administrativen Datenbankverbindung",
                        status:      null
                    },
                    {
                        description: "Initialisierung der lese Datenbankverbindung",
                        status:      null
                    }
                ];
                $scope.actualView  = "/install/partials/tasks.html";
                
                return
                    nephthysInstallService
                        .installAdminDatasource()
                        .then(function (result) {
                            $scope.actualTasks[0].status = result;
                        })
                        .installWwwDatasource()
                        .then(function (result) {
                            $scope.actualTasks[1].status = result;
                        })
                        .then(function () {
                            return true;
                        });
            },
            
            function () { // step 3
                
            },
            
            function () { // step 4
                
            },
            
            function () { // step 5
                
            }
        ];
        
        
        
        $scope.proceed = function () {
            if(stepTasks[$scope.actualStep - 1]()) {
                $scope.actualStep++;
                $scope.actualView  = "/install/partials/step_" + $scope.actualStep + ".html";
                $scope.actualTasks = []
            }
        };
    }]);