component {
    this.name = "Nephthys";
    
    this.datasource = "nephthys_user";
    
    public boolean function onApplicationStart() {
        // components
        application.system.settings = createObject("component", "API.modules.com.Nephthys.system.settings").init();
        application.page.renderer = createObject("component", "API.modules.com.Nephthys.page.renderer").init();
        
        return true;
    }
    
    public boolean function onSessionStart() {
        session.userId = 0;
        
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
                // todo: seite nicht aktiv fehler zeigen
                if(! application.system.settings.getValueOfKey("active")) {
                    include template = "themes/" & request.user.getTheme().getFolderName() & "/offline.cfm";
                    abort;
                }
                
                if(! application.system.settings.getValueOfKey("maintenanceMode")) {
                    request.requestType = "cfm";
                    
                    // check for ses path
                    if(! url.keyExists("pageLink")) {
                        url.pageLink = "/"; // todo: get First link
                    }
                    
                    request.page = createObject("component", "API.modules.com.Nephthys.page.pageRequest").init(url.pageLink);
                    if(request.page.isOnline()) {
                        request.content = application.page.renderer.renderPageContent(request.page.getContent(), request.page.getParameter());
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
                    if(request.keyExists("user")) {
                        themeFoldername = request.user.getTheme().getFolderName();
                    }
                    else {
                        if(application.keyExists("system") && application.system.keyExists("settings")) {
                            themeFoldername = createObject("component", "API.modules.com.Nephthys.theme.theme").init(application.system.settings.getValueOfKey("defaultThemeId")).getFolderName();
                        }
                        else {
                            throw(type = "nephthys.critical.installation", message = "Neither the user nor the system settings are defined!");
                        }
                    }
                    errorLogger.setThemePath("/ADMIN/themes/" & themeFoldername)
                                .show(); // todo: check if needs to be changed to another component
                    
                    break;
                }
            }
        }
        catch(any e) {
            writeDump(var=e, label="critical error");
        }
    }
    
    private boolean function checkIfLoggedIn() {
        request.user = createObject("component", "API.modules.com.Nephthys.user.user").init(session.userId);
        
        if(session.userId == 0) {
            if(! structIsEmpty(form) && /* referer == loginForm */ true) {
                var userId = application.system.settings.getValueOfKey("authenticator").login(form.username, form.password);
                if(userId != 0 && userId != null) {
                    session.userId = userId;
                    login();
                    return true;
                }
            }
            
            return false;
        }
        else {
            if(url.keyExists("logout") || ! request.user.isActive()) {
                logout();
                return false;
            }
            else {
                if(request.user.getActiveStatus() == 0) {
                    logout();
                    return false;
                }
                
                return true;
            }
        }
    }
    
    private void function reloadSystemSettings() {
        application.system.settings.loadDetails();
    }
    
    private void function login() {
        request.user = createObject("component", "API.modules.com.Nephthys.user.user").init(session.userId);
    }
    
    private void function logout() {
        session.userId = 0;
        request.user = createObject("component", "API.modules.com.Nephthys.user.user").init(session.userId);
    }
}