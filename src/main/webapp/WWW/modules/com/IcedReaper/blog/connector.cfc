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
            
            return renderOverview(arguments.options, blogpostSearchCtrl, 1);
        }
        else {
            if(splitParameter[1] == "Seite" && splitParameter.len() == 2) { // todo: Seite multilingual
                blogpostSearchCtrl.setReleased(1)
                                  .setCount(arguments.options.maxEntries)
                                  .setOffset((splitParameter[2]-1) * arguments.options.maxEntries);
                
                return renderOverview(arguments.options, blogpostSearchCtrl, splitParameter[2]);
            }
            else if(splitParameter[1] == "Kategorie") { // todo: Kategorie multilingual
                if(splitParameter.len() == 2) {
                    blogpostSearchCtrl.setReleased(1)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options, blogpostSearchCtrl, 1);
                }
                else if(splitParameter.len() == 4 && splitParameter[3] == "Seite") { // todo: Seite multilingual
                    blogpostSearchCtrl.setReleased(1)
                                      .setCategory(splitParameter[2])
                                      .setCount(arguments.options.maxEntries)
                                      .setOffset((splitParameter[4]-1) * arguments.options.maxEntries);
                    
                    return renderOverview(arguments.options, blogpostSearchCtrl, splitParameter[2]);
                }
            }
            else { // Detail view
                var blogposts = blogpostSearchCtrl.setReleased(1)
                                                  .setLink(request.page.getParameter())
                                                  .execute();
                
                if(blogposts.len() == 1) {
                    var blogpost = blogposts[1];
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
    
    private string function renderDetails(required struct options, required blogpost blogpost, required boolean commentAdded) {
        var renderedContent = "";
        var statisticsCtrl = createObject("component", "API.com.IcedReaper.blog.statistics").init();
        
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
                            var newComment = createObject("component", "API.com.IcedReaper.blog.comment").init(0);
                            
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
        return arguments.username != "" && application.security.loginHandler.checkForUser(username=arguments.username) == false;
    }
    
    private boolean function validateEmail(required string eMail) {
        return arguments.eMail != "" && application.tools.validator.validate(data=arguments.eMail, ruleName="Email");
    }
}