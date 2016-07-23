component extends="API.abstractClasses.statistic" {
    public statistic function init() {
        variables.pageId = null;
        
        super.init();
        
        return this;
    }
    
    public statistic function setPageId(required numeric pageId) {
        variables.pageId = arguments.pageId;
        
        return this;
    }
}