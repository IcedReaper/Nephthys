component {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    remote array function getList() {
        var filterCtrl = new filter().for("contactRequest");
        var rawRequests = filterCtrl.execute()
                                    .getResult();
        
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var contactRequests = [];
        for(var i = 1; i <= arrayLen(rawRequests); ++i) {
            contactRequests.append({
                "contactRequestId" = rawRequests[i].getContactRequestId(),
                "read"             = rawRequests[i].getRead(),
                "requestDate"      = formatCtrl.formatDate(rawRequests[i].getRequestDate()),
                "subject"          = rawRequests[i].getSubject(),
                "requestorUserId"  = rawRequests[i].getRequestor().getUserId(),
                "userName"         = rawRequests[i].getUserName(),
                "replied"          = rawRequests[i].getReplies().len() != 0,
                "replyCount"       = rawRequests[i].getReplies().len()
            });
        }
        
        return contactRequests;
    }
    
    remote struct function getDetails(required numeric contactRequestId = null) {
        var contactRequest = new contactRequest(arguments.contactRequestId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        if(! contactRequest.getRead()) {
            contactRequest.setRead(true)
                          .save(request.user);
        }
        
        return {
            "contactRequestId" = contactRequest.getContactRequestId(),
            "requestDate"      = formatCtrl.formatDate(contactRequest.getRequestDate()),
            "subject"          = contactRequest.getSubject(),
            "requestorUserId"  = contactRequest.getRequestor().getUserId(),
            "email"            = contactRequest.getEmail(),
            "userName"         = contactRequest.getUserName(),
            "message"          = contactRequest.getMessage()
        };
    }
    
    remote array function getReplies(required numeric contactRequestId) {
        var contactRequest = new contactRequest(arguments.contactRequestId);
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
    
    remote boolean function reply(required numeric contactRequestId, required string message) {
        var reply = new reply(null, new contactRequest(arguments.contactRequestId));
        
        reply.setMessage(arguments.message)
             .save(request.user);
        
        return true;
    }
}