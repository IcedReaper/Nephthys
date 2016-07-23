nephthysAdminApp
    .controller("statusFlowCtrl", ["$scope", "statusService", function ($scope, statusService) {
        $scope.reload = function () {
            statusService
                .getListAsArray()
                .then(function (statusList) {
                    $scope.statusList = structDeepCopy(statusList);
                    $scope.allStatusList  = (function(statusList) {
                            // let's remove all children from here.
                            for(var i = 0; i <= statusList.length; ++i) {
                                for(var key in statusList[i]) {
                                    if(key !== "statusId" && key !== "name") {
                                        delete statusList[i][key];
                                    }
                                }
                            }
                            return statusList;
                        }(structDeepCopy(statusList)));
                });
        };
        
        $scope.save = function () {
            statusService
                .saveStatusFlow($scope.statusList)
                .then();
        }
        
        $scope.rowCount = function (colCount) {
            if($scope.statusList) {
                return new Array(Math.ceil($scope.statusList.length / colCount));
            }
            else {
                return new Array(0);
            }
        };
        
        
        $scope.treeOptions = {
            accept: function(sourceNodeScope, destNodesScope, destIndex) {
                if(sourceNodeScope.$modelValue.statusId === destNodesScope.status.statusId) {
                    return false;
                }
                for(var i = 0; i < destNodesScope.$modelValue.length; ++i) {
                    if(destNodesScope.$modelValue[i].statusId === sourceNodeScope.$modelValue.statusId) {
                        return false;
                    }
                }
                return true;
            }
        };
        
        $scope.reload();
    }]);