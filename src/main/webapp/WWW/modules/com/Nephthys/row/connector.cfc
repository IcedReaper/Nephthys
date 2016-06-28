component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.row";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getWwwTheme().getFolderName() & ".modules.com.Nephthys.row.cfc.prepareData").prepareOptions(arguments.options);
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("index.cfm")
            .addParam("options", preparedOptions)
            .addParam("childContent", arguments.childContent)
            .render();
    }
}