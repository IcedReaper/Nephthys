component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    public filter function init() {
        variables.contactRequest = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setContactRequest(required contactRequest contactRequest) {
        variables.contactRequest = arguments.contactRequest;
        
        return this;
    }
    
    public filter function execute() {
        if(isNull(variables.contactRequest)) {
            throw(type = "nephthys.application.invalidResource", message = "Please specify the contact form before executing");
        }
        
        var qryFilter = new Query();
        var sql = "SELECT replyId
                     FROM IcedReaper_contactForm_reply ";
        
        var where = " WHERE contactRequestId = :contactRequestId ";
        qryFilter.addParam(name = "contactRequestId", value = variables.contactRequest.getContactRequestId(), cfsqltype = "cf_sql_numeric");
        
        var orderBy = " ORDER BY replyDate DESC ";
        
        sql &= where & orderBy;
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(variables.results == null) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new reply(variables.qRes.replyId[i]));
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