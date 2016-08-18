component {
    import "API.modules.com.Nephthys.userManager.user";
    import "API.modules.com.Nephthys.system.settings";
    import "API.modules.com.Nephthys.pageManager.pageRequest";
    import "API.modules.com.Nephthys.themeManager.theme";
    
    this.name = "Nephthys";
    
    this.datasource = "nephthys_user";
    
    public boolean function onApplicationStart() {
        if(directoryExists(expandPath("install"))) {
            return false;
        }
        
        if(! server.keyExists("startupTime")) {
            server.startupTime = now();
        }
        
        application.system.settings = new settings("WWW,NULL");
        application.system.settings.load();
        
        return true;
    }
    
    public boolean function onSessionStart() {
        session.userId = null;
        
        return true;
    }
    
    public boolean function onRequestStart(required string targetPage) {
        request.requestType = "";
        
        var callInformation = getHttpRequestData();
        if(url.keyExists("restart")) {
            if(callInformation.headers.keyExists("x-restart") && 
               callInformation.headers["x-restart"] == "systemSettings") {
                reloadSystemSettings();
                
                writeOutput("restart successful");
                return false;
            }
            else { // remove or make only available after update of system
                onApplicationStart();
            }
        }
        
        checkIfLoggedIn();
        
        switch(lcase(right(arguments.targetPage, 3))) {
            case "cfm": {
                if(! application.system.settings.getValueOfKey("active")) {
                    include template = "themes/" & request.user.getTheme().getFolderName() & "/offline.cfm";
                    abort;
                }
                
                if(! application.system.settings.getValueOfKey("maintenanceMode")) {
                    request.requestType = "cfm";
                    
                    if(! url.keyExists("pageLink")) {
                        url.pageLink = "/";
                    }
                    
                    request.page = new pageRequest(url.pageLink);
                    if(request.page.isOnline() || request.page.isPreview()) {
                        request.page.generateContent();
                        request.page.saveToStatistics();
                    }
                    else {
                        throw(type = "403", message = "The subpage is permanently or temporary disabled.");
                    }
                }
                else {
                    include template = "themes/" & request.user.getTheme().getFolderName() & "/maintenanceMode.cfm";
                    return false;
                }
                
                break;
            }
            case "cfc": {
                // implement a check if the 
                var callInformation = getHttpRequestData();
                if(callInformation.headers.keyExists("x-framework") && callInformation.headers["x-framework"] == "angularJs") {
                    // angular $http calls doesn't work as jQuery post calls. The Parameter are in a JSON format and will neither appear in the arguments nor in the form scope. So we have to move them there.
                    var requestBody = toString(callInformation.content);
                    if(isJSON(requestBody)) {
                        form.append(deserializeJSON(requestBody));
                    }
                }
                
                request.requestType = "cfc";
                break;
            }
            default: {
                // to check...
            }
        }
        return true;
    }
    
    public void function onError(required any exception) {
        try {
            var errorLogger = application.system.settings.getValueOfKey("errorLogger");
            errorLogger.setException(arguments.exception)
                        .save(request.user);
            
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
                    
                    errorLogger.setThemePath("/WWW/themes/" & themeFoldername)
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
            if(! structIsEmpty(form) && form.keyExists("name") && form.name == "com.Nephthys.userManager.login" && form.keyExists("username") && form.keyExists("password") && checkReferer()) {
                var userId = application.system.settings.getValueOfKey("authenticator").login(form.username, form.password);
                if(userId != null) {
                    session.userId = userId;
                    login();
                    return true;
                }
            }
            
            return false;
        }
        else {
            if(url.keyExists("logout") || ! request.user.getStatus().getCanLogin()) {
                logout();
                return false;
            }
            else {
                return true;
            }
        }
    }
    
    private void function reloadSystemSettings() {
        application.system.settings.load();
    }
    
    private void function login() {
        request.user = new user(session.userId);
    }
    
    private void function logout() {
        session.userId = null;
        request.user = new user(session.userId);
    }
    
    private boolean function checkReferer() {
        return reReplace(cgi.referer, "https?:\/\/" & cgi.http_host & ".*", "") == "";
    }
}