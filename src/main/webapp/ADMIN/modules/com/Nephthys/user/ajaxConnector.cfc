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
            
            return  user.getAvatarPath();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "It is only allowed to upload an avatar for yourself");
        }
    }
    
    remote array function getPermissions(required numeric userId) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        var permissions = permissionHandlerCtrl.loadForUserId(arguments.userId);
        
        for(var i = 1; i <= permissions.len(); i++) {
            permissions[i].permissionId = permissions[i].permissionId != null ? permissions[i].permissionId : 0;
            permissions[i].roleId       = permissions[i].roleId != null ? permissions[i].roleId : 0;
        }
        
        return permissions;
    }
    
    remote array function getRoles() {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        return permissionHandlerCtrl.loadRoles();
    }
    
    remote boolean function savePermissions(required numeric userId, required array permissions) {
        if(request.user.hasPermission("com.Nephthys.user", "admin")) {
            var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
            
            transaction {
                for(var i = 1; i <= arguments.permissions.len(); i++) {
                    if(arguments.permissions[i].roleId != 0 && arguments.permissions[i].roleId != null) {
                        permissionHandlerCtrl.setPermission(arguments.permissions[i].permissionId,
                                                            arguments.userId,
                                                            arguments.permissions[i].roleId,
                                                            arguments.permissions[i].moduleId);
                    }
                    else {
                        if(arguments.permissions[i].permissionId != 0 && arguments.permissions[i].roleId == null) {
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
                "default"        = theme.getThemeId() == application.system.settings.getValueOfKey("defaultWwwThemeId"),
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
                value         = prop.value;
                public        = prop.public;
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
                description      = extPropertyKeys[i].getDescription()
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
    
    remote struct function getLoginStatisticsTotal(required numeric userId = null, required string sortOrder, required string fromDate, required string toDate) { // format: DD.MM.YYYY // TODO: custom formats by server settings
        var _fromDate = dateFormat(arguments.fromDate, "DD.MM.YYYY");
        var _toDate   = dateFormat(arguments.toDate, "DD.MM.YYYY");

        return new statistics().getTotal(arguments.userId,
                                         arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getPermissionsOfActualUser() {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        var userRoles = {};
        for(var role in permissionHandlerCtrl.loadRoles()) {
            userRoles[role.name] = request.user.hasPermission("com.Nephthys.user", role.name);
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
            "wwwThemeId"   = arguments.userObject.getWwwThemeId(),
            "adminThemeId" = arguments.userObject.getAdminThemeId()
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