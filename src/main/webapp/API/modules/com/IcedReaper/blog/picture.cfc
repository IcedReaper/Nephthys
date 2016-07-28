component {
    public picture function init(required numeric pictureId) {
        variables.pictureId = arguments.pictureId;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public picture function setBlogpostId(required numeric blogpostId) {
        if(variables.pictureId == 0 || variables.blogpostId == arguments.blogpostId) {
            variables.blogpostId = arguments.blogpostId;
        }
        
        return this;
    }
    
    public picture function setTitle(required string title) {
        variables.title = arguments.title;
        variables.attributesChanged = true;
        
        return this;
    }
    public picture function setAlt(required string alt) {
        variables.alt = arguments.alt;
        variables.attributesChanged = true;
        
        return this;
    }
    public picture function setCaption(required string caption) {
        variables.caption = arguments.caption;
        variables.attributesChanged = true;
        
        return this;
    }
    public picture function setSortId(required numeric sortId) {
        variables.sortId = arguments.sortId;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public picture function upload(required user user) {
        if(variables.pictureId != 0) {
            deleteFiles();
        }
        
        var blogpost = new blogpost(variables.blogpostId);
        
        var uploaded = fileUpload(blogpost.getAbsolutePath(), "picture", "image/*", "MakeUnique");
        var newFilename = uploaded.serverFile;
        
        if(uploaded.fileExisted) {
            var newFilename = createUUID() & "." & uploaded.serverFileExt;
            fileMove(uploaded.serverDirectory & "/" & uploaded.serverFile, uploaded.serverDirectory & "/" & newFilename);
        }
        
        var imageEditor = application.system.settings.getValueOfKey("imageEditLibrary");
        imageEditor.resize(source        = blogpost.getAbsolutePath() & "/" & newFilename,
                           width         = 575,
                           target        = blogpost.getAbsolutePath() & "/tn_" & newFilename,
                           interpolation = "bilinear");
        
        variables.pictureFilename   = newFilename;
        variables.thumbnailFilename = "tn_" & newFilename;
        
        var exifReader = application.system.settings.getValueOfKey("exifReader");
        exifReader.setImagePath(blogpost.getAbsolutePath() & "/" & variables.pictureFilename);
        var jpegComment      = exifReader.getExifKey("JPEG Comment");
        var imageDescription = exifReader.getExifKey("Image Description");
        var userComment      = exifReader.getExifKey("User Comment");
        
        if(variables.title == "") {
            if(jpegComment != "") {
                variables.title = jpegComment;
            }
            else {
                if(imageDescription != "") {
                    variables.title = imageDescription;
                }
                else {
                    variables.title = userComment;
                }
            }
        }
        if(variables.alt == "") {
            variables.alt = uploaded.serverFile;
            
            if(jpegComment != "") {
                variables.alt &= (variables.alt != "" ? " - " : "") & jpegComment;
            }
            else {
                if(imageDescription != "") {
                    variables.alt &= (variables.alt != "" ? " - " : "") & imageDescription;
                }
                else {
                    variables.alt &= (variables.alt != "" ? " - " : "") & userComment;
                }
            }
        }
        if(variables.caption == "") {
            if(jpegComment != "") {
                variables.caption = jpegComment;
            }
            if(imageDescription != "") {
                variables.caption &= (variables.caption != "" ? " - " : "") & imageDescription;
            }
            if(userComment != "") {
                variables.caption &= (variables.caption != "" ? " - " : "") & userComment;
            }
        }
        
        save(arguments.user);
        
        return this;
    }
    
    
    public numeric function getPictureId() {
        return variables.pictureId;
    }
    public numeric function getBlogpostId() {
        return variables.blogpostId;
    }
    public string function getPictureFileName() {
        return variables.pictureFileName;
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
    public numeric function getSortId() {
        return variables.sortId;
    }
    
    
    public picture function save(required user user) {
        if(variables.pictureId == 0) {
            variables.pictureId = new Query().setSQL("INSERT INTO IcedReaper_blog_picture
                                                                  (
                                                                      blogpostId,
                                                                      pictureFileName,
                                                                      thumbnailFileName,
                                                                      title,
                                                                      alt,
                                                                      caption,
                                                                      sortId
                                                                  )
                                                           VALUES (
                                                                      :blogpostId,
                                                                      :pictureFileName,
                                                                      :thumbnailFileName,
                                                                      :title,
                                                                      :alt,
                                                                      :caption,
                                                                      (SELECT CASE
                                                                                WHEN max(sortId) IS NOT NULL THEN
                                                                                  max(sortId)+1
                                                                                ELSE
                                                                                  1
                                                                              END newSortId
                                                                         FROM IcedReaper_blog_picture
                                                                        WHERE blogpostId = :blogpostId)
                                                                  );
                                                      SELECT currval('icedreaper_blog_picture_pictureid_seq') newPictureId;")
                                             .addParam(name = "blogpostId",        value = variables.blogpostId,         cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "pictureFileName",   value = variables.pictureFileName,    cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "thumbnailFileName", value = variables.thumbnailFileName,  cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "title",             value = left(variables.title, 250),   cfsqltype = "cf_sql_varchar", null = variables.title == "")
                                             .addParam(name = "alt",               value = left(variables.alt, 250),     cfsqltype = "cf_sql_varchar", null = variables.alt == "")
                                             .addParam(name = "caption",           value = left(variables.caption, 300), cfsqltype = "cf_sql_varchar", null = variables.caption == "")
                                             .execute()
                                             .getResult()
                                             .newPictureId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_blog_picture
                                       SET pictureFileName   = :pictureFileName,
                                           thumbnailFileName = :thumbnailFileName,
                                           title             = :title,
                                           alt               = :alt,
                                           caption           = :caption,
                                           sortId            = :sortId
                                     WHERE pictureId = :pictureId")
                           .addParam(name = "pictureId",         value = variables.pictureId,          cfsqltype = "cf_sql_numeric")
                           .addParam(name = "pictureFileName",   value = variables.pictureFileName,    cfsqltype = "cf_sql_varchar")
                           .addParam(name = "thumbnailFileName", value = variables.thumbnailFileName,  cfsqltype = "cf_sql_varchar")
                           .addParam(name = "title",             value = left(variables.title, 250),   cfsqltype = "cf_sql_varchar", null = variables.title == "")
                           .addParam(name = "alt",               value = left(variables.alt, 250),     cfsqltype = "cf_sql_varchar", null = variables.alt == "")
                           .addParam(name = "caption",           value = left(variables.caption, 300), cfsqltype = "cf_sql_varchar", null = variables.caption == "")
                           .addParam(name = "sortId",            value = variables.sortId,             cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        
        variables.attributesChanged = false;
        
        return this;
    }
    
    public void function delete(required user user) {
        deleteFiles();
        
        new Query().setSQL("DELETE FROM IcedReaper_blog_picture
                                  WHERE pictureId = :pictureId")
                   .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.pictureId = 0;
    }
    
    
    private void function loadDetails() {
        if(variables.pictureId != 0 && variables.pictureId != null) {
            var qPicture = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_blog_picture
                                                WHERE pictureId = :pictureId")
                                      .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qPicture.getRecordCount() == 1) {
                variables.blogpostId         = qPicture.blogpostId[1];
                variables.pictureFileName   = qPicture.pictureFileName[1];
                variables.thumbnailFileName = qPicture.thumbnailFileName[1];
                variables.title             = qPicture.title[1];
                variables.alt               = qPicture.alt[1];
                variables.caption           = qPicture.caption[1];
                variables.sortId            = qPicture.sortId[1];
            }
            else {
                throw(type = "pictureNotFound", message = "Could not find the imahe", detail = variables.pictureId);
            }
        }
        else {
            variables.blogpostId         = 0;
            variables.pictureFileName   = "";
            variables.thumbnailFileName = "";
            variables.title             = "";
            variables.alt               = "";
            variables.caption           = "";
            variables.sortId            = 0;
        }
    }
    
    private void function deleteFiles() {
        var blogpost = new blogpost(variables.blogpostId);
        fileDelete(blogpost.getAbsolutePath() & "/" & variables.pictureFilename);
        fileDelete(blogpost.getAbsolutePath() & "/" & variables.thumbnailFilename);
    }
}