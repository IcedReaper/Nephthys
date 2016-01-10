component {
    public category function init(required numeric categoryId) {
        variables.categoryId = arguments.categoryId;
        
        variables.attributesChanged = false;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public category function setName(required string name) {
        variables.name = arguments.name;
        variables.attributesChanged = true;
        
        return this;
    }
    
    // G E T T E R
    public numeric function getCategoryId() {
        return variables.categoryId;
    }
    public string function getName() {
        return variables.name;
    }
    public numeric function getCreatorUserId() {
        return variables.creatorUserId;
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.creatorUserId);
        }
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate != null ? variables.creationDate : 0;
    }
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.lastEditorUserId);
        }
        return variables.lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate != null ? variables.lastEditDate : 0;
    }
    
    // C R U D
    public category function save() {
        if(variables.categoryId == 0) {
            variables.categoryId = new Query().setSQL("INSERT INTO IcedReaper_gallery_category
                                                                   (
                                                                       name,
                                                                       creatorUserId,
                                                                       lastEditorUserId
                                                                   )
                                                            VALUES (
                                                                       :name,
                                                                       :creatorUserId,
                                                                       :lastEditorUserId
                                                                   );
                                                      SELECT currval('seq_icedreaper_gallery_category_id' :: regclass) newCategoryId;")
                                              .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                                              .addParam(name = "creatorUserId",    value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                              .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                              .execute()
                                              .getResult()
                                              .newCategoryId[1];
        }
        else {
            if(variables.attributesChanged) {
                new Query().setSQL("UPDATE IcedReaper_gallery_category
                                       SET name             = :name,
                                           creatorUserId    = :creatorUserId,
                                           lastEditorUserId = :lastEditorUserId
                                     WHERE categoryId = :categoryId")
                           .addParam(name = "categoryId",       value = variables.categoryId,     cfsqltype = "cf_sql_numeric")
                           .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                           .addParam(name = "creatorUserId",    value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM IcedReaper_gallery_category
                                  WHERE categoryId = :categoryId")
                   .addParam(name = "categoryId",       value = variables.categoryId,     cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.categoryId = 0;
        
        return;
    }
    
    // P R I V A T E
    private void function loadDetails() {
        if(variables.categoryId != 0) {
            var qCategory = new Query().setSQL("SELECT *
                                                  FROM IcedReaper_gallery_category
                                                 WHERE categoryId = :categoryId")
                                       .addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult();
            
            if(qCategory.getRecordCount() == 1) {
                variables.name             = qCategory.name[1];
                variables.creatorUserId    = qCategory.creatorUserId[1];
                variables.creationDate     = qCategory.creationDate[1];
                variables.lastEditorUserId = qCategory.lastEditorUserId[1];
                variables.lastEditDate     = qCategory.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.gallery.notFound", message = "Could not find the category");
            }
        }
        else {
            variables.name             = "";
            variables.creatorUserId    = 0;
            variables.creationDate     = null;
            variables.lastEditorUserId = 0;
            variables.lastEditDate     = null;
        }
    }
}