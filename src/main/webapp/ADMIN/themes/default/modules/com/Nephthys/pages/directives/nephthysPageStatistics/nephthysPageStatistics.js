angular.module("com.nephthys.page.statistics.perPage", ["com.nephthys.page.pageVisit"])
    .directive("nephthysPageStatisticsPerPage", function() {
        return {
            replace: true,
            restrict: "E",
            scope: {
            },
            templateUrl : "/themes/default/modules/com/Nephthys/pages/directives/nephthysPageStatistics/nephthysPageStatistics.html"
        };
    });