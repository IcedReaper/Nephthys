component {
    public hierarchyPage function init(required numeric hierarchyPageId) {
        variables.hierarchyPageId = arguments.hierarchyPageId;
        
        variables.attributesChanged = false;
        
        load();
        
        return this;
    }
    
    public hierarchyPage function setHierarchy(required hierarchy hierarchy) {
        if(variables.hierarchyPageId == null) {
            variables.hierarchy = arguments.hierarchy;
        }
        return this;
    }
    
    public hierarchyPage function setRegion(required region region) {
        variables.region = arguments.region;
        return this;
    }
    
    public hierarchyPage function setPage(required page page) {
        variables.page = arguments.page;
        return this;
    }
    
    public hierarchyPage function setParentPage(required page parentPage) {
        variables.parentPage = arguments.parentPage;
        return this;
    }
    
    public hierarchyPage function setSortOrder(required numeric sortOrder) {
        variables.sortOrder = arguments.sortOrder;
        return this;
    }
    
    
    public numeric function getHierarchyPageId() {
        return variables.hierarchyPageId;
    }
    
    public hierarchy function getHierarchy() {
        return variables.hierarchy;
    }
    
    public page function getPage() {
        return variables.page;
    }
    
    public page function getParentPage() {
        return variables.parentPage;
    }
    
    public numeric function getSortOrder() {
        return variables.sortOrder;
    }
    
    
    public hierarchyPage function save() {
        var qSave = new Query().addParam(name = "hierarchyId",  value = variables.hierarchy.getHierarchyId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "regionId",     value = variables.region.getRegionId(),       cfsqltype = "cf_sql_numeric")
                               .addParam(name = "pageId",       value = variables.page.getPageId(),           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "parentPageId", value = variables.parentPageId.getPageId(),   cfsqltype = "cf_sql_numeric")
                               .addParam(name = "sortOrder",    value = variables.sortOrder,                  cfsqltype = "cf_sql_numeric");
        
        if(variables.hierarchyPageId == null) {
            variables.hierarchyPageId = qSave.setSQL("INSERT INTO nephthys_page_hierarchyPage
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
                                             .execute()
                                             .getResult()
                                             .newHierarchyPageId[1];
        }
        else {
            qSave.setSQL("UPDATE nephthys_page_hierarchyPage
                             SET regionId     = :regionId
                                 pageId       = :pageId
                                 parentPageId = :parentPageId
                                 sortOrder    = :sortOrder
                           WHERE hierarchyPageId = hierarchyPageId")
                 .addParam(name = "hierarchyPageId", value = variables.hierarchyPageId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_page_hierarchyPage
                                  WHERE hierarchyPageId = :hierarchyPageId")
                   .addParam(name = "hierarchyPageId", value = variables.hierarchyPageId, cfsqltype = "cf_sql_numeric")
                   .execute()
    }
    
    
    private void function load() {
        if(variables.hierarchyPageId == null) {
            var qHierarchyPage = new Query().setSQL("SELECT *
                                                       FROM nephthys_page_hierarchyPage
                                                      WHERE hierarchyPageId = :hierarchyPageId")
                                            .addParam(name = "hierarchyPageId", value = variables.hierarchyPageId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            if(qHierarchyPage.getRecordCount() == 1) {
                variables.hierarchy  = new hierarchy(qHierarchyPage.hierarchyId[1]);
                variables.region     = new region(qHierarchyPage.regionId[1]);
                variables.page       = new page(qHierarchyPage.pageId[1]);
                variables.parentPage = new page(qHierarchyPage.parentPageId[1]);
                variables.sortOrder  = qHierarchyPage.sortOrder[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The hierarchy page could not be found.");
            }
        }
        else {
            variables.hierarchy  = new hierarchy(null);
            variables.region     = new region(null);
            variables.page       = new page(null);
            variables.parentPage = new page(null);
            variables.sortOrder  = 1;
        }
    }
}