component {
    public renderer function init() {
        return this;
    }
    
    public string function renderPageContent(required array pageContent, required string parameter) {
        var content = "";
        
        for(var i = 1; i <= arguments.pageContent.len(); i++) {
            if(permissionsOk(arguments.pageContent[i].type, arguments.pageContent[i].options)) {
                var entityConnector = createObject("component", "WWW.modules." & arguments.pageContent[i].type & ".connector").init();
                
                content &= entityConnector.render(arguments.pageContent[i].options,
                                                  renderPageContent(arguments.pageContent[i].children, arguments.parameter));
            }
        }
        
        return content;
    }
    
    private boolean function permissionsOk(required string moduleName, required struct options) {
        if(arguments.options.keyExists("roleName")) {
            return request.user.hasPermission(arguments.moduleName, arguments.options.roleName);
        }
        else {
            if(arguments.options.keyExists("onlyVisibleToLoggedInUser")) {
                return arguments.options.onlyVisibleToLoggedInUser ? request.user.isActive() : true;
            }
            else {
                if(arguments.options.keyExists("onlyVisibleToLoggedOutUser")) {
                    return arguments.options.onlyVisibleToLoggedOutUser ? (! request.user.isActive()) : true;
                }
                else {
                    return true;
                }
            }
        }
    }
}