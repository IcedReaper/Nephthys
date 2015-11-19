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
        var sitemapObj = createObject("component", "API.com.Nephthys.controller.page.sitemap").init();
        
        module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/header.cfm"
               sitemap  = sitemapObj.getSitemap('header');
    }
    
    public void function footer() {
        var sitemapObj = createObject("component", "API.com.Nephthys.controller.page.sitemap").init();
        
        module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/Nephthys/navigation/footer.cfm"
               sitemap  = sitemapObj.getSitemap('footer');
    }
}