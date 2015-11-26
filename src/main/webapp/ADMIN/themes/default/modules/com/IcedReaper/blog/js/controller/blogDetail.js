(function(angular) {
    var blogDetailCtrl = angular.module('blogDetailCtrl', ["blogAdminService"]);
    
    blogDetailCtrl.controller('blogDetailCtrl', function ($scope, $rootScope, $routeParams, $q, blogService) {
        var activePage = "detail";
        // load
        $scope.load = function() {
            return blogService
                       .getDetails($routeParams.blogId)
                       .then(function (blogDetails) {
                           $scope.blogpost = blogDetails.data;
                           
                           $rootScope.$emit('blog-loaded', {blogId: blogDetails.data.blogId});
                       });
        };
        
        $scope.save = function () {
            blogService
                .save($scope.blog)
                .then(function (result) {
                    $scope.blog = result.data;
                })
                .then($scope.loadPictures);
        };
        
        // tabs and paging
        $scope.showPage = function (page) {
            activePage = page;
        };
        
        $scope.tabClasses = function (page) {
            return (activePage === page ? "active" : "");
        };
        
        $scope.pageClasses = function (page) {
            return (activePage === page ? "active" : "");
        };
        
        // init
        $scope
            .load()
            .then($scope.showPage('details'));
        
        $rootScope.blogpostId = $routeParams.blogId;
        $scope.initialized = false;
    });
}(window.angular));