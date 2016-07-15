nephthysAdminApp
    .config(window.$QDecorator)
    .service("errorLogService", function ($http) {
        return {
            getList: function (fromDate, toDate) {
                return $http.get('/ajax/com/Nephthys/errorLog/getList', {
                    params: {
                        fromDate: fromDate.toAjaxFormat(),
                        toDate: toDate.toAjaxFormat()
                    }
                });
            },
            
            getDetails: function (errorCode, fromDate, toDate, errorId) {
                return $http.get('/ajax/com/Nephthys/errorLog/getDetails', {
                    params: {
                        errorCode: errorCode,
                        fromDate: fromDate.toAjaxFormat(),
                        toDate: toDate.toAjaxFormat(),
                        errorId: errorId
                    }
                });
            }
        };
    });