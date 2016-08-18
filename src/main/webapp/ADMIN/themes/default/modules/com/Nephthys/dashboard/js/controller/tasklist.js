nephthysAdminApp
    .controller("tasklistCtrl", ["$rootScope", "$scope", function ($rootScope, $scope) {
        $scope.showNoWorkMessages = false;
        
        $scope.taskCount = [];
        
        var tasklistCountUpdate = $rootScope.$on("tasklist-count-update", function(origin, data) {
            var found = false;
            for(var i = 0; i < $scope.taskCount.length; ++i) {
                if($scope.taskCount[i].module === data.module) {
                    if(! $scope.taskCount[i].subModule || $scope.taskCount[i].subModule === data.subModule) {
                        found = true;
                        $scope.taskCount[i].taskcount = data.taskcount;
                    }
                }
            }
            
            if(! found) {
                $scope.taskCount.push(data);
            }
        });
        
        $scope.$on('$destroy', function() {
            tasklistCountUpdate();
        });
    }]);