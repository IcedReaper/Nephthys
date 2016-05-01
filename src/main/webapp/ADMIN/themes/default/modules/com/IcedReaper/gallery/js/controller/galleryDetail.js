nephthysAdminApp
    .controller('galleryDetailCtrl', ["$scope", "$rootScope", "$routeParams", "$q", "galleryService", function ($scope, $rootScope, $routeParams, $q, galleryService) {
        $rootScope.$$listeners['gallery-loaded'] = null; // as the different js-files will be invoken again and again the event listeners get applied multiple times, so we reset them here
            
        var activePage = "detail";
        // load
        $scope.load = function() {
            return galleryService
                       .getDetails($routeParams.galleryId)
                       .then(function (galleryDetails) {
                           $scope.gallery = galleryDetails;
                           
                           $rootScope.$emit('gallery-loaded', {galleryId: galleryDetails.galleryId});
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
        
        $rootScope.galleryId = $routeParams.galleryId;
        $scope.initialized = false;
    }]);