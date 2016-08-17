component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public type function init(required numeric typeId) {
        variables.typeId = arguments.typeId;
        
        loadDetails();
        
        return this;
    }
    
    public type function setName(required string name) {
        variables.name = arguments.name;
        
        return this;
    }
    
    
    public numeric function getTypeId() {
        return variables.typeId;
    }
    public string function getName() {
        return variables.name;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public date function getlastEditDate() {
        return variables.lastEditDate;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    
    public type function save(required user user) {
        var qSave = new Query().addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                               .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric");
        
        if(variables.typeId == null) {
            variables.typeId = qSave.setSQL("INSERT INTO IcedReaper_review_type
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
                                               SELECT currval('seq_icedreaper_review_type_id') newTypeId;")
                                    .addParam(name = "creatorUserId", value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult()
                                    .newTypeId[1];
            
            variables.creationDate = now();
            variables.lastEditDate = now();
        }
        else {
            qSave.setSQL("UPDATE IcedReaper_review_type
                             SET name             = :name,
                                 lastEditorUserId = :lastEditorUserId
                           WHERE typeId = :typeId")
                 .addParam(name = "typeId", value = variables.typeId, cfsqltype = "cf_sql_numeric")
                 .execute();
            
            variables.lastEditDate = now();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE
                              FROM IcedReaper_review_type
                             WHERE typeId = :typeId")
                   .addParam(name = "typeId", value = variables.typeId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    private void function loadDetails() {
        if(variables.typeId != null) {
            var qType = new Query().setSQL("SELECT *
                                               FROM IcedReaper_review_type
                                              WHERE typeId = :typeId")
                                    .addParam(name = "typeId", value = variables.typeId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qType.getRecordCount() == 1) {
                variables.name         = qType.name[1];
                variables.creator      = new user(qType.creatorUserId[1]);
                variables.creationDate = qType.creationDate[1];
                variables.lastEditor   = new user(qType.lastEditorUserId[1]);
                variables.lastEditDate = qType.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.review.notFound", message = "The type could not be found", detail = variables.typeId);
            }
        }
        else {
            variables.name         = "";
            variables.creator      = new user(null);
            variables.creationDate = now();
            variables.lastEditor   = new user(null);
            variables.lastEditDate = now();
        }
    }
}