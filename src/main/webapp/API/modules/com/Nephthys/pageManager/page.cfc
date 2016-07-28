component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public page function init(required numeric pageId) {
        variables.pageId = arguments.pageId;
        
        variables.pageVersionsLoaded = false;
        
        load();
        
        return this;
    }
    
    public page function setPageVersionId(required string pageVersionId) {
        variables.pageVersionId = arguments.pageVersionId;
        return this;
    }
    
    
    
    public numeric function getPageId() {
        return variables.pageId;
    }
    
    public date function getCreationDate() {
        return variables.creationDate;
    }
    
    public numeric function getPageVersionId() {
        return variables.pageVersionId;
    }
    
    public pageVersion function getActualPageVersion() {
        if(variables.pageId != null && variables.pageId != 0) {
            return new pageVersion(variables.pageVersionId);
        }
        else {
            return null;
        }
    }
    
    
    
    public page function save(required user user) {
        if(variables.pageId == null || variables.pageId == 0) {
            variables.pageId = new Query().setSQL("INSERT INTO nephthys_page_page
                                                               (
                                                                   creationDate
                                                               )
                                                        VALUES (
                                                                   :creationDate
                                                               );
                                                   SELECT currval('nephthys_page_page_pageId_seq') newPageId;")
                                          .addParam(name = "creationDate", value = variables.creationDate, cfsqltype = "cf_sql_timestamp")
                                          .execute()
                                          .getResult()
                                          .newPageId[1];
            
            variables.creationDate  = now();
        }
        else {
            new Query().setSQL("UPDATE nephthys_page_page
                                   SET pageVersionId = :pageVersionId
                                 WHERE pageId = :pageId")
                       .addParam(name = "pageId",        value = variables.pageId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
                       .execute()
                       .getResult();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE
                              FROM nephthys_page_page
                             WHERE pageId = :pageId")
                   .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.pageId = null;
    }
    
    
    
    private void function load() {
        if(variables.pageId != 0 && variables.pageId != null) {
            var qGetPage = new Query().setSQL("SELECT *
                                                 FROM nephthys_page_page
                                                WHERE pageId = :pageId")
                                      .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qGetPage.getRecordCount() == 1) {
                variables.creationDate  = qGetPage.creationDate[1];
                variables.pageVersionId = qgetPage.pageVersionId[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The page could not be found", detail = variables.pageId);
            }
        }
        else {
            variables.creationDate  = now();
            variables.pageVersionId = null;
        }
    }
}