component implements="WWW.interfaces.connector" {
    import "API.modules.com.Nephthys.page.*";
    
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
        var sitemap = new filter().setFor("sitemap")
                                          .setOnline(true)
                                          .execute()
                                          .getResult();
        if(sitemap.len() >= 1) {
            var sitemapId = sitemap[1].getSitemapId();
            
            var sitemapPages = new filter().setFor("sitemapPage")
                                           .setSitemapId(sitemapId)
                                           .setRegionId(arguments.regionId)
                                           .execute()
                                           .getResult();
            
            var sites = [];
            for(var sitemapPage in sitemapPages) {
                sites.append(sitemapPage.getPage());
            }
            
            return sites;
        }
        else {
            throw(type = "nephthys.notFound.page", message = "Could not find an active sitemap");
        }
    }
}