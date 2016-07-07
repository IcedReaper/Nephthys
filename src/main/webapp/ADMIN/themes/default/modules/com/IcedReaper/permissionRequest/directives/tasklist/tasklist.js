angular.module("com.IcedReaper.permissionRequest.tasklist", ["com.nephthys.global.userInfo"])
    .service("tasklistService", function($http) {
        return {
            getRequestsInTasklist: function () {
                return $http.get("/ajax/com/IcedReaper/permissionRequest/getRequestsInTasklist");
            },
            
            approve: function (requestId) {
                return $http.post('/ajax/com/IcedReaper/permissionRequest/approve', {
                    requestId: requestId
                });
            },
            
            decline: function (requestId) {
                return $http.post('/ajax/com/IcedReaper/permissionRequest/decline', {
                    requestId: requestId
                });
            }
        };
    })
    .controller("tasklistController", ["$scope", "tasklistService", function ($scope, tasklistService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            tasklistService
                .getRequestsInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                })
        };
        
        $scope.approve = function (requestId) {
            if(requestId) {
                tasklistService
                    .approve(requestIdd)
                    .then($scope.load);
            }
        };
        
        $scope.decline = function (requestId) {
            if(requestId) {
                tasklistService
                    .decline(requestIdd)
                    .then($scope.load);
            }
        };
        
        $scope.tableClass = $scope.tableClass || "";
        $scope.class      = $scope.class || "";
        
        if($scope.showActions === undefined) {
            $scope.showActions = true;
        }
        if($scope.showDetailsButton === undefined) {
            $scope.showDetailsButton = true;
        }
        if($scope.combineNextStatusButton === undefined) {
            $scope.combineNextStatusButton = true;
        }
        
        $scope.tasklist = {};
        $scope.load();
    }])
    .directive("icedreaperPermissionrequestTasklist", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "tasklistController",
            scope: {
                tableClass: "@",
                class: "@",
                showPages: "=?",
                showSitemaps: "=?",
                showActions: "=?",
                showPageButton: "=?",
                combineNextStatusButton: "=?"
            },
            templateUrl : "/themes/default/modules/com/IcedReaper/permissionRequest/directives/tasklist/tasklist.html"
        };
    });