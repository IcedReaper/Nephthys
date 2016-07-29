component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public gallery function init(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        variables.categoriesChanged = false;
        variables.picturesChanged   = false;
        
        loadDetails();
        
        return this;
    }
    
    
    public gallery function setHeadline(required string headline) {
        variables.headline = arguments.headline;
        
        return this;
    }
    public gallery function setDescription(required string description) {
        variables.description = arguments.description;
        
        return this;
    }
    public gallery function setTitle(required string title) {
        variables.title = arguments.title;
        
        return this;
    }
    public gallery function setLink(required string link) {
        variables.link = arguments.link;
        
        return this;
    }
    public gallery function setFolderName(required string folderName) {
        if(variables.galleryId == null) {
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
    public gallery function setIntroduction(required string introduction) {
        variables.introduction = arguments.introduction;
        
        return this;
    }
    public gallery function setStory(required string story) {
        variables.story = arguments.story;
        
        return this;
    }
    
    public gallery function addPicture(required picture _picture) {
        variables.pictures.append(duplicate(arguments._picture));
        
        variables.picturesChanged = true;
        
        return this;
    }
    public gallery function removePicture(required numeric pictureId, required user user) {
        for(var p = 1; p <= variables.pictures.len(); p++) {
            if(variables.pictures[p].getPictureId() == arguments.pictureId) {
                variables.pictures[p].delete(arguments.user);
                variables.pictures.deleteAt(p);
                
                break;
            }
        }
        
        return this;
    }
    public gallery function setPrivate(required boolean private) {
        variables.private = arguments.private;
        
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
        if(variables.galleryId != null) {
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
    
    public gallery function setStatus(required status newStatus) {
        variables.status = arguments.newStatus;
        return this;
    }
    
    
    public numeric function getGalleryId() {
        return variables.galleryId;
    }
    public string function getHeadline() {
        return variables.headline;
    }
    public string function getDescription() {
        return variables.description;
    }
    public string function getTitle() {
        return variables.title;
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
    public array function getPictures() {
        return variables.pictures;
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
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = new user(variables.lastEditorUserId);
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
            if(! variables.creatorUserId == arguments.userId) {
                return false;
            }
        }
        
        return variables.status.getEditable();
    }
    
    public string function getAbsolutePath() {
        return expandPath("/upload/com.IcedReaper.gallery/" & variables.folderName);
    }
    
    public status function getStatus() {
        return variables.status;
    }
    
    public gallery function pushToStatus(required status newStatus, required user user) {
        var actualStatus = duplicate(variables.status);
        
        var newStatusOK = false;
        for(var nextStatus in actualStatus.getNextStatus()) {
            if(nextStatus.getStatusId() == arguments.newStatus.getStatusId()) {
                newStatusOk = true;
            }
        }
        
        if(newStatusOk) {
            if(arguments.newStatus.isApprovalValid(arguments.user.getUserId())) {
                transaction {
                    setStatus(arguments.newStatus);
                    
                    new Query().setSQL("UPDATE IcedReaper_gallery_gallery
                                           SET statusId = :statusId
                                         WHERE galleryId = :galleryId")
                               .addParam(name = "galleryId", value = variables.galleryId,            cfsqltype = "cf_sql_numeric")
                               .addParam(name = "statusId",  value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric")
                               .execute();
                    
                    new approval(null).setGallery(this)
                                      .setPrevStatus(actualStatus)
                                      .setNewStatus(arguments.newStatus)
                                      .save(arguments.user);
                    
                    transactionCommit();
                }
                
                
                return this;
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You don't have the required permissions for this operation");
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The new status isn't allowed!");
        }
    }
    
    
    public gallery function save(required user user) {
        if(variables.galleryId == null) {
            variables.galleryId = new Query().setSQL("INSERT INTO IcedReaper_gallery_gallery
                                                                  (
                                                                      headline,
                                                                      description,
                                                                      title,
                                                                      link,
                                                                      folderName,
                                                                      introduction,
                                                                      story,
                                                                      private,
                                                                      statusId,
                                                                      creatorUserId,
                                                                      lastEditorUserId,
                                                                      lastEditDate
                                                                  )
                                                           VALUES (
                                                                      :headline,
                                                                      :description,
                                                                      :title,
                                                                      :link,
                                                                      :folderName,
                                                                      :introduction,
                                                                      :story,
                                                                      :private,
                                                                      :statusId,
                                                                      :creatorUserId,
                                                                      :lastEditorUserId,
                                                                      now()
                                                                  );
                                                      SELECT currval('seq_icedreaper_gallery_gallery_id') newGalleryId;")
                                             .addParam(name = "headline",         value = variables.headline,             cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "description",      value = variables.description,          cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "title",            value = variables.title,                cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "link",             value = variables.link,                 cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "folderName",       value = variables.folderName,           cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "introduction",     value = variables.introduction,         cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "story",            value = variables.story,                cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "private",          value = variables.private,              cfsqltype = "cf_sql_bit")
                                             .addParam(name = "statusId",         value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "creatorUserId",    value = request.user.getUserId(),       cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "lastEditorUserId", value = request.user.getUserId(),       cfsqltype = "cf_sql_numeric")
                                             .execute()
                                             .getResult()
                                             .newGalleryId[1];
        }
        else {
            if(variables.status.getEditable()) {
                new Query().setSQL("UPDATE IcedReaper_gallery_gallery
                                       SET headline         = :headline,
                                           description      = :description,
                                           title            = :title,
                                           link             = :link,
                                           folderName       = :folderName,
                                           introduction     = :introduction,
                                           story            = :story,
                                           private          = :private,
                                           statusId         = :statusId,
                                           lastEditorUserId = :lastEditorUserId,
                                           lastEditDate     = now()
                                     WHERE galleryId = :galleryId")
                           .addParam(name = "galleryId",        value = variables.galleryId,            cfsqltype = "cf_sql_numeric")
                           .addParam(name = "headline",         value = variables.headline,             cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",      value = variables.description,          cfsqltype = "cf_sql_varchar", null = variables.description == "")
                           .addParam(name = "title",            value = variables.title,                cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",             value = variables.link,                 cfsqltype = "cf_sql_varchar")
                           .addParam(name = "folderName",       value = variables.folderName,           cfsqltype = "cf_sql_varchar")
                           .addParam(name = "introduction",     value = variables.introduction,         cfsqltype = "cf_sql_varchar", null = variables.introduction == "")
                           .addParam(name = "story",            value = variables.story,                cfsqltype = "cf_sql_varchar", null = variables.story == "")
                           .addParam(name = "private",          value = variables.private,              cfsqltype = "cf_sql_bit")
                           .addParam(name = "statusId",         value = variables.status.getStatusId(), cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId", value = request.user.getUserId(),       cfsqltype = "cf_sql_numeric")
                           .execute();
                
                if(variables.picturesChanged) {
                    for(var p = 1; p <= variables.pictures.len(); p++) {
                        variables.pictures[p].save(arguments.user);
                    }
                }
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update the version that is online");
            }
        }
        
        if(variables.categoriesChanged) {
            for(var c = 1; c <= variables.categories.len(); c++) {
                try {
                    if(variables.categories[c].getCategoryId() == null) {
                        variables.categories[c].save(arguments.user);
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
        
        variables.categoriesChanged = false;
        variables.picturesChanged   = false;
        
        return this;
    }
    
    public void function delete(required user user) {
        directoryDelete(getAbsolutePath(), true);
        
        new Query().setSQL("DELETE
                              FROM IcedReaper_gallery_gallery
                             WHERE galleryId = :galleryId")
                   .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.galleryId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.galleryId != null) {
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
                variables.title            = qGallery.title[1];
                variables.story            = qGallery.story[1];
                variables.creatorUserId    = qGallery.creatorUserId[1];
                variables.creationDate     = qGallery.creationDate[1];
                variables.lastEditorUserId = qGallery.lastEditorUserId[1];
                variables.lastEditDate     = qGallery.lastEditDate[1];
                variables.pictures         = [];
                variables.categories       = [];
                variables.viewCounter      = qGallery.viewCounter[1];
                variables.private          = qGallery.private[1];
                variables.status           = new status(qGallery.statusId[1]);
                
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
            variables.title            = "";
            variables.story            = "";
            variables.creatorUserId    = request.user.getUserId();
            variables.creationDate     = now();
            variables.lastEditorUserId = request.user.getUserId();
            variables.lastEditDate     = now();
            variables.pictures         = [];
            variables.categories       = [];
            variables.viewCounter      = 0;
            variables.private          = false;
            variables.status           = new status(application.system.settings.getValueOfKey("com.IcedReaper.gallery.defaultStatus"));
        }
    }
    
    private void function loadPictures() {
        variables.pictures = new filter().for("picture")
                                         .setGalleryId(variables.galleryId)
                                         .execute()
                                         .getResult();
        
        variables.picturesChanged = false;
    }
    
    private void function loadCategories() {
        variables.categories = new filter().for("category")
                                           .setGalleryId(variables.galleryId)
                                           .execute()
                                           .getResult();
    }
}