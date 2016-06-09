component implements="API.interfaces.filter" {
    import "API.modules.com.Nephthys.page.*";
    
    public filter function init() {
        //variables.online   = null;
        variables.statusId = null;
        variables.pageId   = null;
        variables.majorVersion = null;
        variables.minorVersion = null;
        
        variables.qRes    = null;
        variables.results = null;
        
        return this;
    }
    
    /*public filter function setOnline(required boolean online) {
        variables.online = arguments.online;
        return this;
    }*/
    public filter function setStatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        return this;
    }
    public filter function setPageId(required numeric pageId) {
        variables.pageId = arguments.pageId;
        return this;
    }
    public filter function setMajorVersion(required numeric majorVersion) {
        variables.majorVersion = arguments.majorVersion;
        return this;
    }
    public filter function setMinorVersion(required numeric minorVersion) {
        variables.minorVersion = arguments.minorVersion;
        return this;
    }
    
    
    public filter function execute() {
        variables.results = null;
        var qryFilter = new Query();
        
        var sql     = "";
        var where   = "";
        var orderBy = "";
        
        sql = "    SELECT pv.pageVersionId
                     FROM nephthys_page_pageVersion pv";
        
        /*if(variables.online != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "s.online = :online";
            qryFilter.addParam(name = "online", value = variables.online, cfsqltype = "cf_sql_bit");
        }*/
        if(variables.statusId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.statusId = :statusId";
            qryFilter.addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.pageId != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.pageId = :pageId";
            qryFilter.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
        }
        if(variables.majorVersion != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.majorVersion = :majorVersion";
            qryFilter.addParam(name = "majorVersion", value = variables.majorVersion, cfsqltype = "cf_sql_numeric");
        }
        if(variables.minorVersion != null) {
            where &= (where == "" ? " WHERE " : " AND ") & "pv.minorVersion = :minorVersion";
            qryFilter.addParam(name = "minorVersion", value = variables.minorVersion, cfsqltype = "cf_sql_numeric");
        }
        
        orderBy = " ORDER BY pv.majorVersion, pv.minorVersion ASC";
        
        variables.qRes = qryFilter.setSQL(sql & where & orderBy)
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
                variables.results.append(new pageVersion(variables.qRes.pageVersionId[i]));
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