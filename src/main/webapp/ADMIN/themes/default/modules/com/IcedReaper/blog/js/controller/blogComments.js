nephthysAdminApp
    .controller('blogCommentsCtrl', ["$scope", "$routeParams", "$q", "blogService", function ($scope, $routeParams, $q, blogService) {
        $scope.load = function () {
            $scope.comments = [];
            
            blogService
                .loadComments($routeParams.blogpostId)
                .then(function (result) {
                    $scope.comments = result;
                });
        };
        
        $scope.publish = function (comment, index) {
            blogService
                .publishComment($routeParams.blogpostId, comment.commentId)
                .then(function() {
                    $scope.comments[index].published = true;
                });
        };
        
        $scope.delete = function (comment, index) {
            $scope.comments.splice(index, 1);
            
            blogService.deleteComment($routeParams.blogpostId, comment.commentId);
        };
    }]);