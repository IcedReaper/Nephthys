component {
    import "API.modules.com.Nephthys.userManager.*";
    import "API.modules.com.Nephthys.userManager.statistics.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
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
        
        var moduleFilter = createObject("component", "API.modules.com.Nephthys.moduleManager.filter").init()
                                                                                              .setFor("module")
                                                                                              .setActive(true)
                                                                                              .execute();
        
        for(var module in moduleFilter.getResult()) {
            var found = false;
            for(var i = 1; i <= permissions.len(); ++i) {
                if(permissions[i].moduleId == module.getModuleId()) {
                    found = true;
                    break;
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
        var roleFilter = createObject("component", "API.modules.com.Nephthys.userManager.filter").setFor("permissionRole");
        
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
        if(request.user.hasPermission("com.Nephthys.userManager", "admin")) {
            var user = new user(arguments.userId);
            
            transaction {
                for(var i = 1; i <= arguments.permissions.len(); i++) {
                    if(arguments.permissions[i].roleId != null) {
                        var permissionRole = new permissionRole(arguments.permissions[i].roleId);
                        
                        if(arguments.permissions[i].permissionId == null) {
                            var permission = new permission(null);
                            permission.setUser(user)
                                      .setModule(createObject("component", "API.modules.com.Nephthys.moduleManager.module").init(arguments.permissions[i].moduleId))
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
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.themeManager.filter").init().setFor("theme");
        
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
        
        var extPropertyFilter = new filter().setFor("extProperty")
                                            .setUserId(arguments.userId)
                                            .execute();
        
        for(var extProperty in extPropertyFilter.getResult()) {
            var value = extProperty.getValue();
            
            switch(extProperty.getExtPropertyKey().getType()) {
                case "date": {
                    if(extProperty.getValue() != null) {
                        value = dateFormat(extProperty.getValue(), "YYYYMMDD");
                    }
                    break;
                }
            }
            
            extProperties.append({
                extPropertyId    = extProperty.getExtPropertyId(),
                extPropertyKeyId = extProperty.getExtPropertyKey().getExtPropertyKeyId(),
                value            = value,
                public           = extProperty.getPublic(),
                description      = extProperty.getExtPropertyKey().getDescription(),
                type             = extProperty.getExtPropertyKey().getType()
            });
        }
        
        var extPropertyKeyFilter = new filter().setFor("extPropertyKey").execute();
        for(var extPropertyKey in extPropertyKeyFilter.getResult()) {
            var found = false;
            for(var i = 1; i <= extProperties.len(); ++i) {
                if(extProperties[i].extPropertyKeyId == extPropertyKey.getExtPropertyKeyId()) {
                    found = true;
                    break;
                }
            }
            
            if(! found) {
                extProperties.append({
                    extPropertyId    = null,
                    extPropertyKeyId = extPropertyKey.getExtPropertyKeyId(),
                    value            = "",
                    public           = false,
                    description      = extPropertyKey.getDescription(),
                    type             = extPropertyKey.getType()
                });
            }
        }
        
        return extProperties;
    }
    
    remote boolean function saveExtProperties(required numeric userId, required array extProperties) {
        var user = new user(arguments.userId);
        
        transaction {
            for(var i = 1; i <= arguments.extProperties.len(); ++i) {
                if(arguments.extProperties[i].value != "") {
                    var extProperty = new extProperty(arguments.extProperties[i].extPropertyId).setValue(arguments.extProperties[i].value)
                                                                                               .setPublic(arguments.extProperties[i].public);
                    
                    if(arguments.extProperties[i].extPropertyId == null) {
                        extProperty.setExtPropertyKey(new extPropertyKey(arguments.extProperties[i].extPropertyKeyId))
                                   .setUser(user);
                    }
                    
                    extProperty.save();
                }
                else {
                    if(arguments.extProperties[i].extPropertyId != null) {
                        var extProperty = new extProperty(arguments.extProperties[i].extPropertyId).delete();
                    }
                }
            }
            
            transactionCommit();
        }
        
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
            userRoles[role.getName()] = request.user.hasPermission("com.Nephthys.userManager", role.getName());
        }
        
        return userRoles;
    }
    
    remote array function getBlacklist() {
        var blacklistEntries = [];
        for(var blacklistEntry in new filter().setFor("blacklist").execute().getResult()) {
            blacklistEntries.append(prepareBlacklistStruct(blacklistEntry));
        }
        
        return blacklistEntries;
    }
    
    remote struct function getBlacklistEntry(required numeric blacklistId) {
        return prepareBlacklistStruct(new blacklist(arguments.blacklistId));
    }
    
    remote numeric function saveBlacklistEntry(required struct blacklist) {
        return new blacklist(arguments.blacklist.blacklistId)
                            .setNamepart(arguments.blacklist.namepart)
                            .setCreator(request.user)
                            .setCreationDate(now())
                            .save()
                            .getBlacklistId();
    }
    
    remote boolean function deleteBlacklistEntry(required numeric blacklistId) {
        new blacklist(arguments.blacklistId).delete();
        return true;
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
        for(var i = 1; i <= arguments.loginData.len(); ++i) {
            arguments.loginData[i].loginDate = formatCtrl.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
    
    private struct function prepareReducedDetailStruct(required user userObject) {
        return {
            "userId"   = arguments.userObject.getUserId(),
            "username" = arguments.userObject.getUserName(),
            "avatar"   = arguments.userObject.getAvatarPath()
        };
    }
    
    private struct function prepareBlacklistStruct(required blacklist blacklistEntry) {
        return {
            "blacklistId"  = arguments.blacklistEntry.getBlacklistId(),
            "namepart"     = arguments.blacklistEntry.getNamepart(),
            "creator"      = prepareReducedDetailStruct(arguments.blacklistEntry.getCreator()),
            "creationDate" = formatCtrl.formatDate(arguments.blacklistEntry.getCreationDate())
        };
    }
}