nephthysAdminApp
    .controller('typeDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "typeService", function ($scope, $routeParams, $route, $q, typeService) {
        // load
        $scope.load = function() {
            typeService
                .getDetails($routeParams.typeId)
                .then(function (type) {
                    $scope.type = type;
                });
        };
        
        $scope.save = function () {
            typeService
                .save({
                    typeId: $scope.type.typeId,
                    name:   $scope.type.name
                })
                .then(function (newTypeId) {
                    if($scope.type.typeId != newTypeId) {
                        $scope.type.typeId = newTypeId;
                        
                        $route.updateParams({
                            typeId: newTypeId
                        });
                    }
                });
        };
        
        // init
        $scope.load();
    }]);