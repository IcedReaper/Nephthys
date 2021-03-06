component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public error function init(required numeric errorId = null) {
        variables.errorId = arguments.errorId;
        
        loadDetails();
        
        return this;
    }
    
    
    public error function setErrorCode(required string errorCode) {
        variables.errorCode = arguments.errorCode;
        return this;
    }
    public error function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public error function setMessage(required string message) {
        variables.message = arguments.message;
        return this;
    }
    public error function setDetails(required string details) {
        variables.details = arguments.details;
        return this;
    }
    public error function setStacktrace(required string stacktrace) {
        variables.stacktrace = arguments.stacktrace;
        return this;
    }
    public error function setReferrer(required string referrer) {
        variables.referrer = arguments.referrer;
        return this;
    }
    public error function setUserAgent(required string userAgent) {
        variables.userAgent = arguments.userAgent;
        return this;
    }
    
    
    public numeric function getErrorId() {
        return variables.errorId;
    }
    public string function getErrorCode() {
        return variables.errorCode;
    }
    public string function getLink() {
        return variables.link;
    }
    public string function getMessage() {
        return variables.message;
    }
    public string function getDetails() {
        return variables.details;
    }
    public string function getStacktrace() {
        return variables.stacktrace;
    }
    public user function getUser() {
        return variables.user;
    }
    public date function getDate() {
        return variables.errorDate;
    }
    public string function getReferrer() {
        return variables.referrer;
    }
    public string function getUserAgent() {
        return variables.userAgent;
    }
    
    
    public error function save(required user user) {
        if(variables.errorId == null) {
            variables.errorId = new Query().setSQL("INSERT INTO nephthys_error
                                                                (
                                                                    errorCode,
                                                                    link,
                                                                    message,
                                                                    details,
                                                                    stacktrace,
                                                                    userId,
                                                                    referrer,
                                                                    userAgent
                                                                )
                                                         VALUES (
                                                                    :errorCode,
                                                                    :link,
                                                                    :message,
                                                                    :details,
                                                                    :stacktrace,
                                                                    :userId,
                                                                    :referrer,
                                                                    :userAgent
                                                                );
                                                    SELECT currval('seq_nephthys_error_id') newErrorId")
                                           .addParam(name = "errorCode",  value = left(variables.errorCode, 75),    cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "link",       value = left(variables.link, 255),        cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "message",    value = left(variables.message, 300),     cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "details",    value = left(variables.details, 200),     cfsqltype = "cf_sql_varchar", null = (variables.details        == "" || variables.details        == null))
                                           .addParam(name = "stacktrace", value = left(variables.stacktrace, 4000), cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "userId",     value = arguments.user.getUserId(),       cfsqltype = "cf_sql_numeric", null = (arguments.user.getUserId() == null))
                                           .addParam(name = "referrer",   value = left(variables.referrer, 255),    cfsqltype = "cf_sql_varchar", null = (variables.referrer       == "" || variables.referrer       == null))
                                           .addParam(name = "userAgent",  value = left(variables.userAgent, 75),    cfsqltype = "cf_sql_varchar", null = (variables.userAgent      == "" || variables.userAgent      == null))
                                           .execute()
                                           .getResult()
                                           .newErrorId[1];
            
            variables.user = arguments.user;
            variables.errorDate = now();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE FROM nephthys_error
                                  WHERE errorId = :errorId")
                   .addParam(name = "errorId", value = variables.errorId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.errorId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.errorId != null) {
            var qGetError = new Query().setSQL("SELECT *
                                                  FROM nephthys_error
                                                 WHERE errorId = :errorId")
                                       .addParam(name = "errorId", value = variables.errorId, cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult();
            
            if(qGetError.getRecordCount() == 1) {
                variables.errorCode      = qGetError.errorCode[1];
                variables.link           = qGetError.link[1];
                variables.message        = qGetError.message[1];
                variables.details        = qGetError.details[1];
                variables.stacktrace     = qGetError.stacktrace[1];
                variables.user           = new user(qGetError.userId[1]);
                variables.errorDate      = qGetError.errorDate[1];
                variables.referrer       = qGetError.referrer[1];
                variables.userAgent      = qGetError.userAgent[1];
            }
            else {
                throw(type = "EntryNotFound", message = "Could not find the error with the ID " & variables.errorId);
            }
        }
        else {
            variables.errorCode      = "";
            variables.link           = "";
            variables.message        = "";
            variables.details        = "";
            variables.stacktrace     = "";
            variables.user           = 0;
            variables.errorDate      = new user(null);
            variables.referrer       = "";
            variables.userAgent      = "";
        }
    }
}