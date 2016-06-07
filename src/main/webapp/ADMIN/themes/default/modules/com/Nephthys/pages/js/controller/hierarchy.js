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
            }));
        };
        
        $scope.save = function () {
            if($scope.hierarchy.versions[$scope.selectedIndex].pagesAreEditable) {
                pagesService
                    .saveHierarchy($scope.hierarchy.versions[$scope.selectedIndex])
                    .then(function(hierarchyId) {
                        if($scope.hierarchy.versions[$scope.selectedIndex].hierarchyId === null) {
                            $scope.hierarchy.versions[$scope.selectedIndex].hierarchyId = hierarchyId;
                        }
                    });
            }
        };
        
        $scope.pushToStatus = function (newStatusId) {
            pagesService
                .pushHierarchyToStatus($scope.hierarchy.versions[$scope.selectedIndex].hierarchyId, newStatusId)
                .then(function () {
                    $scope.hierarchy.versions[$scope.selectedIndex].statusId = newStatusId;
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