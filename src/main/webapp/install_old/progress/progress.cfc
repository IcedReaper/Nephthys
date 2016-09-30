component {
    public progress function init() {
        variables.title = "";
        variables.descriptionText = "";
        
        return this;
    }
    
    public progress function setTitle(required string title) {
        variables.title = arguments.title;
        
        return this;
    }
    
    public progress function setDescription(required string descriptionText) {
        variables.descriptionText = arguments.descriptionText;
        
        return this;
    }
    
    public progress function start() {
        module template = "../partials/header.cfm";
        
        module template        = "../partials/progress.cfm"
               title           = variables.title
               descriptionText = variables.descriptionText;
        
        module template = "../partials/footer.cfm";
        
        getPageContext().getOut().flush();
        
        return this;
    }
    
    public progress function startTask(required string taskDescription) {
        
        module template        = "../partials/startTask.cfm"
               taskDescription = arguments.taskDescription;
        
        getPageContext().getOut().flush();
        
        return this;
    }
    
    public progress function finishTask(required boolean successful) {
        
        module template   = "../partials/finishTask.cfm"
               successful = arguments.successful;
        
        getPageContext().getOut().flush();
        
        return this;
    }
}