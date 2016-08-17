component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public picture function init(required numeric pictureId, required blogpost blogpost) {
        variables.pictureId = arguments.pictureId;
        variables.blogpost = arguments.blogpost;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public picture function setBlogpost(required numeric blogpost) {
        if(variables.pictureId == null || variables.blogpost.getBlogpostId() == arguments.blogpost.getBlogpostId()) {
            variables.blogpostId = arguments.blogpost;
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
        if(variables.pictureId != null) {
            deleteFiles();
        }
        
        var uploaded = fileUpload(variables.blogpost.getAbsolutePath(), "picture", "image/*", "MakeUnique");
        var newFilename = uploaded.serverFile;
        
        if(uploaded.fileExisted) {
            var newFilename = createUUID() & "." & uploaded.serverFileExt;
            fileMove(uploaded.serverDirectory & "/" & uploaded.serverFile, uploaded.serverDirectory & "/" & newFilename);
        }
        
        var imageEditor = application.system.settings.getValueOfKey("imageEditLibrary");
        imageEditor.resize(source        = variables.blogpost.getAbsolutePath() & "/" & newFilename,
                           width         = 575,
                           target        = variables.blogpost.getAbsolutePath() & "/tn_" & newFilename,
                           interpolation = "bilinear");
        
        variables.pictureFilename   = newFilename;
        variables.thumbnailFilename = "tn_" & newFilename;
        
        var exifReader = application.system.settings.getValueOfKey("exifReader");
        exifReader.setImagePath(variables.blogpost.getAbsolutePath() & "/" & variables.pictureFilename);
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
    public blogpost function getBlogpost() {
        return variables.blogpost;
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
    public user function getCreator() {
        return duplicate(variables.creator);
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        return duplicate(variables.lastEditor);
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    
    public picture function save(required user user) {
        var qSave = new query().addParam(name = "pictureFileName",   value = variables.pictureFileName,    cfsqltype = "cf_sql_varchar")
                               .addParam(name = "thumbnailFileName", value = variables.thumbnailFileName,  cfsqltype = "cf_sql_varchar")
                               .addParam(name = "title",             value = left(variables.title, 250),   cfsqltype = "cf_sql_varchar", null = variables.title == "")
                               .addParam(name = "alt",               value = left(variables.alt, 250),     cfsqltype = "cf_sql_varchar", null = variables.alt == "")
                               .addParam(name = "caption",           value = left(variables.caption, 300), cfsqltype = "cf_sql_varchar", null = variables.caption == "")
                               .addParam(name = "userId",            value = arguments.user.getUserId(),   cfsqltype = "cf_sql_numeric");
        
        if(variables.pictureId == null) {
            variables.pictureId = qSave.setSQL("INSERT INTO IcedReaper_blog_picture
                                                            (
                                                                blogpostId,
                                                                pictureFileName,
                                                                thumbnailFileName,
                                                                title,
                                                                alt,
                                                                caption,
                                                                sortId,
                                                                creatorUserId,
                                                                lastEditorUserId
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
                                                                  WHERE blogpostId = :blogpostId),
                                                                :userId,
                                                                :userId
                                                            );
                                                SELECT currval('icedreaper_blog_picture_pictureid_seq') newPictureId;")
                                       .addParam(name = "blogpostId", value = variables.blogpost.getBlogpostId(), cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult()
                                       .newPictureId[1];
        }
        else {
            if(variables.attributesChanged) {
                qSave.setSQL("UPDATE IcedReaper_blog_picture
                                 SET pictureFileName   = :pictureFileName,
                                     thumbnailFileName = :thumbnailFileName,
                                     title             = :title,
                                     alt               = :alt,
                                     caption           = :caption,
                                     sortId            = :sortId,
                                     lastEditorUserId  = :userId
                               WHERE pictureId = :pictureId")
                     .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                     .addParam(name = "sortId",    value = variables.sortId,    cfsqltype = "cf_sql_numeric")
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
        
        variables.pictureId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.pictureId != null) {
            var qPicture = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_blog_picture
                                                WHERE pictureId = :pictureId")
                                      .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qPicture.getRecordCount() == 1) {
                variables.pictureFileName   = qPicture.pictureFileName[1];
                variables.thumbnailFileName = qPicture.thumbnailFileName[1];
                variables.title             = qPicture.title[1];
                variables.alt               = qPicture.alt[1];
                variables.caption           = qPicture.caption[1];
                variables.sortId            = qPicture.sortId[1];
                variables.creator           = new user(qPicture.creatorUserId[1]);
                variables.creationDate      = qPicture.creationDate[1];
                variables.lastEditor        = new user(qPicture.lastEditorUserId[1]);
                variables.lastEditDate      = qPicture.lastEditDate[1];
            }
            else {
                throw(type = "pictureNotFound", message = "Could not find the imahe", detail = variables.pictureId);
            }
        }
        else {
            variables.pictureFileName   = "";
            variables.thumbnailFileName = "";
            variables.title             = "";
            variables.alt               = "";
            variables.caption           = "";
            variables.sortId            = 0;
            variables.creator           = request.user;
            variables.creationDate      = now();
            variables.lastEditor        = request.user;
            variables.lastEditDate      = now();
        }
    }
    
    private void function deleteFiles() {
        fileDelete(variables.blogpost.getAbsolutePath() & "/" & variables.pictureFilename);
        fileDelete(variables.blogpost.getAbsolutePath() & "/" & variables.thumbnailFilename);
    }
}