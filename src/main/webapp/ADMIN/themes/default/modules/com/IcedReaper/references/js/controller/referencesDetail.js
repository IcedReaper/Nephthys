nephthysAdminApp
    .controller('referencesDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "referencesService", function ($scope, $routeParams, $route, $q, referencesService) {
        $scope.load = function() {
            referencesService
                .getDetails($routeParams.referenceId)
                .then(function (referenceDetails) {
                    $scope.reference = referenceDetails;
                    
                    var dateParts = $scope.reference.since.split("/");
                    $scope.reference.since = new Date(dateParts[0], parseInt(dateParts[1], 10) - 1, dateParts[2]);
                });
        };
        
        $scope.save = function () {
            referencesService
                .save($scope.reference)
                .then(function(reference) {
                    var oldReferenceId = $scope.reference.referenceId;
                    
                    $scope.reference = referenceDetails;
                    
                    var dateParts = $scope.reference.since.split("/");
                    $scope.reference.since = new Date(dateParts[0], parseInt(dateParts[1], 10) - 1, dateParts[2]);
                    
                    if(oldReferenceId == 0) {
                        $route.updateParams({
                            referenceId: referenceId
                        });
                    }
                });
        };
        
        $scope.openSinceDatePicker = function () {
            $scope.sinceDate.isOpen = true;
        };
        
        $scope.reference = {};
        $scope.reference.referenceId = $routeParams.referenceId;
        $scope.newImage = null;
        
        $scope.sinceDate = {
            isOpen: false,
            options: {
                maxDate: new Date()
            }
        };
        
        $scope.load();
    }]);