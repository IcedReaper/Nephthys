component {
    import "API.modules.com.Nephthys.user.*";
    
    public message function init(required numeric messageId = 0) {
        variables.messageId = arguments.messageId;
        
        load();
        
        return this;
    }
    
    
    public message function setConversationId(required numeric conversationId) {
        if(variables.messageId != 0 && variables.messageId != null) {
            throw(type = "nephthys.application.notAllowed", message = "The conversation cannot be changed for an existing message!");
        }
        
        variables.conversationId = arguments.conversationId;
        
        return this;
    }
    public message function setMessage(required string message) {
        if(variables.messageId != 0 && variables.messageId != null) {
            throw(type = "nephthys.application.notAllowed", message = "The message cannot be changed for an existing message!");
        }
        
        variables.message = arguments.message;
        
        return this;
    }
    public message function setUserId(required numeric userId) {
        if(variables.messageId != 0 && variables.messageId != null) {
            throw(type = "nephthys.application.notAllowed", message = "The user cannot be changed for an existing message!");
        }
        
        variables.userId = arguments.userId;
        variables.user = new user(variables.userId);
        
        return this;
    }
    public message function setUser(required user user) {
        if(variables.messageId != 0 && variables.messageId != null) {
            throw(type = "nephthys.application.notAllowed", message = "The user cannot be changed for an existing message!");
        }
        
        variables.user = arguments.user;
        variables.userId = variables.user.getUserId();
        
        return this;
    }
    
    
    public numeric function getConversationId() {
        return variables.conversationId;
    }
    public numeric function getUserId() {
        return variables.userId;
    }
    public any function getSendDate() {
        return variables.sendDate;
    }
    public any function getDeleteDate() {
        return variables.deleteDate;
    }
    public boolean function getRead() {
        return variables.read;
    }
    /*public any function getReadDate() {
        return variables.readDate;
    }*/
    public string function getMessage() {
        return variables.message;
    }
    
    public user function getUser() {
        return variables.user;
    }
    
    public conversation function getConversation() {
        if(variables.conversation == null) {
            variables.conversation = new conversation(variables.conversationId);
        }
        
        return variables.conversation;
    }
    
    public boolean function isDeleted() {
        return variables.deleteDate != null;
    }
    
    
    public message function send() {
        if(variables.messageId == 0 || variables.messageId == null) {
            variables.messageId = new Query().setSQL("INSERT INTO IcedReaper_privateMessage_message
                                                                  (
                                                                      conversationId,
                                                                      userId,
                                                                      message
                                                                  )
                                                           VALUES (
                                                                      :conversationId,
                                                                      :userId,
                                                                      :message
                                                                  );
                                                           SELECT currval('seq_icedreaper_privateMessage_messageId' :: regclass) newMessageId;")
                                             .addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "userId",         value = variables.userId,         cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "message",        value = variables.message,        cfsqltype = "cf_sql_varchar")
                                             .execute()
                                             .getResult()
                                             .newMessageId[1];
        }
        
        return this;
    }
    public message function delete() {
        if(variables.messageId != 0 && variables.messageId != null) {
            // TODO
        }
    }
    /*public message function read() {
        if(variables.messageId != 0 && variables.messageId != null) {
            // TODO
        }
    }*/
    
    
    private void function load() {
        if(variables.messageId != 0 && variables.messageId != null) {
            var qMessage = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_privateMessage_message
                                                WHERE messageId = :messageId")
                                     .addParam(name = "messageId", value = variables.messageId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
            
            if(qMessage.getRecordCount() == 1) {
                variables.conversationId = qMessage.conversationId[1];
                variables.userId         = qMessage.userId[1];
                variables.sendDate       = qMessage.sendDate[1];
                variables.deleteDate     = qMessage.deleteDate[1];
                /*variables.read           = qMessage.read[1];
                variables.readDate       = qMessage.readDate[1];*/
                variables.message           = qMessage.message[1];
            }
            else {
                throw(type = "nephthys.notFound.general", message = "Message could not be found");
            }
        }
        else {
            variables.conversationId = null;
            variables.userId         = null;
            variables.sendDate       = null;
            variables.deleteDate     = null;
            /*variables.read           = false;
            variables.readDate       = null;*/
            variables.message           = "";
        }
        
        variables.user = new user(variables.userId);
        variables.conversation = null;
    }
    // read has to be changed per user...
}