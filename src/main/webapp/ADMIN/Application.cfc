component {
    import "API.modules.com.Nephthys.userManager.user";
    import "API.modules.com.Nephthys.system.settings";
    import "API.modules.com.Nephthys.themeManager.theme";
    
    this.name = "Nephthys_Admin";
    
    this.sessionmanagement = true;
    this.sessionTimeout    = createTimespan(0, 1, 0, 0);
    
    this.datasource = "nephthys_admin";
    
    public boolean function onApplicationStart() {
        if(directoryExists(expandPath("install"))) {
            return false;
        }
        
        if(! server.keyExists("startupTime")) {
            server.startupTime = now();
        }
        
        application.system.settings = new settings("ADMIN,NULL");
        application.system.settings.load();
        
        return true;
    }
    
    public boolean function onSessionStart() {
        session.userId = null;
        
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
                        .save(request.user);
            
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
                        themeFoldername = request.user.getTheme().getFolderName();
                    }
                    else {
                        if(application.keyExists("system") && application.system.keyExists("settings")) {
                            themeFoldername = new theme(application.system.settings.getValueOfKey("defaultThemeId")).getFolderName();
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
            writeDump(var=e, label="critical error");
        }
    }
    
    private boolean function checkIfLoggedIn() {
        request.user = new user(session.userId);
        
        if(session.userId == null) {
            if(! structIsEmpty(form) && checkReferer("com.Nephthys.login")) {
                var userId = application.system.settings.getValueOfKey("authenticator").login(form.username, form.password);
                if(userId != null) {
                    session.userId = userId;
                    return true;
                }
            }
            
            return false;
        }
        else {
            if(url.keyExists("logout") || ! request.user.getStatus().getCanLogin()) {
                session.userId = null;
                return false;
            }
            else {
                return true;
            }
        }
    }
    
    private connector function getTargetModule(required string moduleName) {
        var moduleConnector = "modules." & arguments.moduleName & ".connector";
        moduleConnector = moduleConnector.replace(".", "/", "ALL");
        moduleConnector &= ".cfc";
        
        if(fileExists(expandPath(moduleConnector))) {
            return createObject("component", "modules." & arguments.moduleName & ".connector").init();
        }
        else {
            throw(type = "404", message = "Could not find the connector for module " & arguments.moduleName);
        }
    }
    
    private boolean function checkReferer(required string refererModule) {
        return reReplace(cgi.referer, "https?:\/\/" & cgi.http_host & "\/" & arguments.refererModule, "") == "";
    }
}