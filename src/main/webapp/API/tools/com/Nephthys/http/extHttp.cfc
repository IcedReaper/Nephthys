component {
    // Inspired from http://coldfusion9.blogspot.de/2012/03/custom-cfhttp-tag.html
    public extHttp function init() {
        variables.url = "";
        variables.maxRedirects = 5;
        variables.method = "GET";
        variables.accept = "*/*";
        variables.contentType = "application/x-www-form-urlencoded";
        variables.acceptEncoding = "gzip, x-gzip, identity, *;q=0";
        variables.acceptCharset = "UTF-8";
        variables.acceptLanguage = "";
        variables.userAgent = "extHttp";
        variables.cacheControl = "no-cache";
        variables.connectTimeout = 15000;
        variables.readTimeout = 15000;
        
        variables.postVariables = {};
        variables.getVariables  = {};
        variables.cookies       = {};
        
        variables.result = {};
        
        return this;
    }
    
    public extHttp function setUrl(required string url) {
        variables.url = arguments.url;
        return this;
    }
    
    public extHttp function setMaxRedirects(required numeric maxRedirects) {
        if(arguments.maxRedirects >= 0) {
            variables.maxRedirects = arguments.maxRedirects;
        }
        return this;
    }
    public extHttp function setMethod(required string method) {
        variables.method = arguments.method;
        return this;
    }
    public extHttp function setAccept(required string accept) {
        variables.accept = arguments.accept;
        return this;
    }
    public extHttp function setContentType(required string contentType) {
        variables.contentType = arguments.contentType;
        return this;
    }
    public extHttp function setAcceptEncoding(required string acceptEncoding) {
        variables.acceptEncoding = arguments.acceptEncoding;
        return this;
    }
    public extHttp function setAcceptCharset(required string acceptCharset) {
        variables.acceptCharset = arguments.acceptCharset;
        return this;
    }
    public extHttp function setAcceptLanguage(required string acceptLanguage) {
        variables.acceptLanguage = arguments.acceptLanguage;
        return this;
    }
    public extHttp function setUserAgent(required string userAgent) {
        variables.userAgent = arguments.userAgent;
        return this;
    }
    public extHttp function setCacheControl(required string cacheControl) {
        variables.cacheControl = arguments.cacheControl;
        return this;
    }
    public extHttp function setConnectTimeout(required numeric timeout) {
        if(arguments.timeout >= 0) {
            variables.connectTimeout = arguments.connectTimeout;
        }
        return this;
    }
    public extHttp function setReadTimeout(required numeric timeout) {
        if(arguments.timeout >= 0) {
            variables.readTimeout = arguments.readTimeout;
        }
        return this;
    }
    
    public extHttp function addParam(required string name, required any value, required string type) {
        switch(arguments.type) {
            case "get": {
                variables.getVariables[arguments.name] = arguments.value;
                break;
            }
            case "post": {
                variables.postVariables[arguments.name] = arguments.value;
                break;
            }
        }
        
        return this;
    }
    
    public extHttp function send() {
        if(variables.url == "") {
            throw(type = "Application", message = "Please specify an url before trying to send the http request");
        }
        
        var localSystem = createObject("java", "java.lang.System").getProperties();
        var javaEncoder = createObject("java","java.net.URLEncoder");
        
        
        var result = {};
        variables.result = {};
        
        
        var localUrl = variables.url;
        for(var getVar in variables.getVariables) {
            localUrl &= (localUrl == variables.url ? "?" : "&") & getVar & "=" & trim(javaEncoder.encode(variables.getVariables[getVar], "utf-8"));
        }
        result.getVariables = variables.getVariables;
        
        var postVariables = "";
        for(var postVar in variables.postVariables) {
            postVariables &= (postVariables != "" ? "&" : "") & postVar & "=" & trim(javaEncoder.encode(variables.postVariables[postVar], "utf-8"));
        }
        result.postVariables = variables.postVariables;
        
        try {
            var javaUrl = createObject("java", "java.net.URL").init(localUrl);
            var connection = javaUrl.openConnection();
            connection.setConnectTimeout(JavaCast("int",     variables.connectTimeout));
            connection.setReadTimeout(JavaCast("int",        variables.readTimeout));
            connection.setRequestMethod(                     variables.method);
            connection.setRequestProperty("Accept",          variables.accept);
            connection.setRequestProperty("Content-Type",    variables.contentType);
            connection.setRequestProperty("Accept-Encoding", variables.acceptEncoding);
            connection.setRequestProperty("Accept-Charset",  variables.acceptCharset);
            connection.setRequestProperty("Accept-Language", variables.acceptLanguage);
            connection.setRequestProperty("User-Agent",      variables.userAgent);
            connection.setRequestProperty("Cache-Control",   variables.cacheControl);
            connection.setFollowRedirects(true);
            connection.setDoInput(true);
            if(postVariables != '') {
                connection.setDoOutput(true);
            }
            //connection.setRequestProperty("Cookie", local_Cookies);
            
            connection.setInstanceFollowRedirects(false);
            
            result.url = connection.getURL().toString();
            
            if(postVariables != "") {
                var uploadStream = connection.getOutputStream();
                var uploadWriter = createObject("java", "java.io.OutputStreamWriter").init(uploadStream);
                uploadWriter.write(javaCast("string", postVariables));
                uploadWriter.close();
            }
            
            result.requestHeader = {};
            var requestProperties = connection.getRequestProperties().entrySet().toArray();
            for(var i = 1; i <= arraylen(requestProperties); ++i) {
                var key = requestProperties[i].getKey();
                if(isNull(key)) {
                    key = "";
                }
                
                if(arrayLen(requestProperties[i].getValue()) > 1) {
                    result.requestHeader[key] = [];
              
                    for(var j = 1; j <= arrayLen(requestProperties[i].getValue()); ++j) {
                        result.requestHeader[key].append(requestProperties[i].getValue()[j]);
                    }
                }
                else {
                    result.requestHeader[key] = requestProperties[i].getValue()[1];
                }
            }
            
            result.header = "";
            result.responseHeader = {};
            var headerFields = connection.getHeaderFields().entrySet().toArray();
            for(var i = 1; i <= arrayLen(headerFields); ++i) {
                var key = headerFields[i].getKey();
                if(isNull(key)) {
                    key = "";
                }
                
                if(key != "") {
                    result.header &= key & ": ";
                }
                
                if(arrayLen(headerFields[i].getValue()) > 1) {
                    result.responseHeader[key] = [];
              
                    for(var j = 1; j <= arrayLen(headerFields[i].getValue()); ++j) {
                        result.header &= headerFields[i].getValue()[j] & " ";
                        result.responseHeader[key].append(headerFields[i].getValue()[j]);
                    }
                }
                else {
                    result.header &= headerFields[i].getValue()[1] & " ";
                    result.responseHeader[key] = requestProperties[i].getValue()[1];
                }
            }
            
            var mimetype = connection.getContentType();
            if(find('charset=', mimetype) > 0) {
                result.charset = reReplace(mimetype, '.*?charset=(.*)', '\1', 'one');
            }
            else {
                result.charset = variables.acceptCharset;
            }
            result.mimetype = reReplace(mimetype, '(.*?);.*', '\1', 'one');
            
            if(! (connection.getResponseCode() == connection.HTTP_MOVED_PERM || connection.getResponseCode() == connection.HTTP_MOVED_TEMP || connection.getResponseCode() == connection.HTTP_SEE_OTHER)) {
                // get response body
                if(connection.getContentEncoding() != "" && (connection.getContentEncoding().equalsIgnoreCase("gzip") || connection.getContentEncoding().equalsIgnoreCase("x-gzip"))) {
                    var bufferedReader = createObject("java", "java.io.BufferedReader").init(createObject("java", "java.io.InputStreamReader").init(createObject("java", "java.util.zip.GZIPInputStream").init(connection.getInputStream()), "UTF-8"));
                }
                else {
                    var bufferedReader = createObject("java","java.io.BufferedReader").init(createObject("java", "java.io.InputStreamReader").init(connection.getInputStream(), "UTF-8"));
                }
                
                var line = bufferedReader.readLine();
                var lineCheck = isDefined("local_line");

                var stringBuilder = createObject("java", "java.lang.StringBuilder").init();
                while(isDefined("line") && ! isNull(line)) {
                    stringBuilder.append(line & chr(13) & chr(10));
                    line = bufferedReader.readLine();
                }
                result.fileContent = stringBuilder.toString();
                bufferedReader.close();
            }
            
            result.statusCode = connection.getResponseCode() & " " & connection.getResponseMessage();
            
            connection.disconnect();
        }
        catch(any e) {
            result.error = e;
            if(isDefined("connection")) {
                result.statusCode = connection.getResponseCode() & " " & connection.getResponseMessage();
                connection.disconnect();
            }
            writeDump(var=e);
            abort;
        }
        
        variables.result = result;
        
        return this;
    }
    
    public struct function getPrefix() {
        if(! structIsEmpty(variables.result)) {
            return variables.result;
        }
        else {
            throw(type = "Application", message = "The result is empty. Please be sure to call send before calling getPrefix.");
        }
    }
}