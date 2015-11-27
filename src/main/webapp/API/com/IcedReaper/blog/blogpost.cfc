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
    public blogpost function setDescription(required string description) {
        variables.description = arguments.description;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setLink(required string link) {
        variables.link = arguments.link;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setStory(required string story) {
        variables.story = arguments.story;
        variables.attributesChanged = true;
        
        return this;
    }
    public blogpost function setReleased(required numeric released) {
        variables.released = arguments.released;
        variables.attributesChanged = true;
        
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
    public string function getDescription() {
        return variables.description;
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
    public date function getReleaseDate() {
        return variables.releaseDate;
    }
    public boolean function getCommentsActivated() {
        return variables.commentsActivated;
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
        return "/upload/com.IcedReaper.blog/";
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
        if(variables.blogpostId == 0) {
            variables.blogpostId = new Query().setSQL("INSERT INTO IcedReaper_blog_blogpost
                                                                   (
                                                                       headline,
                                                                       description,
                                                                       link,
                                                                       story,
                                                                       released,
                                                                       releaseDate,
                                                                       commentsActivated,
                                                                       creatorUserId,
                                                                       lastEditorUserId,
                                                                       lastEditDate
                                                                   )
                                                            VALUES (
                                                                       :headline,
                                                                       :description,
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
                                              .addParam(name = "description",       value = variables.description,       cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "link",              value = variables.link,              cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "story",             value = variables.story,             cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "released",          value = variables.released,          cfsqltype = "cf_sql_bit")
                                              .addParam(name = "releaseDate",       value = variables.releaseDate,       cfsqltype = "cf_sql_date")
                                              .addParam(name = "commentsActivated", value = variables.commentsActivated, cfsqltype = "cf_sql_bit")
                                              .addParam(name = "creatorUserId",     value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                                              .addParam(name = "lastEditorUserId",  value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                                              .execute()
                                              .newBlogpostId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_blog_blogpost
                                       SET headline          = :headline,
                                           description       = :description,
                                           link              = :link,
                                           story             = :story,
                                           released          = :released,
                                           releaseDate       = :releaseDate,
                                           commentsActivated = :commentsActivated,
                                           lastEditorUserId  = :lastEditorUserId,
                                           lastEditDate      = now()
                                     WHERE blogpostId = :blogpostId")
                           .addParam(name = "blogpostId",        value = variables.blogpostId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "headline",          value = variables.headline,          cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",       value = variables.description,       cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",              value = variables.link,              cfsqltype = "cf_sql_varchar")
                           .addParam(name = "story",             value = variables.story,             cfsqltype = "cf_sql_varchar")
                           .addParam(name = "released",          value = variables.released,          cfsqltype = "cf_sql_bit")
                           .addParam(name = "releaseDate",       value = variables.releaseDate,       cfsqltype = "cf_sql_date")
                           .addParam(name = "commentsActivated", value = variables.commentsActivated, cfsqltype = "cf_sql_bit")
                           .addParam(name = "creatorUserId",     value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId",  value = request.user.getUserId(),    cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            if(variables.picturesChanged) {
                for(var p = 1; p <= variables.pictures.len(); p++) {
                    variables.pictures[p].save();
                }
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
    }
    
    // I N T E R N A L
    
    private void function loadDetails() {
        if(variables.blogpostId != 0 && variables.blogpostId != null) {
            var qGallery = new Query().setSQL("SELECT * 
                                                 FROM IcedReaper_blog_blogpost
                                                WHERE blogpostId = :blogpostId")
                                      .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qGallery.getRecordCount() == 1) {
                variables.headline          = qGallery.headline[1];
                variables.description       = qGallery.description[1];
                variables.link              = qGallery.link[1];
                variables.story             = qGallery.story[1];
                variables.released          = qGallery.released[1];
                variables.releaseDate       = qGallery.releaseDate[1];
                variables.commentsActivated = qGallery.commentsActivated[1];
                variables.creatorUserId     = qGallery.creatorUserId[1];
                variables.creationDate      = qGallery.creationDate[1];
                variables.lastEditorUserId  = qGallery.lastEditorUserId[1];
                variables.lastEditDate      = qGallery.lastEditDate[1];
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
            varibales.headline          = "";
            variables.description       = "";
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
                                                   FROM IcedReaper_blogpost_blogpostCategory
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
        
        var comments = [];
        for(var i = 1; i <= qCommentIds.getRecordCount(); i++) {
            comments.append(new comment(qCommentIds.commentId[i]));
        }
        
        return comments;
    }
}