component {
    public reply function init(required numeric replyId) {
        variables.replyId   = arguments.replyId;
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public reply function setRequestId(required numeric requestId) {
        variables.requestId = arguments.requestId;
        return this;
    }
    public reply function setMessage(required string message) {
        variables.message = arguments.message;
        return this;
    }
    
    // GETTER
    public numeric function getReplyId() {
        return variables.replyId;
    }
    public numeric function getRequestId() {
        return variables.requestId;
    }

    public string function getMessage() {
        return variables.message;
    }

    public numeric function getReplyUserId() {
        return variables.replyUserId;
    }

    public any function getReplyDate() {
        return variables.replyDate;
    }
    
    public user function getReplyUser() {
        return createObject("component", "API.modules.com.Nephthys.user.user").init(variables.replyUserId);
    }
    
    // CRUD
    public reply function save() {
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
                                   .addParam(name = "requestId",   value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                                   .addParam(name = "message",     value = variables.message,        cfsqltype = "cf_sql_varchar")
                                   .addParam(name = "replyUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                   .execute();
                        
                        /* todo: to smtp server to check this feature...
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
    
    // PRIVATE
    private void function loadDetails() {
        if(variables.replyId != null && variables.replyId != 0) {
            var qReply = new Query().setSQL("SELECT *
                                               FROM IcedReaper_contactForm_reply
                                              WHERE replyId = :replyId")
                                    .addParam(name = "replyId", value = variables.replyId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qReply.getRecordCount() == 1) {
                variables.requestId   = qReply.requestId[1];
                variables.message     = qReply.message[1];
                variables.replyUserId = qReply.replyUserId[1];
                variables.replyDate   = qReply.replyDate[1];
            }
            else {
                throw(type = "icedreaper.contactForm.notFound", message = "Could not find a reply with this Id");
            }
        }
        else {
            variables.requestId   = 0;
            variables.message     = "";
            variables.replyUserId = null;
            variables.replyDate   = null;
        }
    }
}