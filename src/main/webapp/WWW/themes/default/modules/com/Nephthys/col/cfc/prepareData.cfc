component {
    public struct function prepareOptions(required struct options) {
        var classes = "";
        if(structKeyExists(arguments.options, "width-md")) {
            classes &= "col-md-" & getClassWidthSuffix(arguments.options["width-md"]) & " ";
        }
        
        if(structKeyExists(arguments.options, "width-xs")) {
            classes &= "col-xs-" & getClassWidthSuffix(arguments.options["width-xs"]) & " ";
        }
        
        return {
            classes = classes
        };
    }
    
    private string function getClassWidthSuffix(required string width) {
        switch(arguments.width) {
            case   "8%": { return  "1"; }
            case  "16%": { return  "2"; }
            case  "25%": { return  "3"; }
            case  "33%": { return  "4"; }
            case  "41%": { return  "5"; }
            case  "50%": { return  "6"; }
            case  "58%": { return  "7"; }
            case  "66%": { return  "8"; }
            case  "75%": { return  "9"; }
            case  "83%": { return "10"; }
            case  "91%": { return "11"; }
            case "100%": { return "12"; }
            default: { return "12"; }
        }
    }
}