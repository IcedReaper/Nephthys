component {
    public approval function init(required numeric approvalId) {
        variables.approvalId = arguments.approvalId;
        
        load();
        
        return this;
    }
    
    public approval function setGallery(required gallery gallery) {
        if(variables.approvalId == null) {
            variables.gallery = arguments.gallery;
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
    public approval function setApprover(required user approver) {
        if(variables.approvalId == null) {
            variables.approver = arguments.approver;
        }
        return this;
    }
    public approval function setApprovalDate(required date approvalDate) {
        if(variables.approvalId == null) {
            variables.approvalDate = arguments.approvalDate;
        }
        return this;
    }
    
    public numeric function getApprovalId() {
        return variables.approvalId;
    }
    public gallery function getGallery() {
        return variables.gallery;
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
    
    
    public approval function save() {
        if(variables.approvalId == null) {
            variables.approvalId = new Query().setSQL("INSERT INTO IcedReaper_gallery_approval
                                                                   (
                                                                       galleryId,
                                                                       prevStatusId,
                                                                       newStatusId,
                                                                       approvalUserId,
                                                                       approvalDate
                                                                   )
                                                            VALUES (
                                                                       :galleryId,
                                                                       :prevStatusId,
                                                                       :newStatusId,
                                                                       :approvalUserId,
                                                                       :approvalDate
                                                                   );
                                                       SELECT currval('icedreaper_gallery_approval_approvalid_seq') newApprovalId;
                                                       ")
                   .addParam(name = "galleryId",      value = variables.gallery.getGalleryId(),   cfsqltype = "cf_sql_numeric")
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
                                                     FROM IcedReaper_gallery_approval
                                                    WHERE approvalId = :approvalId")
                                          .addParam(name = "approvalId", value = variables.approvalId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qGetApproval.getRecordCount() == 1) {
                variables.gallery      = new gallery(qGetApproval.galleryId[1]);
                variables.prevStatus   = new status(qGetApproval.prevStatusId[1]);
                variables.newStatus   = new status(qGetApproval.newStatusId[1]);
                variables.approver     = createObject("component", "API.modules.com.Nephthys.userManager.user").init(qGetApproval.approvalUserId[1]);
                variables.approvalDate = qGetApproval.approvalDate[1];
            }
            else {
                throw(type = "icedreaper.gallery.notFound", message = "The Approval could not be found", detail = variables.approvalId);
            }
        }
        else {
            variables.gallery      = null;
            variables.prevStatus   = null;
            variables.newStatus   = null;
            variables.approver     = null;
            variables.approvalDate = now();
        }
    }
}