component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.teamOverview";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        var member = createObject("component", "API.modules.com.IcedReaper.teamOverview.filter").init().execute().getResult();
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/teamOverview/templates/overview.cfm"
                   member   = member;
        }
        
        return renderedContent;
    }
}