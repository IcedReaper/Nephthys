component {
    public gallery function init(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        variables.attributesChanged = false;
        variables.categoriesChanged = false;
        variables.picturesChanged   = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    
    public gallery function setHeadline(required string headline) {
        variables.headline = arguments.headline;
        variables.attributesChanged = true;
        
        return this;
    }
    public gallery function setDescription(required string description) {
        variables.description = arguments.description;
        variables.attributesChanged = true;
        
        return this;
    }
    public gallery function setLink(required string link) {
        variables.link = arguments.link;
        variables.attributesChanged = true;
        
        return this;
    }
    public gallery function setFolderName(required string folderName) {
        if(variables.galleryId == 0) {
            variables.folderName = arguments.folderName;
            
            if(variables.folderName == "") {
                variables.folderName = createUUID();
            }
            if(! directoryExists(getAbsolutePath())) {
                directoryCreate(getAbsolutePath());
            }
            else {
                throw(type = "nephthys.application.alreadyExists", message = "The Folder already exists!");
            }
            
            variables.attributesChanged = true;
            
            return this;
        }
        else {
            if(variables.folderName != arguments.folderName) {
                if(! directoryExists(getAbsolutePath())) {
                    var oldFolderName = variables.folderName;
                    
                    variables.folderName = arguments.folderName;
                    
                    directoryRename("/upload/com.IcedReaper.gallery/" & oldfolderName, "/upload/com.IcedReaper.gallery/" & variables.folderName);
                }
                else {
                    throw(type = "nephthys.application.alreadyExists", message = "The Folder already exists!");
                }
            }
        }
    }
    /*public gallery function setReleaseDate(required date releaseDate) {
        variables.releaseDate = arguments.releaseDate;
        variables.attributesChanged = true;
        
        return this;
    }*/
    public gallery function setActiveStatus(required numeric activeStatus) {
        variables.activeStatus = arguments.activeStatus;
        variables.attributesChanged = true;
        
        return this;
    }
    public gallery function setIntroduction(required string introduction) {
        variables.introduction = arguments.introduction;
        variables.attributesChanged = true;
        
        return this;
    }
    public gallery function setStory(required string story) {
        variables.story = arguments.story;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public gallery function addPicture(required picture _picture) {
        variables.pictures.append(duplicate(arguments._picture));
        
        variables.picturesChanged = true;
        
        return this;
    }
    public gallery function removePicture(required numeric pictureId) {
        for(var p = 1; p <= variables.pictures.len(); p++) {
            if(variables.pictures[p].getPictureId() == arguments.pictureId) {
                variables.pictures[p].delete();
                variables.pictures.deleteAt(p);
                
                break;
            }
        }
        
        return this;
    }
    public gallery function setPrivate(required boolean private) {
        variables.private = arguments.private;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public gallery function addCategory(required category _category) {
        variables.categories.append(duplicate(arguments._category));
        
        variables.categoriesChanged = true;
        
        return this;
    }
    public gallery function addCategoryById(required numeric categoryId) {
        variables.categories.append(new category(arguments.categoryId));
        
        variables.categoriesChanged = true;
        
        return this;
    }
    public gallery function removeCategory(required numeric categoryId) {
        for(var c = 1; c <= variables.categories.len(); c++) {
            if(variables.categories[c].getCategoryId() == arguments.categoryId) {
                new Query().setSQL("DELETE FROM IcedReaper_gallery_galleryCategory
                                         WHERE galleryId  = :galleryId
                                           AND categoryId = :categoryId")
                           .addParam(name = "galleryId",  value = variables.galleryId,  cfsqltype = "cf_sql_numeric")
                           .addParam(name = "categoryId", value = arguments.categoryId, cfsqltype = "cf_sql_numeric")
                           .execute();
                
                break;
            }
        }
        
        return this;
    }
    
    public gallery function reloadPictures() {
        if(variables.galleryId != 0) {
            loadPictures();
            return this;
        }
        else {
            throw(type  = "icedreaper.gallery.notFound", message = "The pictures can only be reloaded for existing galleries.");
        }
    }
    
    public gallery function incrementViewCounter() {
        variables.viewCounter = new Query().setSQL("UPDATE IcedReaper_gallery_gallery
                                                       SET viewCounter = viewCounter + 1
                                                     WHERE galleryId = :galleryId;
                                                    SELECT viewCounter
                                                      FROM IcedReaper_gallery_gallery
                                                     WHERE galleryId = :galleryId;")
                                           .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult()
                                           .viewCounter[1];
        
        return this;
    }
    
    // G E T T E R
    
    public numeric function getGalleryId() {
        return variables.galleryId;
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
    public string function getFolderName() {
        return variables.folderName;
    }
    public string function getIntroduction() {
        return variables.introduction;
    }
    public string function getStory() {
        return variables.story;
    }
    public boolean function getActiveStatus() {
        return variables.activeStatus == 1;
    }
    /*public date function getReleaseDate() {
        return variables.releaseDate;
    }*/
    public array function getPictures() {
        return variables.pictures;
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.creatorUserId);
        }
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.lastEditorUserId);
        }
        return variables.lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    public string function getRelativePath() {
        return "/upload/com.IcedReaper.gallery/" & variables.folderName;
    }
    public numeric function getPictureCount() {
        return variables.pictures.len();
    }
    public array function getCategories() {
        return variables.categories;
    }
    public numeric function getViewCounter() {
        return variables.viewCounter;
    }
    public boolean function getPrivate() {
        return variables.private == 1;
    }
    
    public boolean function isEditable(required numeric userId) {
        if(variables.private) {
            return variables.creatorUserId == arguments.userId;
        }
        else {
            return true;
        }
    }
    
    public string function getAbsolutePath() {
        return expandPath("/upload/com.IcedReaper.gallery/" & variables.folderName);
    }
    
    /*public boolean function isPublished() {
        return variables.releaseDate == null || variables.releaseDate < now();
    }*/
    
    // C R U D
    public gallery function save() {
        if(variables.galleryId == 0) {
            variables.galleryId = new Query().setSQL("INSERT INTO IcedReaper_gallery_gallery
                                                                  (
                                                                      headline,
                                                                      description,
                                                                      link,
                                                                      folderName,
                                                                      introduction,
                                                                      story,
                                                                      activeStatus,
                                                                      private,
                                                                      creatorUserId,
                                                                      lastEditorUserId,
                                                                      lastEditDate
                                                                  )
                                                           VALUES (
                                                                      :headline,
                                                                      :description,
                                                                      :link,
                                                                      :folderName,
                                                                      :introduction,
                                                                      :story,
                                                                      :activeStatus,
                                                                      :private,
                                                                      :creatorUserId,
                                                                      :lastEditorUserId,
                                                                      now()
                                                                  );
                                                      SELECT currval('seq_icedreaper_gallery_gallery_id') newGalleryId;")
                                             .addParam(name = "headline",         value = variables.headline,       cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "description",      value = variables.description,    cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "link",             value = variables.link,           cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "folderName",       value = variables.folderName,     cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "introduction",     value = variables.introduction,   cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "story",            value = variables.story,          cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "activeStatus",     value = variables.activeStatus,   cfsqltype = "cf_sql_bit")
                                             .addParam(name = "private",          value = variables.private,        cfsqltype = "cf_sql_bit")
                                             .addParam(name = "creatorUserId",    value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                             .execute()
                                             .newGalleryId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_gallery_gallery
                                       SET headline         = :headline,
                                           description      = :description,
                                           link             = :link,
                                           folderName       = :folderName,
                                           introduction     = :introduction,
                                           story            = :story,
                                           activeStatus     = :activeStatus,
                                           private          = :private,
                                           lastEditorUserId = :lastEditorUserId,
                                           lastEditDate     = now()
                                     WHERE galleryId = :galleryId")
                           .addParam(name = "galleryId",        value = variables.galleryId,      cfsqltype = "cf_sql_numeric")
                           .addParam(name = "headline",         value = variables.headline,       cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",      value = variables.description,    cfsqltype = "cf_sql_varchar", null = variables.description == "")
                           .addParam(name = "link",             value = variables.link,           cfsqltype = "cf_sql_varchar")
                           .addParam(name = "folderName",       value = variables.folderName,     cfsqltype = "cf_sql_varchar")
                           .addParam(name = "introduction",     value = variables.introduction,   cfsqltype = "cf_sql_varchar", null = variables.introduction == "")
                           .addParam(name = "story",            value = variables.story,          cfsqltype = "cf_sql_varchar", null = variables.story == "")
                           .addParam(name = "activeStatus",     value = variables.activeStatus,   cfsqltype = "cf_sql_bit")
                           .addParam(name = "private",          value = variables.private,        cfsqltype = "cf_sql_bit")
                           .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
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
                    
                    new Query().setSQL("INSERT INTO IcedReaper_gallery_galleryCategory
                                                    (
                                                        galleryId,
                                                        categoryId,
                                                        creatorUserId
                                                    )
                                             VALUES (
                                                        :galleryId,
                                                        :categoryId,
                                                        :creatorUserId
                                                    )")
                               .addParam(name = "galleryId",     value = variables.galleryId,                     cfsqltype = "cf_sql_numeric")
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
        variables.picturesChanged   = false;
        
        return this;
    }
    
    public void function delete() {
        directoryDelete(getAbsolutePath(), true);
        
        new Query().setSQL("DELETE
                              FROM IcedReaper_gallery_gallery
                             WHERE galleryId = :galleryId")
                   .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.galleryId = 0;
    }
    
    // I N T E R N A L
    
    private void function loadDetails() {
        if(variables.galleryId != 0 && variables.galleryId != null) {
            var qGallery = new Query().setSQL("SELECT * 
                                                 FROM IcedReaper_gallery_gallery
                                                WHERE galleryId = :galleryId")
                                      .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qGallery.getRecordCount() == 1) {
                variables.headline         = qGallery.headline[1];
                variables.description      = qGallery.description[1];
                variables.link             = qGallery.link[1];
                variables.folderName       = qGallery.folderName[1];
                variables.introduction     = qGallery.introduction[1];
                variables.story            = qGallery.story[1];
                //variables.releaseDate      = qGallery.releaseDate[1];
                variables.activeStatus     = qGallery.activeStatus[1];
                variables.creatorUserId    = qGallery.creatorUserId[1];
                variables.creationDate     = qGallery.creationDate[1];
                variables.lastEditorUserId = qGallery.lastEditorUserId[1];
                variables.lastEditDate     = qGallery.lastEditDate[1];
                variables.pictures         = [];
                variables.categories       = [];
                variables.viewCounter      = qGallery.viewCounter[1];
                variables.private          = qGallery.private[1];
                
                loadPictures();
                loadCategories();
            }
            else {
                throw(type = "icedreaper.gallery.notFound", message = "The Gallery could not be found", detail = variables.galleryId);
            }
        }
        else {
            variables.headline         = "";
            variables.description      = "";
            variables.link             = "";
            variables.folderName       = createUUID();
            variables.introduction     = "";
            variables.story            = "";
            //variables.releaseDate      = null;
            variables.activeStatus     = false;
            variables.creatorUserId    = null;
            variables.creationDate     = null;
            variables.lastEditorUserId = null;
            variables.lastEditDate     = null;
            variables.pictures         = [];
            variables.categories       = [];
            variables.viewCounter      = 0;
            variables.private          = false;
        }
    }
    
    private void function loadPictures() {
        var qImageIds = new Query().setSQL("  SELECT pictureId
                                                FROM IcedReaper_gallery_picture 
                                               WHERE galleryId = :galleryId
                                            ORDER BY sortId ASC")
                                   .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                                   .execute()
                                   .getResult();
        
        variables.pictures.clear();
        for(var i = 1; i <= qImageIds.getRecordCount(); i++) {
            variables.pictures.append(new picture(qImageIds.pictureId[i]));
        }
        
        variables.picturesChanged = false;
    }
    
    private void function loadCategories() {
        var qCategoryIds = new Query().setSQL("  SELECT categoryId
                                                   FROM IcedReaper_gallery_galleryCategory
                                                  WHERE galleryId = :galleryId
                                               ORDER BY creationDate ASC")
                                      .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
        
        variables.categories.clear();
        for(var i = 1; i <= qCategoryIds.getRecordCount(); i++) {
            variables.categories.append(new category(qCategoryIds.categoryId[i]));
        }
    }
}