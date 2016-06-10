nephthysAdminApp
    .controller("tasklistCtrl", ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        $scope.loadPages = function () {
            $scope.tasklist.pages = {};
            
            pagesService
                .getPageVersionInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.pages = tasklist;
                })
        };
        $scope.loadSitemap = function () {
            $scope.tasklist.sitemap = {};
            
            pagesService
                .getHiearchyInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.sitemap = tasklist;
                })
        };
        
        $scope.pushPageToStatus = function (pageId, pageVersionId, newstatusId) {
            if(pageId && pageVersionId && newstatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newstatusId)
                    .then($scope.loadPages());
            }
        };
        
        $scope.pushSitemapToStatus = function (sitemapId, newstatusId) {
            if(sitemapId && newstatusId) {
                pagesService
                    .pushSitemapToStatus(sitemapId,
                                           newstatusId)
                    .then($scope.loadSitemap());
            }
        };
        
        $scope.tasklist = {
            pages: {},
            sitemap: {}
        };
        $scope.loadPages();
        $scope.loadSitemap();
    }]);