var globalAngularAjaxSettings = function($httpProvider) {
    var activeAjaxCalls = 0;
    $httpProvider.defaults.headers.post = {"x-framework": "angularJs"};
    
    $httpProvider.interceptors.push(function ($rootScope, $q, $timeout) {
        var isServiceCall = function (config) {
            return ! (config.url.match(/^\/themes/) || config.url.match(/^[^\/]/));
        }
        
        return {
            "request": function(config) {
                if(isServiceCall(config)) {
                    if(++activeAjaxCalls === 1) {
                        console.log("show loading screen");
                    }
                    
                    if(activeAjaxCalls === 0) {
                        $rootScope.message = undefined;
                    }
                }
                
                return config;
            },
            "requestError": function (rejection) { // check if needed.
                console.log("requestError", rejection);
                
                return $q.reject(rejection);
            },
            
            "response": function (response) {
                if(! isServiceCall(response.config)) {
                    return response;
                }
                else {
                    if(--activeAjaxCalls === 0) {
                        // hide loading screen
                        console.log("hide loading screen");
                    }
                    
                    switch(response.config.method) {
                        case "POST":
                        case "DELETE": {
                            var action = "Speichern";
                            if(response.config.method === "DELETE") {
                                action = "Löschen";
                            }
                            
                            $rootScope.message = {
                                "type":     "success",
                                "headline": action + " war erfolgreich",
                                "text":     "Das  " + action + " war erfolgreich"
                            };
                            
                            $timeout(function() {
                                $rootScope.message = null;
                            }, 1000);
                            break;
                        }
                    }
                    
                    $rootScope.$emit('session-refreshed', {});
                    
                    return response.data;
                }
            },
            
            "responseError": function (rejection) {
                if(isServiceCall(rejection.config)) {
                    if(--activeAjaxCalls === 0) {
                        // hide loading screen
                        console.log("hide loading screen");
                    }
                    
                    var action = "unbekannte Aktion";
                    switch(rejection.config.method) {
                        case "POST": {
                            action = "Speichern";
                            break;
                        }
                        case "GET": {
                            action = "Laden";
                            break;
                        }
                        case "DELETE": {
                            action = "Löschen";
                            break;
                        }
                    }
                    
                    $rootScope.message = {
                        "type":         "danger",
                        "headline":     "Fehler beim " + action,
                        "text":         "Beim " + action + " ist ein Fehler aufgetaucht!",
                        "errorMessage": rejection.data.type + " - " + rejection.data.errorMessage
                    };
                    
                    return $q.reject({});
                }
                else {
                    return $q.reject(rejection);
                }
            }
        };
    });
};