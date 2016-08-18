component {
    public xssProtector function init() {
        return this;
    }
    
    public string function encodeForHTML(required string input) {
        return ESAPIEncode("html", arguments.input);
    }
    public string function encodeForHTMLAttribute(required string input) {
        return ESAPIEncode("html_attr", arguments.input);
    }
    public string function encodeForJavaScript(required string input) {
        return ESAPIEncode("javascript", arguments.input);
    }
    public string function encodeForCSS(required string input) {
        return ESAPIEncode("css", arguments.input);
    }
    public string function encodeForURL(required string input) {
        return ESAPIEncode("url", arguments.input);
    }
}