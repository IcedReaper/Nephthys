nephthysAdminApp
    .controller('pagesListCtrl', ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        var init = function () {
            pagesService
                .getStatus()
                .then(function (status) {
                    $scope.status = status;
                })
                .then($scope.load());
        };
        
        $scope.pushToStatus = function (pageId, pageVersionId, newstatusId) {
            if(pageId && pageVersionId && newstatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newstatusId)
                    .then($scope.load());
            }
        };
        
        $scope.deletePage = function (pageId) {
            pagesService
                .delete(pageId)
                .then(function () {
                    for(var i = 0; i < $scope.pages.length; ++i) {
                        if($scope.pages[i].pageId === pageId) {
                            $scope.pages.splice(i, 1);
                            break;
                        }
                    }
                });
        };
        
        $scope.load = function() {
            pagesService
                .getList()
                .then(function (pagesList) {
                    $scope.pages = pagesList;
                });
        };
        
        $scope.pages = [];
        $scope.search = {
            statusName: '!!'
        };
        init();
    }]);