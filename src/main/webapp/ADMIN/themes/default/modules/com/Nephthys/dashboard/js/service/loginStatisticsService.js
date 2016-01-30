nephthysAdminApp
    .service("loginStatisticsService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/dashboard/loginStatistics');
            }
        };
    });