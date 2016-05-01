nephthysAdminApp
    .controller('themeListCtrl', ["$scope", "themeService", function ($scope, themeService) {
        $scope.activate = function (themeId) {
            themeService
                .activate(themeId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (themeId) {
            themeService
                .deactivate(themeId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (themeId) {
            themeService
                .delete(themeId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            themeService
                .getList()
                .then(function (themeList) {
                    $scope.themes = themeList;
                });
        };
        
        $scope.themes = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    }]);