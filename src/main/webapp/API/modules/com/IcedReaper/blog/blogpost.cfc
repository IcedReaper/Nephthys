component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public blogpost function init(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        variables.attributesChanged = false;
        variables.categoriesChanged = false;
        variables.picturesChanged   = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public blogpost function setHeadline(required string headline) {
        variables.headline = arguments.headline;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setLink(required string link) {
        variables.link = arguments.link;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setStory(required string story, required array fileNames = []) {
        var _story = arguments.story;
        
        for(var i = 1; i <= arguments.fileNames.len(); i++) {
            _story = replace(_story, "{{{~newImageUpload" & i & "}}}", "<img src=""" & getRelativePath() & "/" & arguments.fileNames[i] & """>");
        }
        
        variables.story = _story;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function clearReleaseDate() {
        variables.releaseDate = null;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setFolderName(required string folderName) {
        variables.oldFolderName = variables.folderName;
        variables.folderName    = arguments.folderName;
        variables.attributesChanged = true;
        
        if(variables.oldFolderName != variables.folderName) {
            if(directoryExists(getAbsolutePath())) {
                throw(type = "Application", message = "Directory is already existing");
            }
        }
        
        return this;
    }
    public blogpost function setReleaseDate(required date releaseDate) {
        variables.releaseDate = arguments.releaseDate;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setCommentsActivated(required numeric commentsActivated) {
        variables.commentsActivated = arguments.commentsActivated;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setAnonymousCommentAllowed(required boolean anonymousCommentAllowed) {
        variables.anonymousCommentAllowed = arguments.anonymousCommentAllowed;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setCommentsNeedToGetPublished(required boolean commentsNeedToGetPublished) {
        variables.commentsNeedToGetPublished = arguments.commentsNeedToGetPublished;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setPrivate(required boolean private) {
        variables.private = arguments.private;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public blogpost function addCategory(required category category) {
        variables.categories.append(duplicate(arguments.category));
        variables.categoriesChanged = true;
        
        return this;
    }
    public blogpost function addCategoryById(required numeric categoryId) {
        variables.categories.append(new category(arguments.categoryId));
        variables.categoriesChanged = true;
        
        return this;
    }
    public blogpost function removeCategory(required numeric categoryId) {
        for(var c = 1; c <= variables.categories.len(); c++) {
            if(variables.categories[c].getCategoryId() == arguments.categoryId) {
                new Query().setSQL("DELETE FROM IcedReaper_blogpost_blogpostCategory
                                         WHERE blogpostId  = :blogpostId
                                           AND categoryId = :categoryId")
                           .addParam(name = "blogpostId",  value = variables.blogpostId,  cfsqltype = "cf_sql_numeric")
                           .addParam(name = "categoryId", value = arguments.categoryId, cfsqltype = "cf_sql_numeric")
                           .execute();
                
                break;
            }
        }
        
        return this;
    }
    public blogpost function addComment(required comment comment) {
        if(arguments.comment.isSaved()) {
            variables.comments.append(arguments.comment);
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot add a non saved comment");
        }
        
        return this;
    }
    public blogpost function incrementViewCounter() {
        variables.viewCounter = new Query().setSQL("UPDATE IcedReaper_blog_blogpost
                                                       SET viewCounter = viewCounter + 1
                                                     WHERE blogpostId = :blogpostId;
                                                    SELECT viewCounter
                                                      FROM IcedReaper_blog_blogpost
                                                     WHERE blogpostId = :blogpostId;")
                                           .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult()
                                           .viewCounter[1];
        
        return this;
    }
    public blogpost function addPicture(required picture _picture) {
        variables.pictures.append(duplicate(arguments._picture));
        
        variables.picturesChanged = true;
        
        return this;
    }
    public blogpost function removePicture(required numeric pictureId) {
        for(var p = 1; p <= variables.pictures.len(); p++) {
            if(variables.pictures[p].getPictureId() == arguments.pictureId) {
                variables.pictures[p].delete(request.user);
                variables.pictures.deleteAt(p);
                
                break;
            }
        }
        
        return this;
    }
    
    public blogpost function setStatus(required status newStatus) {
        variables.status = arguments.newStatus;
        return this;
    }
    
    
    public numeric function getBlogpostId() {
        return variables.blogpostId;
    }
    public string function getHeadline() {
        return variables.headline;
    }
    public string function getLink() {
        return variables.link;
    }
    public string function getStory() {
        return variables.story;
    }
    public any function getReleaseDate() { // any is required as a null date isn't of type date :/
        return variables.releaseDate;
    }
    public string function getFolderName() {
        return variables.folderName;
    }
    public boolean function getCommentsActivated() {
        return variables.commentsActivated == 1;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    public string function getRelativePath() {
        return "/upload/com.IcedReaper.blog/" & variables.folderName;
    }
    public array function getCategories() {
        return variables.categories;
    }
    public array function getComments() {
        return variables.comments;
    }
    public boolean function getAnonymousCommentAllowed() {
        return variables.anonymousCommentAllowed == 1;
    }
    public boolean function getCommentsNeedToGetPublished() {
        return variables.commentsNeedToGetPublished == 1;
    }
    
    public string function getAbsolutePath() {
        return expandPath(getRelativePath());
    }
    public boolean function isPublished() {
        return (variables.releaseDate == null || variables.releaseDate < now()) && variables.released;
    }
    public numeric function getViewCounter() {
        return variables.viewCounter;
    }
    public boolean function getPrivate() {
        return variables.private == 1;
    }
    
    public boolean function isEditable(required user user) {
        if(variables.private) {
            if(! variables.creator.getUserId() == arguments.user.getUserId()) {
                return false;
            }
        }
        
        return variables.status.getEditable();
    }
    
    public status function getStatus() {
        return variables.status;
    }
    public array function getPictures() {
        return variables.pictures;
    }
    public numeric function getPictureCount() {
        return variables.pictures.len();
    }
    
    
    public blogpost function pushToStatus(required status newStatus, required user user) {
        var actualStatus = duplicate(variables.status);
        
        var newStatusOK = false;
        for(var nextStatus in actualStatus.getNextStatus()) {
            if(nextStatus.getStatusId() == arguments.newStatus.getStatusId()) {
                newStatusOk = true;
            }
        }
        
        if(newStatusOk) {
            if(arguments.newStatus.isApprovalValid(arguments.user.getUserId())) {
                transaction {
                    setStatus(arguments.newStatus);
                    
                    new Query().setSQL("UPDATE IcedReaper_blog_blogpost
                                           SET statusId = :statusId
                                         WHERE blogpostId = :blogpostId")
                               .addParam(name = "blogpostId", value = variables.blogpostId,           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "statusId",   value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric")
                               .execute();
                    
                    new approval(null).setBlogpost(this)
                                      .setPrevStatus(actualStatus)
                                      .setNewStatus(arguments.newStatus)
                                      .save(arguments.user);
                    
                    transactionCommit();
                }
                
                return this;
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You don't have the required permissions for this operation");
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The new status isn't allowed!");
        }
    }
    
    public blogpost function save(required user user) {
        if(variables.folderName == "") {
            variables.folderName = createUUID();
        }
        
        var qSave = new Query().addParam(name = "headline",                   value = variables.headline,                   cfsqltype = "cf_sql_varchar")
                               .addParam(name = "link",                       value = variables.link,                       cfsqltype = "cf_sql_varchar")
                               .addParam(name = "story",                      value = variables.story,                      cfsqltype = "cf_sql_varchar")
                               .addParam(name = "releaseDate",                value = variables.releaseDate,                cfsqltype = "cf_sql_timestamp", null = variables.releaseDate == null)
                               .addParam(name = "folderName",                 value = variables.folderName,                 cfsqltype = "cf_sql_varchar")
                               .addParam(name = "commentsActivated",          value = variables.commentsActivated,          cfsqltype = "cf_sql_bit")
                               .addParam(name = "anonymousCommentAllowed",    value = variables.anonymousCommentAllowed,    cfsqltype = "cf_sql_bit")
                               .addParam(name = "commentsNeedToGetPublished", value = variables.commentsNeedToGetPublished, cfsqltype = "cf_sql_bit")
                               .addParam(name = "private",                    value = variables.private,                    cfsqltype = "cf_sql_bit")
                               .addParam(name = "userId",                     value = arguments.user.getUserId(),           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "statusId",                   value = variables.status.getStatusId(),       cfsqltype = "cf_sql_numeric");
        
        if(variables.blogpostId == 0) {
            variables.blogpostId = qSave.setSQL("INSERT INTO IcedReaper_blog_blogpost
                                                             (
                                                                 headline,
                                                                 link,
                                                                 story,
                                                                 releaseDate,
                                                                 folderName,
                                                                 commentsActivated,
                                                                 anonymousCommentAllowed,
                                                                 commentsNeedToGetPublished,
                                                                 private,
                                                                 statusId,
                                                                 creatorUserId,
                                                                 lastEditorUserId
                                                             )
                                                      VALUES (
                                                                 :headline,
                                                                 :link,
                                                                 :story,
                                                                 :releaseDate,
                                                                 :folderName,
                                                                 :commentsActivated,
                                                                 :anonymousCommentAllowed,
                                                                 :commentsNeedToGetPublished,
                                                                 :private,
                                                                 :statusId,
                                                                 :userId,
                                                                 :userId
                                                             );
                                                 SELECT currval('seq_icedreaper_blog_blogpost_id') newBlogpostId;")
                                        .execute()
                                        .getResult()
                                        .newBlogpostId[1];
            
            directoryCreate(getAbsolutePath(), true, true);
            
            variables.creator = arguments.user;
            variables.creationDate = now();
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        else {
            if(variables.attributesChanged) {
                if(variables.status.getEditable()) {
                    qSave.setSQL("UPDATE IcedReaper_blog_blogpost
                                     SET headline                   = :headline,
                                         link                       = :link,
                                         story                      = :story,
                                         releaseDate                = :releaseDate,
                                         folderName                 = :folderName,
                                         commentsActivated          = :commentsActivated,
                                         anonymousCommentAllowed    = :anonymousCommentAllowed,
                                         commentsNeedToGetPublished = :commentsNeedToGetPublished,
                                         private                    = :private,
                                         statusId                   = :statusId,
                                         lastEditorUserId           = :userId,
                                         lastEditDate               = now()
                                   WHERE blogpostId = :blogpostId")
                         .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                         .execute();
                    
                    if(variables.keyExists("oldFolderName") && variables.oldFolderName != variables.folderName) {
                        directoryRename(expandPath("/upload/com.IcedReaper.blog/" & variables.oldFolderName), getAbsolutePath());
                    }
                    
                    variables.lastEditor = arguments.user;
                    variables.lastEditDate = now();
                    
                    variables.attributesChanged = false;
                    
                    if(variables.picturesChanged) {
                        for(var p = 1; p <= variables.pictures.len(); p++) {
                            variables.pictures[p].save(arguments.user);
                        }
                    }
                    variables.picturesChanged = false;
                    
                }
                else {
                    throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update the version that is online");
                }
            }
        }
        
        if(variables.categoriesChanged) {
            if(variables.status.getEditable()) {
                for(var c = 1; c <= variables.categories.len(); c++) {
                    try {
                        if(variables.categories[c].getCategoryId() == 0) {
                            variables.categories[c].save(arguments.user);
                        }
                        
                        new Query().setSQL("INSERT INTO IcedReaper_blog_blogpostCategory
                                                        (
                                                            blogpostId,
                                                            categoryId,
                                                            creatorUserId
                                                        )
                                                 VALUES (
                                                            :blogpostId,
                                                            :categoryId,
                                                            :creatorUserId
                                                        )")
                                   .addParam(name = "blogpostId",    value = variables.blogpostId,                    cfsqltype = "cf_sql_numeric")
                                   .addParam(name = "categoryId",    value = variables.categories[c].getCategoryId(), cfsqltype = "cf_sql_numeric")
                                   .addParam(name = "creatorUserId", value = arguments.user.getUserId(),              cfsqltype = "cf_sql_numeric")
                                   .execute();
                    }
                    catch(any e) {
                        // check for exception types of duplicate unique keys
                    }
                }
                
                variables.categoriesChanged = false;
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update the version that is online");
            }
        }
        
        // delete all unused files
        var usedFiles = directoryList(getAbsolutePath(), false, "name");
        for(var i = 1; i <= usedFiles.len(); i++) {
            if(! find(usedFiles[i], variables.story) && ! imageUsedInPictures(usedFiles[i])) {
                fileDelete(getAbsolutePath() & "/" & usedFiles[i]);
            }
        }
        
        
        return this;
    }
    
    public void function delete(required user user) {
        directoryDelete(getAbsolutePath(), true);
        
        new Query().setSQL("DELETE
                              FROM IcedReaper_blog_blogpost
                             WHERE blogpostId = :blogpostId")
                   .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.blogpostId = 0;
    }
    
    public blogpost function reloadPictures() {
        if(variables.blogpostId != 0) {
            loadPictures();
            return this;
        }
        else {
            throw(type  = "icedreaper.blogpost.notFound", message = "The pictures can only be reloaded for existing galleries.");
        }
    }
    
    
    private void function loadDetails() {
        if(variables.blogpostId != 0 && variables.blogpostId != null) {
            var qBlogpost = new Query().setSQL("SELECT * 
                                                  FROM IcedReaper_blog_blogpost
                                                 WHERE blogpostId = :blogpostId")
                                       .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult();
            
            if(qBlogpost.getRecordCount() == 1) {
                variables.headline                   = qBlogpost.headline[1];
                variables.link                       = qBlogpost.link[1];
                variables.story                      = qBlogpost.story[1];
                variables.releaseDate                = qBlogpost.releaseDate[1];
                variables.commentsActivated          = qBlogpost.commentsActivated[1];
                variables.anonymousCommentAllowed    = qBlogpost.anonymousCommentAllowed[1];
                variables.commentsNeedToGetPublished = qBlogpost.commentsNeedToGetPublished[1];
                variables.creator                    = new user(qBlogpost.creatorUserId[1]);
                variables.creationDate               = qBlogpost.creationDate[1];
                variables.lastEditor                 = new user(qBlogpost.lastEditorUserId[1]);
                variables.lastEditDate               = qBlogpost.lastEditDate[1];
                variables.folderName                 = qBlogpost.folderName[1];
                variables.comments                   = [];
                variables.categories                 = [];
                variables.viewCounter                = qBlogpost.viewCounter[1];
                variables.private                    = qBlogpost.private[1];
                variables.status                     = new status(qBlogpost.statusId[1]);
                
                loadPictures();
                loadComments();
                loadCategories();
            }
            else {
                throw(type = "icedreaper.blogpost.notFound", message = "The Blogpost could not be found", detail = variables.blogpostId);
            }
        }
        else {
            var defaultSettings = new settings().load();
            
            variables.headline                   = "";
            variables.link                       = "";
            variables.story                      = "";
            variables.releaseDate                = null;
            variables.commentsActivated          = defaultSettings.getValueOfKey("commentsActivated");
            variables.anonymousCommentAllowed    = defaultSettings.getValueOfKey("anonymousCommentAllowed");
            variables.commentsNeedToGetPublished = defaultSettings.getValueOfKey("commentsNeedToGetPublished");
            variables.creator                    = request.user;
            variables.creationDate               = null;
            variables.lastEditor                 = request.user;
            variables.lastEditDate               = null;
            variables.categories                 = [];
            variables.comments                   = [];
            variables.pictures                   = [];
            variables.folderName                 = createUUID();
            variables.viewCounter                = 0;
            variables.private                    = false;
            variables.status                     = new status(application.system.settings.getValueOfKey("com.IcedReaper.blog.defaultStatus"));
        }
    }
    
    private void function loadCategories() {
        variables.categories = new filter().for("category")
                                           .setBlogpostId(variables.blogpostId)
                                           .execute()
                                           .getResult();
    }
    
    private void function loadComments() {
         variables.comments = new filter().for("comment")
                                          .setBlogpostId(variables.blogpostId)
                                          .setSortBy("creationDate")
                                          .setSortDirection("DESC")
                                          .execute()
                                          .getResult();
    }
    
    private void function loadPictures() {
        variables.pictures = new filter().for("picture")
                                         .setBlogpost(this)
                                         .execute()
                                         .getResult();
        
        variables.picturesChanged = false;
    }
    
    private boolean function imageUsedInPictures(required string fileName) {
        for(var i = 1; i <= variables.pictures.len(); ++i) {
            if(variables.pictures[i].getPictureFileName() == arguments.fileName) {
                return true;
            }
        }
        
        return false;
    }
}