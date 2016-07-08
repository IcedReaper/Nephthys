nephthysAdminApp
    .service("tileDashboardService", function ($http) {
        return {
            getUptime: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getUptime")
            },
            getNewRegistrations: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getNewRegistrations");
            },
            getErrorCount: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getErrorCount");
            },
            getTotalPageRequests: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getTotalPageRequests");
            },
            getTopPageRequest: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getTopPageRequest");
            },
            getLast24HourRequests: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getLast24HourRequests");
            },
            getServerStatus: function () {
                return $http.get("/ajax/com/IcedReaper/tileDashboard/getServerStatus");
            }
        };
    });