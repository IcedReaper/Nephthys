component {
    public blogpost function init(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        variables.attributesChanged = false;
        variables.categoriesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
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
    public blogpost function setReleased(required numeric released) {
        variables.released = arguments.released;
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
    
    public blogpost function addCategory(required category _category) {
        variables.categories.append(duplicate(arguments._category));
        
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
    
    // G E T T E R
    
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
    public boolean function getReleased() {
        return variables.released;
    }
    public any function getReleaseDate() { // any is required as a null date isn't of type date :/
        return variables.releaseDate;
    }
    public string function getFolderName() {
        return variables.folderName;
    }
    public boolean function getCommentsActivated() {
        return variables.commentsActivated;
    }
    public numeric function getCreatorUserId() {
        return variables.creatorUserId;
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
        if(variables.commentsActivated) {
            return variables.comments;
        }
        else {
            return [];
        }
    }
    
    public string function getAbsolutePath() {
        return expandPath(getRelativePath());
    }
    public boolean function isPublished() {
        return (variables.releaseDate == null || variables.releaseDate < now()) && variables.released;
    }
    
    // C R U D
    public blogpost function save() {
        if(variables.folderName == "") {
            variables.folderName = createUUID();
        }
        
        if(variables.blogpostId == 0) {
            variables.blogpostId = new Query().setSQL("INSERT INTO IcedReaper_blog_blogpost
                                                                   (
                                                                       headline,
                                                                       link,
                                                                       story,
                                                                       released,
                                                                       releaseDate,
                                                                       folderName,
                                                                       commentsActivated,
                                                                       creatorUserId,
                                                                       lastEditorUserId,
                                                                       lastEditDate
                                                                   )
                                                            VALUES (
                                                                       :headline,
                                                                       :link,
                                                                       :story,
                                                                       :released,
                                                                       :releaseDate,
                                                                       :commentsActivated,
                                                                       :creatorUserId,
                                                                       :lastEditorUserId,
                                                                       now()
                                                                   );
                                                       SELECT currval('seq_icedreaper_blog_blogpost_id' :: regclass) newBlogpostId;")
                                              .addParam(name = "headline",          value = variables.headline,          cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "link",              value = variables.link,              cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "story",             value = variables.story,             cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "released",          value = variables.released,          cfsqltype = "cf_sql_bit")
                                              .addParam(name = "releaseDate",       value = variables.releaseDate,       cfsqltype = "cf_sql_timestamp", null=variables.releaseDate == null)
                                              .addParam(name = "folderName",        value = variables.folderName,        cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "commentsActivated", value = variables.commentsActivated, cfsqltype = "cf_sql_bit")
                                              .addParam(name = "creatorUserId",     value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                                              .addParam(name = "lastEditorUserId",  value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                                              .execute()
                                              .getResult()
                                              .newBlogpostId[1];
            
            directoryCreate(getAbsolutePath(), true, true);
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_blog_blogpost
                                       SET headline          = :headline,
                                           link              = :link,
                                           story             = :story,
                                           released          = :released,
                                           releaseDate       = :releaseDate,
                                           folderName        = :folderName,
                                           commentsActivated = :commentsActivated,
                                           lastEditorUserId  = :lastEditorUserId,
                                           lastEditDate      = now()
                                     WHERE blogpostId = :blogpostId")
                           .addParam(name = "blogpostId",        value = variables.blogpostId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "headline",          value = variables.headline,          cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",              value = variables.link,              cfsqltype = "cf_sql_varchar")
                           .addParam(name = "story",             value = variables.story,             cfsqltype = "cf_sql_varchar")
                           .addParam(name = "released",          value = variables.released,          cfsqltype = "cf_sql_bit")
                           .addParam(name = "releaseDate",       value = variables.releaseDate,       cfsqltype = "cf_sql_timestamp", null=variables.releaseDate == null)
                           .addParam(name = "folderName",        value = variables.folderName,        cfsqltype = "cf_sql_varchar")
                           .addParam(name = "commentsActivated", value = variables.commentsActivated, cfsqltype = "cf_sql_bit")
                           .addParam(name = "creatorUserId",     value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId",  value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            if(structKeyExists(variables, "oldFolderName") && variables.oldFolderName != variables.folderName) {
                directoryRename(expandPath("/upload/com.IcedReaper.blog/" & variables.oldFolderName), getAbsolutePath());
            }
        }
        
        if(variables.categoriesChanged) {
            for(var c = 1; c <= variables.categories.len(); c++) {
                try {
                    if(variables.categories[c].getCategoryId() == 0) {
                        variables.categories[c].save();
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
                               .addParam(name = "creatorUserId", value = request.user.getUserId(),                cfsqltype = "cf_sql_numeric")
                               .execute();
                }
                catch(any e) {
                    // check for exception types of duplicate unique keys
                }
            }
        }
        
        variables.attributesChanged = false;
        variables.categoriesChanged = false;
        
        
        // delete all unused files
        var usedFiles = directoryList(getAbsolutePath(), false, "name");
        for(var i = 1; i <= usedFiles.len(); i++) {
            if(! find(usedFiles[i], variables.story)) {
                fileDelete(getAbsolutePath() & "/" & usedFiles[i]);
            }
        }
        
        return this;
    }
    
    public void function delete() {
        //directoryDelete(getAbsolutePath(), true);
        // todo: delete saved objects like pictures and videos
        
        new Query().setSQL("DELETE
                              FROM IcedReaper_blog_blogpost
                             WHERE blogpostId = :blogpostId")
                   .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.blogpostId = 0;
        
        directoryDelete(getAbsolutePath(), true);
    }
    
    // I N T E R N A L
    
    private void function loadDetails() {
        if(variables.blogpostId != 0 && variables.blogpostId != null) {
            var qBlogpost = new Query().setSQL("SELECT * 
                                                  FROM IcedReaper_blog_blogpost
                                                 WHERE blogpostId = :blogpostId")
                                       .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult();
            
            if(qBlogpost.getRecordCount() == 1) {
                variables.headline          = qBlogpost.headline[1];
                variables.link              = qBlogpost.link[1];
                variables.story             = qBlogpost.story[1];
                variables.released          = qBlogpost.released[1];
                variables.releaseDate       = qBlogpost.releaseDate[1];
                variables.commentsActivated = qBlogpost.commentsActivated[1];
                variables.creatorUserId     = qBlogpost.creatorUserId[1];
                variables.creationDate      = qBlogpost.creationDate[1];
                variables.lastEditorUserId  = qBlogpost.lastEditorUserId[1];
                variables.lastEditDate      = qBlogpost.lastEditDate[1];
                variables.folderName        = qBlogpost.folderName[1];
                variables.comments          = [];
                variables.categories        = [];
                
                loadComments();
                loadCategories();
            }
            else {
                throw(type = "icedreaper.blogpost.notFound", message = "The Gallery could not be found", detail = variables.blogpostId);
            }
        }
        else {
            variables.headline          = "";
            variables.link              = "";
            variables.story             = "";
            variables.released          = false;
            variables.releaseDate       = null;
            variables.commentsActivated = false;
            variables.creatorUserId     = null;
            variables.creationDate      = null;
            variables.lastEditorUserId  = null;
            variables.lastEditDate      = null;
            variables.categories        = [];
            variables.comments          = [];
            variables.folderName        = createUUID();
        }
        
        if(variables.creatorUserId != null) {
            variables.creator = createObject("component", "API.com.Nephthys.classes.user.user").init(variables.creatorUserId);
        }
        else {
            variables.creator = null;
        }
        
        if(variables.lastEditorUserId != null) {
            variables.lastEditor = createObject("component", "API.com.Nephthys.classes.user.user").init(variables.lastEditorUserId);
        }
        else {
            variables.lastEditor = null;
        }
    }
    
    private void function loadCategories() {
        var qCategoryIds = new Query().setSQL("  SELECT categoryId
                                                   FROM IcedReaper_blog_blogpostCategory
                                                  WHERE blogpostId = :blogpostId
                                               ORDER BY creationDate ASC")
                                      .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
        
        variables.categories.clear();
        for(var i = 1; i <= qCategoryIds.getRecordCount(); i++) {
            variables.categories.append(new category(qCategoryIds.categoryId[i]));
        }
    }
    
    private void function loadComments() {
        var qCommentIds = new Query().setSQL("  SELECT commentId
                                                  FROM icedReaper_blog_comment
                                                 WHERE blogpostId = :blogpostId
                                                   AND parentCommentId IS NULL 
                                              ORDER BY creationDate DESC ")
                                     .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
        
        for(var i = 1; i <= qCommentIds.getRecordCount(); i++) {
            variables.comments.append(new comment(qCommentIds.commentId[i]));
        }
    }
}