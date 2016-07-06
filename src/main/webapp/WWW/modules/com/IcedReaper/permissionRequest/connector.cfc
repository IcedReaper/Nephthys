component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.permissionRequest.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.permissionRequest";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        if(arguments.options.keyExists("userId") && arguments.options.userId == request.user.getUserId()) {
            if(arguments.options.otherParameter.len() == 0) {
                arguments.options.otherParameter[1] = "overview";
            }
            
            var aPages = createObject("component", "API.modules.com.Nephthys.pages.filter").init()
                                                                                           .setFor("pageWithModule")
                                                                                           .setModuleName("com.Nephthys.user")
                                                                                           .execute()
                                                                                           .getResult(); 
            var userPage = aPages.len() >= 1 ? aPages[1].link : "";
            
            if(arguments.options.keyExists("otherParameter") && arguments.options.otherParameter.len() > 0) {
                switch(arguments.options.otherParameter[1]) {
                    case "new": {
                        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
                        
                        
                        var result = {
                            successful = false,
                            error = false,
                            errors = {
                                module = false,
                                role   = false
                            }
                        };
                        
                        if(! form.isEmpty() && form.keyExists("name") && form.name == "com.IcedReaper.permissionRequest") {
                            var module = createObject("component", "API.modules.com.Nephthys.module.module").init(form.moduleId);
                            
                            if(! module.getActiveStatus()) {
                                result.error = true;
                                result.errors.module = true;
                            }
                            
                            try {
                                var role = permissionHandlerCtrl.loadRole(form.roleId);
                            }
                            catch(nephthys.notFound.role e) {
                                result.error = true;
                                result.errors.role = true;
                            }
                            
                            if(! result.error) {
                                transaction {
                                    new request()
                                        .setUserId(request.user.getUserId())
                                        .setModuleId(form.moduleId)
                                        .setRoleId(form.roleId)
                                        .save();
                                    
                                    result.successful = true;
                                    
                                    transactionCommit();
                                }
                                
                                location(addtoken = false, statuscode = "302", url = userPage & "/" & request.user.getUserName() & "/permissionRequest/overview");
                            }
                        }
                        
                        var modules = createObject("component", "API.modules.com.Nephthys.module.filter").init()
                                                                                                         .setFor("module")
                                                                                                         .setActive(true)
                                                                                                         .execute()
                                                                                                         .getResult();
                        
                        for(var i = 1; i <= modules.len(); ++i) {
                            if(request.user.hasPermission(modules[i].getModuleName(), "admin")) {
                                modules.deleteAt(i);
                                --i;
                            }
                        }
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("newRequest.cfm")
                            .addParam("options",  arguments.options)
                            .addParam("userPage", userPage)
                            .addParam("modules",  modules)
                            .addParam("roles",    permissionHandlerCtrl.loadRoles())
                            .addParam("result",   result)
                            .render();
                    }
                    case "request": {
                        if(arguments.options.otherParameter.len() == 2) {
                            if(isNumeric(arguments.options.otherParameter[2])) {
                                var request = new filter().setFor("request")
                                                          .setParticipantId(request.user.getUserId())
                                                          .setRequestId(arguments.options.otherParameter[2])
                                                          .execute()
                                                          .getResult();
                                
                                if(request.len() == 1) {
                                    return application.system.settings.getValueOfKey("templateRenderer")
                                        .setModulePath(getModulePath())
                                        .setTemplate("request.cfm")
                                        .addParam("options",  arguments.options)
                                        .addParam("request",  request[1])
                                        .addParam("userPage", userPage)
                                        .render();
                                }
                                else {
                                    return application.system.settings.getValueOfKey("templateRenderer")
                                        .setModulePath(getModulePath())
                                        .setTemplate("requestNotFound.cfm")
                                        .addParam("options",  arguments.options)
                                        .addParam("userPage", userPage)
                                        .render();
                                }
                            }
                        }
                        break;
                    }
                    case "overview": {
                        var requestOverview = new filter().setFor("request")
                                                          .setUserId(request.user.getUserId())
                                                          .setSince(dateAdd("d", -10, now()))
                                                          .execute()
                                                          .getResult();
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("overview.cfm")
                            .addParam("options",  arguments.options)
                            .addParam("requests", requestOverview)
                            .addParam("userPage", userPage)
                            .render();
                    }
                    default: {
                        throw(type = "nephthys.notFound.user", message = "Action not found or invalid");
                    }
                }
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Action not found or invalid");
            }
        }
        else {
            throw(type = "nephthys.notFound.user", message = "User not found or invalid");
        }
        return "";
    }
}