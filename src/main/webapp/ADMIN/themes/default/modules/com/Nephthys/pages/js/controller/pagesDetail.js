nephthysAdminApp
    .controller('pagesDetailCtrl', ["$scope", "$routeParams", "$q", "pagesService", function ($scope, $routeParams, $q, pagesService) {
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
            pagesService
                .save($scope.page)
                .then($scope.load);
        };
        
        $scope.stringifiedConttent = function () {
            return JSON.stringify($scope.page.content);
        };
        
        $scope.appendChild = function (child, newChildren) {
            // todo: check when col if 100% is exceeded
            if(newChildren != "") {
                child.children.push({
                    "type": newChildren,
                    "options": {
                    },
                    "children": []
                });
            }
        };
        
        $scope.appendContainer = function () {
            $scope.page.content.push({
                "type": "com.Nephthys.container",
                "options": {
                },
                "children": []
            });
        };
        
        $scope.checkOption = function(child, optionName, value) {
            if(value === "") {
                delete child.options[optionName];
            }
        }
        
        $scope.logContent = function () {
            console.log($scope.page.content);
        };
        
        $scope.load();
        
        $scope.availableSubTypes = {
            "com.Nephthys.container": [
                "com.Nephthys.row"
            ],
            "com.Nephthys.row": [
                "com.Nephthys.col"
            ],
            "com.Nephthys.col": [
                "com.Nephthys.text",
                "com.IcedReaper.teamOverview",
                "com.IcedReaper.blog",
                "com.IcedReaper.gallery"
            ],
            "com.Nephthys.text": [
            ],
            "com.IcedReaper.teamOverview": [
            ],
            "com.IcedReaper.blog": [
            ],
            "com.IcedReaper.gallery": [
            ]
        };
        
        $scope.availableOptions = {
            "com.Nephthys.container": {
                "background-class": { // todo: divide
                    "dbName": "background-class",
                    "description": "Hintergrunddesign",
                    "type": "text"
                },
                "fullWidth": {
                    "dbName": "fullWidth",
                    "description": "Volle Breite",
                    "type": "boolean"
                },
                "fullWidthOnlyBackground": {
                    "dbName": "fullWidthOnlyBackground",
                    "description": "Nur Hintergrund auf  voller Breite",
                    "type": "boolean"
                }
            },
            "com.Nephthys.row": {
            },
            "com.Nephthys.col": {
                "width-xs": {
                    "dbName": "width-xs",
                    "description": "Breite XS",
                    "type": "select",
                    "values": [
                        "8%",
                        "16%",
                        "25%",
                        "33%",
                        "41%",
                        "50%",
                        "58%",
                        "66%",
                        "75%",
                        "83%",
                        "91%",
                        "100%"
                    ]
                },
                "width-sm": {
                    "dbName": "width-sm",
                    "description": "Breite SM",
                    "type": "select",
                    "values": [
                        "8%",
                        "16%",
                        "25%",
                        "33%",
                        "41%",
                        "50%",
                        "58%",
                        "66%",
                        "75%",
                        "83%",
                        "91%",
                        "100%"
                    ]
                },
                "width-md": {
                    "dbName": "width-md",
                    "description": "Breite MD",
                    "type": "select",
                    "values": [
                        "8%",
                        "16%",
                        "25%",
                        "33%",
                        "41%",
                        "50%",
                        "58%",
                        "66%",
                        "75%",
                        "83%",
                        "91%",
                        "100%"
                    ]
                },
                "width-lg": {
                    "dbName": "width-lg",
                    "description": "Breite LG",
                    "type": "select",
                    "values": [
                        "8%",
                        "16%",
                        "25%",
                        "33%",
                        "41%",
                        "50%",
                        "58%",
                        "66%",
                        "75%",
                        "83%",
                        "91%",
                        "100%"
                    ]
                },
                "width-xl": {
                    "dbName": "width-xl",
                    "description": "Breite XL",
                    "type": "select",
                    "values": [
                        "8%",
                        "16%",
                        "25%",
                        "33%",
                        "41%",
                        "50%",
                        "58%",
                        "66%",
                        "75%",
                        "83%",
                        "91%",
                        "100%"
                    ]
                }
            },
            "com.Nephthys.text": {
                "content": {
                    "dbName": "content",
                    "description": "Inhalt",
                    "type": "wysiwyg"
                },
                "centered": {
                    "dbName": "centered",
                    "description": "Zentriert",
                    "type": "boolean"
                }
            },
            "com.IcedReaper.teamOverview": {
            },
            "com.IcedReaper.blog": {
                "onlyLast": {
                    "dbName": "onlyLast",
                    "description": "Nur den aktuellsten",
                    "type": "boolean"
                }
            },
            "com.IcedReaper.gallery": {
            }
        };
    }]);