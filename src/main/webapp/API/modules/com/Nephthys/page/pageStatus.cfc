component {
    public pageStatus function init(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        
        loadDetails();
        
        return this;
    }
    
    public pageStatus function setName(required string name) {
        variables.name = arguments.name;
        
        return this;
    }
    
    public pageStatus function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        
        return this;
    }
    
    public pageStatus function setOfflineStatus(required boolean offline) {
        variables.offline = arguments.offline;
        
        return this;
    }
    
    public numeric function getPageStatusId() {
        return variables.pageStatusId;
    }
    
    public string function getName() {
        return variables.name;
    }
    
    public boolean function getActiveStatus() {
        return variables.active;
    }
    
    public boolean function getOfflineStatus() {
        return variables.offline;
    }
    
    public numeric function getCreatorUserId() {
        return variables.creatorUserId;
    }
    
    public any function getCreationDate() {
        return variables.creationDate;
    }
    
    public numeric function getLastEditorUserId() {
        return variables.lastEditorUserId;
    }
    
    public any function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    public user function getCreator() {
        if(! vairables.keyExists("creator")) {
            variables.creator = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.creatorUserId);
        }
        return variables.creator;
    }
    
    public user function getLastEditor() {
        if(! vairables.keyExists("lastEditor")) {
            variables.lastEditor = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.lastEditorUserId);
        }
        return variables.lastEditor;
    }
    
    
    public pageStatus function save() {
        if(variables.pageStatusId == 0 || variables.pageStatusId == null) {
            variables.pageStatusId = new Query().setSQL("INSERT INTO nephthys_pageStatus
                                                                     (
                                                                         name,
                                                                         active,
                                                                         offline,
                                                                         creatorEditorUserId,
                                                                         creationEditDate,
                                                                         lastEditorUserId,
                                                                         lastEditDate
                                                                     )
                                                              VALUES (
                                                                         :name,
                                                                         :active,
                                                                         :offline,
                                                                         :creatorEditorUserId,
                                                                         now(),
                                                                         :lastEditorUserId,
                                                                         now()
                                                                     );
                                                   SELECT currval('seq_nephthys_pagestatus_id' :: regclass) newPageStatusId;")
                                               .addParam(name = "name",                value = variables.name,           cfsqltype = "cf_sql_varchar")
                                               .addParam(name = "active",              value = variables.active,         cfsqltype = "cf_sql_bit")
                                               .addParam(name = "offline",             value = variables.offline,        cfsqltype = "cf_sql_bit")
                                               .addParam(name = "creatorEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                               .addParam(name = "lastEditorUserId",    value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                               .execute()
                                               .getResult()
                                               .newPageStatusId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_pageStatus
                                   SET name             = :name,
                                       active           = :active,
                                       offline          = :offline,
                                       lastEditorUserId = :lastEditorUserId,
                                       lastEditDate     = now()
                                 WHERE pageStatusId = :pageStatusId")
                       .addParam(name = "pageStatusId",     value = variables.pageStatusId,   cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",           value = variables.active,         cfsqltype = "cf_sql_bit")
                       .addParam(name = "offline",          value = variables.offline,        cfsqltype = "cf_sql_bit")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_pageStatus WHERE pageStatusId = :pageStatusId")
                   .addParam(name = "pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.pageStatusId = 0;
    }
    
    
    private void function loadDetails() {
        if(variables.pageStatusId != 0 && variables.pageStatusId != null) {
            var qPageStatus = new Query().setSQL("SELECT *
                                                    FROM nephthys_pageStatus
                                                   WHERE pageStatusId = :pageStatusId")
                                         .addParam(name="pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric")
                                         .execute()
                                         .getResult();
            
            if(qPageStatus.getRecordCount() == 1) {
                variables.name             = qPageStatus.name[1];
                variables.active           = qPageStatus.active[1];
                variables.offline          = qPageStatus.offline[1];
                variables.creatorUserId    = qPageStatus.creatorUserId[1];
                variables.creationDate     = qPageStatus.creationDate[1];
                variables.lastEditorUserId = qPageStatus.lastEditorUserId[1];
                variables.lastEditDate     = qPageStatus.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.general", message = "The page status could not be found", details = variables.pageStatusId);
            }
        }
        else {
            variables.name             = "";
            variables.active           = false;
            variables.offline          = true;
            variables.creatorUserId    = null;
            variables.creationDate     = null;
            variables.lastEditorUserId = null;
            variables.lastEditDate     = null;
        }
    }
}