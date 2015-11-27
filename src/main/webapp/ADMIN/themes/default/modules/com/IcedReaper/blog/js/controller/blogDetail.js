(function(angular) {
    var blogDetailCtrl = angular.module('blogDetailCtrl', ["blogAdminService"]);
    
    blogDetailCtrl.controller('blogDetailCtrl', function ($scope, $rootScope, $routeParams, $q, blogService) {
        var activePage = "detail";
        // load
        $scope.load = function() {
            return blogService
                       .getDetails($routeParams.blogpostId)
                       .then(function (blogDetails) {
                           $scope.blogpost = blogDetails.data;
                           
                           $rootScope.$emit('blog-loaded', {blogpostId: blogDetails.data.blogpostId});
                       });
        };
        
        $scope.save = function () {
            blogService
                .save($scope.blogpost)
                .then(function (result) {
                    $scope.blogpost = result.data;
                });
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
        
        $rootScope.blogpostId = $routeParams.blogpostId;
        $scope.initialized = false;
    });
}(window.angular));