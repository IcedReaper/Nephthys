nephthysAdminApp
    .service("visitService", function($http) {
        return {
            getTodaysVisits: function () {
                return $http.get('/ajax/com/Nephthys/dashboard/getTodaysVisits');
            },
            getYesterdaysVisits: function () {
                return $http.get('/ajax/com/Nephthys/dashboard/getYesterdaysVisits');
            }
        };
    });