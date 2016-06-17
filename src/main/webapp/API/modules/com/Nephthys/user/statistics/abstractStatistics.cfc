component extends="API.abstractClasses.statistic" {
    import "API.modules.com.Nephthys.user.*";
    
    public statistic function init() {
        variables.userName = null;
        variables.successful = null;
        
        super.init();
        
        return this;
    }
    
    public statistic function setUserNameById(required numeric userId) {
        if(arguments.userId != null) {
            variables.userName = new user(arguments.userId).getUsername();
        }
        else {
            variables.userName = null;
        }
        
        return this;
    }
    
    public statistic function setUserName(required string userName) {
        variables.userName = arguments.userName;
        
        return this;
    }
    
    public statistic function setSuccessful(required boolean successful) {
        variables.successful = arguments.successful;
        
        return this;
    }
}