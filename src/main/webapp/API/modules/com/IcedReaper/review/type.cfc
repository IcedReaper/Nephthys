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
    public numeric function getCreatorUserId() {
        return variables.creatorUserId;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public numeric function getLastEditorUserId() {
        return variables.lastEditorUserId;
    }
    public date function getlastEditDate() {
        return variables.lastEditDate;
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = new user(variables.creatorUserId);
        }
        return variables.creator;
    }
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = new user(variables.creatorUserId);
        }
        return variables.lastEditor;
    }
    
    public type function save() {
        if(variables.typeId == null || variables.typeId == 0) {
            variables.typeId = new Query().setSQL("INSERT INTO IcedReaper_review_type
                                                                (
                                                                    name,
                                                                    creatorUserId,
                                                                    lastEditorUserId
                                                                )
                                                         VALUES (
                                                                    :name,
                                                                    :userId,
                                                                    :userId
                                                                );
                                                      SELECT currval('seq_icedreaper_review_type_id') newTypeId;")
                                           .addParam(name = "name",   value = variables.name,           cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "userId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult()
                                           .newTypeId[1];
            
            variables.creatorUserId    = request.user.getUserId();
            variables.lastEditorUserId = request.user.getUserId();
            variables.creationDate     = now();
            variables.lastEditDate     = now();
        }
        else {
            new Query().setSQL("UPDATE IcedReaper_review_type
                                   SET name = :name,
                                       lastEditorUserId = :lastEditorUserId,
                                       lastEditDate     = now()
                                 WHERE typeId = :typeId")
                       .addParam(name = "typeId",           value = variables.typeId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
            
            variables.lastEditorUserId = request.user.getUserId();
            variables.lastEditDate     = now();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE
                              FROM IcedReaper_review_type
                             WHERE typeId = :typeId")
                   .addParam(name = "typeId", value = variables.typeId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    private void function loadDetails() {
        if(variables.typeId != null && variables.typeId != 0) {
            var qType = new Query().setSQL("SELECT *
                                               FROM IcedReaper_review_type
                                              WHERE typeId = :typeId")
                                    .addParam(name = "typeId", value = variables.typeId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qType.getRecordCount() == 1) {
                variables.name             = qType.name[1];
                variables.creatorUserId    = qType.creatorUserId[1];
                variables.creationDate     = qType.creationDate[1];
                variables.lastEditorUserId = qType.lastEditorUserId[1];
                variables.lastEditDate     = qType.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.review.notFound", message = "The type could not be found", detail = variables.typeId);
            }
        }
        else {
            variables.name             = "";
            variables.creatorUserId    = null;
            variables.creationDate     = now();
            variables.lastEditorUserId = null;
            variables.lastEditDate     = now();
        }
    }
}