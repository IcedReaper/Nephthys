component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.permissionRequest.*";
    import "API.modules.com.Nephthys.userManager.permissionRole";
    import "API.modules.com.Nephthys.moduleManager.module";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.permissionRequest";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        if(arguments.options.keyExists("userId") && arguments.options.userId == request.user.getUserId()) {
            if(arguments.options.otherParameter.len() == 0) {
                arguments.options.otherParameter[1] = "overview";
            }
            
            if(arguments.options.keyExists("otherParameter") && arguments.options.otherParameter.len() > 0) {
                switch(arguments.options.otherParameter[1]) {
                    case "new": {
                        var result = {
                            successful = false,
                            error = false,
                            errors = {
                                module = false,
                                role   = false
                            }
                        };
                        
                        if(! form.isEmpty() && form.keyExists("name") && form.name == "com.IcedReaper.permissionRequest") {
                            var module = new module(form.moduleId);
                            
                            if(! module.getActiveStatus() || ! module.getAvailableWWW()) {
                                result.error = true;
                                result.errors.module = true;
                            }
                            
                            try {
                                var role = new permissionRole(form.roleId);
                            }
                            catch(nephthys.notFound.role e) {
                                result.error = true;
                                result.errors.role = true;
                            }
                            
                            if(! result.error) {
                                transaction {
                                    new request().setModule(new module(form.moduleId))
                                                 .setPermissionRole(new permissionRole(form.roleId))
                                                 .setReason(form.reason)
                                                 .save(request.user);
                                    
                                    result.successful = true;
                                    
                                    transactionCommit();
                                }
                            }
                        }
                        
                        var modules = createObject("component", "API.modules.com.Nephthys.moduleManager.filter").init().for("module")
                                                                                                                       .setActive(true)
                                                                                                                       .setAvailableWww(true)
                                                                                                                       .execute()
                                                                                                                       .getResult();
                        
                        for(var i = 1; i <= modules.len(); ++i) {
                            if(request.user.hasPermission(modules[i].getModuleName(), "admin")) {
                                modules.deleteAt(i);
                                --i;
                            }
                        }
                        
                        var permissionFilter = createObject("component", "API.modules.com.Nephthys.userManager.filter").for("permission")
                                                                                                                       .setUserId(request.user.getUserId())
                                                                                                                       .execute();
                        
                        var existingPermissions = [];
                        for(var permission in permissionFilter.getResult()) {
                            existingPermissions.append({
                                "moduleId"     = permission.getModule().getModuleId(),
                                "moduleName"   = permission.getModule().getModuleName(),
                                "description"  = permission.getModule().getModuleName(),
                                "permissionId" = permission.getPermissionId(),
                                "roleId"       = permission.getPermissionRole().getPermissionRoleId(),
                                "roleValue"    = permission.getPermissionRole().getValue()
                            });
                        }
                        
                        var roleFilter = createObject("component", "API.modules.com.Nephthys.userManager.filter").for("permissionRole");
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("newRequest.cfm")
                            .addParam("options",             arguments.options)
                            .addParam("modules",             modules)
                            .addParam("roles",               roleFilter.execute().getResult())
                            .addParam("result",              result)
                            .addParam("existingPermissions", existingPermissions)
                            .render();
                    }
                    case "request": {
                        if(arguments.options.otherParameter.len() == 2) {
                            if(isNumeric(arguments.options.otherParameter[2])) {
                                try {
                                    var _request = new Request(arguments.options.otherParameter[2]);
                                    
                                    if(_request.getUser().getUserId() == request.user.getUserId()) {
                                        return application.system.settings.getValueOfKey("templateRenderer")
                                            .setModulePath(getModulePath())
                                            .setTemplate("request.cfm")
                                            .addParam("options", arguments.options)
                                            .addParam("request", _request)
                                            .render();
                                    }
                                }
                                catch(nephthys.notFound.general e) {}
                                
                                return application.system.settings.getValueOfKey("templateRenderer")
                                    .setModulePath(getModulePath())
                                    .setTemplate("requestNotFound.cfm")
                                    .addParam("options",  arguments.options)
                                    .render();
                            }
                        }
                        break;
                    }
                    case "overview": {
                        var requestOverview = new filter().for("request")
                                                          .setUserId(request.user.getUserId())
                                                          .setSince(dateAdd("d", -10, now()))
                                                          .execute()
                                                          .getResult();
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("overview.cfm")
                            .addParam("options",  arguments.options)
                            .addParam("requests", requestOverview)
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