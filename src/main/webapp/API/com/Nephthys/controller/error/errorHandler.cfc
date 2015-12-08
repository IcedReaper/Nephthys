component {
    public errorHandler function init() {
        variables.exception = {};
        
        return this;
    }
    
    public errorHandler function setException(required any exception) {
        variables.exception = arguments.exception;
        return this;
    }
    
    public errorHandler function setThemePath(required string themePath) {
        variables.themePath = arguments.themePath;
        
        if(right(variables.themePath, 1) != "/") {
            variables.themePath &= "/";
        }
        
        return this;
    }
    
    public errorHandler function save() {
        if(! structIsEmpty(variables.exception)) {
            var errorSettings = createObject("component", "API.com.Nephthys.classes.error.settings").init(variables.exception.type);
            
            if(errorSettings.logError()) {// check if the error type should be saved to the database
                var error = createObject("component", "API.com.Nephthys.classes.error.error").init();
                
                var link = "";
                if(request.keyExists("page")) {
                    link = request.page.getLink();
                }
                else if(request.keyExists("moduleController")) {
                    link = request.moduleController.getName(); // possible todo...
                }
                else {
                    link = cgi.SCRIPT_NAME & "?" & cgi.QUERY_STRING;
                }
                
                error.setErrorCode(variables.exception.type)
                     .setMessage(variables.exception.message)
                     .setStacktrace(trim(variables.exception.stacktrace))
                     .setUserId(request.user.getUserId())
                     .setLink(link)
                     .setReferrer(cgi.HTTP_REFERER)
                     .setUserAgent(cgi.HTTP_USER_AGENT);
                
                if(variables.exception.keyExists("detail")) {
                    error.setDetails(variables.exception.detail);
                }
                
                if(variables.exception.type == 'Database') {
                    error.setMessage("SQL: " & trim(variables.exception.sql));
                }
                
                if(variables.exception.type == 'missingInclude') {
                    error.setMessage("MissingInclude: " & trim(variables.exception.missingFileName));
                }
                
                error.save();
            }
        }
        
        return this;
    }
    
    public void function show() {
        if(! structIsEmpty(variables.exception)) {
            var errorSettings = createObject("component", "API.com.Nephthys.classes.error.settings").init(variables.exception.type);
            
            clearBuffer();
            
            module template   = variables.themePath & errorSettings.getErrorTemplate()
                   error      = variables.exception
                   statusCode = errorSettings.getErrorType()
                   statusText = variables.exception.message;
        }
    }
    
    private void function clearBuffer() {
        // this is the 'local' page context
        var out = getPageContext().getOut();
        // iterate over this to catch the parent object until we get to a coldfusion.runtime.NeoJspWriter
        while (getMetaData(out).getName() == 'coldfusion.runtime.NeoBodyContent'){
            out = out.getEnclosingWriter();
        }
        
        out.clearBuffer();
    }
}