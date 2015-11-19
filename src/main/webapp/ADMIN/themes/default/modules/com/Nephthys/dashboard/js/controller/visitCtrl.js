(function(angular) {
    var visitCtrl = angular.module('visitCtrl', ["chart.js", "visitService"]);
    
    visitCtrl.controller('visitCtrl', function ($scope, visitService, $q) {
        var refreshVisitData = function (visitData, type) {
            if(visitData.success) {
                $scope[type + 'VisitChart'] = {
                    labels: visitData.pageVisits.labels,
                    data:   [visitData.pageVisits.data]
                };
                
                angular.forEach(visitData.pageVisits.labels, function (value, key) {
                    $scope[type + 'VisitChartLegend'].push({
                        link: visitData.websiteUrl + value,
                        label: value
                    });
                });
            }
        };
        var cleanVisitData = function(type) {
            $scope[type + 'VisitChart'] = {
                labels: [],
                data:   []
            };
            
            $scope[type + 'VisitChartLegend'] = [];
        }
        
        $scope.refresh = function () {
            cleanVisitData("today");
            cleanVisitData("yesterday");
            
            $q.all([
                    visitService.getTodaysVisits(),
                    visitService.getYesterdaysVisits()
                ])
                // and merging them
                .then($q.spread(function (todaysVisits, yesterdaysVisits) {
                    refreshVisitData(todaysVisits, "today");
                    refreshVisitData(yesterdaysVisits, "yesterday");
                }));
        };
        
        $scope.refresh();
    });
}(window.angular));