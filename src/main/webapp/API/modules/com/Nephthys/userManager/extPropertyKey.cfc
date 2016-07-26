component {
    public extPropertyKey function init(required numeric extPropertyKeyId = 0, required string keyName = "") {
        variables.extPropertyKeyId = arguments.extPropertyKeyId;
        variables.keyName = arguments.keyName;
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public extPropertyKey function setDescription(required string description) {
        variables.description = arguments.description;
        return this;
    }
    public extPropertyKey function setKeyName(required string keyName) {
        if(variables.extPropertyKeyId == 0 || variables.extPropertyKeyId == null) {
            variables.keyName = arguments.keyName;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The key of an extended property cannot be changed afterwards.");
        }
        return this;
    }
    public extPropertyKey function setType(required string type) {
        if(variables.extPropertyKeyId == 0 || variables.extPropertyKeyId == null) {
            variables.type = arguments.type;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The key of an extended property cannot be changed afterwards.");
        }
        return this;
    }
    
    // GETTER
    public numeric function getExtPropertyKeyId() {
        return variables.extPropertyKeyId;
    }
    public string function getKeyName() {
        return variables.keyName;
    }
    public string function getDescription() {
        return variables.description;
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
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    public string function getType() {
        return variables.type;
    }
    
    public user function getCreatorUser() {
        if(! variables.keyExists("creator")) {
            variables.creator = new user(variables.creatorUserId);
        }
        return creator;
    }
    public user function getLastEditorUser() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = new user(variables.lastEditorUserId);
        }
        return lastEditor;
    }
    
    // CRUD
    public extPropertyKey function save() {
        if((variables.extPropertyKeyId == 0 || variables.extPropertyKeyId == null) && (variables.keyName == "" || variables.keyName == null)) {
            variables.extPropertyKeyId = new Query().setSQL("INSERT INTO Nephthys_user_extPropertyKey
                                                                         (
                                                                             keyName,
                                                                             description,
                                                                             creatorUserId,
                                                                             lastEditorUserId,
                                                                             type
                                                                         )
                                                                  VALUES (
                                                                             :keyName,
                                                                             :description,
                                                                             :userId,
                                                                             :userId,
                                                                             :type
                                                                         )
                                                             SELECT currval('seq_nephthys_user_extPropertyKey_id') newId;")
                                                    .addParam(name = "keyName",     value = variables.keyName,        cfsqltype = "cf_sql_varchar")
                                                    .addParam(name = "description", value = variables.description,    cfsqltype = "cf_sql_varchar")
                                                    .addParam(name = "userId",      value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                                    .addParam(name = "type",        value = variables.type,           cfsqltype = "cf_sql_varchar")
                                                    .execute()
                                                    .getResult()
                                                    .newId[1];
        }
        else {
            new Query().setSQL("UPDATE Nephthys_user_extPropertyKey
                                   SET description      = :description,
                                       type             = :type,
                                       lastEditorUserId = :userId,
                                       lastEditDate     = now()
                                 WHERE extPropertyKeyId = :extPropertyKeyId ")
                      .addParam(name = "description",      value = variables.description,      cfsqltype = "cf_sql_varchar")
                      .addParam(name = "userId",           value = request.user.getUserId(),   cfsqltype = "cf_sql_numeric")
                      .addParam(name = "extPropertyKeyId", value = variables.extPropertyKeyId, cfsqltype = "cf_sql_numeric")
                      .addParam(name = "type",             value = variables.type,             cfsqltype = "cf_sql_varchar")
                      .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM Nephthys_user_extPropertyKey
                                  WHERE extPropertyKeyId = :extPropertyKeyId")
                   .addParam(name = "extPropertyKeyId", value = variables.extPropertyKeyId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    // PRIVATE
    private void function loadDetails() {
        if((variables.extPropertyKeyId == 0 || variables.extPropertyKeyId == null) && (variables.keyName == "" || variables.keyName == null)) {
            variables.description      = "";
            variables.creatorUserId    = null;
            variables.creationDate     = now();
            variables.lastEditorUserId = null;
            variables.lastEditDate     = now();
        }
        else {
            var qryGetExtPropertyKey = new Query();
            var sql = "SELECT *
                         FROM Nephthys_user_extPropertyKey
                        WHERE ";
            if(variables.extPropertyKeyId != 0 && variables.extPropertyKeyId != null) {
                sql&= "       extPropertyKeyId = :extPropertyKeyId ";
                qryGetExtPropertyKey.addParam(name = "extPropertyKeyId", value = variables.extPropertyKeyId, cfsqltype = "cf_sql_numeric");
            }
            else {
                sql&= "       keyName = :keyName ";
                qryGetExtPropertyKey.addParam(name = "keyName", value = variables.keyName, cfsqltype = "cf_sql_varchar");
            }
            
            var qExtPropertyKey = qryGetExtPropertyKey.setSQL(sql)
                                                      .execute()
                                                      .getResult();
            
            if(qExtPropertyKey.getRecordCount() == 1) {
                variables.extPropertyKeyId = qExtPropertyKey.extPropertyKeyId[1];
                variables.keyName          = qExtPropertyKey.keyName[1];
                variables.description      = qExtPropertyKey.description[1];
                variables.type             = qExtPropertyKey.type[1];
                variables.creatorUserId    = qExtPropertyKey.creatorUserId[1];
                variables.creationDate     = qExtPropertyKey.creationDate[1];
                variables.lastEditorUserId = qExtPropertyKey.lastEditorUserId[1];
                variables.lastEditDate     = qExtPropertyKey.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find the extended property key");
            }
        }
    }
}