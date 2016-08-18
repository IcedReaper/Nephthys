angular.module("com.Nephthys.pageManager.tasklist", ["com.Nephthys.global.userInfo"])
    .service("comNephthysPageManagerTasklistService", function($http) {
        return {
            getPageVersionInTasklist: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getPageVersionInTasklist");
            },

            getSitemapInTasklist: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getSitemapInTasklist");
            },
            
            pushToStatus: function (pageId, pageVersionId, statusId) {
                return $http.post('/ajax/com/Nephthys/pageManager/pushToStatus', {
                    pageId:        pageId,
                    pageVersionId: pageVersionId,
                    statusId:  statusId
                });
            },
            pushSitemapToStatus: function (sitemapId, statusId) {
                return $http.post("/ajax/com/Nephthys/pageManager/pushSitemapToStatus", {
                    sitemapId: sitemapId,
                    statusId:    statusId
                });
            }
        };
    })
    .controller("comNephthysPageManagerTasklistController", ["$rootScope", "$scope", "comNephthysPageManagerTasklistService", function ($rootScope, $scope, tasklistService) {
        $scope.loadPages = function () {
            $scope.tasklist.pages = {};
            
            tasklistService
                .getPageVersionInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.pages = tasklist;
                    
                    $rootScope.$broadcast("tasklist-count-update", {
                        module: "com.Nephthys.pageManager",
                        subList: "pages",
                        taskcount: $scope.tasklist.pages.sumOfSubArrayLength('pages')
                    });
                })
        };
        $scope.loadSitemap = function () {
            $scope.tasklist.sitemap = {};
            
            tasklistService
                .getSitemapInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.sitemap = tasklist;
                    
                    $rootScope.$broadcast("tasklist-count-update", {
                        module:    "com.Nephthys.pageManager",
                        subList:   "sitemaps",
                        taskcount: $scope.tasklist.sitemap.sumOfSubArrayLength('sitemaps')
                    });
                })
        };
        
        $scope.pushPageToStatus = function (pageId, pageVersionId, newStatusId) {
            if(pageId && pageVersionId && newStatusId) {
                tasklistService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newStatusId)
                    .then($scope.loadPages);
            }
        };
        
        $scope.pushSitemapToStatus = function (sitemapId, newStatusId) {
            if(sitemapId && newStatusId) {
                tasklistService
                    .pushSitemapToStatus(sitemapId,
                                           newStatusId)
                    .then($scope.loadSitemap);
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
        
        if($scope.showPages === undefined) {
            $scope.showPages = true;
        }
        if($scope.showSitemaps === undefined) {
            $scope.showSitemaps = true;
        }
        if($scope.showActions === undefined) {
            $scope.showActions = true;
        }
        if($scope.showPageButton === undefined) {
            $scope.showPageButton = true;
        }
        if($scope.combineNextStatusButton === undefined) {
            $scope.combineNextStatusButton = true;
        }
        if($scope.showNoWorkMessage === undefined) {
            $scope.showNoWorkMessage = true;
        }
        
        $scope.tasklist = {
            pages: {},
            sitemap: {}
        };
        if($scope.showPages) {
            $scope.loadPages();
        }
        if($scope.showSitemaps) {
            $scope.loadSitemap();
        }
    }])
    .directive("nephthysPageTasklist", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "comNephthysPageManagerTasklistController",
            scope: {
                tableClass: "@",
                class: "@",
                showPages: "=?",
                showSitemaps: "=?",
                showActions: "=?",
                showPageButton: "=?",
                combineNextStatusButton: "=?",
                showNoWorkMessage: "=?"
            },
            templateUrl : "/themes/default/modules/com/Nephthys/pageManager/directives/tasklist/tasklist.html"
        };
    });