nephthysAdminApp
    .controller("hierarchyCtrl", ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        $scope.refresh = function () {
            $q.all([
                pagesService.getHierarchy(),
                pagesService.getStatus()
            ])
            .then($q.spread(function (hierarchy, pageStatus) {
                $scope.pageStatus = pageStatus;
                $scope.hierarchy  = hierarchy;
            }));
        };
        
        $scope.save = function () {
            if($scope.hierarchy.versions[$scope.selectedVersion].editable) {
                pagesService
                    .saveHierarchy($scope.selectedVersion, $scope.hierarchy.versions[$scope.selectedVersion])
                    .then(function(selectedVersion) {
                        $scope.selectedVersion = selectedVersion;
                        
                        return pagesService.getHierarchy();
                    })
                    .then(function (hierarchy) {
                        $scope.hierarchy = hierarchy;
                    })
            }
        };
        
        $scope.pushToStatus = function (newPageStatusId) {
            
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