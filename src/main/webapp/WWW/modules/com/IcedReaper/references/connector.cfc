component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.references.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.references";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var referenceFilter = new filter().for("reference").execute();
        
        if(! arguments.options.keyExists("layout")) {
            arguments.options.layout = 1;
        }
        
        return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("index.cfm")
                .addParam("options", arguments.options)
                .addParam("references", referenceFilter.getResult())
                .render();
    }
}