component {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    remote array function getList() {
        var filterCtrl = new filter();
        var rawRequests = filterCtrl.execute()
                                    .getResult();
        
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var requests = [];
        for(var i = 1; i <= arrayLen(rawRequests); ++i) {
            requests.append({
                "requestId"       = rawRequests[i].getRequestId(),
                "read"            = rawRequests[i].getRead(),
                "requestDate"     = formatCtrl.formatDate(rawRequests[i].getRequestDate()),
                "subject"         = rawRequests[i].getSubject(),
                "requestorUserId" = rawRequests[i].getRequestorUserId(),
                "userName"        = rawRequests[i].getUserName(),
                "replied"         = rawRequests[i].getReplies().len() != 0,
                "replyCount"      = rawRequests[i].getReplies().len()
            });
        }
        
        return requests;
    }
    
    remote struct function getDetails(required numeric requestId) {
        var cf_request = new request(arguments.requestId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        if(! cf_request.getRead()) {
            cf_request.setRead(true)
                      .save();
        }
        
        return {
            "requestId"       = cf_request.getRequestId(),
            "requestDate"     = formatCtrl.formatDate(cf_request.getRequestDate()),
            "subject"         = cf_request.getSubject(),
            "requestorUserId" = cf_request.getRequestorUserId(),
            "email"           = cf_request.getEmail(),
            "userName"        = cf_request.getUserName(),
            "message"         = cf_request.getMessage()
        };
    }
    
    remote array function getReplies(required numeric requestId) {
        var cf_request = new request(arguments.requestId);
        var rawReplies = cf_request.getReplies();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var replies = [];
        for(var i = 1; i <= rawReplies.len(); ++i) {
            replies.append({
                "replyId"   = rawReplies[i].getReplyId(),
                "replyDate" = formatCtrl.formatDate(rawReplies[i].getReplyDate()),
                "userName"  = rawReplies[i].getReplyUser().getUserName(),
                "message"   = rawReplies[i].getMessage()
            });
        }
        
        return replies;
    }
    
    remote boolean function reply(required numeric requestId, required string message) {
        var reply = new reply(0);
        
        reply.setRequestId(arguments.requestId)
             .setMessage(arguments.message)
             .save();
        
        return true;
    }
}