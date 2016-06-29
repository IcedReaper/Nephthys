component {
    public conversation function init(required numeric conversationId = 0) {
        variables.conversationId = arguments.conversationId;
        
        variables.participantsAdded = [];
        variables.participantsRemoved = [];
        
        load();
        
        return this;
    }
    
    public conversation function setInitiator(required user user) {
        variables.initiator = arguments.user;
        
        return this;
    }
    
    public conversation function addParticipant(required user user) {
        if(arguments.user.isActive()) {
            if(isNull(variables.participants)) {
                loadParticipants();
            }
            
            var index = 0;
            
            for(var i = 1; i <= variables.participants.len(); ++i) {
                if(variables.participants[i].getUserId() == arguments.user.getUserId()) {
                    index = i;
                    break;
                }
            }
            
            if(index == 0) {
                variables.participants.append(arguments.user);
                
                index = variables.participantsRemoved.find(arguments.user.getUserId());
                
                if(index != 0) {
                    variables.participantsRemoved.deleteAt(index);
                }
                else {
                    variables.participantsAdded.append(arguments.user.getUserId());
                }
            }
        }
        
        return this;
    }
    
    public function removeParticipant(required user user) {
        if(arguments.user.arguments.user.isActive()) {
            if(isNull(variables.participants)) {
                loadParticipants();
            }
            
            var index = 0;
            for(var i = 1; i <= variables.participants.len(); ++i) {
                if(variables.participants[i].getUserId() == arguments.user.getUserId()) {
                    index = i;
                    break;
                }
            }
            
            if(index != 0) {
                variables.participants.deleteAt(index);
                
                index = variables.participantsAdded.find(arguments.user.getUserId());
                
                if(index != 0) {
                    variables.participantsAdded.deleteAt(index);
                }
                else {
                    variables.participantsRemoved.append(arguments.participants[index].getUserId());
                }
            }
        }
        
        return this;
    }
    
    public conversation function addMessage(required message message) {
        if(isNull(variables.messages)) {
            loadMessages();
        }
        
        variables.messages.append(arguments.message);
        
        return this;
    }
    
    public numeric function getConversationId() {
        return variables.conversationId;
    }
    public user function getInitiator() {
        return variables.initiator;
    }
    public array function getParticipants() {
        if(isNull(variables.participants)) {
            loadParticipants();
        }
        
        return variables.participants;
    }
    public any function getStartDate() {
        return variables.startDate;
    }
    public array function getMessages() {
        if(isNull(variables.messages)) {
            loadMessages();
        }
        
        return variables.messages;
    }
    public message function getLastMessage() {
        if(isNull(variables.messages)) {
            loadMessages();
        }
        
        for(var i = 1; i <= variables.messages.len(); ++i) {
            if(! variables.messages[i].isDeleted()) {
                return variables.messages[i];
            }
        }
        return null;
    }
    
    
    public boolean function isParticipant(required user user) {
        if(isNull(variables.participants)) {
            loadParticipants();
        }
        
        for(var i = 1; i <= variables.participants.len(); ++i) {
            if(variables.participants[i].getUserId() == arguments.user.getUserId()) {
                return true;
            }
        }
        
        return false;
    }
    
    
    public conversation function save() {
        if(variables.conversationId == 0 || variables.conversationId == null) {
            variables.conversationId = new Query().setSQL("INSERT INTO IcedReaper_privateMessage_conversation
                                                                       (
                                                                           initiatorUserId
                                                                       )
                                                                VALUES (
                                                                           :initiatorUserId
                                                                       );
                                                           SELECT currval('seq_icedreaper_privateMessage_conversationId') newConversationId;")
                                                  .addParam(name = "initiatorUserId", value = variables.initiator.getUserId(), cfsqltype = "cf_sql_numeric")
                                                  .execute()
                                                  .getResult()
                                                  .newConversationId[1];
            
            for(var userId in variables.participantsAdded) {
                new Query().setSQL("INSERT INTO IcedReaper_privateMessage_participant
                                                (
                                                    conversationId,
                                                    userId
                                                )
                                         VALUES (
                                                    :conversationId,
                                                    :userId
                                                )")
                           .addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "userId",         value = userId,                   cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            for(var userId in variables.participantsRemoved) {
                new Query().setSQL("DELETE FROM IcedReaper_privateMessage_participant
                                          WHERE conversationId = :conversationId,
                                            AND userId         = :userId")
                           .addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "userId",         value = userId,                   cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        
        return this;
    }
    
    
    private void function load() {
        if(variables.conversationId != 0 && variables.conversationId != null) {
            var qConversation = new Query().setSQL("SELECT *
                                                      FROM IcedReaper_privateMessage_conversation
                                                     WHERE conversationId = :conversationId")
                                           .addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult();
            
            if(qConversation.getRecordCount() == 1) {
                variables.initiator    = createObject("component", "API.modules.com.Nephthys.user.user").init(qConversation.initiatorUserId[1]);
                variables.participants = null;
                variables.messages     = null;
            }
            else {
                throw(type = "nephthys.notFound.general", message = "Conversation could not be found");
            }
        }
        else {
            variables.initiator    = createObject("component", "API.modules.com.Nephthys.user.user").init(request.user.getUserId());
            variables.participants = null;
            variables.messages     = null;
        }
    }
    
    private void function loadMessages() {
        variables.messages = new filter().setFor("message")
                                         .setConversationId(variables.conversationId)
                                         .setSortBy("sendDate")
                                         .setSortDirection("DESC")
                                         .execute()
                                         .getResult();
    }
    
    private void function loadParticipants() {
        variables.participants = new filter().setFor("participant")
                                             .setConversationId(variables.conversationId)
                                             .execute()
                                             .getResult();
    }
}