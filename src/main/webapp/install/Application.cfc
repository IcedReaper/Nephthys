component {
    
    public boolean function onRequestStart(required string targetPage) {
        request.requestType = "";
        
        switch(right(arguments.targetPage, 3)) {
            case 'cfm': {
                break;
            }
            case 'cfc': {
                var callInformation = getHttpRequestData();
                if(structKeyExists(callInformation.headers, "x-framework") && callInformation.headers['x-framework'] == 'angularJs') {
                    // angular $http calls doesn't work as jQuery post calls. The Parameter are in a JSON format and will neither appear in the arguments nor in the form scope. So we have to move them there.
                    var requestBody = toString(callInformation.content);
                    if(isJSON(requestBody)) {
                        form.append(deserializeJSON(requestBody));
                    }
                }
                break;
            }
            default: {
                // to check...
            }
        }
        
        return true;
    }
    
    public void function onError(required any exception) {
        try {
            // convert some error into a different shape
            if(arguments.exception.type == "Database" && arguments.exception.SQLState == 23505) {
                arguments.exception.type    = "nephthys.application.alreadyExists";
                arguments.exception.message = "Primary Key violation while creating/updating";
            }
            
            writeOutput(serializeJSON({
                "errorMessage" = arguments.exception.message,
                "type"         = arguments.exception.type,
                "detail"       = arguments.exception.detail,
                "stacktrace"   = arguments.exception.stacktrace
            }));
            header statuscode="500" statustext=arguments.exception.message;
        }
        catch(any e) {
            writeDump(var=e, label="critical error");
        }
    }
}