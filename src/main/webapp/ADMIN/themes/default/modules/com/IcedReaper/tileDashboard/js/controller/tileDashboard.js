nephthysAdminApp
    .controller("tileDashboardCtrl", ["$scope", "$q", "tileDashboardService", function ($scope, $q, service) {
        $scope.load = function () {
            $q.all([
                service.getUptime(),
                service.getNewRegistrations(),
                service.getErrorCount(),
                service.getTotalPageRequests(),
                service.getTopPageRequest()
            ])
            .then($q.spread(function (uptime, newRegistrations, errorCount, totalPageRequests, topPageRequest) {
                $scope.uptime = uptime;
                $scope.newRegistrations = newRegistrations;
                $scope.errors.count = errorCount;
                $scope.pageRequests = totalPageRequests;
                $scope.topPage = topPageRequest;
            }));
        }
        $scope.pageRequests = 0;
        $scope.topPage = {
            title: "",
            requests: 0
        };
        $scope.uptime = 0;
        $scope.newRegistrations = 0;
        $scope.tasks = {
            count: 12
        };
        $scope.errors = {
            count: 0
        };
        
        
        window.setInterval(function () {
            $scope.uptime++;
        }, 1000);
        
        $scope.load();
    }]);