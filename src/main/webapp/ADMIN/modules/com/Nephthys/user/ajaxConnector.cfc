component {
    import "API.modules.com.Nephthys.user.*";
    import "API.modules.com.Nephthys.user.statistics.*";
    
    remote array function getList() {
        var userListCtrl = new filter().setFor("user");
        
        var data = [];
        
        for(var user in userListCtrl.execute().getResult()) {
            data.append({
                "userId"   = user.getUserId(),
                "username" = user.getUserName(),
                "email"    = user.getEmail(),
                "active"   = user.getActiveStatus()
            });
        }
        
        return data;
    }
    
    remote struct function getDetails(required numeric userId) {
        var user = new user(arguments.userId);
        
        return prepareDetailStruct(user);
    }
    
    remote struct function save(required numeric userId,
                                required string  userName,
                                required string  eMail,
                                required boolean active,
                                required string  password,
                                required numeric wwwThemeId,
                                required numeric adminThemeId) {
        var user = new user(arguments.userId);
        var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
        
        if(arguments.userId == 0) {
            user.setUsername(arguments.userName);
        }
        
        user.setEmail(arguments.eMail)
            .setActiveStatus(arguments.active)
            .setWwwThemeId(arguments.wwwThemeId)
            .setAdminThemeId(arguments.adminThemeId);
        
        if(trim(arguments.password) != "") {
            user.setPassword(encrypt(arguments.password,
                                     application.system.settings.getValueOfKey("encryptionKey"),
                                     encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId"))));
        }
        
        user.save();
        
        return prepareDetailStruct(user);
    }
    
    remote boolean function delete(required numeric userId) {
        var user = new user(arguments.userId);
        user.delete();
        
        return true;
    }
    
    remote boolean function activate(required numeric userId) {
        var user = new user(arguments.userId);
        user.setActiveStatus(1)
            .save();
        
        return true;
    }
    
    remote boolean function deactivate(required numeric userId) {
        var user = new user(arguments.userId);
        user.setActiveStatus(0)
            .save();
        
        return true;
    }
    
    remote string function uploadAvatar(required numeric userId) {
        var user = new user(arguments.userId);
        
        if(user.getUserId() == request.user.getUserId()) {
            user.uploadAvatar()
                .save();
            
            return user.getAvatarPath();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "It is only allowed to upload an avatar for yourself");
        }
    }
    
    remote array function getPermissions(required numeric userId) {
        var permissionFilter = new filter().setFor("permission").setUserId(arguments.userId)
                                                                .execute();
        
        var permissions = [];
        for(var permission in permissionFilter.getResult()) {
            permissions.append({
                "moduleId"     = permission.getModule().getModuleId(),
                "moduleName"   = permission.getModule().getModuleName(),
                "description"  = permission.getModule().getModuleName(),
                "permissionId" = permission.getPermissionId(),
                "roleId"       = permission.getPermissionRole().getPermissionRoleId(),
                "roleValue"    = permission.getPermissionRole().getValue()
            });
        }
        
        var moduleFilter = createObject("component", "API.modules.com.Nephthys.module.filter").init()
                                                                                              .setFor("module")
                                                                                              .setActive(true)
                                                                                              .execute();
        
        for(var module in moduleFilter.getResult()) {
            var found = false;
            for(var i = 1; i <= permissions.len(); ++i) {
                if(permissions[i].moduleId == module.getModuleId()) {
                    found = true;
                }
            }
            
            if(! found) {
                permissions.append({
                    "moduleId"     = module.getModuleId(),
                    "moduleName"   = module.getModuleName(),
                    "description"  = module.getModuleName(),
                    "permissionId" = null,
                    "roleId"       = null,
                    "roleValue"    = 0
                });
            }
        }
        
        return permissions;
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
    
    remote boolean function savePermissions(required numeric userId, required array permissions) {
        if(request.user.hasPermission("com.Nephthys.user", "admin")) {
            var user = new user(arguments.userId);
            
            transaction {
                for(var i = 1; i <= arguments.permissions.len(); i++) {
                    if(arguments.permissions[i].roleId != null) {
                        var permissionRole = new permissionRole(arguments.permissions[i].roleId);
                        
                        if(arguments.permissions[i].permissionId == null) {
                            var permission = new permission(null);
                            permission.setUser(user)
                                      .setModule(createObject("component", "API.modules.com.Nephthys.module.module").init(arguments.permissions[i].moduleId))
                                      .setPermissionRole(permissionRole)
                                      .save();
                        }
                        else {
                            var permission = new permission(arguments.permissions[i].permissionId);
                            permission.setPermissionRole(permissionRole)
                                      .save();
                        }
                    }
                    else {
                        if(arguments.permissions[i].permissionId != 0 && arguments.permissions[i].permissionId != null) {
                            new permission(arguments.permissions[i].permissionId).delete();
                        }
                    }
                }
                
                transactionCommit();
            }
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You don't have the permission to edit permissions.");
        }
        
        return true;
    }
    
    remote array function getThemes() {
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.theme.filter").init();
        
        var themeData = [];
        for(var theme in filterCtrl.execute().getResult()) {
            themeData.append({
                "themeId"        = theme.getThemeId(),
                "name"           = theme.getName(),
                "default"        = theme.getThemeId() == application.system.settings.getValueOfKey("defaultThemeId"),
                "active"         = theme.getActiveStatus(),
                "availableWww"   = theme.getAvailableWww(),
                "availableAdmin" = theme.getAvailableAdmin()
            });
        }
        
        return themeData;
    }
    
    remote array function getExtProperties(required numeric userId) {
        var extProperties = [];
        var user = new user(arguments.userId);
        var extPropertyKeyLoader = new extPropertyKeyLoader();
        var objExtProperties = user.getExtProperties();
        var extPropertyKeys = extPropertyKeyLoader.load();
        
        var extPropertyId = 0;
        var value = "";
        var public = false;
        var prop = {};
        
        for(var i = 1; i <= extPropertyKeys.len(); ++i) {
            prop = objExtProperties.get(extPropertyKeys[i].getKeyName(), false);
            
            if(! prop.isEmpty()) {
                extPropertyId = prop.extPropertyId;
                public        = prop.public;
                switch(extPropertyKeys[i].getType()) {
                    case "date": {
                        if(prop.value != null) {
                            value = dateFormat(prop.value, "YYYYMMDD");
                        }
                        else {
                            value = prop.value;
                        }
                        break;
                    }
                    default: {
                        value = prop.value;
                    }
                }
            }
            else {
                extPropertyId = 0;
                value         = "";
                public        = false;
            }
            
            extProperties.append({
                extPropertyId    = extPropertyId,
                extPropertyKeyId = extPropertyKeys[i].getExtPropertyKeyId(),
                value            = value,
                public           = public,
                description      = extPropertyKeys[i].getDescription(),
                type             = extPropertyKeys[i].getType()
            });
        }
        
        return extProperties;
    }
    
    remote boolean function saveExtProperties(required numeric userId, required array extProperties) {
        var extProperties = new extProperties(arguments.userId);
        for(var i = 1; i <= arguments.extProperties.len(); ++i) {
            var extPropertyKey = new extPropertyKey(arguments.extProperties[i].extPropertyKeyId);
            
            if(arguments.extProperties[i].value != "") {
                extProperties.set(extPropertyKey.getKeyName(), arguments.extProperties[i].value, arguments.extProperties[i].public);
            }
            else{
                if(arguments.extProperties[i].extPropertyId != 0) {
                    extProperties.remove(extPropertyKey.getKeyName());
                }
            }
        }
        extProperties.save();
        
        return true;
    }
    
    remote struct function loginStatistics() {
        var loginStatisticsCtrl = new loginLog();
        
        loginStatisticsCtrl.setLimit(10);
        
        return {
            "successful" = prepareLoginData(loginStatisticsCtrl.setSuccessful(true).execute().getResult()),
            "failed"     = prepareLoginData(loginStatisticsCtrl.setSuccessful(false).execute().getResult())
        };
    }
    
    remote struct function getLoginStatisticsTotal(required numeric userId = null, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getTotal(arguments.userId,
                                         arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getPermissionsOfActualUser() {
        var roleFilter = new filter().setFor("permissionRole").execute();
        var roles = {};
        for(var role in roleFilter.getResult()) {
            userRoles[role.getName()] = request.user.hasPermission("com.Nephthys.user", role.getName());
        }
        
        return userRoles;
    }
    
    // P R I V A T E   M E T H O D S
    
    private struct function prepareDetailStruct(required user userObject) {
        return {
            "userId"       = arguments.userObject.getUserId(),
            "username"     = arguments.userObject.getUserName(),
            "email"        = arguments.userObject.getEmail(),
            "active"       = arguments.userObject.getActiveStatus(),
            "password"     = "      ",
            "avatar"       = arguments.userObject.getAvatarPath(false),
            "actualUser"   = arguments.userObject.getUserId() == request.user.getUserId(),
            "wwwThemeId"   = arguments.userObject.getThemeId(),
            "adminThemeId" = arguments.userObject.getThemeId()
        };
    }
    
    private array function prepareLoginData(required array loginData) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        for(var i = 1; i <= arguments.loginData.len(); ++i) {
            arguments.loginData[i].loginDate = formatCtrl.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
}