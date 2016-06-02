component {
    public pageStatus function init(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        
        variables.nextStatusLoaded = false;
        
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
    
    public pageStatus function setEditable(required boolean editable) {
        variables.editable = arguments.editable;
        
        return this;
    }
    
    public pageStatus function setStartStatus(required boolean startStatus) {
        variables.startStatus = arguments.startStatus;
        
        return this;
    }
    
    
    public numeric function getPageStatusId() {
        return variables.pageStatusId;
    }
    
    public string function getName() {
        return variables.name;
    }
    
    public boolean function getActiveStatus() {
        return variables.active == 1;
    }
    
    public boolean function getOfflineStatus() {
        return variables.offline == 1;
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
    
    public boolean function isStartStatus() {
        return variables.startStatus == 1;
    }
    
    public boolean function isEndStatus() {
        return variables.endStatus == 1;
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
    
    public boolean function isEditable() {
        return variables.editable == 1;
    }
    
    public array function getNextStatus() {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        return variables.nextStatus;
    }
    
    public boolean function isOnline() {
        return variables.offline == 0;
    }
    
    
    public boolean function isApprovalValid(required numeric userId) {
        // TODO
        /*
            Check for required approvals
            if required approvals set
                if required approvals userId = arguments.userId
                     ok if user hasn't approved yet
            else
                ok if user hasn't approved yet
        */
        return true;
    }
    
    
    public pageStatus function save() {
        /*TODO
        if(variables.pageStatusId == 0 || variables.pageStatusId == null) {
            variables.pageStatusId = new Query().setSQL("INSERT INTO nephthys_pageStatus
                                                                     (
                                                                         name,
                                                                         active,
                                                                         offline,
                                                                         editable,
                                                                         creatorEditorUserId,
                                                                         creationEditDate,
                                                                         lastEditorUserId,
                                                                         lastEditDate
                                                                     )
                                                              VALUES (
                                                                         :name,
                                                                         :active,
                                                                         :offline,
                                                                         :editable,
                                                                         :creatorEditorUserId,
                                                                         now(),
                                                                         :lastEditorUserId,
                                                                         now()
                                                                     );
                                                   SELECT currval('seq_nephthys_pagestatus_id' :: regclass) newPageStatusId;")
                                               .addParam(name = "name",                value = variables.name,           cfsqltype = "cf_sql_varchar")
                                               .addParam(name = "active",              value = variables.active,         cfsqltype = "cf_sql_bit")
                                               .addParam(name = "offline",             value = variables.offline,        cfsqltype = "cf_sql_bit")
                                               .addParam(name = "editable",            value = variables.editable,       cfsqltype = "cf_sql_bit")
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
                                       editable         = :editable
                                       lastEditorUserId = :lastEditorUserId,
                                       lastEditDate     = now()
                                 WHERE pageStatusId = :pageStatusId")
                       .addParam(name = "pageStatusId",     value = variables.pageStatusId,   cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",           value = variables.active,         cfsqltype = "cf_sql_bit")
                       .addParam(name = "offline",          value = variables.offline,        cfsqltype = "cf_sql_bit")
                       .addParam(name = "editable",            value = variables.editable,       cfsqltype = "cf_sql_bit")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
        }*/
        
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
                variables.editable         = qPageStatus.editable[1];
                variables.startStatus      = qPageStatus.startStatus[1];
                variables.endStatus        = qPageStatus.endStatus[1];
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
            variables.editable         = true;
            variables.startStatus      = false;
            variables.endStatus        = false;
            variables.creatorUserId    = null;
            variables.creationDate     = null;
            variables.lastEditorUserId = null;
            variables.lastEditDate     = null;
        }
    }
    
    private void function loadNextStatus() {
        variables.nextStatus = [];
        
        var qGetNextStatus = new Query().setSQL("SELECT nextPageStatusId
                                                   FROM nephthys_pageStatusFlow
                                                  WHERE pageStatusId = :pageStatusId")
                                        .addParam(name = "pageStatusId", value = variables.pageStatusId, cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult();
        
        for(var i = 1; i <= qGetNextStatus.getRecordCount(); ++i) {
            variables.nextStatus.append(new pageStatus(qGetNextStatus.nextPageStatusId[i]));
        }
    }
}