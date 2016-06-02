nephthysAdminApp
    .controller('pagesListCtrl', ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        var init = function () {
            pagesService
                .getStatus()
                .then(function (pageStatus) {
                    $scope.pageStatus = pageStatus;
                })
                .then($scope.load());
        };
        
        $scope.pushToStatus = function (pageId, pageVersionId, newPageStatusId) {
            if(pageId && pageVersionId && newPageStatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newPageStatusId)
                    .then($scope.load());
            }
        };
        
        $scope.deletePage = function (pageId) {
            pagesService
                .delete(pageId)
                .then($scope.load());
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
            pageStatusName: '!!'
        };
        init();
    }]);