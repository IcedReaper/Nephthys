component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.privateMessage.*";
    
    public filter function init() {
        variables.participantId = null;
        
        variables.conversationId = null;
        variables.unreadOnly     = false;
        
        variables.offset        = 0;
        variables.count         = 0;
        variables.sortBy        = "lastMessageDate";
        variables.sortDirection = "DESC";
        
        variables.qRes          = null;
        variables.results       = null;
        
        return this;
    }
    
    public filter function setParticipantId(required numeric participantId) {
        variables.participantId = arguments.participantId;
        
        return this;
    }
    
    public filter function setConversationId(required numeric conversationId) {
        variables.conversationId = arguments.conversationId;
        
        return this;
    }
    
    public filter function setUnreadOnly(required boolean unread) {
        variables.unreadOnly = arguments.unread;
        
        return this;
    }
    
    public filter function setSortBy(required string sortBy) {
        switch(lCase(arguments.sortBy)) {
            case 'lastmessagedate':
            case 'conversationstartdate': {
                variables.sortBy = arguments.sortBy;
                
                break;
            }
        }
        
        return this;
    }
    
    public filter function setSortDirection(required string sortDirection) {
        switch(lCase(arguments.sortDirection)) {
            case 'asc':
            case 'desc': {
                variables.sortDirection = arguments.sortDirection;
                
                break;
            }
        }
        
        return this;
    }
    
    public filter function setOffset(required numeric offset) {
        if(arguments.offset > 0) {
            variables.offset = arguments.offset;
        }
        
        return this;
    }
    
    public filter function setCount(required numeric count) {
        if(arguments.count > 0) {
            variables.count = arguments.count;
        }
        
        return this;
    }
    
    
    public filter function execute() {
        if(variables.participantId == null) {
            throw(type = "nephthys.application.invalidResource", message = "The participantId is required and has to be set!");
        }
        
        var qryFilter = new Query();
        
        var sql = "";
        
        if(! variables.unreadOnly) {
            var sortColumn = "";
            
            switch(lCase(variables.sortBy)) {
                case 'conversationstartdate': {
                    sortColumn = "c.startDate";
                    break;
                }
                default: {
                    sortColumn = "MAX(m.sendDate)";
                }
            }
            
            sql = "    SELECT c.conversationId
                         FROM IcedReaper_privateMessage_conversation c
                   INNER JOIN IcedReaper_privateMessage_message m ON c.conversationId = m.conversationId
                   INNER JOIN (SELECT participant.conversationId
                                 FROM IcedReaper_privateMessage_participant participant
                                WHERE participant.userId = :participantId) p ON c.conversationId = p.conversationId";
            var where = "";
            var orderBy = " GROUP BY c.conversationId
                            ORDER BY " & sortColumn & " " & variables.sortDirection;
            
            qryFilter.addParam(name = "participantId", value = variables.participantId, cfsqltype = "cf_sql_numeric");
            
            if(variables.conversationId != null) {
                where &= (where != "" ? " WHERE " : " AND ") & " c.conversationId = :conversationId ";
                qryFilter.addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric");
            }
            
            sql &= where & orderBy;
        }
        else {
            sql = "SELECT m.messageId
                     FROM IcedReaper_privateMessage_message m
                    WHERE m.messageId NOT IN (SELECT r.messageId
                                                FROM IcedReaper_privateMessage_read r
                                               WHERE r.userId = :participantId)
                      AND m.conversationId IN (    SELECT c.conversationId
                                                     FROM IcedReaper_privateMessage_conversation c
                                               INNER JOIN (SELECT participant.conversationId
                                                             FROM IcedReaper_privateMessage_participant participant
                                                            WHERE participant.userId = :participantId) p ON c.conversationId = p.conversationId)
                   ORDER BY m.sendDate DESC";
            
            qryFilter.addParam(name = "participantId", value = variables.participantId, cfsqltype = "cf_sql_numeric");
        }
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        variables.results = [];
        
        var to = variables.offset + variables.count;
        if(to == 0 || to > variables.qRes.getRecordCount()) {
            to = variables.qRes.getRecordCount();
        }
        
        for(var i = variables.offset + 1; i <= to; i++) {
            if(! variables.unreadOnly) {
                variables.results.append(new conversation(variables.qRes.conversationId[i]));
            }
            else {
                variables.results.append(new message(variables.qRes.messageId[i]));
            }
        }
        return variables.results;
    }
    
    public numeric function getResultCount() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        return variables.qRes.getRecordCount();
    }
}