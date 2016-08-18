component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.startpage";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        request.page.setSpecialCssClass("html", "com-IcedReaper-startpage");
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("index.cfm")
            .addParam("options", arguments.options)
            .render();
    }
}