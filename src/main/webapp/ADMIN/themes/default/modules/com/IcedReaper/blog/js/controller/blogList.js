nephthysAdminApp
    .controller('blogListCtrl', ["$scope", "blogService", function ($scope, blogService) {
        $scope.activate = function (blogpostId) {
            blogService
                .activate(blogpostId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (blogpostId) {
            blogService
                .deactivate(blogpostId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (blogpostId) {
            blogService
                .delete(blogpostId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            blogService
                .getList()
                .then(function (blogposts) {
                    $scope.blogposts = blogposts;
                });
        };
        
        $scope.blogposts = [];
        $scope.search = {
            released: ''
        };
        $scope.refresh();
    }]);