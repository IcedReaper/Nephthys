component {
    public renderer function init() {
        return this;
    }
    
    public string function renderPageContent(required array pageContent, required string parameter) {
        var content = "";
        
        for(var i = 1; i <= arguments.pageContent.len(); i++) {
            var entityConnector = createObject("component", "WWW.modules." & arguments.pageContent[i].type & ".connector").init();
            
            content &= entityConnector.render(arguments.pageContent[i].options,
                                              renderPageContent(arguments.pageContent[i].children, arguments.parameter)); // injecting the content of the children so it can be rendered easily
        }
        
        return content;
    }
}