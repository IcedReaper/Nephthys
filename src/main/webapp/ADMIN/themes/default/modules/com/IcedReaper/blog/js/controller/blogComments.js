(function(angular) {
    var blogCommentsCtrl = angular.module('blogCommentsCtrl', ["blogAdminService"]);
    
    blogCommentsCtrl.controller('blogCommentsCtrl', function ($scope, $rootScope, $routeParams, blogService, $q) {
        var blogpostId = null;
        
        $scope.load = function () {
            blogService
                .loadComments(blogpostId)
                .then(function (result) {
                    $scope.comments = result.comments;
                });
        };
        
        $scope.publish = function (comment, index) {
            blogService
                .publishComment(comment.commentId)
                .then(function() {
                    $scope.comments[index].published = true;
                });
        };
        
        $scope.delete = function (comment, index) {
            blogService
                .deleteComment(comment.commentId)
                .then($scope.load);
        };
        
        $rootScope.$on('blog-loaded', function(event, blogData) {
            blogpostId = blogData.blogpostId;
            
            $scope.load();
        });
    });
}(window.angular));