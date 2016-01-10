component {
    public setting function init(required string errorCode) {
        variables.errorCode = arguments.errorCode;
        
        loadDetails();
        
        return this;
    }
    
    public boolean function logError() {
        return variables.log;
    }
    
    public string function getErrorTemplate() {
        return variables.errortemplate;
    }
    
    public string function getErrorType() {
        return variables.errorType;
    }
    
    private void function loadDetails() {
        var qErrorSettings = new Query().setSQL("SELECT *
                                                   FROM nephthys_errorSettings
                                                  WHERE lower(errorCode) = :errorCode")
                                        .addParam(name = "errorCode", value = lcase(variables.errorCode), cfsqltype = "cf_sql_varchar")
                                        .execute()
                                        .getResult();
        
        if(qErrorSettings.getRecordCount() == 1) {
            variables.log           = qErrorSettings.log[1];
            variables.errorTemplate = qErrorSettings.errorTemplate[1];
            variables.errorType     = qErrorSettings.errorType[1];
        }
        else {
            variables.errorCode = "default";
            
            loadDetails();
        }
    }
}