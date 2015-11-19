(function(angular) {
    angular.module("serverSettingsAdminService", [])
        .config(window.$QDecorator)
        .service("serverSettingsService", function($http) {
            return {
                getDetails: function () {
                    return $http.get('/ajax/com/Nephthys/serverSettings/getDetails');
                },
                
                save: function (serverSettings) {
                    return $http.post('/ajax/com/Nephthys/serverSettings/save', serverSettings);
                },
                
                getEncryptionMethods: function() {
                    return $http.get('/ajax/com/Nephthys/serverSettings/getEncryptionMethods');
                }
            };
        });
}(window.angular));