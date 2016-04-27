nephthysAdminApp
    .controller('UploadImageModalCtrl', ["$scope", "$uibModalInstance", function ($scope, $uibModalInstance) {
        $scope.progress = 0;
        $scope.image = null;

        $scope.insert = function () {
            // implement image resizing
            $uibModalInstance.close($scope.image);
        };
    }]);