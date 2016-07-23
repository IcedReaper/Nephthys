component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public approval function init(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        return this;
    }
    
    public array function getApprovalList() {
        if(variables.galleryId != null && variables.galleryId != 0) {
            var sql = "";
            sql = "  SELECT *
                       FROM IcedReaper_gallery_approval
                      WHERE galleryId = :galleryId
                   ORDER BY approvalDate DESC";
            break;
            
            var qApprovalList = new Query().setSQL(sql)
                                           .addParam(name = "galleryId", value = variables.galleryId, cfsqltype = "cf_sql_numeric")
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
        new Query().setSQL("INSERT INTO IcedReaper_gallery_approval
                                        (
                                            galleryId,
                                            prevStatusId,
                                            nextStatusId,
                                            userId
                                        )
                                 VALUES (
                                            :galleryId,
                                            :prevStatusId,
                                            :nextStatusId,
                                            :userId
                                        )")
                   .addParam(name = "galleryId",    value = variables.galleryId,    cfsqltype = "cf_sql_numeric")
                   .addParam(name = "prevStatusId", value = arguments.prevStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "nextStatusId", value = arguments.nextStatusId, cfsqltype = "cf_sql_numeric")
                   .addParam(name = "userId",       value = arguments.userId,       cfsqltype = "cf_sql_numeric")
                   .execute()
        
        return true;
    }
}