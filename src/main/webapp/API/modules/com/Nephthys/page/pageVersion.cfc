component {
    import "API.modules.com.Nephthys.user.*";
    
    public pageVersion function init(required numeric pageVersionId = null, required numeric pageId = null, required string version = null) {
        variables.pageVersionId = arguments.pageVersionId;
        variables.pageId        = arguments.pageId;
        variables.version       = trim(arguments.version);
        
        load();
        
        return this;
    }
    
    public pageVersion function setPageId(required numeric pageId) {
        if(isNewEntry()) {
            variables.pageId = arguments.pageId;
        }
        return this;
    }
    public pageVersion function setParentPageId(required numeric parentPageId) {
        variables.parentPageId = arguments.parentPageId;
        return this;
    }
    public pageVersion function setPrevPageVersionId(required numeric prevPageVersionId) {
        if(isNewEntry()) {
            variables.prevPageVersionId = arguments.prevPageVersionId;
        }
        return this;
    }
    public pageVersion function setNextPageVersionId(required numeric nextPageVersionId) {
        variables.nextPageVersionId = arguments.nextPageVersionId;
        return this;
    }
    public pageVersion function setMajorVersion(required string majorVersion) {
        variables.majorVersion = arguments.majorVersion;
        return this;
    }
    public pageVersion function setMinorVersion(required string minorVersion) {
        variables.minorVersion = arguments.minorVersion;
        return this;
    }
    public pageVersion function setLinktext(required string linktext) {
        variables.linktext = arguments.linktext;
        return this;
    }
    public pageVersion function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public pageVersion function setTitle(required string title) {
        variables.title = arguments.title;
        return this;
    }
    public pageVersion function setDescription(required string description) {
        variables.description = arguments.description;
        return this;
    }
    public pageVersion function setContent(required array content) {
        variables.content = arguments.content;
        return this;
    }
    public pageVersion function setContentAsJSON(required string content) {
        variables.content = deserializeJSON(arguments.content);
        return this;
    }
    public pageVersion function setSortOrder(required numeric sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        return this;
    }
    public pageVersion function setUseDynamicSuffixes(required boolean useDynamicSuffixes) {
        variables.useDynamicSuffixes = arguments.useDynamicSuffixes;
        return this;
    }
    public pageVersion function setPageStatusId(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        return this;
    }
    public pageVersion function setRegion(required string region) {
        variables.region = arguments.region;
        return this;
    }
    public pageVersion function setCreator(required user creator) {
        variables.creator = duplicate(arguments.creator);
        return this;
    }
    public pageVersion function setCreatorById(required numeric userId) {
        variables.creator = new user(arguments.userId);
        return this;
    }
    public pageVersion function setCreationDate(required date creationDate) {
        variables.creationDate = arguments.creationDate;
        return this;
    }
    public pageVersion function setLastEditor(required user lastEditor) {
        variables.lastEditor = arguments.lastEditor;
        return this;
    }
    public pageVersion function setLastEditorById(required numeric userId) {
        variables.lastEditor = new user(arguments.userId);
        return this;
    }
    public pageVersion function setLastEditDate(required date lastEditDate) {
        variables.lastEditDate = arguments.lastEditDate;
        return this;
    }
    
    
    
    public numeric function getPageVersionId() {
        return variables.pageVersionId;
    }
    public numeric function getPageId() {
        return variables.pageId;
    }
    public numeric function getParentPageId() {
        return variables.parentPageId;
    }
    public numeric function getPrevPageVersionId() {
        return variables.prevPageVersionId;
    }
    public numeric function getNextPageVersionId() {
        return variables.nextPageVersionId;
    }
    public string function getMajorVersion() {
        return variables.majorVersion;
    }
    public string function getMinorVersion() {
        return variables.minorVersion;
    }
    public string function getLinktext() {
        return variables.linktext;
    }
    public string function getLink() {
        return variables.link;
    }
    public string function getTitle() {
        return variables.title;
    }
    public string function getDescription() {
        return variables.description;
    }
    public array function getContent() {
        return variables.content;
    }
    public string function getContentAsJSON() {
        return serializeJSON(variables.content);
    }
    public string function getSortOrder() {
        return variables.sortOrder;
    }
    public boolean function getUseDynamicSuffixes() {
        return variables.useDynamicSuffixes;
    }
    public numeric function getPageStatusId() {
        return variables.pageStatusId;
    }
    public string function getRegion() {
        return variables.region;
    }
    public user function getCreator() {
        return duplicate(variables.creator);
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        return duplicate(variables.lastEditor);
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    public boolean function isOnline() {
        return ! new pageStatus(variables.pageStatusId).getOfflineStatus();
    }
    
    public page function getParentPage() {
        return new page(variables.parentPageId);
    }
    
    public pageStatus function getPageStatus() {
        return new pageStatus(variables.pageStatusId);
    }
    
    
    public pageVersion function save() {
        if(isNewEntry()) {
            variables.pageVersionId = new Query().setSQL("INSERT INTO nephthys_pageVersion
                                                                      (
                                                                          pageId,
                                                                          parentPageId,
                                                                          prevPageVersionId,
                                                                          nextPageVersionId,
                                                                          majorVersion,
                                                                          minorVersion,
                                                                          linktext,
                                                                          link,
                                                                          title,
                                                                          description,
                                                                          content,
                                                                          sortOrder,
                                                                          useDynamicSuffixes,
                                                                          pageStatusId,
                                                                          region,
                                                                          creator,
                                                                          creationDate,
                                                                          lastEditor,
                                                                          lastEditDate
                                                                      )
                                                               VALUES (
                                                                          :pageId,
                                                                          :parentPageId,
                                                                          :prevPageVersionId,
                                                                          :nextPageVersionId,
                                                                          :version,
                                                                          :linktext,
                                                                          :link,
                                                                          :title,
                                                                          :description,
                                                                          :content,
                                                                          :sortOrder,
                                                                          :useDynamicSuffixes,
                                                                          :pageStatusId,
                                                                          :region,
                                                                          :creatorUserId,
                                                                          :creationDate,
                                                                          :lastEditorUserId,
                                                                          :lastEditDate
                                                                      );
                                                          SELECT currval('seq_nephthys_pageVersion_id' :: regclass) newPageVersionId;")
                                                 .addParam(name = "pageId",             value = variables.pageId,                   cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "parentPageId",       value = variables.parentPageId,             cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "prevPageVersionId",  value = variables.prevPageVersionId,        cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "nextPageVersionId",  value = variables.nextPageVersionId,        cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "majorVersion",       value = variables.majorVersion,             cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "minorVersion",       value = variables.minorVersion,             cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "linktext",           value = variables.linktext,                 cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "link",               value = variables.link,                     cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "title",              value = variables.title,                    cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "description",        value = variables.description,              cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "content",            value = deserializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "sortOrder",          value = variables.sortOrder,                cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes,       cfsqltype = "cf_sql_bit")
                                                 .addParam(name = "pageStatusId",       value = variables.pageStatusId,             cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "region",             value = variables.region,                   cfsqltype = "cf_sql_varchar")
                                                 .addParam(name = "creator",            value = variables.creator.getUserId(),      cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "creationDate",       value = variables.creationDate,             cfsqltype = "cf_sql_date")
                                                 .addParam(name = "lastEditor",         value = variables.lastEditor.getUserId(),   cfsqltype = "cf_sql_numeric")
                                                 .addParam(name = "lastEditDate",       value = variables.lastEditDate,             cfsqltype = "cf_sql_date")
                                                 .execute()
                                                 .getResult()
                                                 .newPageVersionId[1];
        }
        else {
            if(isPageVersionOffline() && ! updateOnlineVersionAllowed()) {
                new Query().setSQL("UPDATE nephthys_pageVersion
                                       SET parentPageId       = :parentPageId,
                                           prevPageVersionId  = :prevPageVersionId,
                                           nextPageVersionId  = :nextPageVersionId,
                                           majorVersion       = :majorVersion,
                                           minorVersion       = :minorVersion,
                                           linktext           = :linktext,
                                           link               = :link,
                                           title              = :title,
                                           description        = :description,
                                           content            = :content,
                                           sortOrder          = :sortOrder,
                                           useDynamicSuffixes = :useDynamicSuffixes,
                                           pageStatusId       = :pageStatusId,
                                           region             = :region,
                                           lastEditorUserId   = :lastEditor,
                                           lastEditDate       = :lastEditDate
                                     WHERE pageVersionId = :pageVersionId")
                           .addParam(name = "pageVersionId",      value = variables.pageVersionId,            cfsqltype = "cf_sql_numeric")
                           .addParam(name = "parentPageId",       value = variables.parentPageId,             cfsqltype = "cf_sql_numeric")
                           .addParam(name = "prevPageVersionId",  value = variables.prevPageVersionId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "nextPageVersionId",  value = variables.nextPageVersionId,        cfsqltype = "cf_sql_numeric")
                           .addParam(name = "majorVersion",       value = variables.majorVersion,             cfsqltype = "cf_sql_numeric")
                           .addParam(name = "minorVersion",       value = variables.minorVersion,             cfsqltype = "cf_sql_numeric")
                           .addParam(name = "linktext",           value = variables.linktext,                 cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",               value = variables.link,                     cfsqltype = "cf_sql_varchar")
                           .addParam(name = "title",              value = variables.title,                    cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",        value = variables.description,              cfsqltype = "cf_sql_varchar")
                           .addParam(name = "content",            value = deserializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                           .addParam(name = "sortOrder",          value = variables.sortOrder,                cfsqltype = "cf_sql_numeric")
                           .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes,       cfsqltype = "cf_sql_bit")
                           .addParam(name = "pageStatusId",       value = variables.pageStatusId,             cfsqltype = "cf_sql_numeric")
                           .addParam(name = "region",             value = variables.region,                   cfsqltype = "cf_sql_varchar")
                           .addParam(name = "lastEditor",         value = variables.lastEditor.getUserId(),   cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditDate",       value = variables.lastEditDate,             cfsqltype = "cf_sql_date")
                           .execute();
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update the version that is online");
            }
        }
        
        return this;
    }
    
    public void function delete() {
        var page = new page(variables.pageId);
        
        if(page.getActualVersion() == variables.version) {
            // TODO: update version of page to last one!
        }
        
        new Query().setSQL("DELETE
                              FROM nephthys_pageVersion
                             WHERE pageVersionId = :pageVersionId")
                   .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    
    private void function load() {
        if(isNewEntry() || (variables.pageId != 0 && variables.pageId != null && variables.version != null && variables.version != "")) {
            var qryPageVersion = new Query();
            
            var sql = "SELECT * FROM nephthys_pageVersion ";
            var where = "";
            
            if(variables.pageVersionId != 0 && variables.pageVersionId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " pageVersionId = :pageVersionId ";
                qryPageVersion.addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & " pageId = :pageId AND version = :version";
                qryPageVersion.addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric");
                qryPageVersion.addParam(name = "version", value = variables.version, cfsqltype = "cf_sql_varchar");
            }
            
            sql &= where;
            
            var qPageVersion = qryPageVersion.setSQL(sql)
                                             .execute()
                                             .getResult();
            
            if(qPageVersion.getRecordCount() == 1) {
                variables.pageVersionId      = qPageVersion.pageVersionId[1];
                variables.pageId             = qPageVersion.pageId[1];
                variables.parentPageId       = qPageVersion.parentPageId[1];
                variables.prevPageVersionId  = qPageVersion.prevPageVersionId[1];
                variables.nextPageVersionId  = qPageVersion.nextPageVersionId[1];
                variables.majorVersion       = qPageVersion.majorVersion[1];
                variables.minorVersion       = qPageVersion.minorVersion[1];
                variables.linktext           = qPageVersion.linktext[1];
                variables.link               = qPageVersion.link[1];
                variables.title              = qPageVersion.title[1];
                variables.description        = qPageVersion.description[1];
                variables.content            = deserializeJSON(qPageVersion.content[1]);
                variables.sortOrder          = qPageVersion.sortOrder[1];
                variables.useDynamicSuffixes = qPageVersion.useDynamicSuffixes[1];
                variables.pageStatusId       = qPageVersion.pageStatusId[1];
                variables.region             = qPageVersion.region[1];
                variables.creator            = new user(qPageVersion.creatorUserId[1]);
                variables.creationDate       = qPageVersion.creationDate[1];
                variables.lastEditor         = new user(qPageVersion.lastEditorUserId[1]);
                variables.lastEditDate       = qPageVersion.lastEditDate[1];
            }
            else {
                throw(type = "nephthys.notFound.page",
                      message = "The page version could not be found",
                      details = {
                         "id" = variables.pageVersionId,
                         "pageId" = variables.pageId,
                         "majorVersion" = variables.majorVersion,
                         "minorVersion" = variables.minorVersion
                     });
            }
        }
        else {
            variables.pageVersionId      = null;
            variables.pageId             = null;
            variables.parentPageId       = null;
            variables.prevPageVersionId  = null;
            variables.nextPageVersionId  = null;
            variables.majorVersion       = 1;
            variables.minorVersion       = 0;
            variables.linktext           = "";
            variables.link               = "";
            variables.title              = "";
            variables.description        = "";
            variables.content            = [];
            variables.sortOrder          = getNextSortOrder();
            variables.useDynamicSuffixes = false;
            variables.pageStatusId       = getFirstStatusId();
            variables.region             = 'header';
            variables.creator            = new user(request.user.getUserId());
            variables.creationDate       = now();
            variables.lastEditor         = new user(request.user.getUserId());
            variables.lastEditDate       = now();
        }
        
        variables.prevPageVersion = null;
        variables.nextPageVersion = null;
    }
    
    private numeric function getNextSortOrder() {
        // TODO: implement
        return 1;
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
    
    private boolean function isNewEntry() {
        return (variables.pageVersionId != 0 && variables.pageVersionId != null);
    }
    
    private boolean function isPageVersionOffline() {
        // TOOD: implement
        return true;
    }
    
    private boolean function updateOnlineVersionAllowed() {
        return false;
    }
}