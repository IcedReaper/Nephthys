component {
    this.name = "Nephthys_Admin";
    
    this.sessionmanagement = true;
    this.sessionTimeout    = createTimespan(0, 1, 0, 0);
    
    this.datasource = "nephthys_admin";
    
    public boolean function onApplicationStart() {
        // components
        application.system.settings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        application.security.loginHandler = createObject("component", "API.com.Nephthys.controller.security.loginHandler").init();
        
        application.tools.formatter = createObject("component", "API.com.Nephthys.controller.tools.formatter").init();
        application.tools.validator = createObject("component", "API.com.Nephthys.controller.tools.validator").init();
        
        return true;
    }
    
    public boolean function onSessionStart() {
        session.userId = 0;
        
        return true;
    }
    
    public boolean function onRequestStart(required string targetPage) {
        request.requestType = "";
        
        switch(right(arguments.targetPage, 3)) {
            case 'cfm': {
                if(structKeyExists(url, "restart")) {
                    onApplicationStart();
                }
                request.requestType = "cfm";
                
                if(checkIfLoggedIn()) {
                    if(url.moduleName == '' || url.moduleName == 'com.Nephthys.login') {
                        location(addtoken = false, statuscode = "302", url = "/com.Nephthys.dashboard");
                    }
                }
                else {
                    if(url.moduleName == '' || url.moduleName != "com.Nephthys.login") {
                        location(addtoken = false, statuscode = "302", url = "/com.Nephthys.login");
                    }
                }
                
                request.moduleController = getTargetModule(url.moduleName);
                
                break;
            }
            case 'cfc': {
                if(checkIfLoggedIn()) {
                    request.requestType = "cfc";
                    
                    // implement a check if the 
                    var callInformation = getHttpRequestData();
                    if(structKeyExists(callInformation.headers, "x-framework") && callInformation.headers['x-framework'] == 'angularJs') {
                        // angular $http calls doesn't work as jQuery post calls. The Parameter are in a JSON format and will neither appear in the arguments nor in the form scope. So we have to move them there.
                        var requestBody = toString(callInformation.content);
                        if(isJSON(requestBody)) {
                            form.append(deserializeJSON(requestBody));
                        }
                    }
                    break;
                }
                else {
                    throw(type = "nephthys.notFound.page", message = "Page not found");
                }
            }
            default: {
                // to check...
            }
        }
        
        return true;
    }
    
    public void function onError(required any exception) {
        try {
            // convert some error into a different shape
            if(arguments.exception.type == "Database" && arguments.exception.SQLState == 23505) {
                arguments.exception.type    = "nephthys.application.alreadyExists";
                arguments.exception.message = "Primary Key violation while creating/updating";
            }
            
            var errorHandler = createObject("component", "API.com.Nephthys.controller.error.errorHandler").init();
            errorHandler.setException(arguments.exception)
                        .save();
            
            switch(request.requestType) {
                case "cfc": {
                    writeOutput(serializeJSON({
                            "success"      = false,
                            "errorMessage" = arguments.exception.message,
                            "type"         = arguments.exception.type,
                            "detail"       = arguments.exception.detail,
                            "stacktrace"   = arguments.exception.stacktrace
                        }));
                    header statuscode="500" statustext=arguments.exception.message;
                    break;
                }
                default: {
                    // get theme
                    var themeFoldername = "";
                    if(structKeyExists(request, "user")) {
                        themeFoldername = request.user.getTheme().getFolderName();
                    }
                    else {
                        if(structKeyExists(application, "system") && structKeyExists(application.system, "settings")) {
                            themeFoldername = application.system.settings.getTheme().getFolderName();
                        }
                        else {
                            throw(type = "nephthys.critical.installation", message = "Neither the user nor the system settings are defined!");
                        }
                    }
                    errorHandler.setThemePath("/ADMIN/themes/" & themeFoldername)
                                .show();
                    
                    break;
                }
            }
        }
        catch(any e) {
            // to be removed!!!
            writeDump(var=e, label="critical error");
        }
    }
    
    private boolean function checkIfLoggedIn() {
        request.user = createObject("component", "API.com.Nephthys.classes.user.user").init(session.userId);
        
        if(session.userId == 0) {
            if(! structIsEmpty(form) && /* referer == loginForm */ true) {
                var userId = application.security.loginHandler.loginUser(form.username, form.password);
                if(userId != 0 && userId != null) {
                    session.userId = userId; // todo...
                    return true;
                }
            }
            
            return false;
        }
        else {
            if(structKeyExists(url, "logout") || ! application.security.loginHandler.checkForUser(session.userId)) {
                session.userId = 0;
                return false;
            }
            else {
                if(request.user.getActiveStatus() == 0) {
                    session.userId = 0;
                    return false;
                }
                
                return true;
            }
        }
    }
    
    private connector function getTargetModule(required string moduleName) {
        return createObject("component", "modules." & arguments.moduleName & ".connector").init();
    }
}