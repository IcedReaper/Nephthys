(function(angular) {
    angular.module("themeAdminService", [])
        .config(window.$QDecorator)
        .service("themeService", function ($http, Upload, $timeout) {
            return {
                getList: function () {
                    return $http.get('/ajax/com/Nephthys/theme/getList');
                },
                
                getDetails: function (themeId) {
                    return $http.get('/ajax/com/Nephthys/theme/getDetails', {
                        params: {
                            themeId: themeId
                        }
                    });
                },
                
                save: function (theme) {
                    return $http.post('/ajax/com/Nephthys/theme/save', theme);
                },
                
                createTheme: function (file, theme) {
                    return Upload.upload({
                        url: '/ajax/com/Nephthys/theme/save',
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
                    return $http.delete('/ajax/com/Nephthys/theme/delete', {
                        params: {
                            themeId: themeId
                        }
                    });
                },
                
                activate: function (themeId) {
                    return $http.post('/ajax/com/Nephthys/theme/activate', {
                        themeId: themeId
                    });
                },
                
                deactivate: function (themeId) {
                    return $http.post('/ajax/com/Nephthys/theme/deactivate', {
                        themeId: themeId
                    });
                }
            };
        });
}(window.angular));