component {
    import "API.modules.com.Nephthys.user.*";
    
    public page function init(required numeric pageId) {
        variables.pageId = arguments.pageId;
        
        variables.pageVersionsLoaded = false;
        
        load();
        
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
    
    
    
    public page function save() {
        if(variables.pageId == null || variables.pageId == 0) {
            variables.pageId = new Query().setSQL("INSERT INTO nephthys_page_page
                                                               (
                                                                   creationDate
                                                               )
                                                        VALUES (
                                                                   :creationDate
                                                               );
                                                   SELECT currval('nephthys_page_page_pageId_seq') newPageId;")
                                          .addParam(name = "creationDate",       value = variables.creationDate, cfsqltype = "cf_sql_timestamp")
                                          .execute()
                                          .getResult()
                                          .newPageId[1];
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE
                              FROM nephthys_page_page
                             WHERE pageId = :pageId")
                   .addParam(name = "pageId", value = variables.pageId, cfsqltype = "cf_sql_numeric")
                   .execute();
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