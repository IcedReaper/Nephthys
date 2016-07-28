component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public status function init(required numeric statusId) {
        variables.statusId = arguments.statusId;
        
        variables.attributesChanged = false;
        
        variables.nextStatusLoaded = false;
        
        variables.nextStatusAdded = [];
        variables.nextStatusRemoved = [];
        
        loadDetails();
        
        return this;
    }
    
    public status function setName(required string name) {
        variables.name = arguments.name;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public status function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public status function setCanLogin(required boolean canLogin) {
        variables.canLogin = arguments.canLogin;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public status function setShowInTasklist(required boolean showInTasklist) {
        variables.showInTasklist = arguments.showInTasklist;
        variables.attributesChanged = true;
        
        return this;
    }
    
    public status function setLastEditor(required user lastEditor) {
        variables.lastEditor = arguments.lastEditor;
        variables.attributesChanged = true;
        
        return this;
    }
    
    
    public status function addNextStatus(required numeric nextStatusId) {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        var found = false;
        for(var nextStatus in variables.nextStatus) {
            if(nextStatus.getStatusId() == arguments.nextStatusId) {
                found = true;
                break;
            }
        }
        
        if(! found) {
            variables.nextStatus.append(new status(arguments.nextStatusId));
            variables.nextStatusAdded.append(arguments.nextStatusId);
            
            if(variables.nextStatusRemoved.delete(arguments.nextStatusId)) {
                // if the next status was previosly deleted and then readded again we don't have to do anything.
                variables.nextStatusAdded.delete(arguments.nextStatusId);
            }
        }
        
        return this;
    }
    
    public status function removeNextStatus(required numeric nextStatusId) {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        var found = false;
        var index = 0;
        for(var nextStatus in variables.nextStatus) {
            index++;
            if(nextStatus.getStatusId() == arguments.nextStatusId) {
                found = true;
                break;
            }
        }
        
        if(found && index != 0) {
            variables.nextStatus.deleteAt(index);
            variables.nextStatusRemoved.append(arguments.nextStatusId);
            
            if(variables.nextStatusAdded.delete(arguments.nextStatusId)) {
                // if the next status was previosly added and then removed we don't have to do anything.
                variables.nextStatusRemoved.delete(arguments.nextStatusId);
            }
        }
        
        return this;
    }
    
    
    public numeric function getStatusId() {
        return variables.statusId;
    }
    public string function getName() {
        return variables.name;
    }
    public numeric function getActiveStatus() {
        return variables.active;
    }
    public numeric function getCanLogin() {
        return variables.canLogin == 1;
    }
    public numeric function getLastEditorUserId() {
        return variables.lastEditor.getUserId();
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    
    public array function getNextStatus() {
        if(! variables.nextStatusLoaded) {
            loadNextStatus();
        }
        
        return variables.nextStatus;
    }
    
    public boolean function getEditable() {
        return variables.editable == 1;
    }
    public boolean function getDeleteable() {
        return variables.deleteable == 1;
    }
    public boolean function getShowInTasklist() {
        return variables.showInTasklist == 1;
    }
    public boolean function isActive() {
        return variables.active == 1;
    }
    
    public boolean function isOnline() {
        return variables.online == 1;
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
    
    
    public status function save() {
        transaction {
            var qUpdate = new Query().addParam(name = "name",           value = variables.name,                   cfsqltype = "cf_sql_varchar")
                                     .addParam(name = "active",         value = variables.active,                 cfsqltype = "cf_sql_bit")
                                     .addParam(name = "canLogin",       value = variables.canLogin,               cfsqltype = "cf_sql_bit")
                                     .addParam(name = "showInTasklist", value = variables.showInTasklist,         cfsqltype = "cf_sql_bit")
                                     .addParam(name = "creationUserId", value = variables.creator.getUserId(),    cfsqltype = "cf_sql_numeric")
                                     .addParam(name = "lastEditUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric");
            
            if(variables.statusId == 0 || variables.statusId == null) {
                variables.statusId = qUpdate.setSQL("INSERT INTO nephthys_user_status
                                                                     (
                                                                         name,
                                                                         active,
                                                                         canLogin,
                                                                         showInTasklist,
                                                                         creationUserId,
                                                                         lastEditUserId
                                                                     )
                                                              VALUES (
                                                                         :name,
                                                                         :active,
                                                                         :canLogin,
                                                                         :showInTasklist,
                                                                         :creationUserId,
                                                                         :lastEditUserId
                                                                     );
                                                         SELECT currval('nephthys_user_status_statusId_seq') newStatusId;")
                                                .execute()
                                                .getResult()
                                                .newStatusId[1];
            }
            else {
                if(variables.attributesChanged) {
                    qUpdate.setSQL("UPDATE nephthys_user_status
                                       SET name           = :name,
                                           active         = :active,
                                           canLogin       = :canLogin,
                                           showInTasklist = :showInTasklist,
                                           lastEditUserId = :lastEditUserId,
                                           lastEditDate   = now()
                                     WHERE statusId = :statusId")
                           .addParam(name = "statusId", value = variables.statusId,   cfsqltype = "cf_sql_numeric")
                           .execute();
                }
            }
            
            // update next status
            for(var nextStatusId in variables.nextStatusAdded) {
                new Query().setSQL("INSERT INTO nephthys_user_statusFlow
                                                (
                                                    statusId,
                                                    nextStatusId
                                                )
                                         VALUES (
                                                    :statusId,
                                                    :nextStatusId
                                                )")
                           .addParam(name = "statusId",     value = variables.statusId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "nextStatusId", value = nextStatusId,           cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            for(var removedStatusId in variables.nextStatusRemoved) {
                new Query().setSQL("DELETE FROM nephthys_user_statusFlow
                                          WHERE statusId     = :statusId
                                            AND nextStatusId = :nextStatusId")
                           .addParam(name = "statusId",     value = variables.statusId, cfsqltype = "cf_sql_numeric")
                           .addParam(name = "nextStatusId", value = removedStatusId,        cfsqltype = "cf_sql_numeric")
                           .execute();
            }
            
            variables.nextStatusAdded = [];
            variables.nextStatusRemoved = [];
            
            transactionCommit();
        }
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_user_status WHERE statusId = :statusId")
                   .addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.statusId = 0;
    }
    
    
    private void function loadDetails() {
        if(variables.statusId != 0 && variables.statusId != null) {
            var qStatus = new Query().setSQL("SELECT *
                                                    FROM nephthys_user_status
                                                   WHERE statusId = :statusId")
                                         .addParam(name="statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric")
                                         .execute()
                                         .getResult();
            
            if(qStatus.getRecordCount() == 1) {
                variables.name           = qStatus.name[1];
                variables.active         = qStatus.active[1];
                variables.canLogin       = qStatus.canLogin[1];
                variables.showInTasklist = qStatus.showInTasklist[1];
                variables.creator        = new user(qStatus.creationUserId[1]);
                variables.creationDate   = qStatus.creationDate[1];
                variables.lastEditor     = new user(qStatus.lastEditUserId[1]);
                variables.lastEditDate   = qStatus.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.general", message = "The user status could not be found", details = variables.statusId);
            }
        }
        else {
            variables.name           = "";
            variables.active         = false;
            variables.canLogin       = false;
            variables.showInTasklist = false;
            variables.creator        = request.user;
            variables.creationDate   = now();
            variables.lastEditor     = request.user;
            variables.lastEditDate   = now();
        }
    }
    
    private void function loadNextStatus() {
        variables.nextStatus = [];
        
        var qGetNextStatus = new Query().setSQL("SELECT nextStatusId
                                                   FROM nephthys_user_statusFlow
                                                  WHERE statusId = :statusId")
                                        .addParam(name = "statusId", value = variables.statusId, cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult();
        
        for(var i = 1; i <= qGetNextStatus.getRecordCount(); ++i) {
            variables.nextStatus.append(new status(qGetNextStatus.nextStatusId[i]));
        }
    }
}