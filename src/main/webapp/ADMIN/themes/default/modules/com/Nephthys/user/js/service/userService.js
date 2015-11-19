(function(angular) {
    angular.module("userAdminService", [])
        .config(window.$QDecorator)
        .service("userService", function($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/Nephthys/user/getList');
                },
                
                getDetails: function (userId) {
                    return $http.get('/ajax/com/Nephthys/user/getDetails', {
                        params: {
                            userId: userId
                        }
                    });
                },
                
                getPermissions: function (userId) {
                    return $http.get('/ajax/com/Nephthys/user/getPermissions', {
                        params: {
                            userId: userId
                        }
                    });
                },
                
                getPermissionList: function () {
                    return $http.get('/ajax/com/Nephthys/user/getPermissionList');
                },
                
                save: function (user) {
                    return $http.post('/ajax/com/Nephthys/user/save', user);
                },
                
                delete: function (userId) {
                    return $http.delete('/ajax/com/Nephthys/user/delete', {
                        userId: userId
                    });
                },
                
                activate: function (userId) {
                    return $http.post('/ajax/com/Nephthys/user/activate', {
                        userId: userId
                    });
                },
                
                deactivate: function (userId) {
                    return $http.post('/ajax/com/Nephthys/user/deactivate', {
                        userId: userId
                    });
                },
                
                uploadAvatar: function (userId, avatar) {
                    return Upload.upload({
                        url: '/ajax/com/Nephthys/user/uploadAvatar',
                        data: {
                            avatar: avatar,
                            userId: userId
                        },
                    });
                }
            };
        });
}(window.angular));