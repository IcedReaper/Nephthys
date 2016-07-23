nephthysAdminApp
    .controller('pagesDetailCtrl', ["$scope", "$routeParams", "$route", "$q", "pagesService", function ($scope, $routeParams, $route, $q, pagesService) {
        var _actualUser,
            
            getStartStatus = function () {
                for(var status in $scope.status) {
                    return $scope.status[status].statusId;
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
                }
            },
            loadVersion = function (majorVersion, minorVersion) {
                if(! $scope.page.versions[majorVersion] || ! $scope.page.versions[majorVersion][minorVersion]) {
                    pagesService
                        .getDetailsForVersion($routeParams.pageId,
                                              majorVersion,
                                              minorVersion)
                        .then(function (pageVersion) {
                            if(! $scope.page.versions[majorVersion]) {
                                $scope.page.versions[majorVersion] = {};
                            }
                            
                            $scope.page.versions[majorVersion][minorVersion] = pageVersion;
                            
                            $scope.selectedVersion.major = majorVersion;
                            $scope.selectedVersion.minor = minorVersion;
                        });
                }
                else {
                    $scope.selectedVersion.major = majorVersion;
                    $scope.selectedVersion.minor = minorVersion;
                }
            };
        
        $scope.load = function () {
            $q.all([
                pagesService.getDetails($routeParams.pageId),
                pagesService.getStatus(),
                pagesService.getModule(),
                pagesService.getActualUser()
            ])
            .then($q.spread(function (pageDetails, status, module, actualUser) {
                $scope.page   = pageDetails;
                $scope.status = status;
                $scope.module = module;
                
                $scope.selectedVersion.major    = pageDetails.actualVersion.major;
                $scope.selectedVersion.minor    = pageDetails.actualVersion.minor;
                $scope.selectedVersion.complete = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
                
                _actualUser = actualUser;
                
                if($scope.versionSpecified) {
                    loadVersion($routeParams.majorVersion, $routeParams.minorVersion);
                }
            }));
        };
        
        $scope.save = function () {
            pagesService
                .save($scope.page.pageId,
                      $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor],
                      $scope.selectedVersion.major,
                      $scope.selectedVersion.minor)
                .then(function (newIds) {
                    if($scope.page.pageId != newIds.pageId) {
                        $scope.page.pageId = newIds.pageId;
                        
                        $route.updateParams({
                            pageId: newIds.pageId
                        });
                    }
                    
                    $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageId        = newIds.pageId;
                    $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageVersionId = newIds.pageVersionId;
                });
        };
        
        $scope.pushToStatus = function (newStatusId) {
            if(newStatusId) {
                pagesService
                    .pushToStatus($routeParams.pageId,
                                  $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].pageVersionId,
                                  newStatusId)
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
            var scv = $scope.selectedVersion.complete.split(".");
            
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
            $scope.selectedVersion.complete = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            $scope.page.availableVersions[newMajorVersion] = [];
            $scope.page.availableVersions[newMajorVersion][0] = newMinorVersion;
            
            $scope.page.versions[newMajorVersion] = {};
            $scope.page.versions[newMajorVersion][newMinorVersion] = structDeepCopy($scope.page.versions[ scv[0] ][ scv[1] ]);
            $scope.page.versions[newMajorVersion][newMinorVersion].content = []; // when we have a new major version we probably want to start from scratch
            
            updateNewVersionVariables(newMajorVersion, newMinorVersion);
        };
        
        $scope.addMinorVersion = function () {
            var scv = $scope.selectedVersion.complete.split(".");
            var majorVersion = scv[0];
            
            var newMinorVersion = 0;
            for(var minorVersion in $scope.page.versions[majorVersion]) {
                if(parseInt(minorVersion, 10) > newMinorVersion) {
                    newMinorVersion = parseInt(minorVersion, 10);
                }
            }
            
            ++newMinorVersion;
            
            $scope.selectedVersion.minor = newMinorVersion;
            $scope.selectedVersion.complete = $scope.selectedVersion.major + '.' + $scope.selectedVersion.minor;
            $scope.page.availableVersions[majorVersion].push(newMinorVersion);
            
            $scope.page.versions[majorVersion][newMinorVersion] = structDeepCopy($scope.page.versions[ scv[0] ][ scv[1] ]);
            
            // update all status variables
            updateNewVersionVariables(majorVersion, newMinorVersion);
        };
        
        $scope.setVersion = function () {
            var scv = $scope.selectedVersion.complete.split(".");
            var major = scv[0];
            var minor = scv[1];
            
            loadVersion(major, minor);
        };
        
        $scope.isEditable = function () {
            if($scope.page && ! structIsEmpty($scope.page)) {
                return $scope.status[$scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].statusId].editable;
            }
            else {
                return false;
            }
        };
        
        $scope.isReadonly = function () {
            return ! $scope.isEditable();
        };
        
        $scope.getStatisticsChartType = function () {
            if(! structIsEmpty($scope.page)) {
                if($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].useDynamicUrlSuffix) {
                    return "line";
                }
            }
            return "bar";
        };
        
        $scope.getStatisticsRequestType = function () {
            if(! structIsEmpty($scope.page)) {
                if($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].useDynamicUrlSuffix) {
                    return "splitPerPage";
                }
            }
            return "total";
        };
        
        $scope.$watch(function () {
            if($scope.page.versions) {
                return {
                    content: $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].content
                };
            }
        }, function(newValues, oldValues) {
            if($scope.page.versions) {
                var searchSub = function(subElements) {
                    for(var i = 0; i < subElements.length; ++i) {
                        if($scope.module[ subElements[i].type ].useDynamicUrlSuffix) {
                            return true;
                        }
                        
                        if(searchSub(subElements[i].children)) {
                            return true;
                        }
                    }
                    
                    return false;
                };
                
                $scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].useDynamicUrlSuffix = searchSub($scope.page.versions[$scope.selectedVersion.major][$scope.selectedVersion.minor].content);
            }
        }, true);
        
        // init values
        $scope.page = {};
        $scope.status = {};
        $scope.availableSubModules = {};
        $scope.availableOptions = {};
        $scope.selectedVersion = {
            major: 1,
            minor: 0,
            complete: "1.0"
        };
        $scope.pageId = $routeParams.pageId;
        
        $scope.load();
        
        $scope.versionSpecified = false;
        if($routeParams.majorVersion && $routeParams.minorVersion !== undefined) {
            $scope.versionSpecified = true;
        }
    }]);