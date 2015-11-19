component {
    public sitemap function init() {
        return this;
    }
    
    public array function getSitemap(required string region) {
        var pageCtrl = createObject("component", "API.com.Nephthys.controller.page.pageList").init();
        return pageCtrl.getList(0, arguments.region);
    }
}