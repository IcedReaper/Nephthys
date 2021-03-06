component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.gallery";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        // prepare the options required for the theme
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.IcedReaper.gallery.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        themeIndividualizer.invokeResources();
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        
        if(splitParameter.len() == 0) {
            if(arguments.options.keyExists("galleryId")) {
                if(isArray(arguments.options.galleryId)) {
                    if(arguments.options.galleryId.len() == 1) {
                        var gallery = new gallery(arguments.options.galleryId[1]);
                    
                        return renderDetails(arguments.options, gallery, arguments.rootElement);
                    }
                    else if(arguments.options.galleryId.len() > 1) {
                        var galleryFilterCtrl = new filter().for("gallery");
                        if(! arguments.options.keyExists("maxEntries")) {
                            arguments.options.maxEntries = 5;
                        }
                        galleryFilterCtrl.setOnline(true)
                                         .setGalleryIdList(arguments.options.galleryId.toList(","))
                                         .setCount(arguments.options.maxEntries)
                                         .execute();
                        
                        return renderOverview(arguments.options, galleryFilterCtrl, 1, arguments.rootElement);
                    }
                }
            }
            
            if(arguments.options.keyExists("categoryId")) {
                if(isArray(arguments.options.categoryId)) {
                    var galleryFilterCtrl = new filter().for("gallery");
                    if(! arguments.options.keyExists("maxEntries")) {
                        arguments.options.maxEntries = 5;
                    }
                    galleryFilterCtrl.setOnline(true)
                                     .setCategoryIdList(arguments.options.categoryId.toList(","))
                                     .setCount(arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, 1, arguments.rootElement);
                }
            }
        }
        
        var galleryFilterCtrl = new filter().for("gallery");
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(splitParameter.len() == 0) {
            galleryFilterCtrl.setOnline(true)
                             .setCount(arguments.options.maxEntries)
                             .execute();
            
            return renderOverview(arguments.options, galleryFilterCtrl, 1, arguments.rootElement);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) {
                galleryFilterCtrl.setOnline(true)
                               .setCount(arguments.options.maxEntries)
                               .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                               .execute();
                
                return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2], arguments.rootElement);
            }
            else if(splitParameter[1] == "Kategorie") {
                if(splitParameter.len() == 2) {
                    galleryFilterCtrl.setOnline(true)
                                     .setCategory(splitParameter[2])
                                     .setCount(arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, 1, arguments.rootElement);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") {
                    galleryFilterCtrl.setOnline(true)
                                     .setCategory(splitParameter[2])
                                     .setCount(arguments.options.maxEntries)
                                     .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2], arguments.rootElement);
                }
            }
            else {
                var galleries = galleryFilterCtrl.setOnline(true)
                                                 .setLink(request.page.getParameter())
                                                 .execute()
                                                 .getResult();
                
                if(galleries.len() == 1) {
                    var gallery = galleries[1];
                    
                    return renderDetails(arguments.options, gallery);
                }
                else {
                    throw(type = "icedreaper.gallery.notFound", message = "Could not find the gallery " & request.page.getParameter(), detail = request.page.getParameter());
                }
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required filter  galleryFilterCtrl,
                                           required numeric actualPage,
                                           required boolean rootElement) {
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("overview.cfm")
            .addParam("options",           arguments.options)
            .addParam("galleries",         arguments.galleryFilterCtrl.getResult())
            .addParam("totalGalleryCount", arguments.galleryFilterCtrl.getResultCount())
            .addParam("totalPageCount",    ceiling(arguments.galleryFilterCtrl.getResultCount() / arguments.options.maxEntries))
            .addParam("actualPage",        arguments.actualPage)
            .addParam("rootElement",       arguments.rootElement)
            .render();
    }
    
    private string function renderDetails(required struct options, required gallery gallery, required boolean rootElement) {
        var statisticsCtrl = new statistics();
        
        arguments.gallery.incrementViewCounter();
        
        request.page.setDescription(arguments.gallery.getDescription())
                    .setTitle(arguments.gallery.getTitle())
                    .setOpenGraphUrl("default")
                    .setOpenGraphType("default")
                    .setOpenGraphImage(application.system.settings.getValueOfKey("wwwDomain") & arguments.gallery.getRelativePath() & "/" & arguments.gallery.getPictures()[1].getThumbnailFileName());
        
        statisticsCtrl.add(arguments.gallery.getGalleryId());
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("galleryDetail.cfm")
            .addParam("options",     arguments.options)
            .addParam("gallery",     arguments.gallery)
            .addParam("rootElement", arguments.rootElement)
            .render();
    }
}