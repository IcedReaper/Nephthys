component {
    public renderer function init() {
        variables.template = "";
        variables.params = {};
        
        return this;
    }
    
    public renderer function addParam(required string name, required any data) {
        variables.params[arguments.name] = arguments.data;
        return this;
    }
    
    public renderer function setTemplate(required string template) {
        if(fileExists(expandPath(arguments.template))) {
            variables.template = arguments.template;
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