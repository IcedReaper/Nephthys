component {
    this.name = "Nephthys_Admin";
    
    this.sessionmanagement = true;
    this.sessionTimeout    = createTimespan(0, 1, 0, 0);
    
    this.datasource = "nephthys_admin";
    
    public boolean function onApplicationStart() {
        // components
        application.system.settings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        application.system.settings.load();
        
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
                if(url.keyExists("restart")) {
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
                
                if(! request.moduleController.checkPermission(request.user)) {
                    throw(type = "nephthys.application.insufficientPermissions", message = "You do not have sufficient permissions to use this module", detail = request.moduleController.getName());
                }
                
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
            
            var errorLogger = application.system.settings.getValueOfKey("errorLogger");
            errorLogger.setException(arguments.exception)
                        .save();
            
            switch(request.requestType) {
                case "cfc": {
                    writeOutput(serializeJSON({
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
                    if(request.keyExists("user")) {
                        themeFoldername = request.user.getAdminTheme().getFolderName();
                    }
                    else {
                        if(application.keyExists("system") && application.system.keyExists("settings")) {
                            themeFoldername = createObject("component", "API.modules.com.Nephthys.theme.theme").init(application.system.settings.getValueOfKey("defaultAdminThemeId")).getFolderName();
                        }
                        else {
                            throw(type = "nephthys.critical.installation", message = "Neither the user nor the system settings are defined!");
                        }
                    }
                    errorLogger.setThemePath("/ADMIN/themes/" & themeFoldername)
                               .show();
                    
                    break;
                }
            }
        }
        catch(any e) {
            // TODO: to be removed!!!
            writeDump(var=e, label="critical error");
        }
    }
    
    private boolean function checkIfLoggedIn() {
        request.user = createObject("component", "API.modules.com.Nephthys.user.user").init(session.userId);
        
        if(session.userId == 0) {
            if(! structIsEmpty(form) && checkReferer("com.Nephthys.login")) {
                var userId = application.system.settings.getValueOfKey("authenticator").login(form.username, form.password);
                if(userId != 0 && userId != null) {
                    session.userId = userId;
                    return true;
                }
            }
            
            return false;
        }
        else {
            if(url.keyExists("logout") || ! request.user.isActive()) {
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
    
    private boolean function checkReferer(required string refererModule) {
        return reReplace(cgi.referer, "https?:\/\/" & cgi.http_host & "\/" & arguments.refererModule, "") == "";
    }
}