nephthysAdminApp
    .service("userService", function($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/userManager/getList');
            },
            
            getDetails: function (userId) {
                return $http.get('/ajax/com/Nephthys/userManager/getDetails', {
                    params: {
                        userId: userId
                    }
                });
            },
            
            save: function (user) {
                return $http.post('/ajax/com/Nephthys/userManager/save', user);
            },
            
            delete: function (userId) {
                return $http.delete('/ajax/com/Nephthys/userManager/delete', {
                    params: {
                        userId: userId
                    }
                });
            },
            
            activate: function (userId) {
                return $http.post('/ajax/com/Nephthys/userManager/activate', {
                    userId: userId
                });
            },
            
            deactivate: function (userId) {
                return $http.post('/ajax/com/Nephthys/userManager/deactivate', {
                    userId: userId
                });
            },
            
            uploadAvatar: function (userId, avatar) {
                return Upload.upload({
                    url: '/ajax/com/Nephthys/userManager/uploadAvatar',
                    data: {
                        avatar: avatar,
                        userId: userId
                    }
                });
            },
            
            getPermissions: function (userId) {
                return $http.get('/ajax/com/Nephthys/userManager/getPermissions', {
                    params: {
                        userId: userId
                    }
                });
            },
            
            getRoles: function () {
                return $http.get('/ajax/com/Nephthys/userManager/getRoles');
            },
            
            savePermissions: function (userId, permissions) {
                return $http.post('/ajax/com/Nephthys/userManager/savePermissions', {
                    userId:      userId,
                    permissions: permissions
                });
            },
            
            getThemes: function () {
                return $http.get("/ajax/com/Nephthys/userManager/getThemes");
            },
            
            getExtProperties: function (userId) {
                return $http.get("/ajax/com/Nephthys/userManager/getExtProperties", {
                    params: {
                        userId: userId
                    }
                });
            },
            
            saveExtProperties: function (userId, extProperties) {
                return $http.post("/ajax/com/Nephthys/userManager/saveExtProperties", {
                    userId: userId,
                    extProperties: extProperties
                });
            },
            
            getPermissionsOfActualUser: function () {
                return $http.get("/ajax/com/Nephthys/userManager/getPermissionsOfActualUser");
            },
            
            getBlacklist: function () {
                return $http.get("/ajax/com/Nephthys/userManager/getBlacklist");
            },
            getBlacklistEntry: function (blacklistId) {
                return $http.get("/ajax/com/Nephthys/userManager/getBlacklistEntry", {
                    params: {
                        blacklistId: blacklistId
                    }
                });
            },
            saveBlacklistEntry: function (blacklist) {
                return $http.post("/ajax/com/Nephthys/userManager/saveBlacklistEntry", {
                    blacklist: blacklist
                });
            },
            deleteBlacklistEntry: function (blacklistId) {
                return $http.delete("/ajax/com/Nephthys/userManager/deleteBlacklistEntry", {
                    params: {
                        blacklistId: blacklistId
                    }
                });
            }
        };
    });