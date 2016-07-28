component {
    import "API.modules.com.Nephthys.userManager.*";
    import "API.modules.com.Nephthys.userManager.statistics.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList() {
        var userListCtrl = new filter().for("user");
        
        var data = [];
        
        for(var user in userListCtrl.execute().getResult()) {
            data.append({
                "userId"   = user.getUserId(),
                "username" = user.getUserName(),
                "email"    = user.getEmail(),
                "statusId" = user.getStatus().getStatusId()
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
                                required numeric statusId,
                                required string  password,
                                required numeric wwwThemeId,
                                required numeric adminThemeId) {
        var user = new user(arguments.userId);
        var encryptionMethodLoader = createObject("component", "API.tools.com.Nephthys.security.encryptionMethodLoader").init();
        
        if(arguments.userId == 0) {
            user.setUsername(arguments.userName);
        }
        
        user.setEmail(arguments.eMail)
            .setStatus(new status(arguments.statusId))
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
    
    remote boolean function pushToStatus(required numeric userId, required numeric statusId) {
        new user(arguments.userId).pushToStatus(new status(arguments.statusId), request.user);
        
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
        var permissionFilter = new filter().for("permission").setUserId(arguments.userId)
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
        
        var moduleFilter = createObject("component", "API.modules.com.Nephthys.moduleManager.filter").init().for("module")
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
        var roleFilter = createObject("component", "API.modules.com.Nephthys.userManager.filter").for("permissionRole");
        
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
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.themeManager.filter").init().for("theme");
        
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
        
        var extPropertyFilter = new filter().for("extProperty")
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
        
        var extPropertyKeyFilter = new filter().for("extPropertyKey").execute();
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
        var roleFilter = new filter().for("permissionRole").execute();
        var roles = {};
        for(var role in roleFilter.getResult()) {
            userRoles[role.getName()] = request.user.hasPermission("com.Nephthys.userManager", role.getName());
        }
        
        return userRoles;
    }
    
    remote array function getBlacklist() {
        var blacklistEntries = [];
        for(var blacklistEntry in new filter().for("blacklist").execute().getResult()) {
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
    
    
    
    remote struct function getStatusList() {
        var statusLoader = new filter().for("status");
        
        var prepStatus = {};
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus[status.getStatusId()] = prepareStatus(status);
        }
        
        return prepStatus;
    }
    
    remote array function getStatusListAsArray() {
        var statusLoader = new filter().for("status");
        
        var prepStatus = [];
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus.append(prepareStatusAsArray(status));
        }
        
        return prepStatus;
    }
    
    remote struct function getStatusDetails(required numeric statusId) {
        return prepareStatus(new status(arguments.statusId));
    }
    
    remote boolean function saveStatus(required struct status) {
        transaction {
            var status = new status(arguments.status.statusId);
            
            status.setActiveStatus(arguments.status.active)
                  .setCanLogin(arguments.status.canLogin)
                  .setName(arguments.status.name)
                  .setShowInTasklist(arguments.status.showInTasklist)
                  .setLastEditor(request.user)
                  .save();
            
            transactionCommit();
            return true;
        }
    }
    
    remote boolean function deleteStatus(required numeric statusId) {
        if(arguments.statusId == application.system.settings.getValueOfKey("com.Nephthys.userManager.defaultStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete the start status. Please reset the start status in the system settings");
        }
        
        var userStillWithThisStatus = new filter().for("user")
                                                  .setStatusId(arguments.statusId)
                                                  .execute()
                                                  .getResultCount();
        
        if(userStillWithThisStatus == 0) {
            new status(arguments.statusId).delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & userStillWithThisStatus & " user on this status.");
        }
    }
    
    remote boolean function activateStatus(required numeric statusId) {
        var status = new status(arguments.statusId);
        
        status.setActiveStatus(true)
              .save();
        
        return true;
    }
    
    remote boolean function deactivateStatus(required numeric statusId) {
        new status(arguments.statusId).setActiveStatus(false)
                                      .save();
        
        return true;
    }
    
    remote boolean function saveStatusFlow(required array statusFlow) {
        var i = 0;
        var j = 0;
        var k = 0;
        var found = false;
        transaction {
            for(i = 1; i <= arguments.statusFlow.len(); ++i) {
                var status = new status(arguments.statusFlow[i].statusId);
                
                var nextStatus = status.getNextStatus();
                
                for(j = 1; j <= nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= arguments.statusFlow[i].nextStatus.len() && ! found; ++k) {
                        if(nextStatus[j].getStatusId() == arguments.statusFlow[i].nextStatus[k].statusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        status.removeNextStatus(nextStatus[j].getStatusId());
                    }
                }
                
                for(j = 1; j <= arguments.statusFlow[i].nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= nextStatus.len() && ! found; ++k) {
                        if(nextStatus[k].getStatusId() == arguments.statusFlow[i].nextStatus[j].statusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        status.addNextStatus(arguments.statusFlow[i].nextStatus[j].statusId);
                    }
                }
                
                status.save();
            }
            
            transactionCommit();
        }
        
        return false;
    }
    
    
    remote array function getUserInTasklist() {
        var statusFilter = new filter().for("status")
                                       .setShowInTasklist(true)
                                       .execute();
        
        var userFilter = new filter().for("user");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilter.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["user"] = [];
            
            for(var user in userFilter.setStatusId(status.getStatusId()).execute().getResult()) {
                var lastApproverFilter = new filter().for("approval")
                                                     .setUserId(user.getUserId())
                                                     .setLimit(1)
                                                     .setSortDirection("DESC")
                                                     .execute();
                var lastApprover = {};
                var lastApprovalDate = "";
                if(lastApproverFilter.getResultCount() == 1) {
                    var approval = lastApproverFilter.getResult()[1];
                    lastApprover = prepareReducedDetailStruct(approval.getApprover());
                    lastApprovalDate = formatCtrl.formatDate(approval.getApprovalDate());
                }
                
                statusData[index]["user"].append({
                    "userId"           = user.getUserId(),
                    "username"         = user.getUserName(),
                    "email"            = user.getEmail(),
                    "statusId"         = user.getStatus().getStatusId(),
                    "avatar"           = user.getAvatarPath(),
                    "lastApprover"     = lastApprover,
                    "lastApprovalDate" = lastApprovalDate
                });
            }
        }
        
        return statusData;
    }
    
    
    // P R I V A T E   M E T H O D S
    private struct function prepareDetailStruct(required user user) {
        var preparedApprovalList = prepareApprovalList(new filter().for("approval")
                                                                   .setUserId(arguments.user.getUserId())
                                                                   .setSortDirection("DESC")
                                                                   .execute()
                                                                   .getResult());
        
        return {
            "userId"           = arguments.user.getUserId(),
            "username"         = arguments.user.getUserName(),
            "email"            = arguments.user.getEmail(),
            "statusId"         = arguments.user.getStatus().getStatusId(),
            "password"         = "      ",
            "avatar"           = arguments.user.getAvatarPath(false),
            "actualUser"       = arguments.user.getUserId() == request.user.getUserId(),
            "registrationDate" = formatCtrl.formatDate(arguments.user.getRegistrationDate()),
            "wwwThemeId"       = arguments.user.getThemeId(),
            "adminThemeId"     = arguments.user.getThemeId(),
            "approvalList"     = preparedApprovalList
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
    
    private struct function prepareStatus(required status status) {
        var nextStatusList = {};
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList[nextStatus.getStatusId()] = {
                    "statusId"       = nextStatus.getStatusId(),
                    "name"           = nextStatus.getName(),
                    "active"         = nextStatus.isActive(),
                    "canLogin"       = nextStatus.getCanLogin()
                };
            }
        }
        
        return {
            "statusId"       = arguments.status.getStatusId(),
            "name"           = arguments.status.getName(),
            "active"         = arguments.status.isActive(),
            "canLogin"       = arguments.status.getCanLogin(),
            "showInTasklist" = arguments.status.getShowInTasklist(),
            "nextStatus"     = nextStatusList
        };
    }
    
    private struct function prepareStatusAsArray(required status status) {
        var nextStatusList = [];
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList.append({
                    "statusId"       = nextStatus.getStatusId(),
                    "name"           = nextStatus.getName(),
                    "active"         = nextStatus.isActive(),
                    "canLogin"       = nextStatus.getCanLogin()
                });
            }
        }
        
        return {
            "statusId"       = arguments.status.getStatusId(),
            "name"           = arguments.status.getName(),
            "active"         = arguments.status.isActive(),
            "canLogin"       = arguments.status.getCanLogin(),
            "showInTasklist" = arguments.status.getShowInTasklist(),
            "nextStatus"     = nextStatusList
        };
    }
    
    private array function prepareApprovalList(required array approvalList) {
        var preparedApprovalList = [];
        for(var approval in arguments.approvalList) {
            preparedApprovalList.append({
                "approver"           = prepareReducedDetailStruct(approval.getApprover()),
                "approvalDate"       = formatCtrl.formatDate(approval.getApprovalDate()),
                "previousStatusName" = approval.getPrevStatus().getName(),
                "newStatusName"      = approval.getNewStatus().getName()
            });
        }
        
        return preparedApprovalList;
    }
}