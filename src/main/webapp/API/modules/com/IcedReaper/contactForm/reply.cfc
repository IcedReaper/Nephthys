component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public reply function init(required numeric replyId) {
        variables.replyId   = arguments.replyId;
        
        loadDetails();
        
        return this;
    }
    
    
    public reply function setRequestId(required numeric requestId) {
        variables.requestId = arguments.requestId;
        return this;
    }
    public reply function setMessage(required string message) {
        variables.message = arguments.message;
        return this;
    }
    
    
    public numeric function getReplyId() {
        return variables.replyId;
    }
    public numeric function getRequestId() {
        return variables.requestId;
    }
    public string function getMessage() {
        return variables.message;
    }
    public any function getReplyDate() {
        return variables.replyDate;
    }
    public user function getReplyUser() {
        return variables.replyUser;
    }
    
    
    public reply function save(required user user) {
        if(variables.replyId == 0 || variables.replyId == null) {
            if(variables.requestId != 0 && variables.requestId != null) {
                if(variables.message != "") {
                    transaction {
                        new Query().setSQL("INSERT INTO IcedReaper_contactForm_reply
                                                        (
                                                            requestId,
                                                            message,
                                                            replyUserId
                                                        )
                                                 VALUES (
                                                            :requestId,
                                                            :message,
                                                            :replyUserId
                                                        )")
                                   .addParam(name = "requestId",   value = variables.requestId,        cfsqltype = "cf_sql_numeric")
                                   .addParam(name = "message",     value = variables.message,          cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "replyUserId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                   .execute();
                        
                        variables.replyUser = arguments.user;
                        variables.replyDate = now();
                        
                        /* todo: setup smtp server to check this feature...
                        var cf_request = new request(variables.requestId);
                        var eMail = new mail().setFrom(request.user.getUsername() & "<" & request.user.getEmail() & ">")
                                              .setTo(cf_request.getEmail())
                                              .setSubject("Antwort auf Ihre Anfrage: " & cf_request.getSubject())
                                              .setType("html")
                                              .setBody(variables.message)
                                              .send();*/
                        
                        transactionCommit();
                    }
                }
                else {
                    throw(type = "nephthys.application.notAllowed", message = "It's not allowed to send a reply without a message.");
                }
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "The reply has to be linked to a request.");
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The reply is already saved. It's not allowed to update the reply.");
        }
        
        return this;
    }
    
    
    private void function loadDetails() {
        if(variables.replyId != null && variables.replyId != 0) {
            var qReply = new Query().setSQL("SELECT *
                                               FROM IcedReaper_contactForm_reply
                                              WHERE replyId = :replyId")
                                    .addParam(name = "replyId", value = variables.replyId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qReply.getRecordCount() == 1) {
                variables.requestId = qReply.requestId[1];
                variables.message   = qReply.message[1];
                variables.replyUser = new user(qReply.replyUserId[1]);
                variables.replyDate = qReply.replyDate[1];
            }
            else {
                throw(type = "icedreaper.contactForm.notFound", message = "Could not find a reply with this Id");
            }
        }
        else {
            variables.requestId   = 0;
            variables.message     = "";
            variables.replyUserId = new user(null);
            variables.replyDate   = null;
        }
    }
}