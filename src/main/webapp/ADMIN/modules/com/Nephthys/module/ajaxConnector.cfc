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
        var roleFilter = createObject("component", "API.modules.com.Nephthys.user.filter").setFor("permissionRole");
        
        var roles = [];
        for(var role in roleFilter.execute().getResult()) {
            roles.append({
                "roleId" = role.getPermissionRoleId(),
                "name"   = role.getName(),
                "value"  = role.getValue()
            });
        }
        
        return roles;
    }
    
    remote array function getUser(required numeric moduleId) {
        var permissionFilter = createObject("component", "API.modules.com.Nephthys.user.filter").setFor("permission")
                                                                                                .setModuleId(arguments.moduleId)
                                                                                                .execute();
        
        var permissions = [];
        for(var permission in permissionFilter.getResult()) {
            permissions.append({
                "permissionId" = permission.getPermissionId(),
                "userId"       = permission.getUser().getUserId(),
                "userName"     = permission.getUser().getUserName(),
                "roleId"       = permission.getPermissionRole().getPermissionRoleId()
            });
        }
        
        var userFilter = createObject("component", "API.modules.com.Nephthys.user.filter").setFor("user")
                                                                                          .setActive(true)
                                                                                          .execute();
        
        for(var user in userFilter.getResult()) {
            var found = false;
            for(var i = 1; i <= permissions.len(); ++i) {
                if(permissions[i].userId == user.getUserId()) {
                    found = true;
                    break;
                }
            }
            
            if(! found) {
                permissions.append({
                    "permissionId" = null,
                    "userId"       = user.getUserId(),
                    "userName"     = user.getUserName(),
                    "roleId"       = null
                });
            }
        }
        
        return permissions;
    }
    
    remote boolean function savePermissions(required numeric moduleId, required array permissions) {
        var module = new module(arguments.moduleId);
        
        transaction {
            for(var i = 1; i <= arguments.permissions.len(); i++) {
                if(arguments.permissions[i].roleId != null) {
                    var permissionRole = createObject("component", "API.modules.com.Nephthys.user.permissionRole").init(arguments.permissions[i].roleId);
                    
                    if(arguments.permissions[i].permissionId == null) {
                        var permission = createObject("component", "API.modules.com.Nephthys.user.permission").init(null);
                        permission.setUser(createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.permissions[i].userId))
                                  .setModule(module)
                                  .setPermissionRole(permissionRole)
                                  .save();
                    }
                    else {
                        var permission = createObject("component", "API.modules.com.Nephthys.user.permission").init(arguments.permissions[i].permissionId);
                        permission.setPermissionRole(permissionRole)
                                  .save();
                    }
                }
                else {
                    if(arguments.permissions[i].permissionId != 0 && arguments.permissions[i].permissionId != null) {
                        createObject("component", "API.modules.com.Nephthys.user.permission").init(arguments.permissions[i].permissionId)
                                                                                             .delete();
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