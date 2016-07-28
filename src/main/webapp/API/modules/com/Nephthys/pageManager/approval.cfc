component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public approval function init(required numeric approvalId) {
        variables.approvalId = arguments.approvalId;
        
        load();
        
        return this;
    }
    
    public approval function setPageVersion(required pageVersion pageVersion) {
        if(variables.approvalId == null) {
            variables.pageVersion = arguments.pageVersion;
        }
        return this;
    }
    public approval function setSitemap(required sitemap sitemap) {
        if(variables.approvalId == null) {
            variables.sitemap = arguments.sitemap;
        }
        return this;
    }
    public approval function setPrevStatus(required status status) {
        if(variables.approvalId == null) {
            variables.prevStatus = arguments.status;
        }
        return this;
    }
    public approval function setNewStatus(required status status) {
        if(variables.approvalId == null) {
            variables.newStatus = arguments.status;
        }
        return this;
    }
    
    public numeric function getApprovalId() {
        return variables.approvalId;
    }
    public pageVersion function getPageVersion() {
        return variables.pageVersion;
    }
    public sitemap function getSitemap() {
        return variables.sitemap;
    }
    public status function getPrevStatus() {
        return variables.prevStatus;
    }
    public status function getNewStatus() {
        return variables.newStatus;
    }
    public user function getApprover() {
        return variables.approver;
    }
    public date function getApprovalDate() {
        return variables.approvalDate;
    }
    
    
    public approval function save(required user user) {
        if(variables.approvalId == null) {
            variables.approvalId = new Query().setSQL("INSERT INTO nephthys_page_approval
                                                                   (
                                                                       pageVersionId,
                                                                       sitemapId,
                                                                       prevStatusId,
                                                                       newStatusId,
                                                                       approvalUserId,
                                                                       approvalDate
                                                                   )
                                                            VALUES (
                                                                       :pageVersionId,
                                                                       :sitemapId,
                                                                       :prevStatusId,
                                                                       :newStatusId,
                                                                       :approvalUserId
                                                                   );
                                                       SELECT currval('nephthys_page_approval_approvalid_seq') newApprovalId;
                                                       ")
                   .addParam(name = "pageVersionId",  value = variables.pageVersion.getPageVersionId(), cfsqltype = "cf_sql_numeric", null = variables.pageVersion.getPageVersionId() == null)
                   .addParam(name = "sitemapId",      value = variables.sitemap.getSitemapId(),         cfsqltype = "cf_sql_numeric", null = variables.sitemap.getSitemapId() == null)
                   .addParam(name = "prevStatusId",   value = variables.prevStatus.getStatusId(),       cfsqltype = "cf_sql_numeric")
                   .addParam(name = "newStatusId",    value = variables.newStatus.getStatusId(),        cfsqltype = "cf_sql_numeric")
                   .addParam(name = "approvalUserId", value = arguments.user.getUserId(),               cfsqltype = "cf_sql_numeric")
                   .execute()
                   .getResult()
                   .newApprovalId[1];
            
            variables.approver = arguments.user;
            variables.approvalDate = now();
        }
        
        return this;
    }
    
    
    private void function load() {
        if(variables.approvalId != null) {
            var qGetApproval = new Query().setSQL("SELECT *
                                                     FROM nephthys_page_approval
                                                    WHERE approvalId = :approvalId")
                                          .addParam(name = "approvalId", value = variables.approvalId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qGetApproval.getRecordCount() == 1) {
                variables.pageVersion  = new pageVersion(qGetApproval.pageVersionId[1]);
                variables.sitemap      = new sitemap(qGetApproval.sitemapId[1]);
                variables.prevStatus   = new status(qGetApproval.prevStatusId[1]);
                variables.newStatus    = new status(qGetApproval.newStatusId[1]);
                variables.approver     = new user(qGetApproval.approvalUserId[1]);
                variables.approvalDate = qGetApproval.approvalDate[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The approval could not be found", detail = variables.approvalId);
            }
        }
        else {
            variables.pageVersion  = new pageVersion(null);
            variables.sitemap      = new sitemap(null);
            variables.prevStatus   = new status(null);
            variables.newStatus    = new status(null);
            variables.approver     = new user(null);
            variables.approvalDate = now();
        }
    }
}