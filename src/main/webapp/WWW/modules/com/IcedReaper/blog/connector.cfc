component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.blog";
    }
    
    public string function render(required struct options, required string childContent) {
        // prepare the options required for the theme
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.IcedReaper.blog.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        var blogpostSearchCtrl = createObject("component", "API.com.IcedReaper.blog.search").init();
        
        if(! structKeyExists(arguments.options, "maxEntries")) {
            arguments.options.maxEntries = 1;
        }
        
        if(splitParameter.len() == 0) {
            blogpostSearchCtrl.setReleased(1)
                              .setCount(arguments.options.maxEntries);
            
            return renderOverview(arguments.options,
                                  blogpostSearchCtrl,
                                  1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) { // todo: Seite multilingual
                blogpostSearchCtrl.setReleased(1)
                               .setCount(arguments.options.maxEntries)
                               .setOffset((splitParameter[2]-1) * arguments.options.maxEntries);
                
                return renderOverview(arguments.options,
                                      blogpostSearchCtrl,
                                      splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") { // todo: Kategorie multilingual
                if(splitParameter.len() == 2) {
                    blogpostSearchCtrl.setReleased(1)
                                   .setCategory(splitParameter[2])
                                   .setCount(arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options,
                                          blogpostSearchCtrl,
                                          1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    blogpostSearchCtrl.setReleased(1)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .setOffset((splitParameter[4]-1) * arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options,
                                          blogpostSearchCtrl,
                                          splitParameter[2]);
                }
            }
            else {
                var galleries = blogpostSearchCtrl.setReleased(1)
                                                  .setLink(request.page.getParameter())
                                                  .execute();
                
                if(galleries.len() == 1) {
                    var gallery = galleries[1];
                    
                    request.page.setTitle(gallery.getHeadline());
                
                    return renderDetails(arguments.options,
                                         gallery);
                }
                else {
                    throw(type = "icedreaper.blog.notFound", message = "Could not find the blogpost " & request.page.getParameter(), detail = request.page.getParameter());
                }
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required search  blogpostSearchCtrl,
                                           required numeric actualPage) {
        var renderedContent = "";
        
        saveContent variable="renderedContent" {
            module template          = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/overview.cfm"
                   options           = arguments.options
                   blogposts         = blogpostSearchCtrl.execute()
                   totalGalleryCount = blogpostSearchCtrl.getTotalGalleryCount()
                   totalPageCount    = ceiling(blogpostSearchCtrl.getTotalGalleryCount() / arguments.options.maxEntries)
                   actualPage        = arguments.actualPage;
        }
        
        return renderedContent;
    }
    
    private string function renderDetails(required struct options, required blogpost blogpost) {
        var renderedContent = "";
        var statisticsCtrl = createObject("component", "API.com.IcedReaper.blog.statistics").init();
        
        statisticsCtrl.add(arguments.blogpost.getBlogpostId());
        
        saveContent variable="renderedContent" {
            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/blogpostDetail.cfm"
                   options  = arguments.options
                   blogpost = arguments.blogpost;
        }
        
        return renderedContent;
    }
}