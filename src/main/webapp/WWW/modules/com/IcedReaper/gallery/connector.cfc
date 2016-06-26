component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.gallery.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.gallery";
    }
    
    public string function render(required struct options, required string childContent) {
        // prepare the options required for the theme
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getWwwTheme().getFolderName() & ".modules.com.IcedReaper.gallery.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        themeIndividualizer.invokeResources();
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        
        if(splitParameter.len() == 0) {
            if(arguments.options.keyExists("galleryId")) {
                if(isArray(arguments.options.galleryId)) {
                    if(arguments.options.galleryId.len() == 1) {
                        var gallery = new gallery(arguments.options.galleryId[1]);
                    
                        return renderDetails(arguments.options, gallery);
                    }
                    else if(arguments.options.galleryId.len() > 1) {
                        var galleryFilterCtrl = new filter().setFor("gallery");
                        if(! arguments.options.keyExists("maxEntries")) {
                            arguments.options.maxEntries = 5;
                        }
                        galleryFilterCtrl.setOnline(true)
                                         .setGalleryIdList(arguments.options.galleryId.toList(","))
                                         .setCount(arguments.options.maxEntries)
                                         .execute();
                        
                        return renderOverview(arguments.options, galleryFilterCtrl, 1);
                    }
                }
            }
            
            if(arguments.options.keyExists("categoryId")) {
                if(isArray(arguments.options.categoryId)) {
                    var galleryFilterCtrl = new filter().setFor("gallery");
                    if(! arguments.options.keyExists("maxEntries")) {
                        arguments.options.maxEntries = 5;
                    }
                    galleryFilterCtrl.setOnline(true)
                                     .setCategoryIdList(arguments.options.categoryId.toList(","))
                                     .setCount(arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, 1);
                }
            }
        }
        
        var galleryFilterCtrl = new filter().setFor("gallery");
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(splitParameter.len() == 0) {
            galleryFilterCtrl.setOnline(true)
                             .setCount(arguments.options.maxEntries)
                             .execute();
            
            return renderOverview(arguments.options, galleryFilterCtrl, 1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) {
                galleryFilterCtrl.setOnline(true)
                               .setCount(arguments.options.maxEntries)
                               .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                               .execute();
                
                return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") {
                if(splitParameter.len() == 2) {
                    galleryFilterCtrl.setOnline(true)
                                     .setCategory(splitParameter[2])
                                     .setCount(arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, 1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") {
                    galleryFilterCtrl.setOnline(true)
                                     .setCategory(splitParameter[2])
                                     .setCount(arguments.options.maxEntries)
                                     .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                     .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2]);
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
                                           required numeric actualPage) {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template          = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/overview.cfm"
                   options           = arguments.options
                   galleries         = arguments.galleryFilterCtrl.getResult()
                   totalGalleryCount = arguments.galleryFilterCtrl.getResultCount()
                   totalPageCount    = ceiling(arguments.galleryFilterCtrl.getResultCount() / arguments.options.maxEntries)
                   actualPage        = arguments.actualPage;
        }
        
        return renderedContent;
    }
    
    private string function renderDetails(required struct options, required gallery gallery) {
        var renderedContent = "";
        var statisticsCtrl = new statistics();
        
        arguments.gallery.incrementViewCounter();
        
        request.page.setDescription(arguments.gallery.getDescription())
                    .setTitle(arguments.gallery.getTitle())
                    .setOpenGraphUrl("default")
                    .setOpenGraphType("default")
                    .setOpenGraphImage(application.system.settings.getValueOfKey("wwwDomain") & arguments.gallery.getRelativePath() & "/" & arguments.gallery.getPictures()[1].getThumbnailFileName());
        
        statisticsCtrl.add(arguments.gallery.getGalleryId());
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/galleryDetail.cfm"
                   options  = arguments.options
                   gallery  = arguments.gallery;
        }
        
        return renderedContent;
    }
}