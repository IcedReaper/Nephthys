component {
    public pageStatus function init(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        
        variables.attributesChanged = false;
        
        variables.nextStatusLoaded = false;
        
        variables.nextStatusAdded = [];
        variables.nextStatusRemoved = [];
        
        loadDetails();
        
        return this;
    }
    
    public pageStatus function setName(required string name) {
        variables.name = arguments.name;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setOfflineStatus(required boolean offline) {
        variables.offline = arguments.offline;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setEditable(required boolean editable) {
        variables.editable = arguments.editable;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setStartStatus(required boolean startStatus) {
        variables.startStatus = arguments.startStatus;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setEndStatus(required boolean endStatus) {
        variables.endStatus = arguments.endStatus;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public pageStatus function setDeleteable(required boolean deleteable) {
        variables.deleteable = arguments.deleteable;
        variables.attributesChanged = true;
        
        return this;
    }
    
    
    
    public pageStatus function addNextStatus(required numeric nextPageStatusId) {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        var found = false;
        for(var nextStatus in variables.nextStatus) {
            if(nextStatus.getPageStatusId() == arguments.nextPageStatusId) {
                found = true;
                break;
            }
        }
        
        if(! found) {
            variables.nextStatus.append(new pageStatus(arguments.nextPageStatusId));
            variables.nextStatusAdded.append(arguments.nextPageStatusId);
            
            if(variables.nextStatusRemoved.delete(arguments.nextPageStatusId)) {
                // if the next status was previosly deleted and then readded again we don't have to do anything.
                variables.nextStatusAdded.delete(arguments.nextPageStatusId);
            }
        }
        
        return this;
    }
    
    public pageStatus function removeNextStatus(required numeric nextPageStatusId) {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        var found = false;
        var index = 0;
        for(var nextStatus in variables.nextStatus) {
            index++;
            if(nextStatus.getPageStatusId() == arguments.nextPageStatusId) {
                found = true;
                break;
            }
        }
        
        if(found && index != 0) {
            variables.nextStatus.deleteAt(index);
            variables.nextStatusRemoved.append(arguments.nextPageStatusId);
            
            if(variables.nextStatusAdded.delete(arguments.nextPageStatusId)) {
                // if the next status was previosly added and then removed we don't have to do anything.
                variables.nextStatusRemoved.delete(arguments.nextPageStatusId);
            }
        }
        
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
    
    public boolean function isDeleteable() {
        return variables.deleteable == 1;
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
        transaction {
            var qUpdate = new Query().addParam(name = "name",        value = variables.name,           cfsqltype = "cf_sql_varchar")
                                     .addParam(name = "active",      value = variables.active,         cfsqltype = "cf_sql_bit")
                                     .addParam(name = "offline",     value = variables.offline,        cfsqltype = "cf_sql_bit")
                                     .addParam(name = "editable",    value = variables.editable,       cfsqltype = "cf_sql_bit")
                                     .addParam(name = "startStatus", value = variables.startStatus,    cfsqltype = "cf_sql_bit")
                                     .addParam(name = "endStatus",   value = variables.endStatus,      cfsqltype = "cf_sql_bit")
                                     .addParam(name = "deleteable",  value = variables.deleteable,     cfsqltype = "cf_sql_bit")
                                     .addParam(name = "userId",      value = request.user.getUserId(), cfsqltype = "cf_sql_numeric");
            
            if(variables.pageStatusId == 0 || variables.pageStatusId == null) {
                variables.pageStatusId = qUpdate.setSQL("INSERT INTO nephthys_pageStatus
                                                                     (
                                                                         name,
                                                                         active,
                                                                         offline,
                                                                         editable,
                                                                         startStatus,
                                                                         endStatus,
                                                                         deleteable,
                                                                         creatorUserId,
                                                                         lastEditorUserId
                                                                     )
                                                              VALUES (
                                                                         :name,
                                                                         :active,
                                                                         :offline,
                                                                         :editable,
                                                                         :startStatus,
                                                                         :endStatus,
                                                                         :deleteable,
                                                                         :userId,
                                                                         :userId
                                                                     );
                                                         SELECT currval('seq_nephthys_pagestatus_id' :: regclass) newPageStatusId;")
                                                .execute()
                                                .getResult()
                                                .newPageStatusId[1];
            }
            else {
                if(variables.attributesChanged) {
                    qUpdate.setSQL("UPDATE nephthys_pageStatus
                                       SET name             = :name,
                                           active           = :active,
                                           offline          = :offline,
                                           editable         = :editable,
                                           startStatus      = :startStatus,
                                           endStatus        = :endStatus,
                                           deleteable       = :deleteable,
                                           lastEditorUserId = :userId,
                                           lastEditDate     = now()
                                     WHERE pageStatusId = :pageStatusId")
                           .addParam(name = "pageStatusId", value = variables.pageStatusId,   cfsqltype = "cf_sql_numeric")
                           .execute();
                }
            }
            
            // update next status
            for(var nextStatusId in variables.nextStatusAdded) {
                new Query().setSQL("INSERT INTO nephthys_pageStatusFlow
                                                (
                                                    pageStatusId,
                                                    nextPageStatusId
                                                )
                                         VALUES (
                                                    :pageStatusId,
                                                    :nextPageStatusId
                                                )")
                           .addParam(name = "pageStatusId",     value = variables.pageStatusId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "nextPageStatusId", value = nextStatusId,           cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            for(var removedStatusId in variables.nextStatusRemoved) {
                new Query().setSQL("DELETE FROM nephthys_pageStatusFlow
                                           WHERE pageStatusId     = :pageStatusId
                                             AND nextPageStatusId = :nextPageStatusId")
                           .addParam(name = "pageStatusId",     value = variables.pageStatusId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "nextPageStatusId", value = removedStatusId,        cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            variables.nextStatusAdded = [];
            variables.nextStatusRemoved = [];
            
            transactionCommit();
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
                variables.editable         = qPageStatus.editable[1];
                variables.startStatus      = qPageStatus.startStatus[1];
                variables.endStatus        = qPageStatus.endStatus[1];
                variables.deleteable       = qPageStatus.deleteable[1];
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
            variables.deleteable       = false;
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