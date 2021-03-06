component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.teamOverview.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.teamOverview";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        var member = new filter().for("member").execute().getResult();
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("overview.cfm")
            .addParam("options",  arguments.options)
            .addParam("member",   member)
            .render();
    }
}