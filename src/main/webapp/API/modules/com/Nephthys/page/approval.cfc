component {
    import "API.modules.com.Nephthys.user.*";
    
    public approval function init(required numeric versionId) {
        variables.versionId = arguments.versionId;
        variables.for = "pageVersion";
        
        return this;
    }
    
    public approval function setFor(required string for) {
        switch(arguments.for) {
            case "pageVersion":
            case "hierarchyVersion":
            case "page":
            case "hierarchy": {
                variables.for = arguments.for;
                break;
            }
        }
        
        return this;
    }
    
    public array function getApprovalList() {
        if(variables.versionId != null && variables.versionId != 0) {
            var sql = "";
            switch(variables.for) {
                case "pageversion":
                case "page": {
                    sql = "  SELECT *
                               FROM nephthys_pageApproval
                              WHERE pageVersionId = :versionId
                           ORDER BY approvalDate DESC";
                    break;
                }
                case "hierarchyVersion":
                case "hierarchy": {
                    sql = "  SELECT *
                               FROM nephthys_pageHierarchyApproval
                              WHERE pageHierarchyVersionId = :versionId
                           ORDER BY approvalDate DESC";
                    break;
                }
            }
            
            var qApprovalList = new Query().setSQL(sql)
                                           .addParam(name = "versionId", value = variables.versionId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult();
            
            var approvalList = [];
            for(var i = 1; i <= qApprovalList.getRecordCount(); ++i) {
                approvalList.append({
                    user          = new user(qApprovalList.userId[i]),
                    approvalDate  = qApprovalList.approvalDate[i],
                    oldPageStatus = new pageStatus(qApprovalList.oldPageStatusId[i]),
                    newPageStatus = new pageStatus(qApprovalList.newPageStatusId[i])
                });
            }
            
            return approvalList;
        }
        else {
            return [];
        }
    }
    
    public boolean function approve(required numeric oldPageStatusId, required numeric newPageStatusId, required numeric userId) {
        var sql = "";
        switch(variables.for) {
            case "pageversion":
            case "page": {
                var sql = "INSERT INTO nephthys_pageApproval
                                       (
                                           pageVersionId,
                                           oldPageStatusId,
                                           newPageStatusId,
                                           userId
                                       )
                                VALUES (
                                           :versionId,
                                           :oldPageStatusId,
                                           :newPageStatusId,
                                           :userId
                                       )";
                break;
            }
            case "hierarchyVersion":
            case "hierarchy": {
                var sql = "INSERT INTO nephthys_pageHierarchyApproval
                                       (
                                           pageHierarchyVersionId,
                                           oldPageStatusId,
                                           newPageStatusId,
                                           userId
                                       )
                                VALUES (
                                           :versionId,
                                           :oldPageStatusId,
                                           :newPageStatusId,
                                           :userId
                                       )";
                break;
            }
        }
        new Query().setSQL(sql)
                   .addParam(name = "versionId",       value = variables.versionId,       cfsqltype = "cf_sql_numeric")
                   .addParam(name = "oldPageStatusId", value = arguments.oldPageStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "newPageStatusId", value = arguments.newPageStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "userId",          value = arguments.userId,          cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}