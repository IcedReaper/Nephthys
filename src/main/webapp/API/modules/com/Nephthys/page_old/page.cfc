component {
    public page function init(required numeric pageId, required string version = 'actual') {
        variables.pageId = arguments.pageId;
        variables.version = arguments.version;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    
    public page function setParentId(required numeric parentId) {
        variables.parentId = arguments.parentId;
        
        return this;
    }
    public page function setLinkText(required string linkText) {
        variables.linkText = arguments.linkText;
        
        return this;
    }
    public page function setLink(required string link) {
        variables.link = arguments.link;
        
        return this;
    }
    public page function setTitle(required string title) {
        variables.title = arguments.title;
        
        return this;
    }
    public page function setDescription(required string description) {
        variables.description = arguments.description;
        
        return this;
    }
    public page function setContent(required any content) { // json string or array
        if(isJSON(arguments.content)) {
            variables.content = deserializeJSON(arguments.content);
        }
        else if(isArray(arguments.content)) {
            variables.content = arguments.content;
        }
        else {
            throw(type = "nephthys.application.invalidContent", message = "The content is not a valid JSON format or array");
        }
        
        return this;
    }
    public page function setSortOrder(required string sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        
        return this;
    }
    public page function setUseDynamicSuffixes(required string useDynamicSuffixes) {
        variables.useDynamicSuffixes = arguments.useDynamicSuffixes;
        
        return this;
    }
    public page function setCreatorUserId(required string creatorUserId) {
        if(variables.pageId == 0) {
            variables.creatorUserId = arguments.creatorUserId;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The creator cannot be set for an existing article");
        }
        
        return this;
    }
    public page function setLastEditorUserId(required string lastEditorUserId) {
        variables.lastEditorUserId = arguments.lastEditorUserId;
        
        return this;
    }
    public page function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        
        return this;
    }
    public page function setRegion(required string region) {
        variables.region = arguments.region;
        
        return this;
    }
    public page function setPageStatusId(required numeric pageStatusId) {
        variables.pageStatusId = arguments.pageStatusId;
        
        loadPageStatus();
        
        return this;
    }
    
    // G E T T E R
    
    public numeric function getPageId() {
        return variables.pageId;
    }
    public numeric function getParentId() {
        return variables.parentId;
    }
    public string function getLinkText() {
        return variables.linkText;
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
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    public boolean function getUseDynamicSuffixes() {
        return variables.useDynamicSuffixes == 1;
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
    public boolean function getActiveStatus() {
        return variables.active == 1;
    }
    public page function getParentPage() {
        return new page(variables.parentId);
    }
    public array function getChildPages() { // todo: implement || check if correct place for implementation
        return [];
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.creatorUserId);
        }
        return variables.creator;
    }
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.lastEditorUserId);
        }
        return variables.lastEditor;
    }
    public string function getRegion() {
        return variables.region;
    }
    public numeric function getPageStatusId() {
        return variables.pageStatusId;
    }
    public boolean function isOnline() {
        return ! variables.pageStatus.getOfflineStatus();
    }
    public boolean function isOffline() {
        return variables.pageStatus.getOfflineStatus();
    }
    public pageStatus function getPageStatus() {
        return variables.pageStatus;
    }
    
    // C R U D
    
    public page function save() {
        // data preparation
        var content = serializeJSON(variables.content);
        
        throw(type = "reimplement", message = "reimplement");
        
        if(variables.pageId == 0) {
            variables.pageId = new Query().setSQL("INSERT INTO nephthys_page
                                                               (
                                                                   parentId,
                                                                   linktext,
                                                                   link,
                                                                   title,
                                                                   description,
                                                                   content,
                                                                   sortOrder,
                                                                   useDynamicSuffixes,
                                                                   creatorUserId,
                                                                   lastEditorUserId,
                                                                   active,
                                                                   region,
                                                                   pageStatusId
                                                               )
                                                        VALUES (
                                                                   :parentId,
                                                                   :linktext,
                                                                   :link,
                                                                   :title,
                                                                   :description,
                                                                   :content,
                                                                   :sortOrder,
                                                                   :useDynamicSuffixes,
                                                                   :creatorUserId,
                                                                   :lastEditorUserId,
                                                                   :active,
                                                                   :region,
                                                                   :pageStatusId 
                                                               );
                                                   SELECT currval('seq_nephthys_page_id' :: regclass) newPageId;")
                                          .addParam(name = "parentId",           value = variables.parentId,           cfsqltype = "cf_sql_numeric", null = variables.parentId == null)
                                          .addParam(name = "linktext",           value = variables.linktext,           cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "link",               value = variables.link,               cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "title",              value = variables.title,              cfsqltype = "cf_sql_varchar", null = variables.title == "")
                                          .addParam(name = "description",        value = variables.description,        cfsqltype = "cf_sql_varchar", null = variables.description == "")
                                          .addParam(name = "content",            value = content,                      cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "sortOrder",          value = variables.sortOrder,          cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes, cfsqltype = "cf_sql_bit")
                                          .addParam(name = "creatorUserId",      value = variables.creatorUserId,      cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "lastEditorUserId",   value = variables.lastEditorUserId,   cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "active",             value = variables.active,             cfsqltype = "cf_sql_bit")
                                          .addParam(name = "region",             value = variables.region,             cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "pageStatusId",       value = variables.pageStatusId,       cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult()
                                          .newPageId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_page
                                   SET parentId           = :parentId,
                                       linktext           = :linktext,
                                       link               = :link,
                                       title              = :title,
                                       description        = :description,
                                       content            = :content,
                                       sortOrder          = :sortOrder,
                                       useDynamicSuffixes = :useDynamicSuffixes,
                                       creatorUserId      = :creatorUserId,
                                       lastEditorUserId   = :lastEditorUserId,
                                       lastEditDate       = now(),
                                       active             = :active,
                                       region             = :region,
                                       pageStatusId       = :pageStatusId
                                 WHERE pageId = :pageId")
                       .addParam(name = "pageId",             value = variables.pageId,             cfsqltype = "cf_sql_numeric")
                       .addParam(name = "parentId",           value = variables.parentId,           cfsqltype = "cf_sql_numeric", null = variables.parentId == null)
                       .addParam(name = "linktext",           value = variables.linktext,           cfsqltype = "cf_sql_varchar")
                       .addParam(name = "link",               value = variables.link,               cfsqltype = "cf_sql_varchar")
                       .addParam(name = "title",              value = variables.title,              cfsqltype = "cf_sql_varchar", null = variables.title == "")
                       .addParam(name = "description",        value = variables.description,        cfsqltype = "cf_sql_varchar", null = variables.description == "")
                       .addParam(name = "content",            value = content,                      cfsqltype = "cf_sql_varchar")
                       .addParam(name = "sortOrder",          value = variables.sortOrder,          cfsqltype = "cf_sql_numeric")
                       .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes, cfsqltype = "cf_sql_bit")
                       .addParam(name = "creatorUserId",      value = variables.creatorUserId,      cfsqltype = "cf_sql_numeric")
                       .addParam(name = "lastEditorUserId",   value = variables.lastEditorUserId,   cfsqltype = "cf_sql_numeric")
                       .addParam(name = "active",             value = variables.active,             cfsqltype = "cf_sql_bit")
                       .addParam(name = "region",             value = variables.region,             cfsqltype = "cf_sql_varchar")
                       .addParam(name = "pageStatusId",       value = variables.pageStatusId,       cfsqltype = "cf_sql_numeric")
                       .execute();
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
    
    // I N T E R N A L
    private void function loadDetails() {
        if(variables.pageId != 0 && variables.pageId != null) {
            var qryPage = new Query();
            var sql = "    SELECT pv.*
                             FROM nephthys_page p
                       INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                            WHERE p.pageId = :pageId";
            var versionCondition = "";
            
            if(variables.version == "actual") {
                versionCondition = " AND pv.version = p.actualVersion ";
            }
            else {
                versionCondition = " AND pv.version = :version ";
                qryPage.addParam(name = "version", value = variables.version, cfsqltype = "cf_sql_varchar");
            }
            
            sql &= versionCondition;
            
            var qPage = qryPage.setSQL(sql)
                               .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                               .execute()
                               .getResult();
            
            if(qPage.getRecordCount() == 1) {
                variables.parentId           = qPage.parentPageId[1];
                variables.linkText           = qPage.linkText[1];
                variables.link               = qPage.link[1];
                variables.title              = qPage.title[1];
                variables.description        = qPage.description[1];
                variables.content            = deserializeJSON(qPage.content[1]);
                variables.sortOrder          = qPage.sortOrder[1];
                variables.useDynamicSuffixes = qPage.useDynamicSuffixes[1];
                variables.creatorUserId      = qPage.creatorUserId[1];
                variables.creationDate       = qPage.creationDate[1];
                variables.lastEditorUserId   = qPage.lastEditorUserId[1];
                variables.lastEditDate       = qPage.lastEditDate[1];
                variables.active             = qPage.active[1];
                variables.region             = qPage.region[1];
                variables.region             = qPage.region[1];
                variables.pageStatusId       = qPage.pageStatusId[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The page could not be found", details = variables.pageId);
            }
        }
        else  {
            variables.parentId           = null;
            variables.linkText           = "";
            variables.link               = "";
            variables.title              = "";
            variables.description        = "";
            variables.content            = [];
            variables.sortOrder          = 0;
            variables.useDynamicSuffixes = 0;
            variables.creatorUserId      = 0;
            variables.creationDate       = now();
            variables.lastEditorUserId   = 0;
            variables.lastEditDate       = now();
            variables.active             = 0;
            variables.region             = "header";
            variables.pageStatusId       = null;
        }
        
        loadPageStatus();
    }
    
    private void function loadPageStatus() {
        variables.pageStatus = new pageStatus(variables.pageStatusId);
    }
}