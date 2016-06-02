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
    
    
    public page function setPageVersionId(required string pageVersionId) {
        variables.pageVersionId = arguments.pageVersionId;
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
    
    public numeric function getPageVersionId() {
        return variables.pageVersionId;
    }
    
    public string function getActualVersion() {
        if(variables.pageId != null && variables.pageId != 0) {
            var actualPageVersion = new pageVersion(variables.pageVersionId);
            return actualPageVersion.getMajorVersion() & "." & actualPageVersion.getMinorVersion();
        }
        else {
            return "1.0";
        }
    }
    
    public pageVersion function getActualPageVersion() {
        if(variables.pageId != null && variables.pageId != 0) {
            return new pageVersion(variables.pageVersionId);
        }
        else {
            return null;
        }
    }
    
    public pageVersion function getPageVersion(required numeric majorVersion, required numeric minorVersion) {
        if(variables.pageId != null && variables.pageId != 0) {
            if(! variables.pageVersionsLoaded) {
                loadPageVersions();
            }
            
            if(variables.pageVersions.keyExists(arguments.majorVersion)) {
                if(variables.pageVersions[arguments.majorVersion].keyExists(arguments.minorVersion)) {
                    return duplicate(variables.pageVersions[arguments.majorVersion][arguments.minorVersion]);
                }
            }
            
            throw(type = "nephthys.notFound.page", message = "The page version could not be found", details = arguments.pageVersion);
        }
        else {
            return null;
        }
    }
    
    public array function getPageVersions() {
        if(variables.pageId != null && variables.pageId != 0) {
            if(! variables.pageVersionsLoaded) {
                loadPageVersions();
            }
            
            var tmpPageVersions = [];
            for(var majorVersion in variables.pageVersions) {
                for(var minorVersion in variables.pageVersions[majorVersion]) {
                    tmpPageVersions.append(duplicate(variables.pageVersions[majorVersion][minorVersion]));
                }
            }
            
            return tmpPageVersions;
        }
        else {
            return [];
        }
    }
    
    public struct function getStructuredPageVersions() {
        if(variables.pageId != null && variables.pageId != 0) {
            if(! variables.pageVersionsLoaded) {
                loadPageVersions();
            }
            
            return duplicate(variables.pageVersions);
        }
        else {
            return {};
        }
    }
    
    public numeric function getNextMajorVersion() {
        // TODO
        return 0;
    }
    
    public numeric function getNextMinorVersion(required numeric majorVersion) {
        // TODO
        return 0;
    }
    
    public boolean function versionExists(required numeric majorVersion, required numeric minorVersion) {
        if(variables.pageId != null && variables.pageId != 0) {
            if(! variables.pageVersionsLoaded) {
                loadPageVersions();
            }
            
            return (variables.pageVersions.keyExists(arguments.majorVersion) && variables.pageVersions[arguments.majorVersion].keyExists(arguments.minorVersion));
        }
        else {
            return false;
        }
    }
    
    public numeric function getActualMajorVersion() {
        if(variables.pageId != null && variables.pageId != 0) {
            var actualPageVersion = new pageVersion(variables.pageVersionId);
            return actualPageVersion.getMajorVersion();
        }
        else {
            return 1;
        }
    }
    
    public numeric function getActualMinorVersion() {
        if(variables.pageId != null && variables.pageId != 0) {
            var actualPageVersion = new pageVersion(variables.pageVersionId);
            return actualPageVersion.getMinorVersion();
        }
        else {
            return 0;
        }
    }
    
    
    
    public page function save() {
        if(variables.pageId == 0) {
            variables.pageId = new Query().setSQL("INSERT INTO nephthys_page
                                                               (
                                                                   creatorUserId,
                                                                   pageStatusId
                                                               )
                                                        VALUES (
                                                                   :userId,
                                                                   :pageStatusId
                                                               );
                                                   SELECT currval('seq_nephthys_page_id' :: regclass) newPageId;")
                                          .addParam(name = "userId",       value = variables.creator.getUserId(), cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "pageStatusId", value = variables.pageStatusId,        cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult()
                                          .newPageId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_page
                                   SET pageVersionId = :pageVersionId,
                                       pageStatusId  = :pageStatusId
                                 WHERE pageId = :pageId")
                       .addParam(name = "pageId",        value = variables.pageId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
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
                variables.pageVersionId = qgetPage.pageVersionId[1];
                variables.pageStatusId  = qGetPage.pageStatusId[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The page could not be found", detail = variables.pageId);
            }
        }
        else {
            variables.creator       = new user(request.user.getUserId());
            variables.creationDate  = now();
            variables.pageVersionId = null;
            variables.pageStatusId  = getFirstStatusId();
        }
        
        variables.pageVersions = null;
    }
    
    private numeric function getFirstStatusId() {
        return new pageStatusFilter().setStartStatus(true)
                                     .execute()
                                     .getResult()[1].getPageStatusId();
    }
    
    private void function loadPageVersions() {
        variables.pageVersionsLoaded = true;
        variables.pageVersions = {};
        
        var qGetVersions = new Query().setSQL("SELECT pageVersionId, majorVersion, minorVersion
                                                 FROM nephthys_pageVersion
                                                WHERE pageId = :pageId
                                               ORDER BY majorVersion, minorVersion")
                                      .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
        
        for(var i = 1; i <= qGetVersions.getRecordCount(); ++i) {
            if(! variables.pageVersions.keyExists(qGetVersions.majorVersion[i])) {
                variables.pageVersions[ qGetVersions.majorVersion[i] ] = {};
            }
            
            variables.pageVersions[ qGetVersions.majorVersion[i] ][ qGetVersions.minorVersion[i] ] = new pageVersion(qGetVersions.pageVersionId[i]);
        }
    }
}