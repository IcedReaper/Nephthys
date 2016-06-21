nephthysAdminApp
    .service("serverSettingsService", function($http) {
        return {
            get: function () {
                return $http.get('/ajax/com/Nephthys/system/getSettings');
            },
            
            save: function (settings) {
                return $http.post('/ajax/com/Nephthys/system/saveSettings', {
                    settings: settings
                });
            },
            getModuleList: function () {
                return $http.get('/ajax/com/Nephthys/module/getList');
            }
        };
    });