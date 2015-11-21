component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "gallery";
    }
    
    public string function render(required struct options, required string childContent) {
        // prepare the options required for the theme
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.IcedReaper.gallery.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        themeIndividualizer.invokeResources();
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        var gallerySearcher = createObject("component", "API.com.IcedReaper.gallery.search").init();
        
        if(! structKeyExists(arguments.options, "maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(splitParameter.len() == 0) {
            gallerySearcher.setPublished(1)
                           .setCount(arguments.options.maxEntries);
            
            return renderOverview(arguments.options,
                                  gallerySearcher,
                                  1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) { // todo: Seite multilingual
                gallerySearcher.setPublished(1)
                               .setCount(arguments.options.maxEntries)
                               .setOffset((splitParameter[2]-1) * arguments.options.maxEntries);
                
                return renderOverview(arguments.options,
                                      gallerySearcher,
                                      splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") { // todo: Kategorie multilingual
                if(splitParameter.len() == 2) {
                    gallerySearcher.setPublished(1)
                                   .setCategory(splitParameter[2])
                                   .setCount(arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options,
                                          gallerySearcher,
                                          1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    gallerySearcher.setPublished(1)
                                   .setCategory(splitParameter[2])
                                   .setCount(arguments.options.maxEntries)
                                   .setOffset((splitParameter[4]-1) * arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options,
                                          gallerySearcher,
                                          splitParameter[2]);
                }
            }
            else {
                var gallery = gallerySearcher.execute()[1];
                
                request.page.setDescription(gallery.getDescription())
                            .setTitle(gallery.getHeadline());
                
                gallerySearcher.setPublished(1)
                               .setLink(request.page.getParameter());
            
                return renderDetails(arguments.options,
                                     gallery);
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required search  gallerySearcher,
                                           required numeric actualPage) {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template          = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/overview.cfm"
                   options           = arguments.options
                   galleries         = gallerySearcher.execute()
                   totalGalleryCount = gallerySearcher.getTotalGalleryCount()
                   totalPageCount    = ceiling(gallerySearcher.getTotalGalleryCount() / arguments.options.maxEntries)
                   actualPage        = arguments.actualPage;
        }
        
        return renderedContent;
    }
    
    private string function renderDetails(required struct options, required gallery gallery) {
        var renderedContent = "";
        var statisticsCtrl = createObject("component", "API.com.IcedReaper.gallery.statistics").init();
        
        statisticsCtrl.add(arguments.gallery.getGalleryId());
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/galleryDetail.cfm"
                   options  = arguments.options
                   gallery  = arguments.gallery;
        }
        
        return renderedContent;
    }
}