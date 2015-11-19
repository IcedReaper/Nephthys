(function(angular) {
    angular.module("visitService", [])
        .config(window.$QDecorator)
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
}(window.angular));