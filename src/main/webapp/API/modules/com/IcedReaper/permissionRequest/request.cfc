component {
    public request function init(required numeric requestId = 0) {
        variables.requestId = arguments.requestId;
        
        load();
        
        return this;
    }
    
    
    public request function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public request function setModuleId(required numeric moduleId) {
        variables.moduleId = arguments.moduleId;
        return this;
    }
    public request function setRoleId(required numeric roleId) {
        variables.roleId = arguments.roleId;
        return this;
    }
    public request function setReason(required string reason) {
        variables.reason = arguments.reason;
        return this;
    }
    
    
    public numeric function getRequestId() {
        return variables.requestId;
    }
    public numeric function getUserId() {
        return variables.userId;
    }
    public numeric function getModuleId() {
        return variables.moduleId;
    }
    public numeric function getRoleId() {
        return variables.roleId;
    }
    public numeric function getStatus() {
        return variables.status;
    }
    public string function getReason() {
        return variables.reason;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public numeric function getAdminUserId() {
        return variables.adminUserId;
    }
    public date function getResponseDate() {
        return variables.responseDate;
    }
    public string function getComment() {
        return variables.comment;
    }
    
    public user function getUser() {
        return createObject("component", "API.modules.com.Nephthys.userManager.user").init(variables.userId);
    }
    public user function getAdminUser() {
        return createObject("component", "API.modules.com.Nephthys.userManager.user").init(variables.adminUserId);
    }
    public module function getModule() {
        return createObject("component", "API.modules.com.Nephthys.moduleManager.module").init(variables.moduleId);
    }
    public permissionRole function getPermissionRole() {
        return createObject("component", "API.modules.com.Nephthys.userManager.permissionRole").init(variables.roleId);
    }
    
    public boolean function isApproved() {
        return variables.status == 1;
    }
    public boolean function isDeclined() {
        return variables.status == -1;
    }
    
    
    public request function save() {
        if(variables.requestId == 0 || variables.requestId == null) {
            variables.requestId = new Query().setSQL("INSERT INTO IcedReaper_permissionRequest_request
                                                                  (
                                                                      userId,
                                                                      moduleId,
                                                                      roleId,
                                                                      reason
                                                                  )
                                                           VALUES (
                                                                      :userId,
                                                                      :moduleId,
                                                                      :roleId,
                                                                      :reason
                                                                  );
                                                      SELECT currval('icedreaper_permissionrequest_request_requestid_seq') newRequestId;")
                                             .addParam(name = "userId",   value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "moduleId", value = variables.moduleId,       cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "roleId",   value = variables.roleId,         cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "reason",   value = variables.reason,         cfsqltype = "cf_sql_varchar")
                                             .execute()
                                             .getResult()
                                             .newRequestId[1];
        }
        
        return this;
    }
    
    public request function approve(required string comment = "") {
        new query().setSQL("UPDATE IcedReaper_permissionRequest_request
                               SET status      = 1,
                                   adminUserId = :adminUserId,
                                   comment     = :comment
                             WHERE requestId = :requestId")
                   .addParam(name = "requestId",   value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                   .addParam(name = "adminUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "comment",     value = arguments.comment,        cfsqltype = "cf_sql_varchar")
                   .execute();
        
        return this;
    }
    
    public request function decline(required string comment = "") {
        new query().setSQL("UPDATE IcedReaper_permissionRequest_request
                               SET status      = -1,
                                   adminUserId = :adminUserId,
                                   comment     = :comment
                             WHERE requestId = :requestId")
                   .addParam(name = "requestId",   value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                   .addParam(name = "adminUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "comment",     value = arguments.comment,        cfsqltype = "cf_sql_varchar")
                   .execute();
        
        return this;
    }
    
    
    private void function load() {
        if(variables.requestId != 0 && variables.requestId != null) {
            var qRequest = new Query().setSQL("SELECT *
                                                 FROM IcedReaper_permissionRequest_request
                                                WHERE requestId = :requestId")
                                      .addParam(name = "requestId", value = variables.requestId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qRequest.getRecordCount() == 1) {
                variables.userId       = qRequest.userId[1];
                variables.moduleId     = qRequest.moduleId[1];
                variables.roleId       = qRequest.roleId[1];
                variables.status       = qRequest.status[1];
                variables.reason       = qRequest.reason[1];
                variables.creationDate = qRequest.creationDate[1];
                variables.adminUserId  = qRequest.adminUserId[1];
                variables.responseDate = qRequest.responseDate[1];
                variables.comment      = qRequest.comment[1];
            }
            else {
                throw(type = "nephthys.notFound.general", message = "Conversation could not be found");
            }
        }
        else {
            variables.userId       = request.user.getUserId();
            variables.moduleId     = null;
            variables.roleId       = null;
            variables.status       = 0;
            variables.reason       = "";
            variables.creationDate = now();
            variables.adminUserId  = null;
            variables.responseDate = null;
            variables.comment      = "";
        }
    }
}