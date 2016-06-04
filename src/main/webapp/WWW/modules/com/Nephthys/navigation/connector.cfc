component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "navigation";
    }
    
    public string function render(required struct options, required string childContent) {
        return "";
    }
    
    public void function header() {
        module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/header.cfm"
               sitemap  = getSitemap('header');
    }
    
    public void function footer() {
        module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/footer.cfm"
               sitemap  = getSitemap('footer');
    }
    
    private array function getSitemap(required string region) {
        var pageFilterCtrl = createObject("component", "API.modules.com.Nephthys.page.filter").init();
        
        return pageFilterCtrl.setFor("sitemap")
                             .setRegion(arguments.region)
                             .setOnline(true)
                             .execute()
                             .getResult();
    }
}