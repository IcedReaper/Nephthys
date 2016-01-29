(function(angular) {
    var contactFormListCtrl = angular.module('contactFormListCtrl', ["contactFormService"]);
    
    contactFormListCtrl.controller('contactFormListCtrl', function ($scope, contactFormService) {
        $scope.refresh = function() {
            contactFormService
                .getList()
                .then(function (contactFormList) {
                    $scope.requests = contactFormList.requests;
                });
        }
        
        $scope.requests = [];
        $scope.search = {
            read: "",
            replied: ""
        };
        $scope.refresh();
    });
}(window.angular));