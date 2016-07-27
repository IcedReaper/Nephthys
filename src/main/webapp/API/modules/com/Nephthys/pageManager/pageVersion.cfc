component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public pageVersion function init(required numeric pageVersionId = null) {
        variables.pageVersionId = arguments.pageVersionId;
        
        variables.statusChanged = false;
        
        load();
        
        return this;
    }
    
    public pageVersion function setPageId(required numeric pageId) {
        if(isNewEntry()) {
            variables.pageId = arguments.pageId;
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
    public pageVersion function setuseDynamicUrlSuffix(required boolean useDynamicUrlSuffix) {
        variables.useDynamicUrlSuffix = arguments.useDynamicUrlSuffix;
        return this;
    }
    public pageVersion function setStatusId(required numeric statusId) {
        variables.statusId = arguments.statusId;
        variables.statusChanged = true;
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
    public boolean function getuseDynamicUrlSuffix() {
        return variables.useDynamicUrlSuffix == 1;
    }
    public numeric function getStatusId() {
        return variables.statusId;
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
        return new status(variables.statusId).isOnline();
    }
    
    public status function getStatus() {
        return new status(variables.statusId);
    }
    public string function getVersion() {
        return variables.majorVersion & "." & variables.minorVersion;
    }
    
    public pageVersion function pushToStatus(required numeric newStatusId, required user user) {
        var newStatus    = new status(arguments.newStatusId);
        var actualStatus = new status(variables.statusId);
        
        var newStatusOK = false;
        for(var nextStatus in actualStatus.getNextStatus()) {
            if(nextStatus.getStatusId() == newStatus.getStatusId()) {
                newStatusOk = true;
            }
        }
        
        if(newStatusOk) {
            if(newStatus.isApprovalValid(arguments.user.getUserId())) {
                transaction {
                    setStatusId(newStatus.getStatusId());
                    save();
                    
                    if(newStatus.isOnline()) {
                        var page = new page(variables.pageId);
                        // update last page Status
                        var offlineStatusId = application.system.settings.getValueOfKey("endStatus");
                        
                        var oldPageVersion = page.getActualPageVersion();
                        if(oldPageVersion.getPageVersionId() != variables.pageVersionId) {
                            new approval(null).setPageVersion(oldPageVersion)
                                              .setPrevStatus(oldPageVersion.getStatus())
                                              .setNewStatus(new status(offlineStatusId))
                                              .setApprover(arguments.user)
                                              .setApprovalDate(now())
                                              .save();
                            
                            oldPageVersion.setStatusId(offlineStatusId)
                                          .save();
                        }
                        
                        page.setPageVersionId(variables.pageVersionId)
                            .save();
                    }
                    
                    new approval(null).setPageVersion(this)
                                      .setPrevStatus(actualStatus)
                                      .setNewStatus(newStatus)
                                      .setApprover(arguments.user)
                                      .setApprovalDate(now())
                                      .save();
                    
                    transactionCommit();
                }
                
                return this;
            }
            else {
                throw(type = "nephthys.application.notAllowed", message = "You don't have the required permissions for this operation");
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "The new status isn't allowed!");
        }
    }
    
    
    public pageVersion function save() {
        if(isNewEntry()) {
            if(variables.pageId != null && variables.pageId != 0 && variables.majorVersion != null && variables.majorVersion != 0 && variables.minorVersion != null) {
                variables.pageVersionId = new Query().setSQL("INSERT INTO nephthys_page_pageVersion
                                                                          (
                                                                              pageId,
                                                                              majorVersion,
                                                                              minorVersion,
                                                                              linktext,
                                                                              link,
                                                                              title,
                                                                              description,
                                                                              content,
                                                                              useDynamicUrlSuffix,
                                                                              statusId,
                                                                              creationUserId,
                                                                              creationDate,
                                                                              lastEditUserId,
                                                                              lastEditDate
                                                                          )
                                                                   VALUES (
                                                                              :pageId,
                                                                              :majorVersion,
                                                                              :minorVersion,
                                                                              :linktext,
                                                                              :link,
                                                                              :title,
                                                                              :description,
                                                                              :content,
                                                                              :useDynamicUrlSuffix,
                                                                              :statusId,
                                                                              :userId,
                                                                              :creationDate,
                                                                              :userId,
                                                                              :lastEditDate
                                                                          );
                                                              SELECT currval('nephthys_page_pageVersion_pageVersionId_seq') newPageVersionId;")
                                                     .addParam(name = "pageId",             value = variables.pageId,                 cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "majorVersion",       value = variables.majorVersion,           cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "minorVersion",       value = variables.minorVersion,           cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "linktext",           value = variables.linktext,               cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "link",               value = variables.link,                   cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "title",              value = variables.title,                  cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "description",        value = variables.description,            cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "content",            value = serializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                                                     .addParam(name = "useDynamicUrlSuffix", value = variables.useDynamicUrlSuffix,     cfsqltype = "cf_sql_bit")
                                                     .addParam(name = "statusId",           value = variables.statusId,               cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "userId",             value = variables.creator.getUserId(),    cfsqltype = "cf_sql_numeric")
                                                     .addParam(name = "creationDate",       value = variables.creationDate,           cfsqltype = "cf_sql_timestamp")
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
            if(getStatus().getEditable()) {
                new Query().setSQL("UPDATE nephthys_page_pageVersion
                                       SET majorVersion       = :majorVersion,
                                           minorVersion       = :minorVersion,
                                           linktext           = :linktext,
                                           link               = :link,
                                           title              = :title,
                                           description        = :description,
                                           content            = :content,
                                           useDynamicUrlSuffix = :useDynamicUrlSuffix,
                                           statusId           = :statusId,
                                           lastEditUserId     = :userId,
                                           lastEditDate       = :lastEditDate
                                     WHERE pageVersionId = :pageVersionId")
                           .addParam(name = "pageVersionId",      value = variables.pageVersionId,          cfsqltype = "cf_sql_numeric")
                           .addParam(name = "majorVersion",       value = variables.majorVersion,           cfsqltype = "cf_sql_numeric")
                           .addParam(name = "minorVersion",       value = variables.minorVersion,           cfsqltype = "cf_sql_numeric")
                           .addParam(name = "linktext",           value = variables.linktext,               cfsqltype = "cf_sql_varchar")
                           .addParam(name = "link",               value = variables.link,                   cfsqltype = "cf_sql_varchar")
                           .addParam(name = "title",              value = variables.title,                  cfsqltype = "cf_sql_varchar")
                           .addParam(name = "description",        value = variables.description,            cfsqltype = "cf_sql_varchar")
                           .addParam(name = "content",            value = serializeJSON(variables.content), cfsqltype = "cf_sql_varchar")
                           .addParam(name = "useDynamicUrlSuffix", value = variables.useDynamicUrlSuffix,     cfsqltype = "cf_sql_bit")
                           .addParam(name = "statusId",           value = variables.statusId,               cfsqltype = "cf_sql_numeric")
                           .addParam(name = "userId",             value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditDate",       value = variables.lastEditDate,           cfsqltype = "cf_sql_timestamp")
                           .execute();
            }
            else {
                if(variables.statusChanged) {
                    new Query().setSQL("UPDATE nephthys_page_pageVersion
                                           SET statusId = :statusId
                                         WHERE pageVersionId = :pageVersionId")
                               .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                               .addParam(name = "statusId",  value = variables.statusId,  cfsqltype = "cf_sql_numeric")
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
        
        transaction {
            var qMaxMajorVersion = new Query().setSQL("  SELECT MAX(maxMajorVersion) maxMajorVersion
                                                           FROM nephthys_page_pageVersion
                                                          WHERE pageVersionId != :pageVersionId
                                                            AND pageId         = :pageId")
                                              .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                                              .addParam(name = "pageId",        value = variables.pageId,        cfsqltype = "cf_sql_numeric")
                                              .execute()
                                              .getResult();
            
            if(qMaxMajorVersion.getRecordCount() == 1) {
                var qLastVersion = new Query().setSQL("  SELECT pageVersionId
                                                               FROM nephthys_page_pageVersion
                                                              WHERE pageVersionId != :pageVersionId
                                                                AND pageId         = :pageId
                                                                AND majorVersion   = :majorVersion")
                                                  .addParam(name = "pageVersionId", value = variables.pageVersionId,             cfsqltype = "cf_sql_numeric")
                                                  .addParam(name = "pageId",        value = variables.pageId,                    cfsqltype = "cf_sql_numeric")
                                                  .addParam(name = "majorVersion",  value = qMaxMajorVersion.maxMajorVersion[1], cfsqltype = "cf_sql_numeric")
                                                  .execute()
                                                  .getResult();
                
                if(qLastVersion.getRecordCount() == 1) {
                    new page(variables.pageId).setPageVersionId(qLastVersion.pageVersionId[1])
                                              .save();
                    
                    new Query().setSQL("DELETE
                                          FROM nephthys_page_pageVersion
                                         WHERE pageVersionId = :pageVersionId")
                               .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                               .execute();
                    
                    transactionCommit();
                    
                    return;
                }
            }
            
            // if we don't have another version than this we can delete the complete page
            new page(variables.pageId).delete();
        }
    }
    
    
    
    private void function load() {
        if(! isNewEntry()) {
            var qryPageVersion = new Query();
            
            var sql = "SELECT * FROM nephthys_page_pageVersion ";
            var where = "";
            
            where &= (where == "" ? " WHERE " : " AND ") & " pageVersionId = :pageVersionId ";
            qryPageVersion.addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric");
            
            sql &= where;
            
            var qPageVersion = qryPageVersion.setSQL(sql)
                                             .execute()
                                             .getResult();
            
            if(qPageVersion.getRecordCount() == 1) {
                variables.pageId             = qPageVersion.pageId[1];
                variables.majorVersion       = qPageVersion.majorVersion[1];
                variables.minorVersion       = qPageVersion.minorVersion[1];
                variables.linktext           = qPageVersion.linktext[1];
                variables.link               = qPageVersion.link[1];
                variables.title              = qPageVersion.title[1];
                variables.description        = qPageVersion.description[1];
                variables.content            = deserializeJSON(qPageVersion.content[1]);
                variables.useDynamicUrlSuffix = qPageVersion.useDynamicUrlSuffix[1];
                variables.statusId           = qPageVersion.statusId[1];
                variables.creator            = new user(qPageVersion.creationUserId[1]);
                variables.creationDate       = qPageVersion.creationDate[1];
                variables.lastEditor         = new user(qPageVersion.lastEditUserId[1]);
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
            variables.linktext           = "";
            variables.link               = "";
            variables.title              = "";
            variables.description        = "";
            variables.content            = [];
            variables.useDynamicUrlSuffix = false;
            variables.statusId           = getFirstStatusId();
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
    
    private numeric function getFirstStatusId() {
        return new status(application.system.settings.getValueOfKey("startStatus")).getStatusId();
    }
    
    public boolean function isNewEntry() {
        return (variables.pageVersionId == 0 || variables.pageVersionId == null);
    }
}