(function(angular) {
    var blogListCtrl = angular.module('blogListCtrl', ["blogAdminService"]);
    
    blogListCtrl.controller('blogListCtrl', function ($scope, blogService) {
        $scope.activate = function (blogId) {
            blogService
                .activate(blogId)
                .then($scope.refresh);
        };
        $scope.deactivate = function (blogId) {
            blogService
                .deactivate(blogId)
                .then($scope.refresh);
        };
        
        $scope.delete = function (blogId) {
            blogService
                .delete(blogId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            blogService
                .getList()
                .then(function (blogposts) {
                    $scope.blogposts = blogposts.data;
                });
        };
        
        $scope.blogposts = [];
        $scope.search = {
            active: "", 
            filterCategory: "",
            creatorUserId: ""
        };
        $scope.refresh();
    });
}(window.angular));