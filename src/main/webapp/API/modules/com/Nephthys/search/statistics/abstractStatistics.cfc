component extends="API.abstractClasses.statistic" {
    import "API.modules.com.Nephthys.search.*";
    
    public statistic function init() {
        variables.userId = null;
        variables.minResultCount = null;
        
        super.init();
        
        return this;
    }
    
    public statistic function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public statistic function setMinResultCount(required boolean minResultCount) {
        variables.minResultCount = arguments.minResultCount;
        
        return this;
    }
}