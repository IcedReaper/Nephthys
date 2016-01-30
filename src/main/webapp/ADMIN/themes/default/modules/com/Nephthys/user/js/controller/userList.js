nephthysAdminApp
    .controller('userListCtrl', ["$scope", "userService", function ($scope, userService) {
        $scope.activate = function (userId) {
            userService
                .activate(userId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (userId) {
            userService
                .deactivate(userId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (userId) {
            userService
                .delete(userId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            userService
                .getList()
                .then(function (userList) {
                    $scope.users = userList.data;
                });
        };
        
        $scope.users = [];
        $scope.search = {
            active: ""
        };
        $scope.refresh();
    }]);