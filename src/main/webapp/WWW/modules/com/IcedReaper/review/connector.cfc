component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.review.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.review";
    }
    
    public string function render(required struct options, required string childContent) {
        // prepare the options required for the theme
        var splitParameter = listToArray(request.page.getParameter(), "/");
        var reviewFilter = new filter();
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(splitParameter.len() == 0) {
            reviewFilter//.setPublished(1)
                        .setCount(arguments.options.maxEntries)
                        .execute();
                    
            arguments.options.link = request.page.getLink();
            
            return renderOverview(arguments.options, reviewFilter, 1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) { // todo: Seite multilingual
                reviewFilter//.setPublished(1)
                            .setCount(arguments.options.maxEntries)
                            .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                            .execute();
                    
                arguments.options.link = request.page.getLink();
                
                return renderOverview(arguments.options, reviewFilter, splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") { // todo: Kategorie multilingual
                if(splitParameter.len() == 2) {
                    reviewFilter//.setPublished(1)
                                .setType(splitParameter[2])
                                .setCount(arguments.options.maxEntries)
                                .execute();
                    
                    arguments.options.link = request.page.getLink() & "/Kategorie/" & splitParameter[2];
                    arguments.options.actualFilter = {
                        type = "Kategorie",
                        value = splitParameter[2]
                    };
                    
                    return renderOverview(arguments.options, reviewFilter, 1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    reviewFilter//.setPublished(1)
                                .setType(splitParameter[2])
                                .setCount(arguments.options.maxEntries)
                                .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                .execute();
                    
                    arguments.options.link = request.page.getLink() & "/Kategorie/" & splitParameter[2];
                    arguments.options.actualFilter = {
                        type = "Kategorie",
                        value = splitParameter[2]
                    };
                    
                    return renderOverview(arguments.options, reviewFilter, splitParameter[4]);
                }
            }
            else if(splitParameter[1] == "Genre") { // todo: Genre multilingual
                if(splitParameter.len() == 2) {
                    reviewFilter//.setPublished(1)
                                .setGenre(splitParameter[2])
                                .setCount(arguments.options.maxEntries)
                                .execute();
                    
                    arguments.options.link = request.page.getLink() & "/Genre/" & splitParameter[2];
                    arguments.options.actualFilter = {
                        type = "Genre",
                        value = splitParameter[2]
                    };
                    
                    return renderOverview(arguments.options, reviewFilter, 1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    reviewFilter//.setPublished(1)
                                .setGenre(splitParameter[2])
                                .setCount(arguments.options.maxEntries)
                                .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                .execute();
                    
                    arguments.options.link = request.page.getLink() & "/Genre/" & splitParameter[2];
                    arguments.options.actualFilter = {
                        type = "Genre",
                        value = splitParameter[2]
                    };
                    
                    return renderOverview(arguments.options, reviewFilter, splitParameter[4]);
                }
            }
            else {
                var reviews = reviewFilter//.setPublished(1)
                                          .setLink(request.page.getParameter())
                                          .execute()
                                          .getResult();
                
                if(reviews.len() == 1) {
                    var review = reviews[1];
                    
                    //review.incrementViewCounter();
                    
                    request.page.setDescription(review.getDescription())
                                .setTitle(review.getHeadline());
                
                    return renderDetails(arguments.options, review);
                }
                else {
                    throw(type = "icedreaper.review.notFound", message = "Could not find the Review " & request.page.getParameter(), detail = request.page.getParameter());
                }
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required filter  reviewFilter,
                                           required numeric actualPage) {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template         = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/review/templates/overview.cfm"
                   options          = arguments.options
                   reviews          = arguments.reviewFilter.getResult()
                   totalReviewCount = arguments.reviewFilter.getResultCount()
                   totalPageCount   = ceiling(arguments.reviewFilter.getResultCount() / arguments.options.maxEntries)
                   actualPage       = arguments.actualPage;
        }
        
        return renderedContent;
    }
    
    private string function renderDetails(required struct options, required review review) {
        var renderedContent = "";
        //var statisticsCtrl = createObject("component", "API.modules.com.IcedReaper.gallery.statistics").init();
        
        //statisticsCtrl.add(arguments.gallery.getGalleryId());
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/review/templates/reviewDetail.cfm"
                   options  = arguments.options
                   review   = arguments.review;
        }
        
        return renderedContent;
    }
}