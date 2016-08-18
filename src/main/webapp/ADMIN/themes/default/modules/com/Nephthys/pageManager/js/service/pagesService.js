nephthysAdminApp
    .service("pagesService", function($http) {
        return {
            getList: function () {
                return $http.get('/ajax/com/Nephthys/pageManager/getList');
            },
            
            getDetails: function (pageId) {
                return $http.get('/ajax/com/Nephthys/pageManager/getDetails', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            save: function (pageId, pageVersion, majorVersion, minorVersion) {
                return $http.post('/ajax/com/Nephthys/pageManager/save', {
                    pageId: pageId,
                    pageVersion: pageVersion,
                    majorVersion: majorVersion,
                    minorVersion: minorVersion
                });
            },
            
            pushToStatus: function (pageId, pageVersionId, statusId) {
                return $http.post('/ajax/com/Nephthys/pageManager/pushToStatus', {
                    pageId:        pageId,
                    pageVersionId: pageVersionId,
                    statusId:  statusId
                });
            },
            
            delete: function (pageId) {
                return $http.delete('/ajax/com/Nephthys/pageManager/delete', {
                    params: {
                        pageId: pageId
                    }
                });
            },
            
            getStatus: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getStatusList");
            },
            
            getModule: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getModule");
            },
            
            getActualUser: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getActualUser");
            },
            
            getDetailsForVersion: function (pageId, majorVersion, minorVersion) {
                return $http.get("/ajax/com/Nephthys/pageManager/getDetailsForVersion", {
                    params: {
                        pageId:       pageId,
                        majorVersion: majorVersion,
                        minorVersion: minorVersion
                    }
                });
            },
            
            getSitemap: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/getSitemap");
            },
            addSitemapVersion: function () {
                return $http.get("/ajax/com/Nephthys/pageManager/addSitemapVersion");
            },
            saveSitemap: function (sitemap) {
                return $http.post("/ajax/com/Nephthys/pageManager/saveSitemap", {
                    sitemap: sitemap
                });
            },
            
            pushSitemapToStatus: function (sitemapId, statusId) {
                return $http.post('/ajax/com/Nephthys/pageManager/pushSitemapToStatus', {
                    sitemapId: sitemapId,
                    statusId:  statusId
                });
            }
        };
    });