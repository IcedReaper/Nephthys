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
        var blogpostFilterCtrl = createObject("component", "API.modules.com.IcedReaper.blog.filter").init();
        
        if(! arguments.options.keyExists("maxEntries")) {
            arguments.options.maxEntries = 5;
        }
        
        if(arguments.options.keyExists("onlyLast")) {
            blogpostFilterCtrl.setReleased(1)
                              .setCount(1)
                              .execute();
            
            var renderedContent = "";
            saveContent variable="renderedContent" {
                module template  = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/lastEntry.cfm"
                       options   = arguments.options
                       blogposts = blogpostFilterCtrl;
            }
            
            return renderedContent;
        }
        
        if(splitParameter.len() == 0) {
            blogpostFilterCtrl.setReleased(1)
                              .setCount(arguments.options.maxEntries)
                              .execute();
            
            return renderOverview(arguments.options, blogpostFilterCtrl, 1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) { // todo: Seite multilingual
                blogpostFilterCtrl.setReleased(1)
                                  .setCount(arguments.options.maxEntries)
                                  .setOffset((splitParameter[2]-1) * arguments.options.maxEntries)
                                  .execute();
                
                return renderOverview(arguments.options, blogpostFilterCtrl, splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") { // todo: Kategorie multilingual
                if(splitParameter.len() == 2) {
                    blogpostFilterCtrl.setReleased(1)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .execute();
                    
                    return renderOverview(arguments.options, blogpostFilterCtrl, 1, splitParameter[2]);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    blogpostFilterCtrl.setReleased(1)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .setOffset((splitParameter[4]-1) * arguments.options.maxEntries)
                                      .execute();
                    
                    return renderOverview(arguments.options, blogpostFilterCtrl, splitParameter[2]);
                }
            }
            else { // Detail view
                blogpostFilterCtrl.setReleased(1)
                                  .setLink(request.page.getParameter())
                                  .execute();

                if(blogpostFilterCtrl.getResultCount() == 1) {
                    var blogpost = blogpostFilterCtrl.getResult()[1];
                    
                    blogpost.incrementViewCounter();
                    
                    request.page.setTitle(blogpost.getHeadline());
                    
                    var commentAdded = checkAndAddComment(blogpost);
                    
                    return renderDetails(arguments.options, blogpost, commentAdded);
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
                                                    string  activeCategory = "") {
        var renderedContent = "";
        var categoryLoader = createObject("component", "API.modules.com.IcedReaper.blog.categoryLoader").init();
        
        saveContent variable="renderedContent" {
            module template           = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/overview.cfm"
                   options            = arguments.options
                   blogposts          = arguments.blogpostFilterCtrl.getResult()
                   totalBlogpostCount = arguments.blogpostFilterCtrl.getResultCount()
                   totalPageCount     = ceiling(arguments.blogpostFilterCtrl.getResultCount() / arguments.options.maxEntries)
                   actualPage         = arguments.actualPage
                   categories         = categoryLoader.load()
                   activeCategory     = arguments.activeCategory;
        }
        
        return renderedContent;
    }
    
    private string function renderDetails(required struct options, required blogpost blogpost, required boolean commentAdded) {
        var renderedContent = "";
        var statisticsCtrl = createObject("component", "API.modules.com.IcedReaper.blog.statistics").init();
        
        statisticsCtrl.add(arguments.blogpost.getBlogpostId());
        
        saveContent variable="renderedContent" {
            module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/blog/templates/blogpostDetail.cfm"
                   options      = arguments.options
                   blogpost     = arguments.blogpost
                   commentAdded = commentAdded;
        }
        
        return renderedContent;
    }
    
    private boolean function checkAndAddComment(required blogpost blogpost) {
        if(! structIsEmpty(form)) {
            if(true) { // check referrer
                if(arguments.blogpost.getCommentsActivated()) {
                    if(len(form.comment) > 0 && len(form.comment) <= 500) {
                        // todo: check if ip/user/what ever commented > X times the last Y seconds (Spam-Protection)
                        if(request.user.getUserId() != 0 || (arguments.blogpost.getAnonymousCommentAllowed() && validateUsername(form.anonymousUsername) && validateEmail(form.anonymousEmail))) {
                            var newComment = createObject("component", "API.modules.com.IcedReaper.blog.comment").init(0);
                            
                            newComment.setBlogpostId(arguments.blogpost.getBlogpostId())
                                      .setComment(form.comment);
                            
                            if(request.user.getUserId() != 0) {
                                newComment.setCreatorUserId(request.user.getUserId());
                            }
                            else {
                                newComment.setAnonymousUsername(form.anonymousUsername)
                                          .setAnonymousEmail(form.anonymousEmail);
                            }
                            
                            if(! arguments.blogpost.getCommentsNeedToGetPublished()) {
                                newComment.setPublished(true);
                            }
                            
                            newComment.save();
                            
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
        
        var userFilterCtrl = createObject("component", "API.modules.com.Nephthys.user.filter").init();
        return userFilterCtrl.setUserName(arguments.userName)
                             .execute()
                             .getResultCount() == 0;
    }
    
    private boolean function validateEmail(required string eMail) {
        return arguments.eMail != "" && application.system.settings.getValueOfKey("validator").validate(data=arguments.eMail, ruleName="Email");
    }
}