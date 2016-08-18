component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.text";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        var preparedOptions = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.Nephthys.text.cfc.prepareData").prepareOptions(arguments.options);
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("index.cfm")
            .addParam("options", preparedOptions)
            .addParam("childContent", arguments.childContent)
            .render();
    }
}