component {
    // todo: adaptions
    public comment function init(required numeric commentId) {
        variables.commentId = arguments.commentId;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public comment function setBlogpostId(required numeric blogpostId) {
        if(variables.commentId == 0 || variables.blogpostId == arguments.blogpostId) {
            variables.blogpostId = arguments.blogpostId;
        }
        
        return this;
    }
    public comment function setParentCommentId(required numeric parentCommentId) {
        variables.parentCommentId = arguments.parentCommentId;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setComment(required string comment) {
        variables.comment = arguments.comment;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setPublished(required boolean published) {
        variables.published = arguments.published;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public comment function publish() {
        variables.published = true;
        variables.publishedUserId = request.user.getUserId();
        variables.publishedDate = now();
    }
    
    // G E T T E R
    public numeric function getCommentId() {
        return variables.commentId;
    }
    public numeric function getBlogpostId() {
        return variables.blogpostId;
    }
    public numeric function getParentCommentId() {
        return variables.parentCommentId;
    }
    public string function getComment() {
        return variables.comment;
    }
    public boolean function getPublished() {
        return variables.published;
    }
    public user function getPublishedUser() {
        return variables.publishedUser;
    }
    public date function getPublishedDate() {
        return variables.publishedDate;
    }
    
    // C R U D
    public comment function save() {
        if(variables.commentId == 0) {
            variables.commentId = new Query().setSQL("INSERT INTO IcedReaper_blog_comment
                                                                  (
                                                                      blogpostId,
                                                                      parentCommentId,
                                                                      comment,
                                                                      creatorUserId,
                                                                      published,
                                                                      publishedUserId,
                                                                      publishedDate
                                                                  )
                                                           VALUES (
                                                                      :blogpostId,
                                                                      :commentFileName,
                                                                      :thumbnailFileName,
                                                                      :title,
                                                                      :alt,
                                                                      :caption,
                                                                      (SELECT max(sortId)+1 newSortId FROM IcedReaper_blog_comment WHERE blogpostId = :blogpostId)
                                                                  );
                                                      SELECT currval('seq_icedreaper_blogpost_comment_id' :: regclass) newPictureId;")
                                             .addParam(name = "blogpostId",         value = variables.blogpostId,         cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "commentFileName",   value = variables.commentFileName,   cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "thumbnailFileName", value = variables.thumbnailFileName, cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "title",             value = variables.title,             cfsqltype = "cf_sql_varchar", null = variables.title == "")
                                             .addParam(name = "alt",               value = variables.alt,               cfsqltype = "cf_sql_varchar", null = variables.alt == "")
                                             .addParam(name = "caption",           value = variables.caption,           cfsqltype = "cf_sql_varchar", null = variables.caption == "")
                                             .execute()
                                             .getResult()
                                             .newPictureId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_blog_comment
                                       SET commentFileName   = :commentFileName,
                                           thumbnailFileName = :thumbnailFileName,
                                           title             = :title,
                                           alt               = :alt,
                                           caption           = :caption
                                     WHERE commentId = :commentId")
                           .addParam(name = "commentId",         value = variables.commentId,         cfsqltype = "cf_sql_numeric")
                           .addParam(name = "commentFileName",   value = variables.commentFileName,   cfsqltype = "cf_sql_varchar")
                           .addParam(name = "thumbnailFileName", value = variables.thumbnailFileName, cfsqltype = "cf_sql_varchar")
                           .addParam(name = "title",             value = variables.title,             cfsqltype = "cf_sql_varchar", null = variables.title == "")
                           .addParam(name = "alt",               value = variables.alt,               cfsqltype = "cf_sql_varchar", null = variables.alt == "")
                           .addParam(name = "caption",           value = variables.caption,           cfsqltype = "cf_sql_varchar", null = variables.caption == "")
                           .execute();
            }
        }
        
        variables.attributesChanged = false;
        
        return this;
    }
    
    public void function delete() {
        deleteFiles();
        
        new Query().setSQL("DELETE FROM IcedReaper_blogpost_comment
                                  WHERE commentId = :commentId")
                   .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.commentId = 0;
    }
    
    // I N T E R N A L
    private void function loadDetails() {
        if(variables.commentId != 0 && variables.commentId != null) {
            var qPicture = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_blogpost_comment
                                                WHERE commentId = :commentId")
                                      .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qPicture.getRecordCount() == 1) {
                variables.blogpostId         = qPicture.blogpostId[1];
                variables.commentFileName   = qPicture.commentFileName[1];
                variables.thumbnailFileName = qPicture.thumbnailFileName[1];
                variables.title             = qPicture.title[1];
                variables.alt               = qPicture.alt[1];
                variables.caption           = qPicture.caption[1];
            }
            else {
                throw(type = "commentNotFound", message = "Could not find the imahe", detail = variables.commentId);
            }
        }
        else {
            variables.blogpostId         = 0;
            variables.commentFileName   = "";
            variables.thumbnailFileName = "";
            variables.title             = "";
            variables.alt               = "";
            variables.caption           = "";
        }
    }
}