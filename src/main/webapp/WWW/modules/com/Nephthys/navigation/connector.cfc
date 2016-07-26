component implements="WWW.interfaces.connector" {
    import "API.modules.com.Nephthys.pageManager.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.Nephthys.navigation";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        return "";
    }
    
    public string function header() {
        return renderNavigation("header", getSitemap(1));
    }
    
    public string function footer() {
        return renderNavigation("footer", getSitemap(2));
    }
    
    private array function getSitemap(required numeric regionId) {
        var sitemap = new filter().for("sitemap")
                                          .setOnline(true)
                                          .execute()
                                          .getResult();
        if(sitemap.len() >= 1) {
            var sitemapId = sitemap[1].getSitemapId();
            
            var sitemapPages = new filter().for("sitemapPage")
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
    
    private string function renderNavigation(required string template, required array sitemap) {
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate(arguments.template & ".cfm")
            .addParam("sitemap",  arguments.sitemap)
            .addParam("searchPage", getSearchLink())
            .render();
    }
    
    private string function getSearchLink() {
        var aPages = createObject("component", "API.modules.com.Nephthys.pageManager.filter").init().for("pageWithModule")
                                                                                                    .setModuleName("com.Nephthys.search")
                                                                                                    .execute()
                                                                                                    .getResult(); 
        return aPages.len() >= 1 ? aPages[1].getLink() : "";
    }
}