component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.conversationId = null;
        
        variables.qRes          = null;
        variables.results       = null;
        
        return this;
    }
    
    public filter function setConversationId(required numeric conversationId) {
        variables.conversationId = arguments.conversationId;
        
        return this;
    }
    
    public filter function execute() {
        if(variables.conversationId == null) {
            throw(type = "nephthys.application.invalidResource", message = "The conversationId is required and has to be set!");
        }
        
        var qryFilter = new Query();
        
        var sql = "SELECT userId
                     FROM IcedReaper_privateMessage_participant ";
        var where = "";
        if(variables.conversationId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " conversationId = :conversationId ";
            qryFilter.addParam(name = "conversationId", value = variables.conversationId, cfsqltype = "cf_sql_numeric");
        }
        
        var sortBy = " ORDER BY userId ASC";
        
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
            variables.results.append(new user(variables.qRes.userId[i]));
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