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
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.IcedReaper.gallery.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        themeIndividualizer.invokeResources();
        
        if(arguments.options.keyExists("galleryId") && isNumeric(arguments.options.galleryId)) {
            var gallery = new gallery(arguments.options.galleryId);
            
            gallery.incrementViewCounter();
        
            return renderDetails(arguments.options, gallery);
        }
        else {
            var splitParameter = listToArray(request.page.getParameter(), "/");
            var galleryFilterCtrl = new filter();
            
            if(! arguments.options.keyExists("maxEntries")) {
                arguments.options.maxEntries = 5;
            }
            
            if(splitParameter.len() == 0) {
                galleryFilterCtrl.setPublished(1)
                                 .setCount(arguments.options.maxEntries)
                                 .execute();
                
                return renderOverview(arguments.options, galleryFilterCtrl, 1);
            }
            else {
                if(splitParameter[1] == "Seite" && splitParameter.len() == 2) {
                    galleryFilterCtrl.setPublished(1)
                                   .setCount(arguments.options.maxEntries)
                                   .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                                   .execute();
                    
                    return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2]);
                }
                else if(splitParameter[1] == "Kategorie") {
                    if(splitParameter.len() == 2) {
                        galleryFilterCtrl.setPublished(1)
                                         .setCategory(splitParameter[2])
                                         .setCount(arguments.options.maxEntries)
                                         .execute();
                        
                        return renderOverview(arguments.options, galleryFilterCtrl, 1);
                    }
                    else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") {
                        galleryFilterCtrl.setPublished(1)
                                         .setCategory(splitParameter[2])
                                         .setCount(arguments.options.maxEntries)
                                         .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                         .execute();
                        
                        return renderOverview(arguments.options, galleryFilterCtrl, splitParameter[2]);
                    }
                }
                else {
                    var galleries = galleryFilterCtrl.setPublished(1)
                                                     .setLink(request.page.getParameter())
                                                     .execute()
                                                     .getResult();
                    
                    if(galleries.len() == 1) {
                        var gallery = galleries[1];
                        
                        gallery.incrementViewCounter();
                        
                        request.page.setDescription(gallery.getDescription())
                                    .setTitle(gallery.getHeadline());
                    
                        return renderDetails(arguments.options, gallery);
                    }
                    else {
                        throw(type = "icedreaper.gallery.notFound", message = "Could not find the gallery " & request.page.getParameter(), detail = request.page.getParameter());
                    }
                }
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required filter  galleryFilterCtrl,
                                           required numeric actualPage) {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template          = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/overview.cfm"
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
        
        statisticsCtrl.add(arguments.gallery.getGalleryId());
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/gallery/templates/galleryDetail.cfm"
                   options  = arguments.options
                   gallery  = arguments.gallery;
        }
        
        return renderedContent;
    }
}