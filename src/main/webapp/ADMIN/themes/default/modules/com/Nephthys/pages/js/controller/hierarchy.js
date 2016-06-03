nephthysAdminApp
    .controller("hierarchyCtrl", ["$scope", "pagesService", function ($scope, pagesService) {
        /* = */
        
        $scope.refresh = function () {
            pagesService
                .getHierarchy()
                .then(function (hierarchy) {
                    $scope.hierarchy = hierarchy;
                });
        };
        
        $scope.save = function () {
            if($scope.hierarchy.versions[$scope.selectedVersion].editable) {
                // save...
            }
        };
        
        $scope.addVersion = function () {
            pagesService
                .addHierarchyVersion()
                .then(function (hierarchy) {
                    $scope.hierarchy = hierarchy.hierarchy;
                    $scope.selectedVersion = hierarchy.newVersion.toString();
                });
        };
        
        $scope.refresh();
        
        $scope.selectedVersion = "1";
    }]);