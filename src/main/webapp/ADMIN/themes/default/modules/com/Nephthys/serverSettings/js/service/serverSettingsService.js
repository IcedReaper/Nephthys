(function(angular) {
    angular.module("serverSettingsAdminService", [])
        .config(window.$QDecorator)
        .service("serverSettingsService", function($http) {
            return {
                get: function () {
                    return $http.get('/ajax/com/Nephthys/serverSettings/getSettings');
                },
                
                save: function (settings) {
                    return $http.post('/ajax/com/Nephthys/serverSettings/saveSettings', {
                        settings: JSON.stringify(settings)
                    });
                }
                /*,
                
                getEncryptionMethods: function() {
                    return $http.get('/ajax/com/Nephthys/serverSettings/getEncryptionMethods');
                }*/
            };
        });
}(window.angular));