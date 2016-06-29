component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.privateMessage.*";
    
    public filter function init() {
        variables.conversationId = null;
        variables.unreadOnly = null;
        
        variables.sortBy        = "lastMessageDate";
        variables.sortDirection = "DESC";
        
        variables.qRes          = null;
        variables.results       = null;
        
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
            case 'senddate': {
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
        if(variables.conversationId == null) {
            throw(type = "nephthys.application.invalidResource", message = "The conversationId is required and has to be set!");
        }
        
        var qryFilter = new Query();
        
        var sql = "SELECT messageId
                     FROM IcedReaper_privateMessage_message ";
        var where = "";
        if(variables.conversationId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " conversationId = :conversationId ";
            qryFilter.addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.unreadOnly != null) {
            if(variables.unreadOnly) {
                where &= (where == "" ? " WHERE " : " AND ") & " m.messageId NOT IN (SELECT r.messageId
                                                                                       FROM IcedReaper_privateMessage_read r
                                                                                      WHERE r.userId = :userId) ";
                qryFilter.addParam(name = "userId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & " m.messageId IN (SELECT r.messageId
                                                                                   FROM IcedReaper_privateMessage_read r
                                                                                  WHERE r.userId = :userId) ";
                qryFilter.addParam(name = "userId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric");
            }
        }
        
        var sortBy = " ORDER BY " & variables.sortBy & " " & variables.sortDirection;
        
        variables.qRes = qryFilter.setSQL(sql & where & sortBy)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        variables.results = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
            variables.results.append(new message(variables.qRes.messageId[i]));
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