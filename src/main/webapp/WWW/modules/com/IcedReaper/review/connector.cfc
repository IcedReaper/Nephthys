component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.review.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.review";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        // prepare the options required for the theme
        var splitParameter = listToArray(request.page.getParameter(), "/");
        var reviewFilter = new filter();
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(splitParameter.len() == 0) {
            reviewFilter.setCount(arguments.options.maxEntries)
                        .execute();
                    
            arguments.options.link = request.page.getLink();
            
            return renderOverview(arguments.options, reviewFilter, 1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) {
                reviewFilter.setCount(arguments.options.maxEntries)
                            .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                            .execute();
                    
                arguments.options.link = request.page.getLink();
                
                return renderOverview(arguments.options, reviewFilter, splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") {
                if(splitParameter.len() == 2) {
                    reviewFilter.setType(splitParameter[2])
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
                    reviewFilter.setType(splitParameter[2])
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
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") {
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
                var reviews = reviewFilter.setLink(request.page.getParameter())
                                          .execute()
                                          .getResult();
                
                if(reviews.len() == 1) {
                    var review = reviews[1];
                    
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
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("overview.cfm")
            .addParam("options",          arguments.options)
            .addParam("reviews",          arguments.reviewFilter.getResult())
            .addParam("totalReviewCount", arguments.reviewFilter.getResultCount())
            .addParam("totalPageCount",   ceiling(arguments.reviewFilter.getResultCount() / arguments.options.maxEntries))
            .addParam("actualPage",       arguments.actualPage)
            .addParam("userPage",         getUserLink())
            .render();
    }
    
    private string function renderDetails(required struct options, required review review) {
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("reviewDetail.cfm")
            .addParam("options",  arguments.options)
            .addParam("review",   arguments.review)
            .addParam("userPage", getUserLink())
            .render();
    }
    
    private string function getUserLink() {
        var aPages = createObject("component", "API.modules.com.Nephthys.pages.filter").init()
                                                                                       .setFor("pageWithModule")
                                                                                       .setModuleName("com.Nephthys.user")
                                                                                       .execute()
                                                                                       .getResult(); 
        return aPages.len() >= 1 ? aPages[1].link : "";
    }
}