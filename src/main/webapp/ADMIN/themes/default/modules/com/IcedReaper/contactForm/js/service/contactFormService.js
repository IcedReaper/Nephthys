nephthysAdminApp
    .service("contactFormService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/contactForm/getList');
            },
            
            getReplies: function (requestId) {
                return $http.get('/ajax/com/IcedReaper/contactForm/getReplies', {
                    params: {
                        requestId: requestId
                    }
                });
            },
            
            getDetails: function (requestId) {
                return $http.get('/ajax/com/IcedReaper/contactForm/getDetails', {
                    params: {
                        requestId: requestId
                    }
                });
            },
            
            reply: function (requestId, message) {
                return $http.post('/ajax/com/IcedReaper/contactForm/reply', {
                    requestId: requestId,
                    message: message
                });
            }
        };
    });