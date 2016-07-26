component {
    public approval function init(required numeric blogpostId) {
        variables.blogpostId = arguments.blogpostId;
        
        return this;
    }
    
    public array function getApprovalList() {
        if(variables.blogpostId != null && variables.blogpostId != 0) {
            var sql = "";
            sql = "  SELECT *
                       FROM IcedReaper_blog_approval
                      WHERE blogpostId = :blogpostId
                   ORDER BY approvalDate DESC";
            break;
            
            var qApprovalList = new Query().setSQL(sql)
                                           .addParam(name = "blogpostId", value = variables.blogpostId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult();
            
            var approvalList = [];
            for(var i = 1; i <= qApprovalList.getRecordCount(); ++i) {
                approvalList.append({
                    user           = createObject("component", "API.modules.com.Nephthys.userManager.user").init(qApprovalList.userId[i]),
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
        new Query().setSQL("INSERT INTO IcedReaper_blog_approval
                                        (
                                            blogpostId,
                                            prevStatusId,
                                            nextStatusId,
                                            userId
                                        )
                                 VALUES (
                                            :blogpostId,
                                            :prevStatusId,
                                            :nextStatusId,
                                            :userId
                                        )")
                   .addParam(name = "blogpostId",   value = variables.blogpostId,   cfsqltype = "cf_sql_numeric")
                   .addParam(name = "prevStatusId", value = arguments.prevStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "nextStatusId", value = arguments.nextStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "userId",       value = arguments.userId,       cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}