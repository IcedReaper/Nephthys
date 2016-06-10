nephthysAdminApp
    .controller("sitemapCtrl", ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        $scope.refresh = function () {
            $q.all([
                pagesService.getSitemap(),
                pagesService.getStatus()
            ])
            .then($q.spread(function (sitemap, status) {
                $scope.status    = status;
                $scope.sitemap = sitemap;
                
                $scope.selectedIndex = ($scope.sitemap.length - 1).toString()
            }));
        };
        
        $scope.save = function () {
            if($scope.sitemap[$scope.selectedIndex].pagesAreEditable) {
                pagesService
                    .saveSitemap($scope.sitemap[$scope.selectedIndex])
                    .then(function(sitemapId) {
                        if($scope.sitemap[$scope.selectedIndex].sitemapId === null) {
                            $scope.sitemap[$scope.selectedIndex].sitemapId = sitemapId;
                        }
                    });
            }
        };
        
        $scope.pushToStatus = function (newStatusId) {
            pagesService
                .pushSitemapToStatus($scope.sitemap[$scope.selectedIndex].sitemapId, newStatusId)
                .then(function () {
                    return pagesService.getSitemap()
                })
                .then(function(sitemap) {
                    $scope.sitemap = sitemap;
                });
        };
        
        $scope.addVersion = function () {
            pagesService
                .addSitemapVersion()
                .then(function (sitemap) {
                    $scope.sitemap = sitemap.sitemap;
                    $scope.selectedIndex = (sitemap.newVersion - 1).toString();
                });
        };
        
        $scope.refresh();
        
        $scope.selectedIndex = "0";
    }]);