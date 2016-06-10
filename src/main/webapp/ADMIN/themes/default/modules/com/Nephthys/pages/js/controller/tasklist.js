nephthysAdminApp
    .controller("tasklistCtrl", ["$scope", "$q", "pagesService", function ($scope, $q, pagesService) {
        $scope.loadPages = function () {
            $scope.tasklist.pages = {};
            
            pagesService
                .getPageVersionInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.pages = tasklist;
                })
        };
        $scope.loadHierarchy = function () {
            $scope.tasklist.hierarchy = {};
            
            pagesService
                .getHiearchyInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist.hierarchy = tasklist;
                })
        };
        
        $scope.pushPageToStatus = function (pageId, pageVersionId, newstatusId) {
            if(pageId && pageVersionId && newstatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newstatusId)
                    .then($scope.loadPages());
            }
        };
        
        $scope.pushHierarchyToStatus = function (hierarchyId, newstatusId) {
            if(hierarchyId && newstatusId) {
                pagesService
                    .pushHierarchyToStatus(hierarchyId,
                                           newstatusId)
                    .then($scope.loadHierarchy());
            }
        };
        
        $scope.tasklist = {
            pages: {},
            hierarchy: {}
        };
        $scope.loadPages();
        $scope.loadHierarchy();
    }]);