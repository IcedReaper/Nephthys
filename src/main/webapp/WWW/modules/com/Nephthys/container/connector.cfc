component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "container";
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.container.cfc.prepareData").prepareOptions(arguments.options);
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/container/templates/index.cfm"
                   options      = preparedOptions
                   childContent = arguments.childContent;
        }
        
        return renderedContent;
    }
}