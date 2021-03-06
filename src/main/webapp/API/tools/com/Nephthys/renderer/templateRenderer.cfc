component implements="API.interfaces.templateRenderer" {
    public templateRenderer function init() {
        variables.modulePath = "";
        variables.template = "";
        variables.params = {};
        variables.themeFolderName = "";
        
        return this;
    }
    
    public templateRenderer function setThemeFolderName(required string themeFolderName) {
        variables.themeFolderName = arguments.themeFolderName;
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
        if(variables.themeFolderName == "") {
            variables.themeFolderName = request.user.getTheme().getFolderName();
        }
        var tmpTemplate = application.system.settings.getValueOfKey("rootPath") & "/themes/" & variables.themeFolderName & "/modules/" & variables.modulePath & "/templates/" & arguments.template;
        
        if(fileExists(expandPath(tmpTemplate))) {
            variables.template = tmpTemplate;
        }
        else {
            var errorLogger = application.system.settings.getValueOfKey("errorLogger");
            errorLogger.setException({
                    type       = "nephthys.application.invalidResource",
                    message    = "Cannot find the template '" & tmpTemplate & "'",
                    stacktrace = callStackGet("string")
                })
                .save(request.user);
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
        else {
            if(application.system.settings.getValueOfKey("applicationType") == "WWW" && request.page.isPreview()) {
                renderedContent = "Template could not be fond in theme!";
            }
        }
        
        return renderedContent;
    }
}