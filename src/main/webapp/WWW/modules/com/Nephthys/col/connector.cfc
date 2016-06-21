component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "col";
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getWwwTheme().getFolderName() & ".modules.com.Nephthys.col.cfc.prepareData").prepareOptions(arguments.options);
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template     = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/Nephthys/col/templates/index.cfm"
                   options      = preparedOptions
                   childContent = arguments.childContent;
        }
        
        return renderedContent;
    }
}