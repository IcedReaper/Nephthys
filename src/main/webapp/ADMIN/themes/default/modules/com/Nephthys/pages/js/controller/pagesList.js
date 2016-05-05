nephthysAdminApp
    .controller('pagesListCtrl', ["$scope", "pagesService", function ($scope, pagesService) {
        $scope.activate = function (pageId) {
            pagesService
                .activate(pageId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (pageId) {
            pagesService
                .deactivate(pageId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (pageId) {
            pagesService
                .delete(pageId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function() {
            pagesService
                .getList()
                .then(function (pagesList) {
                    $scope.pages = pagesList;
                });
        }
        
        $scope.pages = [];
        $scope.search = {
            active: ''
        };
        $scope.refresh();
    }]);