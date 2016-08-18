nephthysAdminApp
    .service("themeService", function ($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/themeManager/getList');
            },
            
            getDetails: function (themeId) {
                return $http.get('/ajax/com/Nephthys/themeManager/getDetails', {
                    params: {
                        themeId: themeId
                    }
                });
            },
            
            save: function (theme) {
                return $http.post('/ajax/com/Nephthys/themeManager/save', theme);
            },
            
            createTheme: function (file, theme) {
                return Upload.upload({
                    url: '/ajax/com/Nephthys/themeManager/save',
                    data: {
                        file:       file,
                        themeId:    theme.themeId,
                        foldername: theme.foldername,
                        active:     theme.active,
                        name:       theme.name
                    },
                });
            },
            
            delete: function (themeId) {
                return $http.delete('/ajax/com/Nephthys/themeManager/delete', {
                    params: {
                        themeId: themeId
                    }
                });
            },
            
            activate: function (themeId) {
                return $http.post('/ajax/com/Nephthys/themeManager/activate', {
                    themeId: themeId
                });
            },
            
            deactivate: function (themeId) {
                return $http.post('/ajax/com/Nephthys/themeManager/deactivate', {
                    themeId: themeId
                });
            }
        };
    });