nephthysAdminApp
    .controller('userExtPropertiesCtrl', ["$scope", "$routeParams", "$q", "userService", function ($scope, $routeParams, $q, userService) {
        $scope.load = function () {
            if($routeParams.userId !== null && $routeParams.userId !== 0) {
                userService
                    .getExtProperties($routeParams.userId)
                    .then(function (extProperties) {
                        $scope.extProperties = extProperties;
                        
                        for(var i = 0; i < $scope.extProperties.length; ++i) {
                            if($scope.extProperties[i].type === 'date') {
                                $scope.extProperties[i].value = $scope.extProperties[i].value.urlFormatToDate();
                            }
                        }
                    });
            }
        };
        
        $scope.save = function () {
            var extProperties = [];
            for(var i = 0; i < $scope.extProperties.length; ++i) {
                var value = $scope.extProperties[i].value;
                
                if($scope.extProperties[i].type === "date") {
                    value = $scope.extProperties[i].value.toAjaxFormat();
                }
                
                extProperties.push({
                    extPropertyId:    $scope.extProperties[i].extPropertyId,
                    extPropertyKeyId: $scope.extProperties[i].extPropertyKeyId,
                    public:           $scope.extProperties[i].public,
                    value:            value,
                    type:             $scope.extProperties[i].type
                });
                
            }
            
            userService
                .saveExtProperties($routeParams.userId, extProperties)
                .then($scope.load);
        };
        
        $scope.datePicker = {
            isOpen: false,
            options: {
                startingDay: 1,
                maxDate: new Date()
            }
        };
        
        $scope.openDatePicker = function () {
            $scope.datePicker.isOpen = true;
        };
        
        $scope.load();
    }]);