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
            case "page":
            case "hierarchy":
            case "hierarchyVersion": {
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
                               FROM nephthys_page_approval
                              WHERE pageVersionId = :versionId
                           ORDER BY approvalDate DESC";
                    break;
                }
                case "hierarchyVersion":
                case "hierarchy": {
                    sql = "  SELECT *
                               FROM nephthys_page_approval
                              WHERE hierarchyId = :versionId
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
                    user           = new user(qApprovalList.userId[i]),
                    approvalDate   = qApprovalList.approvalDate[i],
                    previousStatus = new status(qApprovalList.prevStatusId[i]),
                    newStatus      = new status(qApprovalList.nextStatusId[i])
                });
            }
            
            return approvalList;
        }
        else {
            return [];
        }
    }
    
    public boolean function approve(required numeric prevStatusId, required numeric nextStatusId, required numeric userId) {
        var sql = "";
        switch(variables.for) {
            case "pageVersion":
            case "page": {
                var sql = "INSERT INTO nephthys_page_approval
                                       (
                                           pageVersionId,
                                           prevStatusId,
                                           nextStatusId,
                                           userId
                                       )
                                VALUES (
                                           :versionId,
                                           :prevStatusId,
                                           :nextStatusId,
                                           :userId
                                       )";
                break;
            }
            case "hierarchyVersion":
            case "hierarchy": {
                var sql = "INSERT INTO nephthys_page_approval
                                       (
                                           hierarchyId,
                                           prevStatusId,
                                           nextStatusId,
                                           userId
                                       )
                                VALUES (
                                           :versionId,
                                           :prevStatusId,
                                           :nextStatusId,
                                           :userId
                                       )";
                break;
            }
        }
        new Query().setSQL(sql)
                   .addParam(name = "versionId",    value = variables.versionId,    cfsqltype = "cf_sql_numeric")
                   .addParam(name = "prevStatusId", value = arguments.prevStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "nextStatusId", value = arguments.nextStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "userId",       value = arguments.userId,       cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}