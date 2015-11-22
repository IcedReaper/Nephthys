component {
    remote struct function getList() {
        var moduleOverviewCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
        
        var installedModules = moduleOverviewCtrl.getList();
        var preparedModules = [];
        
        for(var i = 1; i <= installedModules.len(); i++) {
            preparedModules.append({
                    'moduleId'     = installedModules[i].getModuleId(),
                    'moduleName'   = installedModules[i].getModuleName(),
                    'description'  = installedModules[i].getDescription(),
                    'active'       = toString(installedModules[i].getActiveStatus()),
                    'systemModule' = toString(installedModules[i].getSystemModule())
                });
        }
        
        return {
            'success' = true,
            'data'    = preparedModules
        };
    }
    
    remote struct function getDetails(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        
        return {
            'success' = true,
            'data' = {
                'moduleId'     = module.getModuleId(),
                'moduleName'   = module.getModuleName(),
                'description'  = module.getDescription(),
                'active'       = toString(module.getActiveStatus()),
                'systemModule' = toString(module.getSystemModule())
            }
        };
    }
    
    remote struct function save(required numeric moduleId,
                                required string  moduleName,
                                required string  description,
                                required numeric active) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        
        if(arguments.moduleId == 0) {
            var moduleOverviewCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
            var maxSortOrder = moduleOverviewCtrl.getMaxSortOrder();
            
            module.setSortOrder(maxSortOrder + 1);
        }
        
        module.setModuleName(arguments.moduleName)
              .setDescription(arguments.description)
              .setActiveStatus(arguments.active)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function delete(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.delete();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activate(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.setActiveStatus(1)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.setActiveStatus(0)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function getRoles() {
        var permissionHandlerCtrl = createObject("component", "API.com.Nephthys.controller.security.permissionHandler").init();
        
        return {
            "success" = true,
            "roles"   = permissionHandlerCtrl.loadRoles()
        };
    }
    
    remote struct function getUser(required numeric moduleId) {
        var permissionHandlerCtrl = createObject("component", "API.com.Nephthys.controller.security.permissionHandler").init();
        
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
        var permissionHandlerCtrl = createObject("component", "API.com.Nephthys.controller.security.permissionHandler").init();
        
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
}