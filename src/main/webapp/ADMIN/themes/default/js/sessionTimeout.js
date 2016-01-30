nephthysAdminApp
    .controller("sessionTimeoutCtrl", ["$scope", "$rootScope", "$interval", "$location", function ($scope, $rootScope, $interval, $location) {
        var sessionTimeout = 3599;
        var interval = null;
        $scope.secondsRemaining = sessionTimeout;
        
        interval = $interval(function() {
            --$scope.secondsRemaining;
            
            if($scope.secondsRemaining === 0) {
                $interval.cancel(interval);
                
                // session is expired? reroute the user to the login page
                $location.path("/com.Nephthys.login");
            }
        }, 1000);
        
        
        $rootScope.$on('session-refreshed', function(event, data) {
            $scope.secondsRemaining = sessionTimeout;
        });
    }])
    .filter('secondsToDateTime', [function() {
        return function(seconds) {
            return new Date(1970, 0, 1).setSeconds(seconds);
        };
    }]);