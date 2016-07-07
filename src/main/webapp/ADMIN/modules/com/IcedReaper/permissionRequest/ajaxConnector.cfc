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
    
    remote boolean function approve(required numeric requestId) {
        return true;
    }
    
    remote boolean function decline(required numeric requestId) {
        return true;
    }
    
    remote struct function getRequest(required numeric requestId) {
        return {};
    }
}