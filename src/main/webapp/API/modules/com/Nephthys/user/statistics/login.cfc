component {
    public login function init() {
        return this;
    }
    
    public array function getSuccessful(required numeric maxCount = 10) {
        return getData(true, arguments.maxCount);
    }
    
    public array function getFailed(required numeric maxCount = 10) {
        return getData(false, arguments.maxCount);
    }
    
    private array function getData(required boolean successful, required numeric maxCount) {
        var qLoginStatistics = new Query().setSQL("  SELECT username, loginDate
                                                       FROM nephthys_statistics_login
                                                      WHERE successful = :successful
                                                   ORDER BY loginDate DESC
                                                      LIMIT :maxCount")
                                         .addParam(name = "successful", value = arguments.successful, cfsqltype = "cf_sql_bit")
                                         .addParam(name = "maxCount",   value = arguments.maxCount,   cfsqltype = "cf_sql_numeric")
                                         .execute()
                                         .getResult();
        
        var logins = [];
        for(var i = 1; i <= qLoginStatistics.getRecordCount(); i++) {
            logins.append({
                username  = qLoginStatistics.username[i],
                loginDate = qLoginStatistics.loginDate[i]
            });
        }
        
        return logins;
    }
}