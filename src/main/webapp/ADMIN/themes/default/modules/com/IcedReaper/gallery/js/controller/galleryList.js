nephthysAdminApp
    .controller('galleryListCtrl', ["$scope", "$q", "galleryService", function ($scope, $q, galleryService) {
        $scope.delete = function (galleryId) {
            galleryService
                .delete(galleryId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            $q.all([
                galleryService.getList(),
                galleryService.getStatus()
            ])
            .then($q.spread(function (galleries, status) {
                $scope.galleries = galleries;
                $scope.status    = status;
            }));
        };
        
        $scope.pushToStatus = function (galleryId, newStatusId) {
            if(galleryId && newStatusId) {
                galleryService
                    .pushToStatus(galleryId,
                                  newStatusId)
                    .then($scope.refresh);
            }
        };
        
        $scope.statusButtonClass = function (actualOnline, nextOnline) {
            if(! actualOnline && nextOnline) {
                return "btn-success";
            }
            if(actualOnline && ! nextOnline) {
                return "btn-danger";
            }
            if(! actualOnline && ! nextOnline) {
                return "btn-primary";
            }
            if(actualOnline && nextOnline) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
        $scope.galleries = [];
        $scope.refresh();
    }]);