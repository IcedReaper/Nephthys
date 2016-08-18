angular.module("com.IcedReaper.gallery.tasklist", ["com.Nephthys.global.userInfo"])
    .service("comIcedReaperGalleryTasklistService", function($http) {
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
    .controller("comIcedReaperGalleryTasklistController", ["$rootScope", "$scope", "comIcedReaperGalleryTasklistService", function ($rootScope, $scope, tasklistService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            tasklistService
                .getGalleriesInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                    
                    $rootScope.$broadcast("tasklist-count-update", {
                        module:    "com.IcedReaper.gallery",
                        taskcount: $scope.tasklist.sumOfSubArrayLength('galleries')
                    });
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
        if($scope.showNoWorkMessage === undefined) {
            $scope.showNoWorkMessage = true;
        }
        
        $scope.tasklist = {};
        $scope.load();
    }])
    .directive("icedreaperGalleryTasklist", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "comIcedReaperGalleryTasklistController",
            scope: {
                tableClass: "@",
                class: "@",
                showActions: "=?",
                showPageButton: "=?",
                combineNextStatusButton: "=?",
                showNoWorkMessage: "=?"
            },
            templateUrl : "/themes/default/modules/com/IcedReaper/gallery/directives/tasklist/tasklist.html"
        };
    });