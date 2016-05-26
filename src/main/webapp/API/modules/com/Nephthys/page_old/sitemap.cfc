component {
    public sitemap function init() {
        return this;
    }
    
    public array function getSitemap(required string region) {
        var pageFilterCtrl = createObject("component", "API.modules.com.Nephthys.page.filter").init();
        return pageFilterCtrl.setParentId(0)
                             .setRegion(arguments.region)
                             .setVersion("actual")
                             .setActive(true)
                             .execute()
                             .getResult();
    }
}