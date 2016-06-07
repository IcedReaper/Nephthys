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
               sitemap  = getSitemap(1);
    }
    
    public void function footer() {
        module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/footer.cfm"
               sitemap  = getSitemap(2);
    }
    
    private array function getSitemap(required numeric regionId) {
        var pageFilterCtrl = createObject("component", "API.modules.com.Nephthys.page.filter").init();
        // TODO: regionId istn icht intuitiv. Über Filter laden
        return pageFilterCtrl.setFor("sitemap")
                             .setRegionId(arguments.regionId)
                             .setOnline(true)
                             .execute()
                             .getResult();
    }
}