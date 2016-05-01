component {
    remote array function getList() {
        var userListCtrl = createObject("component", "API.modules.com.Nephthys.user.filter").init();
        
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
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        
        return prepareDetailStruct(user);
    }
    
    remote struct function save(required numeric userId,
                                required string  userName,
                                required string  eMail,
                                required numeric active,
                                required string  password,
                                required numeric themeId) {
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
        
        if(arguments.userId == 0) {
            user.setUsername(arguments.userName);
        }
        
        user.setEmail(arguments.eMail)
            .setActiveStatus(arguments.active)
            .setThemeId(arguments.themeId);
        
        if(trim(arguments.password) != "") {
            user.setPassword(encrypt(arguments.password,
                                     application.system.settings.getValueOfKeyFromForeignTable("encryptionMethodId")),
                                     encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId")));
        }
        
        user.save();
        
        return prepareDetailStruct(user);
    }
    
    remote boolean function delete(required numeric userId) {
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        fileDelete(expandPath("/upload/com.Nephthys.user/avatar/") & user.getAvatarFilename());
        user.delete();
        
        return true;
    }
    
    remote boolean function activate(required numeric userId) {
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        user.setActiveStatus(1)
            .save();
        
        return true;
    }
    
    remote boolean function deactivate(required numeric userId) {
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        user.setActiveStatus(0)
            .save();
        
        return true;
    }
    
    remote string function uploadAvatar(required numeric userId) {
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        
        if(user.getUserId() == request.user.getUserId()) {
            user.uploadAvatar()
                .save();
            
            return  "/upload/com.Nephthys.user/avatar/" & user.getAvatarFilename();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "It is only allowed to upload an avatar for yourself");
        }
    }
    
    remote array function getPermissions(required numeric userId) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        var permissions = permissionHandlerCtrl.loadForUserId(arguments.userId);
        
        for(var i = 1; i <= permissions.len(); i++) {
            permissions[i].permissionId = toString(permissions[i].permissionId != null ? permissions[i].permissionId : 0);
            permissions[i].roleId       = toString(permissions[i].roleId != null ? permissions[i].roleId : 0);
        }
        
        return permissions;
    }
    
    remote array function getRoles() {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        return permissionHandlerCtrl.loadRoles();
    }
    
    remote boolean function savePermissions(required numeric userId, required array permissions) {
        var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
        
        transaction {
            for(var i = 1; i <= arguments.permissions.len(); i++) {
                if(arguments.permissions[i].roleId != 0) {
                    permissionHandlerCtrl.setPermission(arguments.permissions[i].permissionId,
                                                        arguments.userId,
                                                        arguments.permissions[i].roleId,
                                                        arguments.permissions[i].moduleId);
                }
                else {
                    if(arguments.permissions[i].permissionId != 0) {
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
    
    remote array function getThemes() {
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.theme.filter").init();
        
        var themeData = [];
        for(var theme in filterCtrl.execute().getResult()) {
            themeData.append({
                    "themeId"    = theme.getThemeId(),
                    "name"       = theme.getName(),
                    "default"    = theme.getThemeId() == application.system.settings.getValueOfKey("defaultThemeId"),
                    "active"     = toString(theme.getActiveStatus())
                });
        }
        
        return themeData;
    }
    
    remote array function getExtProperties(required numeric userId) {
        var extProperties = [];
        var user = createObject("component", "API.modules.com.Nephthys.user.user").init(arguments.userId);
        var extPropertyKeyLoader = createObject("component", "API.modules.com.Nephthys.user.extPropertyKeyLoader").init();
        var objExtProperties = user.getExtProperties();
        var extPropertyKeys = extPropertyKeyLoader.load();
        
        var extPropertyId = 0;
        var value = "";
        var public = 0;
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
                public        = 0;
            }
            
            extProperties.append({
                extPropertyId    = extPropertyId,
                extPropertyKeyId = extPropertyKeys[i].getExtPropertyKeyId(),
                value            = value,
                public           = toString(public),
                description      = extPropertyKeys[i].getDescription()
            });
        }
        
        return extProperties;
    }
    
    remote boolean function saveExtProperties(required numeric userId, required array extProperties) {
        var extProperties = createObject("API.modules.com.Nephthys.user.extProperties").init(arguments.userId);
        for(var i = 1; i <= arguments.extProperties.len(); ++i) {
            var extPropertyKey = createObject("component", "API.modules.com.Nephthys.user.extPropertyKey").init(arguments.extProperties[i].extPropertyKeyId);
            
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
    
    // P R I V A T E   M E T H O D S
    
    private struct function prepareDetailStruct(required user userObject) {
        return {
            "userId"     = arguments.userObject.getUserId(),
            "username"   = arguments.userObject.getUserName(),
            "email"      = arguments.userObject.getEmail(),
            "active"     = toString(arguments.userObject.getActiveStatus()),
            "password"   = "      ",
            "avatar"     = arguments.userObject.getAvatarPath(false),
            "actualUser" = arguments.userObject.getUserId() == request.user.getUserId(),
            "themeId"    = toString(arguments.userObject.getThemeId())
        };
    }
}