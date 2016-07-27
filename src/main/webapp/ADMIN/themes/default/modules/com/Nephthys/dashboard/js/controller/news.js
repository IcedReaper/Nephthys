nephthysAdminApp
    .controller("newsCtrl", ["$rootScope", "$scope", function ($rootScope, $scope) {
        var now = new Date();
        $scope.selectedDate = {};
        $scope.selectedDate.fromDate = new Date(now.getFullYear(), now.getMonth(), 1);
        $scope.selectedDate.toDate = today();
        
        $scope.options = {
            showDatePicker:    false,
            showRefreshButton: false
        };
        $scope.loginChart = {
            options: {
                fixedHeight: true,
                height: 250,
                legend: {
                    display: true
                },
                tooltips: {
                    mode: 'label'
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        };
        $scope.pageChart = {
            options: {
                fixedHeight: true,
                height: 250,
                legend: {
                    display: true
                },
                tooltips: {
                    mode: 'label'
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        };
        $scope.errorChart = {
            options: {
                fixedHeight: true,
                height: 250,
                legend: {
                    display: true
                },
                tooltips: {
                    mode: 'label'
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        };
        
        $scope.showNoWorkMessages = false;
        
        $scope.refresh = function () {
            $rootScope.$broadcast("nephthys-statistics-refresh");
        };
    }]);