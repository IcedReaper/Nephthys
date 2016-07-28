component {
    public logger function init() {
        variables.exception = {};
        
        return this;
    }
    
    public logger function setException(required any exception) {
        variables.exception = arguments.exception;
        return this;
    }
    
    public logger function setThemePath(required string themePath) {
        variables.themePath = arguments.themePath;
        
        if(right(variables.themePath, 1) != "/") {
            variables.themePath &= "/";
        }
        
        return this;
    }
    
    public logger function save(required user user) {
        if(! structIsEmpty(variables.exception)) {
            var errorSettings = new setting(variables.exception.type);
            
            // check if the error type should be saved to the database
            if(errorSettings.logError()) {
                var error = new error();
                
                var link = "";
                if(request.keyExists("page")) {
                    link = request.page.getLink();
                }
                else if(request.keyExists("moduleController")) {
                    link = request.moduleController.getName();
                }
                else {
                    link = cgi.SCRIPT_NAME & "?" & cgi.QUERY_STRING;
                }
                
                error.setErrorCode(variables.exception.type)
                     .setMessage(variables.exception.message)
                     .setStacktrace(trim(variables.exception.stacktrace))
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
                
                error.save(arguments.user);
            }
        }
        
        return this;
    }
    
    public void function show() {
        if(! structIsEmpty(variables.exception)) {
            var errorSettings = new setting(variables.exception.type);
            
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