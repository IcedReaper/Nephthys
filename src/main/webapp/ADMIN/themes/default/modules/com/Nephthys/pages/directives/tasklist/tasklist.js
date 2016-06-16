angular.module("com.nephthys.page.tasklist", ["nephthys.userInfo"])
    .service("tasklistService", function($http) {
        return {
            getPageVersionInTasklist: function () {
                return $http.get("/ajax/com/Nephthys/pages/getPageVersionInTasklist");
            },

            getSitemapInTasklist: function () {
                return $http.get("/ajax/com/Nephthys/pages/getSitemapInTasklist");
            },
            
            pushToStatus: function (pageId, pageVersionId, statusId) {
                return $http.post('/ajax/com/Nephthys/pages/pushToStatus', {
                    pageId:        pageId,
                    pageVersionId: pageVersionId,
                    statusId:  statusId
                });
            },
            pushSitemapToStatus: function (sitemapId, statusId) {
                return $http.post("/ajax/com/Nephthys/pages/pushSitemapToStatus", {
                    sitemapId: sitemapId,
                    statusId:    statusId
                });
            }
        };
    })
    .controller("tasklistController", ["$scope", "tasklistService", function ($scope, tasklistService) {
        $scope.loadPages = function () {
            $scope.tasklist.pages = {};
            
            tasklistService
                .getPageVersionInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.pages = tasklist;
                })
        };
        $scope.loadSitemap = function () {
            $scope.tasklist.sitemap = {};
            
            tasklistService
                .getSitemapInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.sitemap = tasklist;
                })
        };
        
        $scope.pushPageToStatus = function (pageId, pageVersionId, newstatusId) {
            if(pageId && pageVersionId && newstatusId) {
                tasklistService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newstatusId)
                    .then($scope.loadPages());
            }
        };
        
        $scope.pushSitemapToStatus = function (sitemapId, newstatusId) {
            if(sitemapId && newstatusId) {
                tasklistService
                    .pushSitemapToStatus(sitemapId,
                                           newstatusId)
                    .then($scope.loadSitemap());
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
        
        if($scope.showPages) {
            $scope._showPages = $scope.showPages === "true";
        }
        else {
            $scope._showPages = true;
        }
        if($scope.showSitemaps) {
            $scope._showSitemaps = $scope.showSitemaps === "true";
        }
        else {
            $scope._showSitemaps = true;
        }
        
        if($scope.showActions) {
            $scope._showActions = $scope.showActions === "true";
        }
        else {
            $scope._showActions = true;
        }
        if($scope.showPageButton) {
            $scope._showPageButton = $scope.showPageButton === "true";
        }
        else {
            $scope._showPageButton = true;
        }
        if($scope.combineNextStatusButton) {
            $scope._combineNextStatusButton = $scope.combineNextStatusButton === "true";
        }
        else {
            $scope._combineNextStatusButton = true;
        }
        
        $scope.tasklist = {
            pages: {},
            sitemap: {}
        };
        $scope.loadPages();
        $scope.loadSitemap();
    }])
    .directive("nephthysPageTasklist", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "tasklistController",
            scope: {
                tableClass: "@",
                class: "@",
                showPages: "@",
                showSitemaps: "@",
                showActions: "@",
                showPageButton: "@",
                combineNextStatusButton: "@"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/pages/directives/tasklist/tasklist.html"
        };
    });