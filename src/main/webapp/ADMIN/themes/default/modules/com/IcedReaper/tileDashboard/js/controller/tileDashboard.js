nephthysAdminApp
    .controller("tileDashboardCtrl", ["$scope", "$q", "tileDashboardService", function ($scope, $q, service) {
        $scope.load = function () {
            $q.all([
                service.getUptime(),
                service.getNewRegistrations(),
                service.getErrorCount(),
                service.getTotalPageRequests(),
                service.getTopPageRequest(),
                service.getLast24HourRequests(),
                service.getServerStatus()
            ])
            .then($q.spread(function (uptime, newRegistrations, errorCount, totalPageRequests, topPageRequest, last24HourRequests, serverStatus) {
                $scope.uptime = uptime;
                $scope.newRegistrations = newRegistrations;
                $scope.errors.count = errorCount;
                $scope.pageRequests = totalPageRequests;
                $scope.topPage = topPageRequest;
                
                $scope.last24HourChart.data   = last24HourRequests.data;
                $scope.last24HourChart.labels = last24HourRequests.labels;
                
                $scope.serverStatus = serverStatus;
            }));
        };
        
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
        $scope.status = {
            online: true,
            maintenanceMode: false
        };
        $scope.last24HourChart = {
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            },
            type: "line"
        };
        
        window.setInterval(function () {
            $scope.uptime++;
        }, 1000);
        
        $scope.load();
    }]);