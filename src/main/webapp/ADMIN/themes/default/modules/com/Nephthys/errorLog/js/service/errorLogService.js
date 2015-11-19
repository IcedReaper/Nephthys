(function(angular) {
    angular.module("errorLogAdminService", [])
        .config(window.$QDecorator)
        .service("errorLogService", function ($http) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/Nephthys/errorLog/getList');
                },
                
                getDetails: function (errorCode) {
                    return $http.get('/ajax/com/Nephthys/errorLog/getDetails', {
                        params: {
                            errorCode: errorCode
                        }
                    });
                }
            };
        });
}(window.angular));