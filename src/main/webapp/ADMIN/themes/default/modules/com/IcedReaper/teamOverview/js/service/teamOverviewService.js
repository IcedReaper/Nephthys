nephthysAdminApp
    .service("teamOverviewService", function($http) {
        return {
            loadMember: function() {
                return $http.get('/ajax/com/IcedReaper/teamOverview/getMember');
            },
            
            loadRemainingUser: function() {
                return $http.get('/ajax/com/IcedReaper/teamOverview/getRemainingUser');
            },
            
            addUser: function(userId) {
                return $http.post('/ajax/com/IcedReaper/teamOverview/addUser', {
                    userId: userId
                });
            },
            
            removeUser: function(userId) {
                return $http.delete('/ajax/com/IcedReaper/teamOverview/removeUser', {
                    params: {
                        userId: userId
                    }
                });
            },
            
            removeMember: function(memberId) {
                return $http.delete('/ajax/com/IcedReaper/teamOverview/removeMember', {
                    params: {
                        memberId: memberId
                    }
                });
            },
            
            sortUp: function(memberId) {
                return $http.post('/ajax/com/IcedReaper/teamOverview/sortUp', {
                    memberId: memberId
                });
            },
            
            sortDown: function(memberId) {
                return $http.post('/ajax/com/IcedReaper/teamOverview/sortDown', {
                    memberId: memberId
                });
            }
        }
    });