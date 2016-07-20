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
                            
                            if(! module.getActiveStatus() || ! module.getAvailableWWW()) {
                                result.error = true;
                                result.errors.module = true;
                            }
                            
                            try {
                                var role = createObject("component", "API.modules.com.Nephthys.user.permissionRole").init(form.roleId);
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
                                        .setReason(form.reason)
                                        .save();
                                    
                                    result.successful = true;
                                    
                                    transactionCommit();
                                }
                            }
                        }
                        
                        var modules = createObject("component", "API.modules.com.Nephthys.module.filter").init()
                                                                                                         .setFor("module")
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
                        
                        var permissionFilter = createObject("component", "API.modules.com.Nephthys.user.filter").setFor("permission")
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
                        
                        var roleFilter = createObject("component", "API.modules.com.Nephthys.user.filter").setFor("permissionRole");
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("newRequest.cfm")
                            .addParam("options",             arguments.options)
                            .addParam("userPage",            userPage)
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
                                    
                                    if(_request.getUserId() == request.user.getUserId()) {
                                        return application.system.settings.getValueOfKey("templateRenderer")
                                            .setModulePath(getModulePath())
                                            .setTemplate("request.cfm")
                                            .addParam("options",  arguments.options)
                                            .addParam("request",  _request)
                                            .addParam("userPage", userPage)
                                            .render();
                                    }
                                }
                                catch(nephthys.notFound.general e) {}
                                
                                return application.system.settings.getValueOfKey("templateRenderer")
                                    .setModulePath(getModulePath())
                                    .setTemplate("requestNotFound.cfm")
                                    .addParam("options",  arguments.options)
                                    .addParam("userPage", userPage)
                                    .render();
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