angular.module("com.IcedReaper.blog.tasklist", ["com.nephthys.global.userInfo"])
    .service("tasklistService", function($http) {
        return {
            getBlogpostsInTasklist: function () {
                return $http.get("/ajax/com/IcedReaper/blog/getBlogpostsInTasklist");
            },
            
            pushToStatus: function (blogpostId, statusId) {
                return $http.post('/ajax/com/IcedReaper/blog/pushToStatus', {
                    blogpostId: blogpostId,
                    statusId:  statusId
                });
            }
        };
    })
    .controller("tasklistController", ["$scope", "tasklistService", function ($scope, tasklistService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            tasklistService
                .getBlogpostsInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                })
        };
        
        $scope.pushToStatus = function (blogId, newStatusId) {
            if(blogId && newStatusId) {
                tasklistService
                    .pushToStatus(blogId,
                                  newStatusId)
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
    .directive("icedreaperBlogTasklist", function() {
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
            templateUrl : "/themes/default/modules/com/IcedReaper/blog/directives/tasklist/tasklist.html"
        };
    });