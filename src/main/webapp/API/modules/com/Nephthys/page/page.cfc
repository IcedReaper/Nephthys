component {
    import "API.modules.com.Nephthys.user.*";
    
    public page function init(required numeric pageId) {
        variables.pageId = arguments.pageId;
        variables.pageVersionsLoaded = false;
        
        load();
        
        return this;
    }
    
    public page function setCreator(required user user) {
        if(variables.pageId == 0 || variables.pageId == null || ! variables.creator.isActive()) {
            variables.creator = arguments.user;
        }
        return this;
    }
    
    public page function setCreatorById(required numeric userId) {
        if(variables.pageId == 0 || variables.pageId == null || ! variables.creator.isActive()) {
            variables.creator = new user(arguments.userId);
        }
        return this;
    }
    
    public page function setCreationDate(required date creationDate) {
        if(variables.pageId == 0 || variables.pageId == null) {
            variables.creationDate = arguments.creationDate;
        }
        return this;
    }
    
    
    public page function setActualVersion(required string version) {
        variables.actualVersion = arguments.version;
        return this;
    }
    
    public page function setPageStatusId(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        return this;
    }
    
    public page function addPageVersion(required pageVersion pageVersion) {
        if(! variables.pageVersions.keyExists(arguments.pageVersion.getVersion())) {
            variables.pageVersions[arguments.pageVersion.getVersion()] = arguments.pageVersion;
        }
        
        return this;
    }
    
    
    
    public numeric function getPageId() {
        return variables.pageId;
    }
    
    public user function getCreator() {
        return duplicate(variables.creator);
    }
    
    public date function getCreationDate() {
        return variables.creationDate;
    }
    
    public numeric function getPageStatusId() {
        return variables.pageStatusId;
    }
    
    public string function getActualVersion() {
        return variables.actualVersion;
    }
    
    public pageVersion function getActualPageVersion() {
        return variables.pageVersions[variables.actualVersion];
    }
    
    public pageVersion function getPageVersion(required string pageVersion) {
        if(! variables.pageVersionsLoaded) {
            loadPageVersions();
        }
        
        if(variables.pageVersions.keyExists(arguments.pageVersion)) {
            return variables.pageVersions[arguments.pageVersion];
        }
        else {
            throw(type = "nephthys.notFound.page", message = "The page version could not be found", details = arguments.pageVersion);
        }
    }
    
    public struct function getPageVersions() {
        if(! variables.pageVersionsLoaded) {
            loadPageVersions();
        }
        
        return duplicate(variables.pageVersions);
    }
    
    public string function getNextVersion() {
        // TODO
        return "1.1";
    }
    
    public boolean function versionExists(required string version) {
        if(! variables.pageVersionsLoaded) {
            loadPageVersions();
        }
        
        return variables.pageVersions.keyExists(arguments.version);
    }
    
    
    
    public page function save() {
        if(variables.pageId == 0) {
            variables.pageId = new Query().setSQL("INSERT INTO nephthys_page
                                                               (
                                                                   creatorUserIdv
                                                                   creationDate,
                                                                   actualVersion,
                                                                   pageStatusId
                                                               )
                                                        VALUES (
                                                                   :creatorUserId,
                                                                   :creationDate,
                                                                   :actualVersion,
                                                                   :pageStatusId
                                                               );
                                                   SELECT currval('seq_nephthys_page_id' :: regclass) newPageId;")
                                          .addParam(name = "creatorUserId", value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "creationDate",  value = variables.creationDate,        cfsqltype = "cf_sql_date")
                                          .addParam(name = "actualVersion", value = variables.actualVersion,       cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "pageStatusId",  value = variables.pageStatusId,        cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult()
                                          .newPageId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_page
                                   SET actualVersion = :actualVersion,
                                       pageStatusId  = :pageStatusId
                                 WHERE pageId = :pageId")
                       .addParam(name = "pageId",        value = variables.pageId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "actualVersion", value = variables.actualVersion, cfsqltype = "cf_sql_varchar")
                       .addParam(name = "pageStatusId",  value = variables.pageStatusId,  cfsqltype = "cf_sql_numeric")
                       .execute()
                       .getResult();
        }
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE
                              FROM nephthys_page
                             WHERE pageId = :pageId")
                   .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    
    private void function load() {
        if(variables.pageId != 0 && variables.pageId != null) {
            var qGetPage = new Query().setSQL("SELECT *
                                                 FROM nephthys_page
                                                WHERE pageId = :pageId")
                                      .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qGetPage.getRecordCount() == 1) {
                variables.creator       = new user(qGetPage.creatorUserId[1]);
                variables.creationDate  = qGetPage.creationDate[1];
                variables.actualVersion = qGetPage.actualVersion[1];
                variables.pageStatusId  = qGetPage.pageStatusId[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The page could not be found", details = variables.pageId);
            }
        }
        else {
            variables.creator       = new user(request.user.getUserId());
            variables.creationDate  = now();
            variables.actualVersion = "1.0";
            variables.pageStatusId  = getFirstStatusId();
        }
        
        variables.pageVersions[variables.actualVersion] = new pageVersion(pageId = variables.pageId, version = variables.actualVersion);
    }
    
    private numeric function getFirstStatusId() {
        // TODO: implement filter here...
        return new Query().setSQL("  SELECT pageStatusId
                                       FROM nephthys_pageStatus
                                   ORDER BY sortOrder ASC
                                      LIMIT 1")
                         .execute()
                         .getResult()
                         .pageStatusId[1];
    }
    
    private void function loadPageVersions() {
        // TODO: implement filter here to load versions
        variables.pageVersionsLoaded = true;
    }
}