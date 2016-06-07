component {
    import "API.modules.com.Nephthys.user.*";
    
    public hierarchy function init(required numeric hierarchyId) {
        variables.hierarchyId = arguments.hierarchyId;
        
        
        variables.statusChanged = false;
        
        variables.hierarchyPages = [];
        variables.pagesLoaded    = false;
        variables.pagesChanged   = false;
        variables.pagesAdded     = [];
        variables.pagesRemoved   = [];
        
        load();
        
        return this;
    }
    
    public hierarchy function setStatus(required status status) {
        variables.status = arguments.status;
        variables.statusChanged = true;
        return this;
    }
    
    public hierarchy function setVersion(required numeric version) {
        if(variables.hierarchyId == null) {
            variables.version = arguments.version;
        }
        return this;
    }
    
    public hierarchy function setCreator(required user creator) {
        if(variables.hierarchyId == null) {
            variables.creator = arguments.creator;
        }
        return this;
    }
    
    public hierarchy function setCreationDate(required date creationDate) {
        if(variables.hierarchyId == null) {
            variables.creationDate = arguments.creationDate;
        }
        return this;
    }
    
    public hierarchy function setLastEditor(required user lastEditor) {
        variables.lastEditor = arguments.lastEditor;
        return this;
    }
    
    public hierarchy function setLastEditDate(required date lastEditDate) {
        variables.lastEditDate = arguments.lastEditDate;
        return this;
    }
    
    
    public numeric function getHierarchyId() {
        return variables.hierarchyId;
    }
    
    public status function getStatus() {
        return variables.status;
    }
    
    public numeric function getversion() {
        return variables.version;
    }
    
    public user function getCreator() {
        return variables.creator;
    }
    
    public date function getCreationDate() {
        return variables.creationDate;
    }
    
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    // TODO: hierarchyPage opterations...
    
    public hierarchy function updatePagesByRegion(required array regions) {
         new query().setSQL("DELETE FROM nephthys_page_hierarchyPage
                                  WHERE hierarchyId = :hierarchyId")
                   .addParam(name = "hierarchyId", value = hierarchyId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        for(var region in arguments.regions) {
            saveHierarchyLevel(region.regionId, null, region.pages);
        }
        
        return this;
    }
    
    public hierarchy function pushToStatus(required status newStatus) {
        transaction {
            var actualStatus = duplicate(variables.status);
            
            variables.status = arguments.newStatus;
            
            if(variables.status.isOnline()) {
                var offlineStatus = new status(application.system.settings.getValueOfKey("endStatus"));
               
               var actualOnlineCtrl = new filter().setFor("hierarchy")
                                                  .setOnline(true)
                                                  .execute();
               
               if(actualOnlineCtrl.getResultCount() == 1) {
                   actualOnlineCtrl.getResult()[1].setStatus(offlineStatus)
                                                  .save();
                }
            }
            
            save();
            
            new approval(variables.hierarchyId).setFor("hierarchy")
                                               .approve(actualStatus.getStatusId(), variables.status.getStatusId(), request.user.getUserId());
            
            transactionCommit();
        }
        
        return this;
    }
    
    
    public hierarchy function save() {
        var qSave = new Query().addParam(name = "statusId",       value = variables.status.getStatusId(),   cfsqltype = "cf_sql_numeric")
                               .addParam(name = "version",        value = variables.version,                cfsqltype = "cf_sql_numeric")
                               .addParam(name = "lastEditUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "lastEditDate",   value = variables.lastEditDate,           cfsqltype = "cf_sql_timestamp");
        
        if(variables.hierarchyId == null) {
            variables.hierarchyId = qSave.setSQL("INSERT INTO nephthys_page_hierarchy
                                                              (
                                                                  statusId,
                                                                  version,
                                                                  creationUserId,
                                                                  creationDate,
                                                                  lastEditUserId,
                                                                  lastEditDate
                                                              )
                                                       VALUES (
                                                                  :statusId,
                                                                  :version,
                                                                  :creationUserId,
                                                                  :creationDate,
                                                                  :lastEditUserId,
                                                                  :lastEditDate
                                                              );
                                                  SELECT currval('nephthys_page_hierarchy_hierarchyId_seq') newHierarchyId;")
                                         .addParam(name = "creationUserId", value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                                         .addParam(name = "creationDate",   value = variables.creationDate,        cfsqltype = "cf_sql_timestamp")
                                         .execute()
                                         .getResult()
                                         .newHierarchyId[1];
        }
        else {
            qSave.setSQL("UPDATE nephthys_page_hierarchy
                             SET statusId       = :statusId,
                                 lastEditUserId = :lastEditUserId,
                                 lastEditDate   = :lastEditDate
                           WHERE hierarchyId = :hierarchyId")
                 .addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        if(variables.status.arePagesDeleteable()) {
            new Query().setSQL("DELETE FROM nephthys_page_hierarchy
                                      WHERE hierarchyId = :hierarchyId")
                       .addParam(name = "hierarchyId", variables = variables.hierarchyId, cfsqltype="cf_sql_numeric")
                       .execute();
        }
        else {
            throw(type = "nephthys.application.notAllowed", message="You cannot delete a hierarchy which status doesn't allow deletion.");
        }
    }
    
    private void function load() {
        if(variables.hierarchyId != null) {
            var qHierarchy = new Query().setSQL("SELECT *
                                                   FROM nephthys_page_hierarchy
                                                  WHERE hierarchyId = :hierarchyId")
                                        .addParam(name = "hierarchyId", value = variables.hierarchyId, cfsqltype = "cf_sql_numeric")
                                        .execute()
                                        .getResult();
            
            if(qHierarchy.getRecordCount() == 1) {
                variables.version      = qHierarchy.version[1];
                variables.status       = new status(qHierarchy.statusId[1]);
                variables.creator      = new user(qHierarchy.creationUserId[1]);
                variables.creationDate = qHierarchy.creationDate[1];
                variables.lastEditor   = new user(qHierarchy.lastEditUserId[1]);
                variables.lastEditDate = qHierarchy.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "Could not find the required hierarchy");
            }
        }
        else {
            variables.version      = getMaxVersion() + 1;
            variables.status       = new status(application.system.settings.getValueOfKey("startStatus"));
            variables.creator      = new user(request.user.getUserId());
            variables.creationDate = now();
            variables.lastEditor   = new user(request.user.getUserId());
            variables.lastEditDate = now();
        }
    }
    
    private numeric function getMaxVersion() {
        var qMaxVersion = new Query().setSQL("SELECT MAX(version) maxVersion
                                                FROM nephthys_page_hierarchy")
                                     .execute()
                                     .getResult();
        
        if(qMaxVersion.getRecordCount() == 1) {
            return qMaxVersion.maxVersion[1];
        }
        else {
            return 1;
        }
    }
    
    private void function loadPages() {
        variables.hierarchyPages = [];
    }
    
    private boolean function saveHierarchyLevel(required numeric regionId, required numeric parentPageId, required array pages) {
        for(var i = 1; i <= arguments.pages.len(); i++) {
            new Query().setSQL("INSERT INTO nephthys_page_hierarchyPage
                                            (
                                                hierarchyId,
                                                regionId,
                                                pageId,
                                                parentPageId,
                                                sortOrder
                                            )
                                     VALUES (
                                                :hierarchyId,
                                                :regionId,
                                                :pageId,
                                                :parentPageId,
                                                :sortOrder
                                            )")
                       .addParam(name = "hierarchyId",  value = variables.hierarchyId,     cfsqltype = "cf_sql_numeric")
                       .addParam(name = "regionId",     value = arguments.regionId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "pageId",       value = arguments.pages[i].pageId, cfsqltype = "cf_sql_numeric")
                       .addParam(name = "parentPageId", value = arguments.parentPageId,    cfsqltype = "cf_sql_numeric", null = arguments.parentPageId == null)
                       .addParam(name = "sortOrder",    value = i,                         cfsqltype = "cf_sql_numeric")
                       .execute();
            
            if(arguments.pages[i].pages.len() > 0) {
                saveHierarchyLevel(arguments.regionId, arguments.pages[i].pageId, arguments.pages[i].pages);
            }
        }
        
        return true;
    }
}