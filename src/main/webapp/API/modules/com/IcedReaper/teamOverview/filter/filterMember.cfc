component implements="API.interfaces.filter" {
    import "API.modules.com.IcedReaper.teamOverview.*";
    
    public filter function init() {
        variables.userId = null;
        variables.sortId = null;
        variables.minSortId = null;
        variables.maxSortId = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setSortId(required numeric sortId) {
        variables.sortId = arguments.sortId;
        return this;
    }
    public filter function setMinSortId(required numeric sortId) {
        variables.minSortId = arguments.sortId;
        return this;
    }
    public filter function setMaxSortId(required numeric sortId) {
        variables.maxSortId = arguments.sortId;
        return this;
    }
    
    public filter function execute() {
        var qryMember = new Query();
        
        var sql = "SELECT memberId
                     FROM icedReaper_teamOverview_member";
        var where = "";
        if(variables.userId != 0 && variables.userId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " userId = :userId";
            qryMember.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.sortId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & " sortId = :sortId";
            qryMember.addParam(name = "sortId", value = variables.sortId, cfsqltype = "cf_sql_numeric");
        }
        else {
            if(variables.minSortId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " sortId >= :minSortId";
                qryMember.addParam(name = "minSortId", value = variables.minSortId, cfsqltype = "cf_sql_numeric");
            }
            
            if(variables.maxSortId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " sortId <= :maxSortId";
                qryMember.addParam(name = "maxSortId", value = variables.maxSortId, cfsqltype = "cf_sql_numeric");
            }
        }
        sql &= where &
               " ORDER BY sortId ASC";
        
        variables.qRes = qryMember.setSQL(sql)
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
                variables.results.append(new member(variables.qRes.memberId[i]));
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