component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.user.*";
    
    public filter function init() {
        variables.userId = null;
        
        variables.userName     = null;
        variables.userNameLike = false;
        
        variables.email = null;
        
        variables.registerFromDate = null;
        variables.registerToDate   = null;
        
        variables.active = null;
        
        variables.qRes = null;
        variables.results = null;
        
        return this;
    }
    
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setUserName(required string userName) {
        variables.userName = arguments.userName;
        return this;
    }
    public filter function setUserNameLike(required boolean like) {
        variables.userNameLike = arguments.like;
        return this;
    }
    public filter function setEmail(required string email) {
        variables.email = arguments.email;
        return this;
    }
    public filter function setRegistrationFromDate(required date fromDate) {
        variables.registerFromDate = arguments.fromDate;
        return this;
    }
    public filter function setRegistrationToDate(required date toDate) {
        variables.registerToDate = arguments.toDate;
        return this;
    }
    public filter function setRegistrationDate(required date regDate) {
        variables.registerFromDate = arguments.regDate;
        variables.registerToDate   = arguments.regDate.add("d", 1);
        return this;
    }
    public filter function setActive(required boolean active) {
        variables.active = arguments.active;
        return this;
    }
    
    public filter function execute() {
        variables.qRes = null;
        variables.results = null;
        
        var qryFilter = new Query();
        var sql = "SELECT userId
                     FROM nephthys_user ";
        
        var where = "";
        if(variables.userId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "userId = :userId";
            qryFilter.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
        }
        
        if(variables.userName != null) {
            if(variables.userNameLike) {
                where &= (where == "" ? " WHERE " : " AND ") & "lower(userName) LIKE :userName";
                qryFilter.addParam(name = "userName", value = "%" & lCase(variables.userName) & "%", cfsqltype = "cf_sql_varchar");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & "lower(userName) = :userName";
                qryFilter.addParam(name = "userName", value = lCase(variables.userName), cfsqltype = "cf_sql_varchar");
            }
        }
        
        if(variables.registerFromDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "registrationDate >= :regFromDate";
            qryFilter.addParam(name = "regFromDate", value = variables.registerFromDate, cfsqltype = "cf_sql_date");
        }
        if(variables.registerToDate != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "registrationDate < :regToDate";
            qryFilter.addParam(name = "regToDate", value = variables.registerToDate, cfsqltype = "cf_sql_date");
        }
        
        if(variables.active != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "active = :active";
            qryFilter.addParam(name = "active", value = variables.active, cfsqltype = "cf_sql_bit");
        }
        
        if(variables.email != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "email = :email";
            qryFilter.addParam(name = "email", value = variables.email, cfsqltype = "cf_sql_varchar");
        }
        
        sql &= where & " ORDER BY userName ASC";
        
        variables.qRes = qryFilter.setSQL(sql)
                                  .execute()
                                  .getResult();
        return this;
    }
    
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the results");
        }
        
        if(isNull(variables.results)) {
            variables.results = [];
            for(var i = 1; i <= variables.qRes.getRecordCount(); i++) {
                variables.results.append(new user(variables.qRes.userId[i]));
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