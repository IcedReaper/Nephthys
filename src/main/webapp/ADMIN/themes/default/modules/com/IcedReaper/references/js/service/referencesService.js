nephthysAdminApp
    .service("referencesService", function($http, Upload) {
        return {
            getList: function () {
                return $http.get('/ajax/com/IcedReaper/references/getList');
            },
            
            getDetails: function (referenceId) {
                return $http.get('/ajax/com/IcedReaper/references/getDetails', {
                    params: {
                        referenceId: referenceId
                    }
                });
            },
            
            save: function (reference) {
                return Upload.upload({
                    url: '/ajax/com/IcedReaper/references/save',
                    data: {
                        referenceId: reference.referenceId,
                        newImage:    reference.newImage,
                        name:        reference.name,
                        homepage:    reference.homepage,
                        quote:       reference.quote,
                        since:       reference.since.toAjaxFormat()
                    }
                });
            }
        };
    });