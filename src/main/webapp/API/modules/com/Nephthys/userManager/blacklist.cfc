component {
    public blacklist function init(required numeric blacklistId) {
        variables.blacklistId = arguments.blacklistId;
        
        load();
        
        return this;
    }
    
    
    public blacklist function setNamepart(required string namepart) {
        variables.namepart = arguments.namepart;
        
        return this;
    }
    public blacklist function setCreator(required user creator) {
        if(variables.blacklistId == null) {
            variables.creator = arguments.creator;
        }
        
        return this;
    }
    public blacklist function setCreationDate(required date creationDate) {
        if(variables.blacklistId == null) {
            variables.creationDate = arguments.creationDate;
        }
        
        return this;
    }
    
    
    public numeric function getBlacklistId() {
        return variables.blacklistId;
    }
    public string function getNamepart() {
        return variables.namepart;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    
    
    public blacklist function save() {
        var qSave = new Query().addParam(name = "namepart",       value = variables.namepart,            cfsqltype = "cf_sql_varchar")
                               .addParam(name = "creationUserId", value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "creationDate",   value = variables.creationDate,        cfsqltype = "cf_sql_timestamp");
                                               
        if(variables.blacklistId == null || variables.blacklistId == 0) {
            variables.blacklistId = qSave.setSQL("INSERT INTO nephthys_user_blacklist
                                                              (
                                                                  namepart,
                                                                  creationUserId,
                                                                  creationDate
                                                              )
                                                       VALUES (
                                                                  :namepart,
                                                                  :creationUserId,
                                                                  :creationDate
                                                              );
                                                  SELECT currval('nephthys_user_blacklist_blacklistid_seq') newBlacklistId;")
                                         .execute()
                                         .getResult()
                                         .newBlacklistId[1];
        }
        else {
            qSave.setSQL("UPDATE nephthys_user_blacklist
                             SET namepart = :namepart
                           WHERE blacklistId = :blacklistId")
                 .addParam(name = "blacklistId", value = variables.blacklistId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_user_blacklist
                             WHERE blacklistId = :blacklistId")
                   .addParam(name = "blacklistId", value = variables.blacklistId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    private void function load() {
        if(variables.blacklistId != null && variables.blacklistId != 0) {
            var qBlacklist = new Query().setSQL("SELECT *
                                                   FROM nephthys_user_blacklist
                                                  WHERE blacklistId = :blacklistId")
                                        .addParam(name = "blacklistId", value = variables.blacklistId, cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult();
            
            if(qBlacklist.getRecordCount() == 1) {
                variables.namepart     = qBlacklist.namepart[1];
                variables.creator      = new user(qBlacklist.creationUserId[1]);
                variables.creationDate = qBlacklist.creationDate[1];
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find user blacklist by ID ", detail = variables.blacklistId);
            }
        }
        else {
            variables.namepart     = "";
            variables.creator      = request.user;
            variables.creationDate = now();
        }
    }
}