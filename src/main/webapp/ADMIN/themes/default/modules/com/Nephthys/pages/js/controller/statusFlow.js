nephthysAdminApp
    .controller("statusFlowCtrl", ["$scope", "pageStatusService", function ($scope, pageStatusService) {
        $scope.reload = function () {
            pageStatusService
                .getListAsArray()
                .then(function (statusList) {
                    $scope.pageStatusList = structDeepCopy(statusList);
                    $scope.allStatusList  = (function(statusList) {
                            // let's remove all children from here.
                            for(var i = 0; i <= statusList.length; ++i) {
                                for(var key in statusList[i]) {
                                    if(key !== "pageStatusId" && key !== "name") {
                                        delete statusList[i][key];
                                    }
                                }
                            }
                            return statusList;
                        }(structDeepCopy(statusList)));
                });
        };
        
        $scope.save = function () {
            pageStatusService
                .saveStatusFlow($scope.pageStatusList)
                .then();
        }
        
        $scope.rowCount = function (colCount) {
            if($scope.pageStatusList) {
                return new Array(Math.ceil($scope.pageStatusList.length / colCount));
            }
            else {
                return new Array(0);
            }
        };
        
        
        $scope.treeOptions = {
            accept: function(sourceNodeScope, destNodesScope, destIndex) {
                if(sourceNodeScope.$modelValue.pageStatusId === destNodesScope.pageStatus.pageStatusId) {
                    return false;
                }
                for(var i = 0; i < destNodesScope.$modelValue.length; ++i) {
                    if(destNodesScope.$modelValue[i].pageStatusId === sourceNodeScope.$modelValue.pageStatusId) {
                        return false;
                    }
                }
                return true;
            }
        };
        
        $scope.reload();
    }]);