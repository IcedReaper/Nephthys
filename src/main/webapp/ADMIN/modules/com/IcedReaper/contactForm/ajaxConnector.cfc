component {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    remote array function getList() {
        var filterCtrl = new filter().for("request");
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
                "requestorUserId" = rawRequests[i].getRequestor().getUserId(),
                "userName"        = rawRequests[i].getUserName(),
                "replied"         = rawRequests[i].getReplies().len() != 0,
                "replyCount"      = rawRequests[i].getReplies().len()
            });
        }
        
        return requests;
    }
    
    remote struct function getDetails(required numeric requestId) {
        var contactRequest = new request(arguments.requestId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        if(! contactRequest.getRead()) {
            contactRequest.setRead(true)
                          .save(request.user);
        }
        
        return {
            "requestId"       = contactRequest.getRequestId(),
            "requestDate"     = formatCtrl.formatDate(contactRequest.getRequestDate()),
            "subject"         = contactRequest.getSubject(),
            "requestorUserId" = contactRequest.getRequestor().getUserId(),
            "email"           = contactRequest.getEmail(),
            "userName"        = contactRequest.getUserName(),
            "message"         = contactRequest.getMessage()
        };
    }
    
    remote array function getReplies(required numeric requestId) {
        var contactRequest = new request(arguments.requestId);
        var rawReplies = contactRequest.getReplies();
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
             .save(request.user);
        
        return true;
    }
}