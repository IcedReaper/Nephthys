nephthysAdminApp
    .service("visitService", function($http) {
        return {
            getPageRequests: function (pageId, fromDate, toDate) {
                return $http.get('/ajax/com/Nephthys/pages/getPageRequests', {
                    params: {
                        pageId:   pageId,
                        fromDate: fromDate,
                        toDate:   toDate
                    }
                });
            }
        };
    });