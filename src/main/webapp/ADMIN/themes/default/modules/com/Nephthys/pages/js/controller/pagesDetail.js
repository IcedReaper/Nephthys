nephthysAdminApp
    .controller('pagesDetailCtrl', ["$scope", "$routeParams", "$q", "pagesService", function ($scope, $routeParams, $q, pagesService) {
        var _actualUser,
            
            getStartStatus = function () {
                for(var status in $scope.status) {
                    return $scope.status[status].statusId;
                    /*if($scope.status[status].startStatus === true) {
                        return $scope.status[status].statusId;
                    }*/
                }
            },
            updateNewVersionVariables = function (majorVersion, minorVersion) {
                if(! isNaN(majorVersion) && ! isNaN(minorVersion)) {
                    $scope.page.versions[majorVersion][minorVersion].pageVersionId = null;
                    $scope.page.versions[majorVersion][minorVersion].statusId      = getStartStatus();
                    
                    $scope.page.versions[majorVersion][minorVersion].creationDate = new Date();
                    $scope.page.versions[majorVersion][minorVersion].lastEditDate = new Date();
                    $scope.page.versions[majorVersion][minorVersion].creator.userId      = _actualUser.userId;
                    $scope.page.versions[majorVersion][minorVersion].creator.userName    = _actualUser.userName;
                    $scope.page.versions[majorVersion][minorVersion].lastEditor.userId   = _actualUser.userId;
                    $scope.page.versions[majorVersion][minorVersion].lastEditor.userName = _actualUser.userName;
                    
                    //TODO: sortOrder = get actual sortOrder from hierarchy as the versions sortOrder isn't as reliable.
                }
            };
        
        $scope.load = function () {
            $q.all([
                pagesService.getDetails($routeParams.pageId),
                pagesService.getStatus(),
                pagesService.getAvailableSubModules(),
                pagesService.getAvailableOptions(),
                pagesService.getActualUser()
            ])
            .then($q.spread(function (pageDetails, status, availableSubModules, availableOptions, actualUser) {
                $scope.page                = pageDetails;
                $scope.status              = status;
                $scope.availableSubModules = availableSubModules;
                $scope.availableOptions    = availableOptions;
                
                $scope.selectedVersion = pageDetails.actualVersion; // {major, minor}
                $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
                
                _actualUser = actualUser;
            }));
        };
        
        $scope.save = function () {
            pagesService
                .save($scope.page.pageId,
                      $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor],
                      $scope.selectedVersion.major,
                      $scope.selectedVersion.minor)
                .then(function (newIds) {
                    $scope.page.pageId = newIds.pageId;
                    $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageId        = newIds.pageId;
                    $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageVersionId = newIds.pageVersionId;
                });
        };
        
        $scope.pushToStatus = function (newstatusId) {
            if(newstatusId) {
                pagesService
                    .pushToStatus($routeParams.pageId,
                                  $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageVersionId,
                                  newstatusId)
                    .then(function() {
                        return pagesService.getDetailsForVersion($routeParams.pageId,
                                                                 $scope.selectedVersion.major,
                                                                 $scope.selectedVersion.minor);
                    })
                    .then(function (pageVersion) {
                        // update everything
                        $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor] = pageVersion;
                    });
            }
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
                if(parseInt(majorVersion, 10) > newMajorVersion) {
                    newMajorVersion = parseInt(majorVersion, 10);
                }
            }
            
            ++newMajorVersion;
            
            $scope.selectedVersion.major = newMajorVersion;
            $scope.selectedVersion.minor = newMinorVersion;
            $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            $scope.page.availableVersions[newMajorVersion] = [];
            $scope.page.availableVersions[newMajorVersion][0] = newMinorVersion;
            
            $scope.page.versions[newMajorVersion] = {};
            $scope.page.versions[newMajorVersion][newMinorVersion] = structDeepCopy($scope.page.versions[ scv[0] ][ scv[1] ]);
            $scope.page.versions[newMajorVersion][newMinorVersion].content = []; // when we have a new major version we probably want to start from scratch
            
            updateNewVersionVariables(newMajorVersion, newMinorVersion);
        };
        
        $scope.addMinorVersion = function () {
            var scv = $scope.selectedCompleteVersion.split(".");
            var majorVersion = scv[0];
            
            var newMinorVersion = 0;
            for(var minorVersion in $scope.page.versions[majorVersion]) {
                if(parseInt(minorVersion, 10) > newMinorVersion) {
                    newMinorVersion = parseInt(minorVersion, 10);
                }
            }
            
            ++newMinorVersion;
            
            $scope.selectedVersion.minor = newMinorVersion;
            $scope.selectedCompleteVersion = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            $scope.page.availableVersions[majorVersion].push(newMinorVersion);
            
            $scope.page.versions[majorVersion][newMinorVersion] = structDeepCopy($scope.page.versions[ scv[0] ][ scv[1] ]);
            
            // update all status variables
            updateNewVersionVariables(majorVersion, newMinorVersion);
        };
        
        $scope.setVersion = function () {
            var scv = $scope.selectedCompleteVersion.split(".");
            var major = scv[0];
            var minor = scv[1];
            
            if(! $scope.page.versions[major] || ! $scope.page.versions[major][minor]) {
                pagesService
                    .getDetailsForVersion($routeParams.pageId,
                                          major,
                                          minor)
                    .then(function (pageVersion) {
                        if(! $scope.page.versions[major]) {
                            $scope.page.versions[major] = {};
                        }
                        
                        $scope.page.versions[major][minor] = pageVersion;
                        
                        $scope.selectedVersion.major = major;
                        $scope.selectedVersion.minor = minor;
                    });
            }
            else {
                $scope.selectedVersion.major = major;
                $scope.selectedVersion.minor = minor;
            }
        };
        
        $scope.isEditable = function () {
            if($scope.page) {
                return $scope.status[$scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].statusId].pagesAreEditable;
            }
            else {
                return false;
            }
        };
        
        $scope.isReadonly = function () {
            if($scope.page) {
                return ! $scope.status[$scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].statusId].pagesAreEditable;
            }
            else {
                return true;
            }
        };
        
        $scope.load();
    }]);