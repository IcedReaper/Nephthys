nephthysAdminApp
    .controller('typeDetailCtrl', ["$scope", "$routeParams", "$q", "typeService", function ($scope, $routeParams, $q, typeService) {
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
                .then(function () {
                    if($scope.type.typeId == 0) {
                        $scope.type.name = "";
                    }
                });
        };
        
        // init
        $scope.load();
    }]);