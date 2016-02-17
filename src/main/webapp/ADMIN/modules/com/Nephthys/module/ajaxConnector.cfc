component {
    remote struct function getList() {
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        var installedModules = filterCtrl.filter();
        var preparedModules = [];
        
        for(var i = 1; i <= installedModules.len(); i++) {
            preparedModules.append({
                    'moduleId'       = installedModules[i].getModuleId(),
                    'moduleName'     = installedModules[i].getModuleName(),
                    'description'    = installedModules[i].getDescription(),
                    'active'         = toString(installedModules[i].getActiveStatus()),
                    'systemModule'   = toString(installedModules[i].getSystemModule()),
                    'availableWWW'   = toString(installedModules[i].getAvailableWWW()),
                    'availableADMIN' = toString(installedModules[i].getAvailableADMIN())
                });
        }
        
        return {
            'success' = true,
            'data'    = preparedModules
        };
    }
    
    remote struct function getDetails(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        
        return {
            'success' = true,
            'data' = {
                'moduleId'       = module.getModuleId(),
                'moduleName'     = module.getModuleName(),
                'description'    = module.getDescription(),
                'active'         = toString(module.getActiveStatus()),
                'systemModule'   = toString(module.getSystemModule()),
                'availableWWW'   = toString(module.getAvailableWWW()),
                'availableADMIN' = toString(module.getAvailableADMIN())
            }
        };
    }
    
    remote struct function save(required numeric moduleId,
                                required string  moduleName,
                                required string  description,
                                required numeric active,
                                required numeric availableWWW,
                                required numeric availableADMIN) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        
        // todo: refactor
        if(arguments.moduleId == 0) {
            var filterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
            var modules = filterCtrl.filter();
            var maxSortOrder = modules[modules.len()].getSortId() + 1;
            
            module.setSortOrder(maxSortOrder + 1);
        }
        
        module.setModuleName(arguments.moduleName)
              .setDescription(arguments.description)
              .setActiveStatus(arguments.active)
              .setAvailableWWW(arguments.availableWWW)
              .setAvailableADMIN(arguments.availableADMIN)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function delete(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        module.delete();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activate(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        module.setActiveStatus(1)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        module.setActiveStatus(0)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function getRoles() {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        return {
            "success" = true,
            "roles"   = permissionHandlerCtrl.loadRoles()
        };
    }
    
    remote struct function getUser(required numeric moduleId) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        var users = permissionHandlerCtrl.loadUserForModule(arguments.moduleId);
        var userArray = [];
        for(var i = 1; i <= users.len(); i++) {
            userArray.append({
                "permissionId" = users[i].permissionId,
                "userId"       = users[i].user.getUserId(),
                "userName"     = users[i].user.getUserName(),
                "roleId"       = toString(users[i].roleId != null ? users[i].roleId : 0)
            });
        }
        
        return {
            "success" = true,
            "users"   = userArray
        };
    }
    
    remote struct function savePermissions(required numeric moduleId, required array permissions) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        transaction {
            for(var i = 1; i <= arguments.permissions.len(); i++) {
                if(arguments.permissions[i].roleId != 0) {
                    permissionHandlerCtrl.setPermission(arguments.permissions[i].permissionId,
                                                        arguments.permissions[i].userId,
                                                        arguments.permissions[i].roleId,
                                                        arguments.moduleId);
                }
                else {
                    if(arguments.permissions[i].permissionId != 0 && arguments.permissions[i].permissionId != null) {
                        permissionHandlerCtrl.removePermission(arguments.permissions[i].permissionId);
                    }
                    else {
                        continue;
                    }
                }
            }
            
            transactionCommit();
        }
        
        return {
            "success" = true
        };
    }
    
    remote array function getOptions(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        var options = [];
        
        for(var moduleOptions in module.getOptions()) {
            options.append({
                "dbName"        = moduleOptions.getOptionName(),
                "description"   = moduleOptions.getDescription(),
                "type"          = moduleOptions.getType(),
                "selectOptions" = moduleOptions.getSelectOptions()
            });
        }
        
        return options;
    }
    
    remote array function getSubModules(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        
        var subModules = [];
        for(var subModule in module.getSubModules()) {
            subModules.append(subModule.getModuleName());
        }
        
        return subModules;
    }
    
    remote array function getUnusedSubModules(required numeric moduleId) {
        var moduleFilterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        moduleFilterCtrl.setParentId(arguments.moduleId)
                        .setAvailableWWW(true);
        
        var availableModules = [];
        for(var module in moduleFilterCtrl.filter()) {
            availableModules.append(module.getModuleName());
        }
        
        return availableModules;
    }
    
    remote boolean function addSubModules(required numeric moduleId, required array subModules) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        var moduleFilterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        var subModule = null;
        for(var i = 1; i <= arguments.subModules.len(); ++i) {
            subModule = moduleFilterCtrl.setModuleName(arguments.subModules[i]).filter()[1];
            module.addSubModule(subModule);
        }
        module.save();
        
        return true;
    }
    
    remote boolean function removeSubModules(required numeric moduleId, required array subModules) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        
        var subModule = null;
        for(var i = 1; i <= arguments.subModules.len(); ++i) {
            module.removeSubModule(arguments.subModules[i]);
        }
        module.save();
        
        return true;
    }
    
    remote array function checkThemeAvailability(required numeric moduleId) {
        var module = createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.moduleId);
        
        var themes = [];
        var themeFilterCtrl = createObject("component", "API.modules.com.Nephthys.theme.filter").init();
        var themeList = 
        
        var modulePath = module.getModuleName().replace(".", "/", "ALL");
        var i = 0;
        for(var theme in themeFilterCtrl.getList()) { // todo: refactor theme filter component
            themes[++i] = {
                available = false,
                active    = toString(theme.getActiveStatus())
            };
            
            if(fileExists(expandPath("/WWW/modules/" & modulePath & "/connector.cfc"))) {
                var tComp = createObject("component", "WWW.modules." & module.getModuleName() & ".connector").init();
                if(tComp.keyExists("render")) {
                    themes[i].available = true;
                }
            }
        }
        
        return themes;
    }
}