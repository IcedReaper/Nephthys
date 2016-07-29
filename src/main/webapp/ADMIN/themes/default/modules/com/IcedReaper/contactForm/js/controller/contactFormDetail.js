nephthysAdminApp
    .controller('contactFormDetailCtrl', ["$scope", "$routeParams", "$q", "contactFormService", function ($scope, $routeParams, $q, contactFormService) {
        $scope.load = function () {
            $q.all([
                contactFormService.getDetails($routeParams.contactRequestId),
                contactFormService.getReplies($routeParams.contactRequestId)
            ])
            .then($q.spread(function (contactRequestDetails, replies) {
                $scope.contactRequest = contactRequestDetails;
                $scope.replies         = replies;
            }));
        };
        
        $scope.sendReply = function () {
            contactFormService
                .reply($routeParams.contactRequestId, $scope.reply.message)
                .then(function() {
                    return contactFormService.getReplies($routeParams.contactRequestId);
                })
                .then(function(replies) {
                    $scope.replies = replies;
                    
                    $scope.reply.message = "";
                });
        };
        
        $scope.load();
    }]);