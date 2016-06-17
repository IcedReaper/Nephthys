component extends="API.modules.com.Nephthys.user.statistics.abstractStatistics" {
    public array function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        var logins = [];
        for(var i = 1; i <= variables.qRes.getRecordCount(); ++i) {
            logins.append({
                "date"       = variables.qRes._date[i],
                "loginCount" = variables.qRes.loginCount[i],
                "successful" = variables.qRes.successful[i]
            });
        }
        
        return logins;
    }
}