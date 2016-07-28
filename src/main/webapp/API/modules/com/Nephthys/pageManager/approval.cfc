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
            var pageVersionId = null;
            var sitemapId = null;
            
            if(! isNull(variables.pageVersion)) {
                pageVersionId = variables.pageVersion.getPageVersionId();
            }
            if(! isNull(variables.sitemap)) {
                sitemapId = variables.sitemap.getSitemapId();
            }
            
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
                                                                       :approvalUserId,
                                                                       :approvalDate
                                                                   );
                                                       SELECT currval('nephthys_page_approval_approvalid_seq') newApprovalId;
                                                       ")
                   .addParam(name = "pageVersionId",  value = pageVersionId,                      cfsqltype = "cf_sql_numeric", null = pageVersionId == null)
                   .addParam(name = "sitemapId",      value = sitemapId,                          cfsqltype = "cf_sql_numeric", null = sitemapId == null)
                   .addParam(name = "prevStatusId",   value = variables.prevStatus.getStatusId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "newStatusId",    value = variables.newStatus.getStatusId(),  cfsqltype = "cf_sql_numeric")
                   .addParam(name = "approvalUserId", value = variables.approver.getUserId(),     cfsqltype = "cf_sql_numeric")
                   .addParam(name = "approvalDate",   value = variables.approvalDate,             cfsqltype = "cf_sql_timestamp")
                   .execute()
                   .getResult()
                   .newApprovalId[1];
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
                if(qGetApproval.pageVersionId != null) {
                    variables.pageVersion  = new pageVersion(qGetApproval.pageVersionId[1]);
                }
                else {
                    variables.pageVersion = null;
                }
                if(qGetApproval.sitemapId != null) {
                    variables.sitemap      = new sitemap(qGetApproval.sitemapId[1]);
                }
                else {
                    variables.sitemap = null;
                }
                variables.prevStatus   = new status(qGetApproval.prevStatusId[1]);
                variables.newStatus   = new status(qGetApproval.newStatusId[1]);
                variables.approver     = new user(qGetApproval.approvalUserId[1]);
                variables.approvalDate = qGetApproval.approvalDate[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The approval could not be found", detail = variables.approvalId);
            }
        }
        else {
            variables.pageVersion  = null;
            variables.sitemap      = null;
            variables.prevStatus   = null;
            variables.newStatus   = null;
            variables.approver     = null;
            variables.approvalDate = now();
        }
    }
}