nephthysAdminApp
    .controller('pagesDetailCtrl', ["$scope", "$routeParams", "$q", "pagesService", function ($scope, $routeParams, $q, pagesService) {
        $scope.load = function () {
            $q.all([
                pagesService.getDetails($routeParams.pageId),
                pagesService.getStatus(),
                pagesService.getAvailableSubModules(),
                pagesService.getAvailableOptions()
            ])
            .then($q.spread(function (pageDetails, pageStatus, availableSubModules, availableOptions) {
                $scope.page                = pageDetails;
                $scope.pageStatus          = pageStatus;
                $scope.availableSubModules = availableSubModules;
                $scope.availableOptions    = availableOptions;
                
                $scope.selectedVersion = pageDetails.actualVersion; // {major, minor}
                $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            }));
        };
        
        $scope.save = function () {
            pagesService
                .save($scope.page)
                .then($scope.load);
        };
        
        $scope.appendChild = function (child, newChildren) {
            // todo: check when col if 100% is exceeded
            if(newChildren) {
                if(child.children) {
                    child.children.push({
                        "type": newChildren,
                        "options": {
                        },
                        "children": []
                    });
                }
                else {
                    child.push({
                        "type": newChildren,
                        "options": {
                        },
                        "children": []
                    });
                }
                
                delete child["newChildren"];
            }
        };
        
        $scope.checkOption = function(child, optionName, value) {
            if(value === "") {
                delete child.options[optionName];
            }
        };
        
        $scope.moveUp = function(child) {
            var searchSub = function(subElements) {
                for(var i = 0; i < subElements.length; ++i) {
                    if(subElements[i].$$hashKey === child.$$hashKey) {
                        subElements.move(i, i-1);
                        return true;
                    }
                    
                    if(searchSub(subElements[i].children)) {
                        return true;
                    }
                }
                
                return false;
            };
            
            searchSub($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].content);
        };
        
        $scope.moveDown = function(child) {
            var searchSub = function(subElements) {
                for(var i = 0; i < subElements.length; ++i) {
                    if(subElements[i].$$hashKey === child.$$hashKey) {
                        subElements.move(i, i+1);
                        return true;
                    }
                    
                    if(searchSub(subElements[i].children)) {
                        return true;
                    }
                }
                
                return false;
            };
            
            searchSub($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].content);
        };
        
        $scope.deleteElement = function(child) {
            var searchSub = function(subElements) {
                for(var i = 0; i < subElements.length; ++i) {
                    if(subElements[i].$$hashKey === child.$$hashKey) {
                        subElements.splice(i, 1);
                        return true;
                    }
                    
                    if(searchSub(subElements[i].children)) {
                        return true;
                    }
                }
                
                return false;
            };
            
            searchSub($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].content);
        };
        
        $scope.addMajorVersion = function () {
            var scv = $scope.selectedCompleteVersion.split(".");
            
            var newMajorVersion = 0;
            var newMinorVersion = 0;
            for(var majorVersion in $scope.page.versions) {
                if(majorVersion > newMajorVersion) {
                    newMajorVersion = majorVersion;
                }
            }
            
            ++newMajorVersion;
            
            $scope.selectedVersion.major = newMajorVersion;
            $scope.selectedVersion.minor = newMinorVersion;
            $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            
            $scope.page.versions[newMajorVersion] = {};
            $scope.page.versions[newMajorVersion][newMinorVersion] = JSON.parse(JSON.stringify($scope.page.versions[scv[0]][scv[1]]));
            
            // update all status variables
            $scope.page.versions[newMajorVersion][newMinorVersion].pageStatus = JSON.parse(JSON.stringify($scope.pageStatus[0]));
            $scope.page.versions[newMajorVersion][newMinorVersion].content = [];
            // TODO:
            $scope.page.versions[newMajorVersion][newMinorVersion].creator.userId = 0;
            $scope.page.versions[newMajorVersion][newMinorVersion].creator.userName = "IcedReaper";
            $scope.page.versions[newMajorVersion][newMinorVersion].lastEditor.userId = 0;
            $scope.page.versions[newMajorVersion][newMinorVersion].lastEditor.userName = "IcedReaper";
        };
        
        $scope.addMinorVersion = function () {
            var scv = $scope.selectedCompleteVersion.split(".");
            var majorVersion = scv[0];
            
            var newMinorVersion = 0;
            for(var minorVersion in $scope.page.versions[majorVersion]) {
                if(minorVersion > newMinorVersion) {
                    newMinorVersion = minorVersion;
                }
            }
            
            ++newMinorVersion;
            
            $scope.selectedVersion.minor = newMinorVersion;
            $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            
            $scope.page.versions[majorVersion][newMinorVersion] = JSON.parse(JSON.stringify($scope.page.versions[scv[0]][scv[1]]));
            
            // update all status variables
            $scope.page.versions[majorVersion][newMinorVersion].pageStatus = JSON.parse(JSON.stringify($scope.pageStatus[0]));
            // TODO:
            $scope.page.versions[majorVersion][newMinorVersion].creator.userId = 0;
            $scope.page.versions[majorVersion][newMinorVersion].creator.userName = "IcedReaper";
            $scope.page.versions[majorVersion][newMinorVersion].lastEditor.userId = 0;
            $scope.page.versions[majorVersion][newMinorVersion].lastEditor.userName = "IcedReaper";
        };
        
        $scope.setVersion = function () {
            var scv = $scope.selectedCompleteVersion.split(".");
            $scope.selectedVersion.major = scv[0];
            $scope.selectedVersion.minor = scv[1];
        };
        
        $scope.isEditable = function () {
            if($scope.page) {
                return $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageStatus.editable;
            }
            else {
                return false;
            }
        };
        
        $scope.isReadonly = function () {
            if($scope.page) {
                return ! $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageStatus.editable;
            }
            else {
                return true;
            }
        };
        
        $scope.load();
    }]);