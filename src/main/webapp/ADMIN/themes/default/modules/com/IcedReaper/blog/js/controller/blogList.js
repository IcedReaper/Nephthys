nephthysAdminApp
    .controller('blogListCtrl', ["$scope", "$q", "blogService", function ($scope, $q, blogService) {
        $scope.delete = function (blogpostId) {
            blogService
                .delete(blogpostId)
                .then($scope.refresh);
        }
        
        $scope.refresh = function () {
            $q.all([
                blogService.getList(),
                blogService.getStatus()
            ])
            .then($q.spread(function (blogposts, status) {
                $scope.blogposts = blogposts;
                $scope.status    = status;
            }));
        };
        
        $scope.pushToStatus = function (blogpostId, newStatusId) {
            if(blogpostId && newStatusId) {
                blogService
                    .pushToStatus(blogpostId,
                                  newStatusId)
                    .then($scope.refresh);
            }
        };
        
        $scope.statusButtonClass = function (actualOnline, nextOnline) {
            if(! actualOnline && nextOnline) {
                return "btn-success";
            }
            if(actualOnline && ! nextOnline) {
                return "btn-danger";
            }
            if(! actualOnline && ! nextOnline) {
                return "btn-primary";
            }
            if(actualOnline && nextOnline) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
        $scope.blogposts = [];
        $scope.search = {
            released: ''
        };
        $scope.refresh();
    }]);