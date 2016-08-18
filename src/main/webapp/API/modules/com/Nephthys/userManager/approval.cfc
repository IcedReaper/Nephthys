component {
    public approval function init(required numeric approvalId) {
        variables.approvalId = arguments.approvalId;
        
        load();
        
        return this;
    }
    
    public approval function setUser(required user user) {
        if(variables.approvalId == null) {
            variables.user = arguments.user;
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
    public user function getUser() {
        return variables.user;
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
            variables.approvalId = new Query().setSQL("INSERT INTO nephthys_user_approval
                                                                   (
                                                                       userId,
                                                                       prevStatusId,
                                                                       newStatusId,
                                                                       approvalUserId
                                                                   )
                                                            VALUES (
                                                                       :userId,
                                                                       :prevStatusId,
                                                                       :newStatusId,
                                                                       :approvalUserId
                                                                   );
                                                       SELECT currval('nephthys_user_approval_approvalid_seq') newApprovalId;
                                                       ")
                   .addParam(name = "userId",         value = variables.user.getUserId(),         cfsqltype = "cf_sql_numeric")
                   .addParam(name = "prevStatusId",   value = variables.prevStatus.getStatusId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "newStatusId",    value = variables.newStatus.getStatusId(),  cfsqltype = "cf_sql_numeric")
                   .addParam(name = "approvalUserId", value = arguments.user.getUserId(),         cfsqltype = "cf_sql_numeric")
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
                                                     FROM nephthys_user_approval
                                                    WHERE approvalId = :approvalId")
                                          .addParam(name = "approvalId", value = variables.approvalId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qGetApproval.getRecordCount() == 1) {
                variables.user         = new user(qGetApproval.userId[1]);
                variables.prevStatus   = new status(qGetApproval.prevStatusId[1]);
                variables.newStatus    = new status(qGetApproval.newStatusId[1]);
                variables.approver     = new user(qGetApproval.approvalUserId[1]);
                variables.approvalDate = qGetApproval.approvalDate[1];
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find the approval by ID ", detail = variables.approvalId);
            }
        }
        else {
            variables.user         = new user(null);
            variables.prevStatus   = new status(null);
            variables.newStatus    = new status(null);
            variables.approver     = new user(null);
            variables.approvalDate = now();
        }
    }
}