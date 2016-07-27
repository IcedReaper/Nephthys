angular.module("com.Nephthys.userManager.tasklist", ["com.nephthys.global.userInfo"])
    .service("tasklistService", function($http) {
        return {
            getUserInTasklist: function () {
                return $http.get("/ajax/com/Nephthys/userManager/getUserInTasklist");
            },
            
            pushToStatus: function (userId, statusId) {
                return $http.post('/ajax/com/Nephthys/userManager/pushToStatus', {
                    userId:   userId,
                    statusId: statusId
                });
            }
        };
    })
    .controller("tasklistController", ["$scope", "tasklistService", function ($scope, tasklistService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            tasklistService
                .getUserInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                })
        };
        
        $scope.pushToStatus = function (userId, newStatusId) {
            if(userId && newStatusId) {
                tasklistService
                    .pushToStatus(userId, newStatusId)
                    .then($scope.load);
            }
        };
        
        $scope.statusButtonClass = function (actualOnline, nextOnline) {
            if(! actualOnline && nextOnline) {
                return "btn-success";
            }
            if(actualOnline && ! nextOnline) {
                return "btn-danger";
            }
            if(! actualOnline && ! nextOnline) {
                return "btn-primary";
            }
            if(actualOnline && nextOnline) {
                return "btn-secondary";
            }
            
            return "btn-warning";
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
    .directive("nephthysUsermanagerTasklist", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "tasklistController",
            scope: {
                tableClass: "@",
                class: "@",
                showActions: "=?",
                showPageButton: "=?",
                combineNextStatusButton: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/userManager/directives/tasklist/tasklist.html"
        };
    });