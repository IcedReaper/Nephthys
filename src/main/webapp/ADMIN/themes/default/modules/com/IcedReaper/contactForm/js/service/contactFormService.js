nephthysAdminApp
    .service("contactFormService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/contactForm/getList');
            },
            
            getReplies: function (contactRequestId) {
                return $http.get('/ajax/com/IcedReaper/contactForm/getReplies', {
                    params: {
                        contactRequestId: contactRequestId
                    }
                });
            },
            
            getDetails: function (contactRequestId) {
                return $http.get('/ajax/com/IcedReaper/contactForm/getDetails', {
                    params: {
                        contactRequestId: contactRequestId
                    }
                });
            },
            
            reply: function (contactRequestId, message) {
                return $http.post('/ajax/com/IcedReaper/contactForm/reply', {
                    contactRequestId: contactRequestId,
                    message: message
                });
            }
        };
    });