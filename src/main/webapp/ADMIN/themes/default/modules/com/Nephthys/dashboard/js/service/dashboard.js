nephthysAdminApp
    .service("dashboardService", function ($http) {
        return {
            getServerInfo: function () {
                return $http.get("/ajax/com/Nephthys/dashboard/getServerInfo");
            }
        }
    });