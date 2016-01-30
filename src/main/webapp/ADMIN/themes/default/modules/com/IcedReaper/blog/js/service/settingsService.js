nephthysAdminApp
    .service("settingsService", function($http, Upload) {
        return {
            get: function () {
                return $http.get('/ajax/com/IcedReaper/blog/getSettings');
            },
            
            save: function (settings) {
                return $http.post('/ajax/com/IcedReaper/blog/saveSettings', {
                    settings: JSON.stringify(settings)
                });
            }
        };
    });