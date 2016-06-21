nephthysAdminApp
    .controller("serverInfoCtrl", ["$scope", "dashboardService", function ($scope, dashboardService) {
        $scope.load = function () {
            dashboardService
                .getServerInfo()
                .then(function (serverInfo) {
                    $scope.serverInfo = serverInfo;
                });
        };
        
        $scope.getUsedMemoryClass = function () {
            if($scope.serverInfo.memory.percentageUsed < 50) {
                return "progress-success";
            }
            else if($scope.serverInfo.memory.percentageUsed < 80) {
                return "progress-warning";
            }
            else {
                return "progress-danger";
            }
        };
        
        $scope.serverInfo = {
            memory: {
                total: 0,
                used: 0,
                percentageUsed: 100
            },
            installedVersion: "0",
            installDate: new Date().toLocaleString(),
            maintenanceMode: false,
            onlineStatus: true
        };
        
        $scope.load();
    }]);