component {
    public templateRenderer function init() {
        variables.modulePath = "";
        variables.template = "";
        variables.params = {};
        
        return this;
    }
    
    public templateRenderer function setModulePath(required string modulePath) {
        variables.modulePath = arguments.modulePath;
        return this;
    }
    
    public templateRenderer function addParam(required string name, required any data) {
        variables.params[arguments.name] = arguments.data;
        return this;
    }
    
    public templateRenderer function setTemplate(required string template) {
        var tmpTemplate = application.rootPath & "/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/" & variables.modulePath & "/templates/" & arguments.template;
        
        if(fileExists(expandPath(tmpTemplate))) {
            variables.template = tmpTemplate;
        }
        else {
            throw(type = "test", message="File not found!", detail = tmpTemplate);
        }
        
        return this;
    }
    
    public string function render() {
        var renderedContent = "";
        
        if(variables.template != "") {
            var params = {};
            structAppend(params, arguments, true);
            structAppend(params, variables.params, true);
            
            saveContent variable="renderedContent" {
                module template            = variables.template
                       attributeCollection = params;
            }
        }
        
        return renderedContent;
    }
}