angular.module("com.IcedReaper.gallery.tasklist", ["com.nephthys.global.userInfo"])
    .service("tasklistService", function($http) {
        return {
            getGalleriesInTasklist: function () {
                return $http.get("/ajax/com/IcedReaper/gallery/getGalleriesInTasklist");
            },
            
            pushToStatus: function (galleryId, statusId) {
                return $http.post('/ajax/com/IcedReaper/gallery/pushToStatus', {
                    galleryId: galleryId,
                    statusId:  statusId
                });
            }
        };
    })
    .controller("tasklistController", ["$scope", "tasklistService", function ($scope, tasklistService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            tasklistService
                .getGalleriesInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                })
        };
        
        $scope.pushToStatus = function (galleryId, newStatusId) {
            if(galleryId && newStatusId) {
                tasklistService
                    .pushToStatus(galleryId,
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
    .directive("icedreaperGalleryTasklist", function() {
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
            templateUrl : "/themes/default/modules/com/IcedReaper/gallery/directives/tasklist/tasklist.html"
        };
    });