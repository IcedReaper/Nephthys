(function(angular) {
    var pagesDetailCtrl = angular.module('pagesDetailCtrl', ["chart.js", "ngSanitize", "pagesAdminService"]);
    
    pagesDetailCtrl.controller('pagesDetailCtrl', function ($scope, $routeParams, $q, pagesService) {
        /*
        var prepareContentForHtml = function () {
                var htmlContent = prepareKnotForHtml(JSON.parse($scope.page.content));
                console.log(htmlContent);
                $scope.page.preparedContent = htmlContent;
            },
            prepareContentForDB = function () {
                $scope.page.content = $scope.page.preparedContent;
            },
            prepareKnotForHtml = function (knot) {
                var widthToColName = function(width) {
                    switch(knot[i].options['width-md']) {
                        case   "8%": { return  "1"; }
                        case  "16%": { return  "2"; }
                        case  "25%": { return  "3"; }
                        case  "33%": { return  "4"; }
                        case  "41%": { return  "5"; }
                        case  "50%": { return  "6"; }
                        case  "58%": { return  "7"; }
                        case  "66%": { return  "8"; }
                        case  "75%": { return  "9"; }
                        case  "83%": { return "10"; }
                        case  "91%": { return "11"; }
                        default: { return "12"; }
                    }
                }
                
                console.log("start", knot);
                var htmlContent = "";
                for(var i = 0; i < knot.length; i++) {
                    console.log("for", knot[i].type);
                    switch(knot[i].type) {
                        case 'com.Nephthys.container': {
                            htmlContent += "<div class=\"container\">" + prepareKnotForHtml(knot[i].children) + "</div>";
                            break;
                        }
                        case 'com.Nephthys.row': {
                            htmlContent += "<div class=\"row\">" + prepareKnotForHtml(knot[i].children) + "</div>";
                            break;
                        }
                        case 'com.Nephthys.col': {
                            var classes = "";
                            if(knot[i].options['width-xs']) {
                                classes += " col-xs-" + widthToColName(knot[i].options['width-xs']);
                            }
                            if(knot[i].options['width-sm']) {
                                classes += " col-sm-" + widthToColName(knot[i].options['width-sm']);
                            }
                            if(knot[i].options['width-md']) {
                                classes += " col-md-" + widthToColName(knot[i].options['width-md']);
                            }
                            if(knot[i].options['width-lg']) {
                                classes += " col-lg-" + widthToColName(knot[i].options['width-lg']);
                            }
                            htmlContent += "<div class=\"" + classes + "\" contenteditable=\"true\">" + prepareKnotForHtml(knot[i].children) + "</div>";
                            break;
                        }
                        case 'com.Nephthys.text': {
                            htmlContent += knot[i].options.content;
                            break;
                        }
                        default: {
                            htmlContent += knot[i].type + "needs to be implemented";
                            break;
                        }
                    }
                }
                
                console.log("end", knot, htmlContent);
                return htmlContent;
            };
        */
        $scope.load = function () {
            $q.all([
                pagesService.getDetails($routeParams.pageId),
                pagesService.getStatus()
            ])
            // and merging them
            .then($q.spread(function (pageDetails, pageStatus) {
                $scope.page = pageDetails.page;
                $scope.pageStatus = pageStatus.data;
            }));
        };
        
        $scope.save = function () {
            /*prepareContentForDB();
            console.log($scope.page);
            return ; // remove*/
            pagesService
                .save($scope.page)
                .then($scope.load);
        };
        
        $scope.load();
    });
}(window.angular));