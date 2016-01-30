nephthysAdminApp
    .controller('contactFormDetailCtrl', ["$scope", "$routeParams", "$q", "contactFormService", function ($scope, $routeParams, $q, contactFormService) {
        $scope.load = function () {
            $q.all([
                contactFormService.getDetails($routeParams.requestId),
                contactFormService.getReplies($routeParams.requestId)
            ])
            .then($q.spread(function (requestDetails, replies) {
                $scope.request = requestDetails.request;
                $scope.replies = replies.replies;
            }));
        };
        
        $scope.sendReply = function () {
            contactFormService
                .reply($routeParams.requestId, $scope.reply.message)
                .then(function() {
                    return contactFormService.getReplies($routeParams.requestId);
                })
                .then(function(replies) {
                    $scope.replies = replies.replies;
                    
                    $scope.reply.message = "";
                });
        };
        
        $scope.load();
    }]);