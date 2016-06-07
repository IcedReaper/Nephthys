nephthysAdminApp
    .controller("hierarchyCtrl", ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        $scope.refresh = function () {
            $q.all([
                pagesService.getHierarchy(),
                pagesService.getStatus()
            ])
            .then($q.spread(function (hierarchy, status) {
                $scope.status    = status;
                $scope.hierarchy = hierarchy;
                
                $scope.selectedIndex = ($scope.hierarchy.length - 1).toString()
            }));
        };
        
        $scope.save = function () {
            if($scope.hierarchy[$scope.selectedIndex].pagesAreEditable) {
                pagesService
                    .saveHierarchy($scope.hierarchy[$scope.selectedIndex])
                    .then(function(hierarchyId) {
                        if($scope.hierarchy[$scope.selectedIndex].hierarchyId === null) {
                            $scope.hierarchy[$scope.selectedIndex].hierarchyId = hierarchyId;
                        }
                    });
            }
        };
        
        $scope.pushToStatus = function (newStatusId) {
            pagesService
                .pushHierarchyToStatus($scope.hierarchy[$scope.selectedIndex].hierarchyId, newStatusId)
                .then(function () {
                    return pagesService.getHierarchy()
                })
                .then(function(hierarchy) {
                    $scope.hierarchy = hierarchy;
                });
        };
        
        $scope.addVersion = function () {
            pagesService
                .addHierarchyVersion()
                .then(function (hierarchy) {
                    $scope.hierarchy = hierarchy.hierarchy;
                    $scope.selectedIndex = (hierarchy.newVersion - 1).toString();
                });
        };
        
        $scope.refresh();
        
        $scope.selectedIndex = "0";
    }]);