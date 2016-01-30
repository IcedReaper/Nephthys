nephthysAdminApp
    .controller('UploadImageModalCtrl', ["$scope", "$modalInstance", function($scope, $modalInstance) {
        $scope.progress = 0;
        $scope.image = null;

        $scope.insert = function(){
            // implement image resizing
            $modalInstance.close($scope.image);
        };
    }]);