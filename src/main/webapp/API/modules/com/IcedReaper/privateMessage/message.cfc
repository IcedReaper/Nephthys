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
    
    
    public numeric function getMessageId() {
        return variables.messageId;
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
    public string function getMessage() {
        return variables.message;
    }
    
    public user function getUser() {
        return variables.user;
    }
    
    public conversation function getConversation() {
        if(isNull(variables.conversation)) {
            variables.conversation = new conversation(variables.conversationId);
        }
        
        return variables.conversation;
    }
    
    public boolean function isDeleted() {
        return variables.deleteDate != null;
    }
    
    public boolean function isRead(required user user) {
        for(var i = 1; i <= variables.read.len(); ++i) {
            if(variables.read[i].read && variables.read[i].user.getUserId() == arguments.user.getUserId()) {
                return true;
            }
        }
        
        return false;
    }
    
    public any function getReadDate(required user user) {
        for(var i = 1; i <= variables.read.len(); ++i) {
            if(variables.read[i].read && variables.read[i].user.getUserId() == arguments.user.getUserId()) {
                return variables.read[i].readDate;
            }
        }
        
        return null;
    }
    
    public boolean function isReadByAll() {
        var readByAll = true;
        
        for(participant in getConversation().getParticipants()) {
            if(! isRead(participant)) {
                readByAll = false;
                break;
            }
        }
        
        return readByAll;
    }
    
    public boolean function isReadByOther(required user user) {
        var readByOther = false;
        
        for(participant in getConversation().getParticipants()) {
            if(participant.getUserId() != arguments.user.getUserId()) {
                if(isRead(participant)) {
                    readByOther = true;
                    break;
                }
            }
        }
        
        return readByOther;
    }
    
    public array function getOtherReadData(required user user) {
        var tmpRead = variables.read;
        
        for(var i = 1; i <= tmpRead.len(); ++i) {
            if(tmpRead[i].user.getUserId() == arguments.user.getUserId()) {
                tmpRead.deleteAt(i);
                break;
            }
        }
        
        return tmpRead;
    }
    
    public boolean function getReadData(required user user) {
        for(var i = 1; i <= variables.read.len(); ++i) {
            if(variables.read[i].read && variables.read[i].user.getUserId() == arguments.user.getUserId()) {
                return duplicate(variables.read[i]);
            }
        }
        
        return false;
    }
    
    public array function getAllReadData() {
        return variables.read;
    }
    
    public struct function getLastRead(required user user) {
        for(var i = 1; i <= variables.read.len(); ++i) {
            if(variables.read[i].user.getUserId() != arguments.user.getUserId()) {
                return duplicate(variables.read[i]);
            }
        }
        
        return null;
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
                                                           SELECT currval('seq_icedreaper_privateMessage_messageId') newMessageId;")
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
            new Query().setSQL("UPDATE IcedReaper_privateMessage_message
                                   SET deleteDate = now()
                                 WHERE messageId = :messageId")
                       .addParam(name = "messageId", value = variables.messageId, cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot mark a non existing message as deleted");
        }
        
        return this;
    }
    public message function read(required user user) {
        if(variables.messageId != 0 && variables.messageId != null) {
            if(! isRead(arguments.user)) {
                new Query().setSQL("INSERT INTO IcedReaper_privateMessage_read
                                                (
                                                    messageId,
                                                    userId
                                                )
                                         VALUES (
                                                    :messageId,
                                                    :userId
                                                )")
                           .addParam(name = "messageId", value = variables.messageId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "userId",    value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        
        return this;
    }
    
    
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
                variables.message        = qMessage.message[1];
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
            variables.message           = "";
        }
        
        variables.user = new user(variables.userId);
        variables.conversation = null;
        
        loadRead();
    }
    
    private void function loadRead() {
        variables.read = [];
        
        var readInfo = new Query().setSQL("  SELECT readDate, userId
                                               FROM IcedReaper_privateMessage_read
                                              WHERE messageId = :messageId
                                           ORDER BY readDate DESC")
                                  .addParam(name = "messageId", value = variables.messageId, cfsqltype = "cf_sql_numeric")
                                  .execute()
                                  .getResult();
        
        for(var i = 1; i <= readInfo.getRecordCount(); ++i) {
            variables.read[i] = {
                read     = true,
                user     = new user(readInfo.userId[i]),
                readDate = readInfo.readDate[i]
            };
        }
        
        for(participant in getConversation().getParticipants()) {
            for(i = 1; i <= variables.read.len(); ++i) {
                if(variables.read[i].user.getUserId() == participant.getUserId()) {
                    variables.read.append({
                        read     = false,
                        user     = participant,
                        readDate = null
                    });
                    
                    break;
                }
            }
        }
    }
}