nephthysAdminApp
    .controller("sitemapCtrl", ["$scope", "$routeParams", "$q", "pagesService", function ($scope, $routeParams, $q, pagesService) {
        $scope.refresh = function () {
            $q.all([
                pagesService.getSitemap(),
                pagesService.getStatus()
            ])
            .then($q.spread(function (sitemap, status) {
                $scope.status  = status;
                $scope.sitemap = sitemap;
                
                if($routeParams.sitemapId) {
                    for(var i = 0; i < $scope.sitemap.length; ++i) {
                        if($scope.sitemap[i].sitemapId == $routeParams.sitemapId) {
                            $scope.selectedIndex = i.toString();
                            break;
                        }
                    }
                }
                else {
                    $scope.selectedIndex = ($scope.sitemap.length - 1).toString();
                }
            }));
        };
        
        $scope.save = function () {
            if($scope.status[ $scope.sitemap[$scope.selectedIndex].statusId ].editable) {
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
        
        $scope.refresh();
        
        $scope.selectedIndex = "0";
    }]);