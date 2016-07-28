component {
    import "API.modules.com.IcedReaper.permissionRequest.*";
    import "API.modules.com.Nephthys.userManager.permission";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getRequestsInTasklist() {
        var requests = new filter().for("request")
                                   .setStatus(0)
                                   .execute()
                                   .getResult();
        
        var preparedRequests = [];
        
        for(var _request in requests) {
            preparedRequests.append({
                "requestId" = _request.getRequestId(),
                "module" = {
                    "name" = _request.getModule().getModuleName()
                },
                "role" = {
                    "name" = _request.getPermissionRole().getName()
                },
                "reason" = _request.getReason(),
                "creator" = {
                    "userId"   = _request.getUser().getUserId(),
                    "userName" = _request.getUser().getUserName(),
                    "avatar"   = _request.getUser().getAvatarPath()
                },
                "creationDate" =  formatCtrl.formatDate(_request.getCreationDate())
            });
        }
        
        return preparedRequests;
    }
    
    remote boolean function approve(required numeric requestId, required string comment = "") {
        transaction {
            var _request = new request(arguments.requestId).approve(arguments.comment);
            
            var permissionFilter = createObject("API.modules.com.Nephthys.userManager.filter").for("permission");
            
            permissionFilter.setUserId(_request.getUserId())
                            .setModuleId(_request.getModuleId())
                            .execute();
            
            if(permissionFilter.getResultCount() == 1) {
                permissionFilter.getResult()[1].setPermissionRole(_request.getPermissionRole())
                                               .save();
            }
            else {
                var permission = new permission(null);
                permission.setUser(_request.getUser())
                          .setModule(_request.getModule())
                          .setPermissionRole(_request.getPermissionRole())
                          .save();
            }
            
            transactionCommit();
        }
        
        return true;
    }
    
    remote boolean function decline(required numeric requestId, required string comment = "") {
        new request(arguments.requestId).decline(arguments.comment);
        
        return true;
    }
    
    remote struct function getRequest(required numeric requestId) {
        var _request = new request(arguments.requestId);
        
        return {
            "requestId" = _request.getRequestId(),
            "module" = {
                "name" = _request.getModule().getModuleName()
            },
            "role" = {
                "name" = _request.getPermissionRole().getName()
            },
            "reason" = _request.getReason(),
            "creator" = {
                "userId"   = _request.getUser().getUserId(),
                "userName" = _request.getUser().getUserName(),
                "avatar"   = _request.getUser().getAvatarPath()
            },
            "creationDate" =  formatCtrl.formatDate(_request.getCreationDate()),
            "admin" = {
                "userId"   = _request.getAdminUser().getUserId(),
                "userName" = _request.getAdminUser().getUserName(),
                "avatar"   = _request.getAdminUser().getAvatarPath()
            },
            "comment" = _request.getComment(),
            "status"  = _request.getStatus()
        };
    }
    
    remote array function getList() {
        var requests = new filter().for("request")
                                   .execute()
                                   .getResult();
        
        var preparedRequests = [];
        
        for(var _request in requests) {
            preparedRequests.append({
                "requestId" = _request.getRequestId(),
                "module" = {
                    "name" = _request.getModule().getModuleName()
                },
                "role" = {
                    "name" = _request.getPermissionRole().getName()
                },
                "reason" = _request.getReason(),
                "creator" = {
                    "userId"   = _request.getUser().getUserId(),
                    "userName" = _request.getUser().getUserName(),
                    "avatar"   = _request.getUser().getAvatarPath()
                },
                "creationDate" =  formatCtrl.formatDate(_request.getCreationDate()),
                "status"       = _request.getStatus()
            });
        }
        
        return preparedRequests;
    }
}