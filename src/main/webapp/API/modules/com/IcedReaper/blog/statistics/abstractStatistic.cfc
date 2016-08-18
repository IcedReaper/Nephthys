component extends="API.abstractClasses.statistic" {
    public statistic function init() {
        variables.blogpostId = null;
        
        super.init();
        
        return this;
    }
    
    public statistic function setBlogpostId(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        return this;
    }
}