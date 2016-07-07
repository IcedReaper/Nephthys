component {
    import "API.modules.com.IcedReaper.permissionRequest.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getRequestsInTasklist() {
        var requests = new filter().setFor("request")
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
                    "name" = _request.getRole().name
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
    
    remote boolean function approve(required numeric requestId, required string comment) {
        transaction {
            var _request = new request(arguments.requestId).approve(arguments.comment);
            
            var permissionHandlerCtrl = application.system.settings.getValueOfKey("permissionManager");
            
            var existingRole = permissionHandlerCtrl.loadRoleForUserInModule(_request.getUserId(),
                                                                             _request.getModuleId());
            
            if(existingRole.isEmpty()) {
                permissionHandlerCtrl.setPermission(null,
                                                    _request.getUserId(),
                                                    _request.getRoleId(),
                                                    _request.getModuleId());
            }
            else {
                permissionHandlerCtrl.setPermission(existingRole.permissionId,
                                                    _request.getUserId(),
                                                    _request.getRoleId(),
                                                    _request.getModuleId());
            }
            
            transactionCommit();
        }
        
        return true;
    }
    
    remote boolean function decline(required numeric requestId, required string comment) {
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
                "name" = _request.getRole().name
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
        var requests = new filter().setFor("request")
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
                    "name" = _request.getRole().name
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