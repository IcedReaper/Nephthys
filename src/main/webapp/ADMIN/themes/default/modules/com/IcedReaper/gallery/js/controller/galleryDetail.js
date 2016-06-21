nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$routeParams", "$q", "galleryService", function ($scope, $routeParams, $q, galleryService) {
        var activePage = "detail";
        // load
        $scope.load = function() {
            return galleryService
                       .getDetails($routeParams.galleryId)
                       .then(function (galleryDetails) {
                           $scope.gallery = galleryDetails;
                       });
        };
        
        $scope.save = function () {
            galleryService
                .save($scope.gallery)
                .then(function (result) {
                    $scope.gallery = result;
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
        
        $scope.initialized = false;
    }]);