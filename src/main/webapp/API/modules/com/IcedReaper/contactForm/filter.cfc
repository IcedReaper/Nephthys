component {
    public filter function init() {
        variables.read            = -1;
        variables.answered        = -1;
        variables.requestorUserId = 0;
        variables.readUserId      = null;
        
        return this;
    }
    
    public filter function setRead(required numeric read) {
        switch(arguments.read) { // 1 = read | 0 = not read | -1 = all
            case 0:
            case 1:
            case -1: {
                variables.read = arguments.read;
            }
        }
        
        return this;
    }
    
    public filter function setAnswered(required numeric answered) {
        switch(arguments.read) { // 1 = answered | 0 = not answered | -1 = all
            case 0:
            case 1:
            case -1: {
                variables.answered = arguments.answered;
            }
        }
        
        return this;
    }
    
    public filter function setRequestorUserId(required numeric userId) {
        variables.requestorUserId = arguments.userId;
        return this;
    }
    
    public filter function setReadUserId(required numeric userId) {
        variables.readUserId = arguments.userId;
        return this;
    }
    
    public array function filter() {
        var qGetRequests = new Query();
        var sql = "SELECT r.requestId
                     FROM icedreaper_contactForm_request r ";
        
        var where = "";
        
        if(variables.read != -1) {
            where &= (where != "" ? " AND " : " WHERE ") & "read = :read";
            qGetRequests.addParam(name = "read", value = arguments.read, cfsqltype = "cf_sql_bit");
        }
        
        if(variables.answered == 1) {
            where &= (where != "" ? " AND " : " WHERE ") & "requestId IN (SELECT requestId FROM icedreaper_contactForm_reply)";
        }
        else if(variables.answered == 0) {
            where &= (where != "" ? " AND " : " WHERE ") & "requestId NOT IN (SELECT requestId FROM icedreaper_contactForm_reply)";
        }
        
        if(variables.requestorUserId != null && variables.requestorUserId != 0) {
            where &= (where != "" ? " AND " : " WHERE ") & "requestorUserId = :requestorUserId";
            qGetRequests.addParam(name = "requestorUserId", value = arguments.requestorUserId, cfsqltype = "cf_sql_integer");
        }
        else if(variables.requestorUserId == null) {
            where &= (where != "" ? " AND " : " WHERE ") & "requestorUserId IS NULL";
        }
        
        if(variables.readUserId != null) {
            where &= (where != "" ? " AND " : " WHERE ") & "readUserId = :readUserId";
            qGetRequests.addParam(name = "readUserId", value = arguments.readUserId, cfsqltype = "cf_sql_integer");
        }
        
        sql &= where &
               " ORDER BY requestDate ASC ";
        
        var qRequests = qGetRequests.setSQL(sql)
                                    .execute()
                                    .getResult();
        
        var requests = [];
        for(var i = 1; i <= qRequests.getRecordCount(); ++i) {
            requests.append(new request(qRequests.requestId[i]));
        }
        
        return requests;
    }
}