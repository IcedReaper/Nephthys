component {
    this.name = "Nephthys";
    
    this.datasource = "nephthys_user";
    
    public boolean function onApplicationStart() {
        // components
        application.system.settings = createObject("component", "API.com.Nephthys.classes.system.settings").init();
        
        application.security.loginHandler = createObject("component", "API.com.Nephthys.controller.security.loginHandler").init();
        
        application.page.loader   = createObject("component", "API.com.Nephthys.controller.page.loader").init();
        application.page.renderer = createObject("component", "API.com.Nephthys.controller.page.renderer").init();
        
        application.tools.formatter = createObject("component", "API.com.Nephthys.controller.tools.formatter").init();
        application.tools.validator = createObject("component", "API.com.Nephthys.controller.tools.validator").init();
        
        return true;
    }
    
    public boolean function onRequestStart(required string targetPage) {
        request.requestType = "";
        
        var callInformation = getHttpRequestData();
        if(structKeyExists(url, "restart")) {
            if(structKeyExists(callInformation.headers, "x-restart") && 
               callInformation.headers["x-restart"] == "systemSettings") {
                reloadSystemSettings();
                
                writeOutput("restart successful");
                return false;
            }
            else { // remove or make only available after update of system
                onApplicationStart();
            }
        }
        
        request.user = createObject("component", "API.com.Nephthys.classes.user.user").init(0);
        
        switch(lcase(right(arguments.targetPage, 3))) {
            case "cfm": {
                if(! application.system.settings.getMaintenanceModeStatus()) {
                    request.requestType = "cfm";
                    
                    // check for ses path
                    if(! structKeyExists(url, "pageLink")) {
                        url.pageLink = "/"; // todo: get First link
                    }
                    
                    request.page = application.page.loader.getPageId(url.pageLink);
                    request.content = application.page.renderer.renderPageContent(request.page.getContent(), request.page.getParameter());
                    request.page.saveToStatistics();
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
                if(structKeyExists(callInformation.headers, "x-framework") && callInformation.headers["x-framework"] == "angularJs") {
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
            writeDump(var=e, label="critical error");
        }
    }
    
    private void function reloadSystemSettings() {
        application.system.settings.loadDetails();
    }
}