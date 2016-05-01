nephthysAdminApp
    .controller('blogCommentsCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "blogService", function ($scope, $rootScope, $routeParams, $q, blogService) {
        var blogpostId = null;
        
        $scope.load = function () {
            $scope.comments = [];
            
            blogService
                .loadComments(blogpostId)
                .then(function (result) {
                    $scope.comments = result;
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
            $scope.comments.splice(index, 1);
            
            blogService.deleteComment(comment.commentId);
        };
        
        $rootScope.$on('blog-loaded', function(event, blogData) {
            blogpostId = blogData.blogpostId;
            
            $scope.load();
        });
    }]);