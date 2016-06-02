component {
    import "API.modules.com.Nephthys.user.*";
    
    public pageApproval function init(required numeric pageVersionId) {
        variables.pageVersionId = arguments.pageVersionId;
        
        return this;
    }
    
    public array function getApprovalList() {
        if(variables.pageVersionId != null && variables.pageVersionId != 0) {
            var qApprovalList = new Query().setSQL("  SELECT *
                                                        FROM nephthys_pageApproval
                                                       WHERE pageVersionId = :pageVersionId
                                                    ORDER BY approvalDate DESC")
                                           .addParam(name = "pageVersionId", value = variables.pageVersionId, cfsqltype = "cf_sql_numeric")
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
        new Query().setSQL("INSERT INTO nephthys_pageApproval
                                        (
                                            pageVersionId,
                                            oldPageStatusId,
                                            newPageStatusId,
                                            userId
                                        )
                                 VALUES (
                                            :pageVersionId,
                                            :oldPageStatusId,
                                            :newPageStatusId,
                                            :userId
                                        )")
                   .addParam(name = "pageVersionId",   value = variables.pageVersionId,   cfsqltype = "cf_sql_numeric")
                   .addParam(name = "oldPageStatusId", value = arguments.oldPageStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "newPageStatusId", value = arguments.newPageStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "userId",          value = arguments.userId,          cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}