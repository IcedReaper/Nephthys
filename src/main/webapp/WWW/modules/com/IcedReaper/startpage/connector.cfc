component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.startpage";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        request.page.setSpecialCssClass("html", "com-IcedReaper-startpage");
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/startpage/templates/index.cfm"
                   options  = arguments.options;
        }
        
        return renderedContent;
    }
}