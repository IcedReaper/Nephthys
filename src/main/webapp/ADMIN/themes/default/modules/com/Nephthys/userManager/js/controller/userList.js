nephthysAdminApp
    .controller('userListCtrl', ["$scope", "userService", function ($scope, userService) {
        var init = function () {
            userService
                .getStatus()
                .then(function (status) {
                    $scope.status = status;
                })
                .then($scope.load);
        };
        
        $scope.activate = function (userId) {
            userService
                .activate(userId)
                .then($scope.load);
        };
        $scope.deactivate = function (userId) {
            userService
                .deactivate(userId)
                .then($scope.load);
        };
        
        $scope.delete = function (userId) {
            userService
                .delete(userId)
                .then($scope.load);
        }
        
        $scope.load = function () {
            userService
                .getList()
                .then(function (userList) {
                    $scope.users = userList;
                });
        };
        
        $scope.pushToStatus = function (userId, newStatusId) {
            if(userId && newStatusId) {
                userService
                    .pushToStatus(userId,
                                  newStatusId)
                    .then($scope.load);
            }
        };
        
        $scope.statusButtonClass = function (actualCanLogin, nextCanLogin) {
            if(! actualCanLogin && nextCanLogin) {
                return "btn-success";
            }
            if(actualCanLogin && ! nextCanLogin) {
                return "btn-danger";
            }
            if(! actualCanLogin && ! nextCanLogin) {
                return "btn-primary";
            }
            if(actualCanLogin && nextCanLogin) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
        $scope.users = [];
        $scope.search = {
            canLogin: ''
        };
        init();
    }]);