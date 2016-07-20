nephthysAdminApp
    .controller('userExtPropertiesCtrl', ["$scope", "$routeParams", "$q", "userService", function ($scope, $routeParams, $q, userService) {
        $scope.load = function () {
            if($routeParams.userId !== null && $routeParams.userId !== 0) {
                $q.all([
                    userService.getExtProperties($routeParams.userId)
                ])
                .then($q.spread(function (extProperties) {
                    $scope.extProperties = extProperties;
                    
                    for(var i = 0; i <= $scope.extProperties.length; ++i) {
                        if($scope.extProperties[i].type === 'date') {
                            $scope.extProperties[i].value = $scope.extProperties[i].value.urlFormatToDate();
                        }
                    }
                }));
            }
        };
        
        $scope.save = function () {
            userService.saveExtProperties($routeParams.userId, $scope.extProperties);
        };
        
        $scope.datePicker = {
            isOpen: false,
            options: {
                
            }
        };
        
        $scope.openDatePicker = function () {
            $scope.datePicker.isOpen = true;
        };
        
        $scope.load();
    }]);