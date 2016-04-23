nephthysAdminApp
    .service("visitService", function($http) {
        return {
            getTodaysVisits: function () {
                return $http.get('/ajax/com/Nephthys/dashboard/getTodaysVisits');
            },
            getYesterdaysVisits: function () {
                return $http.get('/ajax/com/Nephthys/dashboard/getYesterdaysVisits');
            },
            getVisitsForDayCount: function(dayCount) {
                return $http.get('/ajax/com/Nephthys/dashboard/getVisitsForDayCount', {
                    params: {
                        dayCount: dayCount
                    }
                });
            },
            getVisitsForMonth: function(month, year) {
                return $http.get('/ajax/com/Nephthys/dashboard/getVisitsForMonth', {
                    params: {
                        month: month,
                        year:  year
                    }
                });
            },
            getVisitsForYear: function(year) {
                return $http.get('/ajax/com/Nephthys/dashboard/getVisitsForYear', {
                    params: {
                        year: year
                    }
                });
            },
            getVisitsForTimeframe: function(startDate, endDate) {
                return $http.get('/ajax/com/Nephthys/dashboard/getVisitsForTimeframe', {
                    params: {
                        startDate: startDate,
                        endDate:   endDate
                    }
                });
            }
        };
    });