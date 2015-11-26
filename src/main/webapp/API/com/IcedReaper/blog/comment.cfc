component {
    public comment function init(required numeric commentId) {
        variables.commentId = arguments.commentId;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public comment function setGalleryId(required numeric blogpostId) {
        if(variables.commentId == 0 || variables.blogpostId == arguments.blogpostId) {
            variables.blogpostId = arguments.blogpostId;
        }
        
        return this;
    }
    
    public comment function setTitle(required string title) {
        variables.title = arguments.title;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setAlt(required string alt) {
        variables.alt = arguments.alt;
        variables.attributesChanged = true;
        
        return this;
    }
    public comment function setCaption(required string caption) {
        variables.caption = arguments.caption;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public comment function upload() {
        if(variables.picureId != 0) {
            deleteFiles();
        }
        
        var blogpost = createObject("component", "API.com.IcedReaper.blogpost.blogpost").init(variables.blogpostId);
        
        var uploaded = fileUpload(blogpost.getAbsolutePath(), "comment", "image/*", "MakeUnique");
        var newFilename = uploaded.serverFile;
        
        if(uploaded.fileExisted) {
            var newFilename = createUUID() & "." & uploaded.serverFileExt;
            fileMove(uploaded.serverDirectory & "/" & uploaded.serverFile, uploaded.serverDirectory & "/" & newFilename);
        }
        
        var imageFunctionCtrl = createObject("component", "API.com.Nephthys.controller.tools.imageFunctions");
        imageFunctionCtrl.resize(blogpost.getAbsolutePath() & "/" & newFilename, 575, blogpost.getAbsolutePath() & "/tn_" & newFilename);
        
        variables.commentFilename   = newFilename;
        variables.thumbnailFilename = "tn_" & newFilename;
        
        save();
    }
    
    // G E T T E R
    public numeric function getPictureId() {
        return variables.commentId;
    }
    public numeric function getGalleryId() {
        return variables.blogpostId;
    }
    public string function getPictureFileName() {
        return variables.commentFileName;
    }
    public string function getThumbnailFileName() {
        return variables.thumbnailFileName;
    }
    public string function getTitle() {
        return variables.title;
    }
    public string function getAlt() {
        return variables.alt;
    }
    public string function getCaption() {
        return variables.caption;
    }
    
    // C R U D
    public comment function save() {
        if(variables.commentId == 0) {
            variables.commentId = new Query().setSQL("INSERT INTO IcedReaper_blog_comment
                                                                  (
                                                                      blogpostId,
                                                                      commentFileName,
                                                                      thumbnailFileName,
                                                                      title,
                                                                      alt,
                                                                      caption,
                                                                      sortId
                                                                  )
                                                           VALUES (
                                                                      :blogpostId,
                                                                      :commentFileName,
                                                                      :thumbnailFileName,
                                                                      :title,
                                                                      :alt,
                                                                      :caption,
                                                                      (SELECT max(sortId)+1 newSortId FROM IcedReaper_blogpost_comment WHERE blogpostId = :blogpostId)
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
    
    private void function deleteFiles() {
        var blogpost = createObject("component", "API.com.IcedReaper.blogpost.blogpost").init(variables.blogpostId);
        fileDelete(blogpost.getAbsolutePath() & "/" & variables.commentFilename);
        fileDelete(blogpost.getAbsolutePath() & "/" & variables.thumbnailFilename);
    }
}