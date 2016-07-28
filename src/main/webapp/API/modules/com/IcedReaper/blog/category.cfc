component {
    import "API.modules.com.Nephthys.userManager.user";
    
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
    public user function getCreator() {
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate != null ? variables.creationDate : 0;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate != null ? variables.lastEditDate : 0;
    }
    
    
    public numeric function getUseCount() {
        return new filter().for("blogpost")
                           .setCategoryId(variables.categoryId)
                           .execute()
                           .getResultCount();
    }
    
    // C R U D
    public category function save(required user user) {
        var qSave = new Query().addParam(name = "name",             value = variables.name,                   cfsqltype = "cf_sql_varchar")
                               .addParam(name = "lastEditorUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric");
        
        if(variables.categoryId == null || variables.categoryId == 0) {
            variables.categoryId = qSave.setSQL("INSERT INTO IcedReaper_blog_category
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
                                                SELECT currval('seq_icedreaper_blog_category_id') newCategoryId;")
                                        .addParam(name = "creatorUserId", value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult()
                                        .newCategoryId[1];
        }
        else {
            if(variables.attributesChanged) {
                qSave.setSQL("UPDATE IcedReaper_blog_category
                                 SET name             = :name,
                                     lastEditorUserId = :lastEditorUserId
                               WHERE categoryId = :categoryId")
                     .addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric")
                     .execute();
            }
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE FROM IcedReaper_blog_category
                                  WHERE categoryId = :categoryId")
                   .addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.categoryId = null;
        
        return;
    }
    
    // P R I V A T E
    private void function loadDetails() {
        if(variables.categoryId != null && variables.categoryId != 0) {
            var qCategory = new Query().setSQL("SELECT *
                                                  FROM IcedReaper_blog_category
                                                 WHERE categoryId = :categoryId")
                                       .addParam(name = "categoryId", value = variables.categoryId, cfsqltype = "cf_sql_numeric")
                                       .execute()
                                       .getResult();
            
            if(qCategory.getRecordCount() == 1) {
                variables.name             = qCategory.name[1];
                variables.creator    = new user(qCategory.creatorUserId[1]);
                variables.creationDate     = qCategory.creationDate[1];
                variables.lastEditor = new user(qCategory.lastEditorUserId[1]);
                variables.lastEditDate     = qCategory.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.blog.notFound", message = "Could not find the category");
            }
        }
        else {
            variables.name         = "";
            variables.creator      = 0;
            variables.creationDate = request.user;
            variables.lastEditor   = 0;
            variables.lastEditDate = request.user;
        }
    }
}