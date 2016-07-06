component {
    import "API.modules.com.Nephthys.module.*";
    
    remote array function getList() {
        var filterCtrl = new filter().setFor("module");
        
        var installedModules = filterCtrl.execute()
                                         .getResult();
        var preparedModules = [];
        
        for(var module in installedModules) {
            preparedModules.append(prepareModule(module));
        }
        
        return preparedModules;
    }
    
    remote struct function getDetails(required numeric moduleId) {
        var module = new module(arguments.moduleId);
        
        return prepareModule(module);
    }
    
    remote boolean function save(required numeric moduleId,
                                 required string  description,
                                 required numeric active) {
        var module = new module(arguments.moduleId);
        
        module.setDescription(arguments.description)
              .setActiveStatus(arguments.active)
              .save();
        
        return true;
    }
    
    remote boolean function delete(required numeric moduleId) {
        var module = new module(arguments.moduleId);
        module.delete();
        
        return true;
    }
    
    remote boolean function activate(required numeric moduleId) {
        var module = new module(arguments.moduleId);
        module.setActiveStatus(1)
              .save();
        
        return true;
    }
    
    remote boolean function deactivate(required numeric moduleId) {
        var module = new module(arguments.moduleId);
        module.setActiveStatus(0)
              .save();
        
        return true;
    }
    
    remote array function getRoles() {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        return permissionHandlerCtrl.loadRoles();
    }
    
    remote array function getUser(required numeric moduleId) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        var users = permissionHandlerCtrl.loadUserForModule(arguments.moduleId);
        var userArray = [];
        for(var i = 1; i <= users.len(); i++) {
            userArray.append({
                "permissionId" = users[i].permissionId,
                "userId"       = users[i].user.getUserId(),
                "userName"     = users[i].user.getUserName(),
                "roleId"       = users[i].roleId != null ? users[i].roleId : 0
            });
        }
        
        return userArray;
    }
    
    remote boolean function savePermissions(required numeric moduleId, required array permissions) {
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
        
        return true;
    }
    
    remote array function getOptions(required numeric moduleId) {
        var module = new module(arguments.moduleId);
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
        var module = new module(arguments.moduleId);
        
        var subModules = [];
        for(var subModule in module.getSubModules()) {
            subModules.append(subModule.getModuleName());
        }
        
        return subModules;
    }
    
    remote array function getUnusedSubModules(required numeric moduleId) {
        var moduleFilterCtrl = new filter().setFor("module");
        
        moduleFilterCtrl.setParentId(arguments.moduleId)
                        .setAvailableWWW(true);
        
        var availableModules = [];
        for(var module in moduleFilterCtrl.execute().getResult()) {
            availableModules.append(module.getModuleName());
        }
        
        return availableModules;
    }
    
    remote boolean function addSubModules(required numeric moduleId, required array subModules) {
        var module = new module(arguments.moduleId);
        var moduleFilterCtrl = new filter().setFor("module");
        
        var subModule = null;
        for(var i = 1; i <= arguments.subModules.len(); ++i) {
            subModule = moduleFilterCtrl.setModuleName(arguments.subModules[i])
                                        .execute()
                                        .getResult()[1];
            module.addSubModule(subModule);
        }
        module.save();
        
        return true;
    }
    
    remote boolean function removeSubModules(required numeric moduleId, required array subModules) {
        var module = new module(arguments.moduleId);
        
        var subModule = null;
        for(var i = 1; i <= arguments.subModules.len(); ++i) {
            module.removeSubModule(arguments.subModules[i]);
        }
        module.save();
        
        return true;
    }
    
    
    private struct function prepareModule(required module module) {
        return {
            "moduleId"       = arguments.module.getModuleId(),
            "moduleName"     = arguments.module.getModuleName(),
            "description"    = arguments.module.getDescription(),
            "active"         = arguments.module.getActiveStatus(),
            "systemModule"   = arguments.module.getSystemModule(),
            "availableWWW"   = arguments.module.getAvailableWWW(),
            "availableADMIN" = arguments.module.getAvailableADMIN()
        };
    }
}