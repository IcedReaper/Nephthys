nephthysAdminApp
    .controller('teamOverviewCtrl', ["$scope", "$q", "teamOverviewService", function ($scope, $q, teamOverviewService) {
        var setMember = function(member) {
            $scope.teamMember = member;
        };
        var setRemainingUser = function(user) {
            $scope.remainingUser = user;
        };
        
        $scope.reloadAll = function() {
            $q.all([
                teamOverviewService.loadMember(),
                teamOverviewService.loadRemainingUser()
            ])
            .then($q.spread(function (member, user) {
                setMember(member);
                setRemainingUser(user);
            }));
        };
        
        $scope.reloadMember = function () {
            teamOverviewService
                .loadMember()
                .then(setMember);
        };
        
        $scope.reloadRemainingUser = function () {
            teamOverviewService
                .loadRemainingUser()
                .then(setRemainingUser);
        };
        
        $scope.addUser = function () {
            if($scope.newUserId !== 0) {
                teamOverviewService
                    .addUser($scope.newUserId)
                    .then(function () {
                        $scope.newUserId = 0;
                    })
                    .then($scope.reloadAll);
            }
        };
        
        $scope.removeUser = function (userId) {
            if(userId) {
                teamOverviewService
                    .removeUser(userId)
                    .then($scope.reloadAll);
            }
        };
        
        $scope.removeMember = function (memberId) {
            if(memberId) {
                teamOverviewService
                    .removeMember(memberId)
                    .then($scope.reloadAll);
            }
        };
        
        $scope.sortUp = function (memberId) {
            if(memberId) {
                teamOverviewService
                    .sortUp(memberId)
                    .then($scope.reloadMember);
            }
        };
        
        $scope.sortDown = function (memberId) {
            if(memberId) {
                teamOverviewService
                    .sortDown(memberId)
                    .then($scope.reloadMember);
            }
        };
        
        $scope.newUserId = 0;
        $scope.teamMember = [];
        $scope.remainingUser = [];
        
        $scope.reloadAll();
    }]);