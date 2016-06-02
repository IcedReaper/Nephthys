nephthysAdminApp
    .controller('pagesListCtrl', ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        var init = function () {
            pagesService
                .getStatus()
                .then(function (pageStatus) {
                    $scope.pageStatus = pageStatus;
                })
                .then($scope.refresh());
        };
        
        $scope.pushToStatus = function (pageId, pageVersionId, newPageStatusId) {
            console.log(pageId, pageVersionId, newPageStatusId);
            if(pageId && pageVersionId && newPageStatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newPageStatusId)
                    .then($scope.refresh());
            }
        };
        
        $scope.refresh = function() {
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