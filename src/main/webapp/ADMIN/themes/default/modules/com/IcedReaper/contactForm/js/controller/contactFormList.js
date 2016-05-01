nephthysAdminApp
    .controller('contactFormListCtrl', ["$scope", "contactFormService", function ($scope, contactFormService) {
        $scope.refresh = function() {
            contactFormService
                .getList()
                .then(function (contactFormList) {
                    $scope.requests = contactFormList;
                });
        }
        
        $scope.requests = [];
        $scope.search = {
            read: "",
            replied: ""
        };
        $scope.refresh();
    }]);