component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.blog.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.blog";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        // prepare the options required for the theme
        var themeIndividualizer = createObject("component", "WWW.themes." & request.user.getTheme().getFolderName() & ".modules.com.IcedReaper.blog.cfc.prepareData");
        var preparedOptions = themeIndividualizer.prepareOptions(arguments.options);
        
        themeIndividualizer.invokeResources();
        
        var splitParameter = listToArray(request.page.getParameter(), "/");
        var blogpostFilterCtrl = new filter().for("blogpost");
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(arguments.options.keyExists("onlyLast")) {
            blogpostFilterCtrl.setReleased(true)
                              .setCount(1)
                              .execute();
            
            return application.system.settings.getValueOfKey("templateRenderer")
                .setTemplate("/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/lastEntry.cfm")
                .addParam("options", arguments.options)
                .addParam("blogposts", blogpostFilterCtrl.getResult())
                .addParam("rootElement",  arguments.rootElement)
                .render();
        }
        
        if(splitParameter.len() == 0) {
            blogpostFilterCtrl.setReleased(true)
                              .setCount(arguments.options.maxEntries)
                              .execute();
            
            return renderOverview(arguments.options, blogpostFilterCtrl, 1, arguments.rootElement);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) {
                blogpostFilterCtrl.setReleased(true)
                                  .setCount(arguments.options.maxEntries)
                                  .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                                  .execute();
                
                return renderOverview(arguments.options, blogpostFilterCtrl, splitParameter[2], arguments.rootElement);
            }
            else if(splitParameter[1] == "Kategorie") {
                if(splitParameter.len() == 2) {
                    blogpostFilterCtrl.setReleased(true)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .execute();
                    
                    return renderOverview(arguments.options, blogpostFilterCtrl, 1, arguments.rootElement, splitParameter[2]);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") {
                    blogpostFilterCtrl.setReleased(true)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                      .execute();
                    
                    return renderOverview(arguments.options, blogpostFilterCtrl, splitParameter[2], arguments.rootElement);
                }
            }
            else { // Detail view
                blogpostFilterCtrl.setReleased(true)
                                  .setLink(request.page.getParameter())
                                  .execute();

                if(blogpostFilterCtrl.getResultCount() == 1) {
                    var blogpost = blogpostFilterCtrl.getResult()[1];
                    
                    blogpost.incrementViewCounter();
                    
                    request.page.setTitle(blogpost.getHeadline());
                    
                    var commentAdded = checkAndAddComment(blogpost);
                    
                    return renderDetails(arguments.options, blogpost, commentAdded, arguments.rootElement);
                }
                else {
                    throw(type = "icedreaper.blog.notFound", message = "Could not find the blogpost " & request.page.getParameter(), detail = request.page.getParameter());
                }
            }
        }
    }
    
    private string function renderOverview(required struct  options,
                                           required filter  blogpostFilterCtrl,
                                           required numeric actualPage,
                                           required boolean rootElement,
                                                    string  activeCategory = "") {
        var categoryFilter = new filter().for("category").setUsed(true);
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("overview.cfm")
            .addParam("options",            arguments.options)
            .addParam("blogposts",          arguments.blogpostFilterCtrl.getResult())
            .addParam("totalBlogpostCount", arguments.blogpostFilterCtrl.getResultCount())
            .addParam("totalPageCount",     ceiling(arguments.blogpostFilterCtrl.getResultCount() / arguments.options.maxEntries))
            .addParam("actualPage",         arguments.actualPage)
            .addParam("categories",         categoryFilter.execute().getResult())
            .addParam("activeCategory",     arguments.activeCategory)
            .addParam("rootElement",        arguments.rootElement)
            .render();
    }
    
    private string function renderDetails(required struct options,
                                          required blogpost blogpost,
                                          required boolean commentAdded,
                                          required boolean rootElement) {
        var statisticsCtrl = new statistics();
        
        statisticsCtrl.add(arguments.blogpost.getBlogpostId());
        
        return application.system.settings.getValueOfKey("templateRenderer")
            .setModulePath(getModulePath())
            .setTemplate("blogpostDetail.cfm")
            .addParam("options",      arguments.options)
            .addParam("blogpost",     arguments.blogpost)
            .addParam("commentAdded", commentAdded)
            .addParam("rootElement",  arguments.rootElement)
            .render();
    }
    
    private boolean function checkAndAddComment(required blogpost blogpost) {
        if(! structIsEmpty(form)) {
            if(true) { // check referrer
                if(arguments.blogpost.getCommentsActivated()) {
                    if(len(form.comment) > 0 && len(form.comment) <= 500) {
                        if(request.user.getUserId() != null || (arguments.blogpost.getAnonymousCommentAllowed() && validateUsername(form.anonymousUsername) && validateEmail(form.anonymousEmail))) {
                            var newComment = new comment(null, arguments.blogpost);
                            
                            if(request.user.getStatus().getCanLogin() == 0) {
                                newComment.setAnonymousUsername(form.anonymousUsername)
                                          .setAnonymousEmail(form.anonymousEmail);
                            }
                            
                            if(! arguments.blogpost.getCommentsNeedToGetPublished()) {
                                newComment.setPublished(true);
                            }
                            
                            newComment.setComment(form.comment)
                                      .save(request.user);
                            
                            arguments.blogpost.addComment(newComment);
                            
                            return true;
                        }
                        else {
                            throw(type = "nephthys.application.notAllowed", message = "Either you are not logged, but have to be, or your typed in username or email is empty or invalid");
                        }
                    }
                    else {
                        throw(type = "nephthys.application.invalidContent", message = "The comment is either empty or longer then 500 characters");
                    }
                }
                else {
                    throw(type = "nephthys.application.notAllowed", message = "It is not allowed to post comments to this blog post");
                }
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "This action is not allowed");
            }
        }
        
        return false;
    }
    
    private boolean function validateUsername(required string username) {
        if(arguments.username == "") {
            return false;
        }
        
        var userFilterCtrl = createObject("component", "API.modules.com.Nephthys.userManager.filter").init().for("user");
        return userFilterCtrl.setUserName(arguments.userName)
                             .execute()
                             .getResultCount() == 0;
    }
    
    private boolean function validateEmail(required string eMail) {
        return arguments.eMail != "" && application.system.settings.getValueOfKey("validator").validate(data=arguments.eMail, ruleName="Email");
    }
}