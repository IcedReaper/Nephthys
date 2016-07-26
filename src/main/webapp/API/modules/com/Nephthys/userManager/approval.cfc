component {
    public approval function init(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public array function getApprovalList() {
        if(variables.userId != null && variables.userId != 0) {
            var sql = "  SELECT *
                           FROM nephthys_page_approval
                          WHERE userId = :userId
                       ORDER BY approvalDate DESC";
            
            var qApprovalList = new Query().setSQL(sql)
                                           .addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult();
            
            var approvalList = [];
            for(var i = 1; i <= qApprovalList.getRecordCount(); ++i) {
                approvalList.append({
                    user           = new user(qApprovalList.approvalUserId[i]),
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
    
    public boolean function approve(required numeric prevStatusId, required numeric nextStatusId, required numeric approvalUserId) {
        var sql = "INSERT INTO nephthys_user_approval
                               (
                                   userId,
                                   prevStatusId,
                                   nextStatusId,
                                   approvalUserId
                               )
                        VALUES (
                                   :userId,
                                   :prevStatusId,
                                   :nextStatusId,
                                   :approvalUserId
                               )";
        
        new Query().setSQL(sql)
                   .addParam(name = "userId",         value = variables.userId,         cfsqltype = "cf_sql_numeric")
                   .addParam(name = "prevStatusId",   value = arguments.prevStatusId,   cfsqltype = "cf_sql_numeric")
                   .addParam(name = "nextStatusId",   value = arguments.nextStatusId,   cfsqltype = "cf_sql_numeric")
                   .addParam(name = "approvalUserId", value = arguments.approvalUserId, cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}