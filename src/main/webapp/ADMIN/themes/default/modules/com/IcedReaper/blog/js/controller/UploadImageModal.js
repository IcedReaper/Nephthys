(function(angular) {
    var UploadImageModalCtrl = angular.module('UploadImageModalCtrl', ["blogAdminService"]);
    
    UploadImageModalCtrl.controller('UploadImageModalCtrl', function($scope, $modalInstance, Upload){
        $scope.progress = 0;
        $scope.image = null;

        $scope.insert = function(){
            // implement image resizing
            $modalInstance.close($scope.image);
        };
    });
}(window.angular));