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
                
                $scope.page.versions["1.1"].content = [{"type": "com.Nephthys.container"}];
                $scope.selectedVersion = pageDetails.actualVersion;
            }));
        };
        
        $scope.save = function () {
            pagesService
                .save($scope.page)
                .then($scope.load);
        };
        
        $scope.appendChild = function (child, newChildren) {
            // todo: check when col if 100% is exceeded
            if(newChildren != "") {
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
            
            searchSub($scope.page.content);
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
            
            searchSub($scope.page.content);
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
            
            searchSub($scope.page.content);
        };
        
        $scope.addMajorVersion = function () {
            var newVersion = getNextMajorVersion() + ".0";
            
            $scope.page.versions[newVersion] = [];
            
            $scope.selectedVersion = newVersion;
        };
        
        $scope.addMinorVersion = function () {
            var v = $scope.page.actualVersion.split(".");
            
            var newVersion = v[0] + "." + (parseInt(v[1], 10) + 1);
            
            // json way is a try to deep copy the struct | structs are pointers and therefore changed.
            $scope.page.versions[newVersion] = JSON.parse(JSON.stringify($scope.page.versions[$scope.page.actualVersion]));
            $scope.page.versions[newVersion].pageStatus = JSON.parse(JSON.stringify($scope.pageStatus[0]));
            
            $scope.selectedVersion = newVersion;
        };
        
        var getNextMajorVersion = function () {
            var lastVersion = 0;
            for(var v in $scope.page.versions) {
                if(lastVersion < Math.ceil(parseInt(v, 10))) {
                    lastVersion = Math.ceil(parseInt(v, 10));
                }
            }
            
            return lastVersion + 1;
        }
        
        $scope.load();
    }]);