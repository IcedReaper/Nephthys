component {
    public picture function init(required numeric pictureId) {
        variables.pictureId = arguments.pictureId;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public picture function setGalleryId(required numeric galleryId) {
        if(variables.pictureId == 0 || variables.galleryId == arguments.galleryId) {
            variables.galleryId = arguments.galleryId;
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
    
    public picture function upload() {
        if(variables.pictureId != 0) {
            deleteFiles();
        }
        
        var gallery = new gallery(variables.galleryId);
        
        var uploaded = fileUpload(gallery.getAbsolutePath(), "picture", "image/*", "MakeUnique");
        var newFilename = uploaded.serverFile;
        
        if(uploaded.fileExisted) {
            var newFilename = createUUID() & "." & uploaded.serverFileExt;
            fileMove(uploaded.serverDirectory & "/" & uploaded.serverFile, uploaded.serverDirectory & "/" & newFilename);
        }
        
        var imageEditor = application.system.settings.getValueOfKey("imageEditLibrary");
        imageEditor.resize(gallery.getAbsolutePath() & "/" & newFilename, 575, gallery.getAbsolutePath() & "/tn_" & newFilename);
        
        variables.pictureFilename   = newFilename;
        variables.thumbnailFilename = "tn_" & newFilename;
        
        var exifReader = application.system.settings.getValueOfKey("exifReader");
        exifReader.setImagePath(gallery.getAbsolutePath() & "/" & variables.pictureFilename);
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
        
        save();
        
        return this;
    }
    
    // G E T T E R
    public numeric function getPictureId() {
        return variables.pictureId;
    }
    public numeric function getGalleryId() {
        return variables.galleryId;
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
    
    // C R U D
    public picture function save() {
        if(variables.pictureId == 0) {
            variables.pictureId = new Query().setSQL("INSERT INTO IcedReaper_gallery_picture
                                                                  (
                                                                      galleryId,
                                                                      pictureFileName,
                                                                      thumbnailFileName,
                                                                      title,
                                                                      alt,
                                                                      caption,
                                                                      sortId
                                                                  )
                                                           VALUES (
                                                                      :galleryId,
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
                                                                         FROM IcedReaper_gallery_picture
                                                                        WHERE galleryId = :galleryId)
                                                                  );
                                                      SELECT currval('seq_icedreaper_gallery_picture_id') newPictureId;")
                                             .addParam(name = "galleryId",         value = variables.galleryId,         cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "pictureFileName",   value = variables.pictureFileName,   cfsqltype = "cf_sql_varchar")
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
                new Query().setSQL("UPDATE IcedReaper_gallery_picture
                                       SET pictureFileName   = :pictureFileName,
                                           thumbnailFileName = :thumbnailFileName,
                                           title             = :title,
                                           alt               = :alt,
                                           caption           = :caption
                                     WHERE pictureId = :pictureId")
                           .addParam(name = "pictureId",         value = variables.pictureId,         cfsqltype = "cf_sql_numeric")
                           .addParam(name = "pictureFileName",   value = variables.pictureFileName,   cfsqltype = "cf_sql_varchar")
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
        
        new Query().setSQL("DELETE FROM IcedReaper_gallery_picture
                                  WHERE pictureId = :pictureId")
                   .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.pictureId = 0;
    }
    
    // I N T E R N A L
    private void function loadDetails() {
        if(variables.pictureId != 0 && variables.pictureId != null) {
            var qPicture = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_gallery_picture
                                                WHERE pictureId = :pictureId")
                                      .addParam(name = "pictureId", value = variables.pictureId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qPicture.getRecordCount() == 1) {
                variables.galleryId         = qPicture.galleryId[1];
                variables.pictureFileName   = qPicture.pictureFileName[1];
                variables.thumbnailFileName = qPicture.thumbnailFileName[1];
                variables.title             = qPicture.title[1];
                variables.alt               = qPicture.alt[1];
                variables.caption           = qPicture.caption[1];
            }
            else {
                throw(type = "pictureNotFound", message = "Could not find the imahe", detail = variables.pictureId);
            }
        }
        else {
            variables.galleryId         = 0;
            variables.pictureFileName   = "";
            variables.thumbnailFileName = "";
            variables.title             = "";
            variables.alt               = "";
            variables.caption           = "";
        }
    }
    
    private void function deleteFiles() {
        var gallery = new gallery(variables.galleryId);
        fileDelete(gallery.getAbsolutePath() & "/" & variables.pictureFilename);
        fileDelete(gallery.getAbsolutePath() & "/" & variables.thumbnailFilename);
    }
}