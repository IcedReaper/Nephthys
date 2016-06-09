nephthysAdminApp
    .controller("tasklistCtrl", ["$scope", "pagesService", function ($scope, pagesService) {
        $scope.load = function () {
            $scope.tasklist = {};
            
            pagesService
                .getPageVersionInTasklist()
                .then(function (tasklist) {
                    $scope.tasklist = tasklist;
                })
        };
        
        $scope.pushToStatus = function (pageId, pageVersionId, newstatusId) {
            if(pageId && pageVersionId && newstatusId) {
                pagesService
                    .pushToStatus(pageId,
                                  pageVersionId,
                                  newstatusId)
                    .then($scope.load());
            }
        };
        
        $scope.load();
    }]);