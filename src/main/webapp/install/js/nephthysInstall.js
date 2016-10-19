angular.module("nephthysInstallApp", ["ngRoute"])
    .config(["$routeProvider",
        function ($routeProvider) {
            $routeProvider
                .when("/1", {
                    templateUrl: "/install/partials/step_1.html"
                })
                .when("/2", {
                    templateUrl: "/install/partials/step_2.html",
                    controller:  "nephthysInstallCtrl"
                })
                .when("/3", {
                    templateUrl: "/install/partials/step_3.html",
                    controller:  "nephthysInstallCtrl"
                })
                .when("/4", {
                    templateUrl: "/install/partials/step_4.html",
                    controller:  "nephthysInstallCtrl"
                })
                .when("/5", {
                    templateUrl: "/install/partials/step_5.html",
                    controller:  "nephthysInstallCtrl"
                })
                .otherwise({
                    redirectTo: "/1"
                });
        }
    ])
    .service("nephthysInstallService", function ($http) {
        return {
            setupLuceeAdminAccess: function (data) {
                return $http.post("/install/ajax/step_2.cfc?method=setupLuceeAdminAccess&returnFormat=json", {
                    formData: data
                });
            },
            
            setupAdminDatasource: function (data) {
                return $http.post("/install/ajax/step_2.cfc?method=setupAdminDatasource&returnFormat=json", {
                    formData: data
                });
            },
            
            setupWwwDatasource: function (data) {
                return $http.post("/install/ajax/step_2.cfc?method=setupWwwDatasource&returnFormat=json", {
                    formData: data
                });
            }
        }
    })
    .controller("nephthysInstallCtrl", ["$scope", "$location", "nephthysInstallService", function($scope, $location, nephthysInstallService) {
        $scope.wizardSteps  = ["Schritt 1", "Schritt 2", "Schritt 3", "Schritt 4", "Schritt 5"];
        $scope.stepFormData = [
            {},
            {
                host: "localhost",
                port: 5432,
                database: "nephthys",
                adminUsername: "",
                adminPassword: "",
                userUsername: "",
                userPassword: "",
                luceeAdminPassword: ""
            }];
        $scope.processing   = false;
        $scope.actualStep   = parseInt($location.url().substring(1,2), 10);
        $scope.actualTasks  = [];
        
        var stepTasks = [
            function () { // step 1
                return true;
            },
            
            function () { // step 2
                if($scope.stepFormData[1].luceeAdminPassword.length < 6) {
                    return false;
                }
                
                $scope.processing = true;
                $scope.actualTasks = [
                    {
                        description: "Initialisierung des Zugangs zur administrativen Oberfläche von Lucee",
                        status:      0
                    },
                    {
                        description: "Initialisierung der administrativen Datenbankverbindung",
                        status:      0
                    },
                    {
                        description: "Initialisierung der lese Datenbankverbindung",
                        status:      0
                    }
                ];
                $scope.actualView  = "/install/partials/tasks.html";
                
                $scope.actualTasks[0].status = 2;
                
                nephthysInstallService
                    .setupLuceeAdminAccess($scope.stepFormData[1])
                    .then(function (result) {
                        if(result === true) {
                            $scope.actualTasks[0].status = 1;
                        }
                        else {
                            $scope.actualTasks[0].status = -1;
                        }
                        
                        $scope.actualTasks[1].status = 2;
                        return nephthysInstallService.setupAdminDatasource($scope.stepFormData[1]);
                    })
                    .then(function (result) {
                        if(result === true) {
                            $scope.actualTasks[1].status = 1;
                        }
                        else {
                            $scope.actualTasks[1].status = -1;
                        }
                        
                        $scope.actualTasks[2].status = 2;
                        return nephthysInstallService.setupWwwDatasource($scope.stepFormData[1]);
                    })
                    .then(function (result) {
                        if(result === true) {
                            $scope.actualTasks[2].status = 1;
                        }
                        else {
                            $scope.actualTasks[2].status = -1;
                        }
                    })
                    .then(function () {
                        $scope.actualStep = 3;
                        $location.url("/3");
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
            stepTasks[$scope.actualStep - 1]();
        };
    }])
    .config(["$httpProvider", function($httpProvider) {
        var activeAjaxCalls = 0;
        $httpProvider.defaults.headers.post = {"x-framework": "angularJs"};
        
        $httpProvider.interceptors.push(function ($rootScope, $q, $timeout) {
            var isServiceCall = function (config) {
                return ! (config.url.match(/^\/install\/partials/) || config.url.match(/^[^\/]/));
            }
            
            return {
                request: function(config) {
                    return config;
                },
                
                response: function (response) {
                    if(! isServiceCall(response.config)) {
                        return response;
                    }
                    else {
                        return response.data;
                    }
                },
                
                responseError: function (rejection) {
                    if(isServiceCall(rejection.config)) {
                        return $q.reject({});
                    }
                    else {
                        return $q.reject(rejection);
                    }
                }
            };
        });
    }]);