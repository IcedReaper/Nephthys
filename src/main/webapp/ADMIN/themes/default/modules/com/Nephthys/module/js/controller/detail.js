nephthysAdminApp
    .controller('detailCtrl', ["$scope", "$routeParams", "$q", "moduleService", function ($scope, $routeParams, $q, moduleService) {
        var addedSubModules = [];
        var removedSubModules = [];
        var originalSubModules = [];
        var setOriginalSubModules = function () {
            for(var i = 0; i < $scope.subModules.length; ++i) {
                originalSubModules.push($scope.subModules[i]);
            }
        };
        
        $scope.load = function () {
            $q.all([
                   moduleService.getDetails($routeParams.moduleId),
                   moduleService.getOptions($routeParams.moduleId),
                   moduleService.getSubModules($routeParams.moduleId),
                   moduleService.getUnusedSubModules($routeParams.moduleId)
              ])
              .then($q.spread(function (moduleDetails, options, subModules, unusedSubModules) {
                    $scope.module                 = moduleDetails.data;
                    $scope.options                = options;
                    $scope.subModules             = subModules;
                    $scope.unusedSubModules       = unusedSubModules;
                    
                    originalSubModules = [];
                    setOriginalSubModules();
              }));
        };
        
        
        $scope.save = function () {
            $q.all([
                   moduleService.save($scope.module),
                   moduleService.addSubModules($routeParams.moduleId, addedSubModules),
                   moduleService.removeSubModules($routeParams.moduleId, removedSubModules)
              ])
              .then($q.spread(function (save, added, removed) {
                  addedSubModules   = [];
                  removedSubModules = [];
                  
                  setOriginalSubModules();
              }));
        };
        
        $scope.addSubModule = function() {
            $scope.unusedSubModules.splice($scope.unusedSubModules.indexOf($scope.newModule.name), 1);
            
            if(originalSubModules.indexOf($scope.newModule.name) === -1) {
                addedSubModules.push($scope.newModule.name);
            }
            
            removedSubModules.splice($scope.newModule.name, 1);
            
            $scope.subModules.push($scope.newModule.name);
            $scope.newModule.name = "";
        };
        
        $scope.removeSubModule = function (index) {
            var moduleName = $scope.subModules.splice(index, 1)[0];
            $scope.unusedSubModules.push(moduleName);
            
            if(originalSubModules.indexOf(moduleName) !== -1) {
                removedSubModules.push(moduleName);
            }
            
            addedSubModules.splice(addedSubModules.indexOf(moduleName), 1);
        };
        
        $scope.load();
        $scope.newModule = {
            name: ""
        };
    }]);