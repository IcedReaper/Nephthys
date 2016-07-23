component {
    import "API.modules.com.Nephthys.userManager.*";
    
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
    public comment function setAnonymousUsername(required string username) {
        variables.anonymousUsername = arguments.username;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setAnonymousEmail(required string email) {
        variables.anonymousEmail = arguments.email;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setCreatorUserId(required numeric userId) {
        if(variables.commentId == 0) {
            variables.creatorUserId = arguments.userId;
        }
        
        return this;
    }
    
    public comment function publish() {
        variables.published       = true;
        variables.publishedUserId = request.user.getUserId();
        variables.publishedDate   = now();
        
        variables.attributesChanged = true;
        
        return this;
    }
    
    // G E T T E R
    public numeric function getCommentId() {
        return variables.commentId;
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
    public user function getCreatorUserId() {
        return variables.creatorUserId;
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = new user(variables.creatorUserId);
        }
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getPublisher() {
        if(! variables.keyExists("publishedUser")) {
            variables.publishedUser = new user(variables.publishedUserId);
        }
        return variables.publishedUser;
    }
    public user function getPublishedUserId() {
        return variables.publishedUserId;
    }
    public date function getPublishedDate() {
        return variables.publishedDate;
    }
    public string function getUsername() {
        if(variables.creatorUserId != 0 && variables.creatorUserId != null) {
            return getCreator().getUsername();
        }
        else {
            return variables.anonymousUsername;
        }
    }
    public boolean function fromRegistrated() {
        return variables.creatorUserId != 0 && variables.creatorUserId != null;
    }
    public string function getAnonymousUsername() {
        return variables.anonymousUsername;
    }
    public string function getAnonymousEmail() {
        return variables.anonymousEmail;
    }
    
    public boolean function isPublished() {
        return variables.published;
    }
    public boolean function isSaved() {
        return variables.commentId != 0 && variables.attributesChanged == false;
    }
    
    
    // C R U D
    public comment function save() {
        if(variables.commentId == 0) {
            variables.commentId = new Query().setSQL("INSERT INTO IcedReaper_blog_comment
                                                                  (
                                                                      blogpostId,
                                                                      comment,
                                                                      creatorUserId,
                                                                      anonymousUsername,
                                                                      anonymousEmail,
                                                                      published,
                                                                      publishedUserId,
                                                                      publishedDate
                                                                  )
                                                           VALUES (
                                                                      :blogpostId,
                                                                      :comment,
                                                                      :creatorUserId,
                                                                      :anonymousUsername,
                                                                      :anonymousEmail,
                                                                      :published,
                                                                      :publishedUserId,
                                                                      :publishedDate
                                                                  );
                                                      SELECT currval('seq_icedreaper_blog_comment_id') newPictureId;")
                                             .addParam(name = "blogpostId",        value = variables.blogpostId,        cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "comment",           value = variables.comment,           cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "creatorUserId",     value = variables.creatorUserId,     cfsqltype = "cf_sql_numeric", null = variables.creatorUserId == 0 || variables.creatorUserId == null)
                                             .addParam(name = "anonymousUsername", value = variables.anonymousUsername, cfsqltype = "cf_sql_varchar", null = variables.anonymousUsername == null)
                                             .addParam(name = "anonymousEmail",    value = variables.anonymousEmail,    cfsqltype = "cf_sql_varchar", null = variables.anonymousEmail == null)
                                             .addParam(name = "published",         value = variables.published,         cfsqltype = "cf_sql_bit")
                                             .addParam(name = "publishedUserId",   value = variables.publishedUserId,   cfsqltype = "cf_sql_numeric", null = variables.publishedUserId == 0 || variables.publishedUserId == null)
                                             .addParam(name = "publishedDate",     value = variables.publishedDate,     cfsqltype = "cf_sql_date",    null = variables.publishedDate == null)
                                             .execute()
                                             .getResult()
                                             .newPictureId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_blog_comment
                                       SET blogpostId        = :blogpostId,
                                           comment           = :comment,
                                           creatorUserId     = :creatorUserId,
                                           anonymousUsername = :anonymousUsername,
                                           anonymousEmail    = :anonymousEmail,
                                           published         = :published,
                                           publishedUserId   = :publishedUserId,
                                           publishedDate     = :publishedDate
                                     WHERE commentId         = :commentId")
                           .addParam(name = "commentId",         value = variables.commentId,         cfsqltype = "cf_sql_numeric")
                           .addParam(name = "blogpostId",        value = variables.blogpostId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "comment",           value = variables.comment,           cfsqltype = "cf_sql_varchar")
                           .addParam(name = "creatorUserId",     value = variables.creatorUserId,     cfsqltype = "cf_sql_numeric", null = variables.creatorUserId == 0 || variables.creatorUserId == null)
                           .addParam(name = "anonymousUsername", value = variables.anonymousUsername, cfsqltype = "cf_sql_varchar", null = variables.anonymousUsername == null)
                           .addParam(name = "anonymousEmail",    value = variables.anonymousEmail,    cfsqltype = "cf_sql_varchar", null = variables.anonymousEmail == null)
                           .addParam(name = "published",         value = variables.published,         cfsqltype = "cf_sql_bit")
                           .addParam(name = "publishedUserId",   value = variables.publishedUserId,   cfsqltype = "cf_sql_numeric", null = variables.publishedUserId == 0 || variables.publishedUserId == null)
                           .addParam(name = "publishedDate",     value = variables.publishedDate,     cfsqltype = "cf_sql_date",    null = variables.publishedDate == null)
                           .execute();
            }
        }
        
        variables.attributesChanged = false;
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM IcedReaper_blog_comment
                                  WHERE commentId = :commentId")
                   .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.commentId = 0;
    }
    
    // I N T E R N A L
    private void function loadDetails() {
        if(variables.commentId != 0 && variables.commentId != null) {
            var qComment = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_blog_comment
                                                WHERE commentId = :commentId")
                                      .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qComment.getRecordCount() == 1) {
                variables.blogpostId        = qComment.blogpostId[1];
                variables.comment           = qComment.comment[1];
                variables.creatorUserId     = qComment.creatorUserId[1];
                variables.creationDate      = qComment.creationDate[1];
                variables.anonymousUsername = qComment.anonymousUsername[1];
                variables.anonymousEmail    = qComment.anonymousEmail[1];
                variables.published         = qComment.published[1];
                variables.publishedUserId   = qComment.publishedUserId[1];
                variables.publishedDate     = qComment.publishedDate[1];
            }
            else {
                throw(type = "commentNotFound", message = "Could not find the imahe", detail = variables.commentId);
            }
        }
        else {
            variables.blogpostId        = 0;
            variables.comment           = "";
            variables.creatorUserId     = 0;
            variables.creationDate      = now();
            variables.anonymousUsername = "";
            variables.anonymousEmail    = "";
            variables.published         = false;
            variables.publishedUserId   = 0;
            variables.publishedDate     = null;
        }
    }
}