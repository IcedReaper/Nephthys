angular.module("com.nephthys.global.loadingBar", [])
    .controller("nephthysLoadingBarController", ["$rootScope", "$scope", function($rootScope, $scope) {
        $scope.showLoadingBar = true;
        
        if($scope.loadingType) {
            switch($scope.loadingType) {
                case "line":
                case "dots": {
                    break;
                }
                default: {
                    console.warn("Could not recognise the loading type. - The type line was automatically assigned");
                    $scope.loadingType = "line";
                }
            }
        }
        else {
            $scope.loadingType = "line";
        }
        
        var destroyShowListener = $rootScope.$on("nephthys-loading-bar-show", function () {
            $scope.showLoadingBar = true;
        });
        
        var destroyHideListener = $rootScope.$on("nephthys-loading-bar-hide", function () {
            $scope.showLoadingBar = false;
        });
        
        $scope.$on('$destroy', function() {
            destroyShowListener();
            destroyHideListener();
        });
    }])
    .directive("nephthysLoadingBar", function() {
        return {
            replace: true,
            restrict: "E",
            controller: "nephthysLoadingBarController",
            scope: {
                loadingType: "@"
            },
            templateUrl : "/themes/default/directive/nephthysLoadingBar/nephthysLoadingBar.html"
        };
    });