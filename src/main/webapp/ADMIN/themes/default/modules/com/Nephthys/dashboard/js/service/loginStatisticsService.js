(function(angular) {
    angular.module("loginStatisticsService", [])
        .config(window.$QDecorator)
        .service("loginStatisticsService", function($http) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/Nephthys/dashboard/loginStatistics');
                }
            };
        });
}(window.angular));