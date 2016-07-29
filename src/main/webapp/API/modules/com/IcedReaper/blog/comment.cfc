component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public comment function init(required numeric commentId, required blogpost blogpost) {
        variables.commentId = arguments.commentId;
        variables.blogpost  = arguments.blogpost;
        
        variables.attributesChanged = false;
        variables.publishedChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public comment function setComment(required string comment) {
        if(variables.commentId == null || (variables.creator.getStatus().getCanLogin() && variables.creator.getUserId() == request.user.getUserId())) {
            variables.comment = arguments.comment;
            variables.attributesChanged = true;
        }
        
        return this;
    }
    public comment function setAnonymousUsername(required string username) {
        if(variables.commentId == null) {
            variables.anonymousUsername = arguments.username;
            variables.attributesChanged = true;
        }
        
        return this;
    }
    public comment function setAnonymousEmail(required string email) {
        if(variables.commentId == null) {
            variables.anonymousEmail = arguments.email;
            variables.attributesChanged = true;
        }
        
        return this;
    }
    
    public comment function setPublished(required boolean published) {
        variables.published = arguments.published;
        variables.publishedChanged = true;
        
        return this;
    }
    
    
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
    public user function getCreator() {
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getPublisher() {
        return variables.publisher;
    }
    public date function getPublishedDate() {
        return variables.publishedDate;
    }
    public string function getUsername() {
        if(variables.creator.getUserId() != null) {
            return variables.creator.getUsername();
        }
        else {
            return variables.anonymousUsername;
        }
    }
    public boolean function fromRegistrated() {
        return variables.creator.getUserId() != null;
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
        return variables.commentId != null && variables.attributesChanged == false;
    }
    
    
    public comment function save(required user user) {
        var qSave = new Query();
                                             
        if(variables.commentId == null) {
            variables.commentId = qSave.setSQL("INSERT INTO IcedReaper_blog_comment
                                                            (
                                                                blogpostId,
                                                                comment,
                                                                creatorUserId,
                                                                anonymousUsername,
                                                                anonymousEmail
                                                            )
                                                     VALUES (
                                                                :blogpostId,
                                                                :comment,
                                                                :creatorUserId,
                                                                :anonymousUsername,
                                                                :anonymousEmail
                                                            );
                                                SELECT currval('seq_icedreaper_blog_comment_id') newPictureId;")
                                       .addParam(name = "blogpostId",        value = variables.blogpost.getBlogpostId(), cfsqltype = "cf_sql_numeric")
                                       .addParam(name = "comment",           value = variables.comment,                  cfsqltype = "cf_sql_varchar")
                                       .addParam(name = "anonymousUsername", value = variables.anonymousUsername,        cfsqltype = "cf_sql_varchar", null = variables.anonymousUsername == null)
                                       .addParam(name = "anonymousEmail",    value = variables.anonymousEmail,           cfsqltype = "cf_sql_varchar", null = variables.anonymousEmail == null)
                                       .addParam(name = "creatorUserId",     value = arguments.user.getUserId(),         cfsqltype = "cf_sql_numeric", null = arguments.user.getUserId() == null)
                                       .execute()
                                       .getResult()
                                       .newPictureId[1];
            
            variables.creator = arguments.user;
            variables.creationDate = now();
        }
        else {
            if(variables.attributesChanged) {
                qSave.setSQL("UPDATE IcedReaper_blog_comment
                                 SET comment   = :comment
                               WHERE commentId = :commentId")
                     .addParam(name = "comment",   value = variables.comment,   cfsqltype = "cf_sql_varchar")
                     .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                     .execute();
            }
            
            if(variables.publisheDChanged) {
                qSave.setSQL("UPDATE IcedReaper_blog_comment
                                 SET published       = :published,
                                     publisherUserId = :publisherUserId,
                                     publishedDate   = now()
                               WHERE commentId       = :commentId")
                     .addParam(name = "commentId",       value = variables.commentId,        cfsqltype = "cf_sql_numeric")
                     .addParam(name = "published",       value = variables.published,        cfsqltype = "cf_sql_bit")
                     .addParam(name = "publisherUserId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric", null = arguments.user.getUserId() == null)
                     .execute();
                
                variables.publisher = arguments.user;
                variables.publishedDate = now();
                
                variables.publisheDChanged = false;
            }
        }
        
        variables.attributesChanged = false;
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE FROM IcedReaper_blog_comment
                                  WHERE commentId = :commentId")
                   .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.commentId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.commentId != null) {
            var qComment = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_blog_comment
                                                WHERE commentId = :commentId")
                                      .addParam(name = "commentId", value = variables.commentId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qComment.getRecordCount() == 1) {
                variables.comment           = qComment.comment[1];
                variables.creator           = new user(qComment.creatorUserId[1]);
                variables.creationDate      = qComment.creationDate[1];
                variables.anonymousUsername = qComment.anonymousUsername[1];
                variables.anonymousEmail    = qComment.anonymousEmail[1];
                variables.published         = qComment.published[1];
                variables.publisher         = new user(qComment.publisherUserId[1]);
                variables.publishedDate     = qComment.publishedDate[1];
            }
            else {
                throw(type = "commentNotFound", message = "Could not find the imahe", detail = variables.commentId);
            }
        }
        else {
            variables.comment           = "";
            variables.creatorUserId     = new user(null);
            variables.creationDate      = now();
            variables.anonymousUsername = "";
            variables.anonymousEmail    = "";
            variables.published         = false;
            variables.publisherUserId   = new user(null);
            variables.publishedDate     = null;
        }
    }
}