component {
    import "API.modules.com.Nephthys.user.*";
    
    public pageVersion function init(required numeric pageVersionId = null) {
        variables.pageVersionId = arguments.pageVersionId;
        
        variables.pageStatusChanged = false;
        
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
        if(isNewEntry()) {
            variables.parentPageId = arguments.parentPageId;
        }
        return this;
    }
    public pageVersion function setMajorVersion(required string majorVersion) {
        if(isNewEntry()) {
            variables.majorVersion = arguments.majorVersion;
        }
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
        variables.pageStatusChanged = true;
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
        return variables.useDynamicSuffixes == 1;
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
    public string function getVersion() {
        return variables.majorVersion & "." & variables.minorVersion;
    }
    
    
    public pageVersion function save() {
        if(isNewEntry()) {
            if(variables.pageId != null && variables.pageId != 0 && variables.majorVersion != null && variables.majorVersion != 0 && variables.minorVersion != null) {
                variables.pageVersionId = new Query().setSQL("INSERT INTO nephthys_pageVersion
                                                                          (
                                                                              pageId,
                                                                              parentPageId,
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
                                                                              creatorUserId,
                                                                              creationDate,
                                                                              lastEditorUserId,
                                                                              lastEditDate
                                                                          )
                                                                   VALUES (
                                                                              :pageId,
                                                                              :parentPageId,
                                                                              :majorVersion,
                                                                              :minorVersion,
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
                                                     .addParam(name = "pageId",             value = variables.pageId,                 cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "parentPageId",       value = variables.parentPageId,           cfsqltype = "cf_sql_numeric", null = variables.parentPageId == null)
                                                     .addParam(name = "majorVersion",       value = variables.majorVersion,           cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "minorVersion",       value = variables.minorVersion,           cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "linktext",           value = variables.linktext,               cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "link",               value = variables.link,                   cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "title",              value = variables.title,                  cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "description",        value = variables.description,            cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "content",            value = serializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "sortOrder",          value = variables.sortOrder,              cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes,     cfsqltype = "cf_sql_bit")
                                                     .addParam(name = "pageStatusId",       value = variables.pageStatusId,           cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "region",             value = variables.region,                 cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "creatorUserId",      value = variables.creator.getUserId(),    cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "creationDate",       value = variables.creationDate,           cfsqltype = "cf_sql_date")
                                                     .addParam(name = "lastEditorUserId",   value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "lastEditDate",       value = variables.lastEditDate,           cfsqltype = "cf_sql_timestamp")
                                                     .execute()
                                                     .getResult()
                                                     .newPageVersionId[1];
            }
            else {
                throw(type = "nephthys.application.notAllowed",
                      message = "You are not allowed to save a page version without a pageId and a version",
                      detail = serializeJSON({
                        pageId       = variables.pageId,
                        majorVersion = variables.majorVersion,
                        minorVersion = variables.minorVersion
                    }));
            }
        }
        else {
            if(getPageStatus().isEditable()) {
                new Query().setSQL("UPDATE nephthys_pageVersion
                                       SET parentPageId       = :parentPageId,
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
                                           lastEditorUserId   = :lastEditorUserId,
                                           lastEditDate       = :lastEditDate
                                     WHERE pageVersionId = :pageVersionId")
                           .addParam(name = "pageVersionId",      value = variables.pageVersionId,          cfsqltype = "cf_sql_numeric")
                           .addParam(name = "parentPageId",       value = variables.parentPageId,           cfsqltype = "cf_sql_numeric", null = variables.parentPageId == null)
                           .addParam(name = "majorVersion",       value = variables.majorVersion,           cfsqltype = "cf_sql_numeric")
                           .addParam(name = "minorVersion",       value = variables.minorVersion,           cfsqltype = "cf_sql_numeric")
                           .addParam(name = "linktext",           value = variables.linktext,               cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",               value = variables.link,                   cfsqltype = "cf_sql_varchar")
                           .addParam(name = "title",              value = variables.title,                  cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",        value = variables.description,            cfsqltype = "cf_sql_varchar")
                           .addParam(name = "content",            value = serializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                           .addParam(name = "sortOrder",          value = variables.sortOrder,              cfsqltype = "cf_sql_numeric")
                           .addParam(name = "useDynamicSuffixes", value = variables.useDynamicSuffixes,     cfsqltype = "cf_sql_bit")
                           .addParam(name = "pageStatusId",       value = variables.pageStatusId,           cfsqltype = "cf_sql_numeric")
                           .addParam(name = "region",             value = variables.region,                 cfsqltype = "cf_sql_varchar")
                           .addParam(name = "lastEditorUserId",   value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditDate",       value = variables.lastEditDate,           cfsqltype = "cf_sql_timestamp")
                           .execute();
            }
            else {
                if(variables.pageStatusChanged) {
                    new Query().setSQL("UPDATE nephthys_pageVersion
                                           SET pageStatusId = :pageStatusId
                                         WHERE pageVersionId = :pageVersionId")
                               .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                               .addParam(name = "pageStatusId",  value = variables.pageStatusId,  cfsqltype = "cf_sql_numeric")
                               .execute();
                }
                else {
                    throw(type = "nephthys.application.notAllowed", message = "You're not allowed to update the version that is online");
                }
            }
        }
        
        return this;
    }
    
    public void function delete() {
        var page = new page(variables.pageId);
        
        /*if(page.getActualVersion() == variables.version) {
            // TODO: update version of page to last one!
        }*/
        
        new Query().setSQL("DELETE
                              FROM nephthys_pageVersion
                             WHERE pageVersionId = :pageVersionId")
                   .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    
    
    public struct function dumpMyAttributes() {
        return duplicate(variables);
    }
    
    
    private void function load() {
        // TODO: Check für pageId, minor & major version to filter | not here
        if(! isNewEntry()) {
            var qryPageVersion = new Query();
            
            var sql = "SELECT * FROM nephthys_pageVersion ";
            var where = "";
            
            if(variables.pageVersionId != 0 && variables.pageVersionId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " pageVersionId = :pageVersionId ";
                qryPageVersion.addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric");
            }
            else {
                where &= (where == "" ? " WHERE " : " AND ") & " pageId = :pageId AND majorVersion = :majorVersion AND minorVersion = :minorVersion";
                qryPageVersion.addParam(name = "pageId",       value = variables.pageId,       cfsqltype = "cf_sql_numeric");
                qryPageVersion.addParam(name = "majorVersion", value = variables.majorVersion, cfsqltype = "cf_sql_numeric");
                qryPageVersion.addParam(name = "minorVersion", value = variables.minorVersion, cfsqltype = "cf_sql_numeric");
            }
            
            sql &= where;
            
            var qPageVersion = qryPageVersion.setSQL(sql)
                                             .execute()
                                             .getResult();
            
            if(qPageVersion.getRecordCount() == 1) {
                variables.pageId             = qPageVersion.pageId[1];
                variables.parentPageId       = qPageVersion.parentPageId[1];
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
            variables.pageId             = null;
            variables.parentPageId       = null;
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
            variables.majorVersion       = 0;
            variables.minorVersion       = 0;
        }
        
        variables.prevPageVersion = null;
        variables.nextPageVersion = null;
    }
    
    private numeric function getNextSortOrder() {
        // TODO: implement
        return 1;
    }
    
    private numeric function getFirstStatusId() {
        return new pageStatusFilter().setStartStatus(true)
                                     .execute()
                                     .getResult()[1].getPageStatusId();
    }
    
    public boolean function isNewEntry() {
        return (variables.pageVersionId == 0 || variables.pageVersionId == null);
    }
    
    private boolean function isPageVersionOffline() {
        // TOOD: implement
        return true;
    }
    
    private boolean function updateOnlineVersionAllowed() {
        return false;
    }
}