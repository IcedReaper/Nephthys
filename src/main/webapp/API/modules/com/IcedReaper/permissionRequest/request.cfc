component {
    import "API.modules.com.Nephthys.userManager.user";
    import "API.modules.com.Nephthys.moduleManager.module";
    import "API.modules.com.Nephthys.userManager.permissionRole";
    
    public request function init(required numeric requestId = 0) {
        variables.requestId = arguments.requestId;
        
        load();
        
        return this;
    }
    
    
    public request function setModule(required module module) {
        variables.module = arguments.module;
        return this;
    }
    public request function setPermissionRole(required permissionRole permissionRole) {
        variables.permissionRole = arguments.permissionRole;
        return this;
    }
    public request function setReason(required string reason) {
        variables.reason = arguments.reason;
        return this;
    }
    
    
    public numeric function getRequestId() {
        return variables.requestId;
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
    public date function getResponseDate() {
        return variables.responseDate;
    }
    public string function getComment() {
        return variables.comment;
    }
    
    public user function getUser() {
        return variables.user;
    }
    public user function getAdminUser() {
        return variables.adminUser;
    }
    public module function getModule() {
        return variables.module;
    }
    public permissionRole function getPermissionRole() {
        return variables.permissionRole;
    }
    
    public boolean function isApproved() {
        return variables.status == 1;
    }
    public boolean function isDeclined() {
        return variables.status == -1;
    }
    
    
    public request function save(required user user) {
        if(variables.requestId == 0 || variables.requestId == null) {
            variables.requestId = new Query().setSQL("INSERT INTO IcedReaper_permissionRequest_request
                                                                  (
                                                                      userId,
                                                                      moduleId,
                                                                      permissionRoleId,
                                                                      reason
                                                                  )
                                                           VALUES (
                                                                      :userId,
                                                                      :moduleId,
                                                                      :permissionRoleId,
                                                                      :reason
                                                                  );
                                                      SELECT currval('icedreaper_permissionrequest_request_requestid_seq') newRequestId;")
                                             .addParam(name = "userId",           value = arguments.user.getUserId(),                     cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "moduleId",         value = variables.module.getModuleId(),                 cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "permissionRoleId", value = variables.permissionRole.getpermissionRoleId(), cfsqltype = "cf_sql_numeric")
                                             .addParam(name = "reason",           value = variables.reason,                               cfsqltype = "cf_sql_varchar")
                                             .execute()
                                             .getResult()
                                             .newRequestId[1];
            
            variables.user = arguments.user;
            variables.creationDate = now();
        }
        
        return this;
    }
    
    public request function approve(required user user, required string comment = "") {
        new query().setSQL("UPDATE IcedReaper_permissionRequest_request
                               SET status       = 1,
                                   adminUserId  = :adminUserId,
                                   responseDate = now(),
                                   comment      = :comment
                             WHERE requestId = :requestId")
                   .addParam(name = "requestId",   value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                   .addParam(name = "adminUserId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "comment",     value = arguments.comment,        cfsqltype = "cf_sql_varchar")
                   .execute();
        
        variables.admin = arguments.user;
        variables.responseDate = now();
        
        return this;
    }
    
    public request function decline(required user user, required string comment = "") {
        new query().setSQL("UPDATE IcedReaper_permissionRequest_request
                               SET status       = -1,
                                   adminUserId  = :adminUserId,
                                   responseDate = now(),
                                   comment      = :comment
                             WHERE requestId = :requestId")
                   .addParam(name = "requestId",   value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                   .addParam(name = "adminUserId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                   .addParam(name = "comment",     value = arguments.comment,        cfsqltype = "cf_sql_varchar")
                   .execute();
        
        variables.admin = arguments.user;
        variables.responseDate = now();
        
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
                variables.user           = new user(qRequest.userId[1]);
                variables.module         = new module(qRequest.moduleId[1]);
                variables.permissionRole = new permissionRole(qRequest.permissionRoleId[1]);
                variables.status         = qRequest.status[1];
                variables.reason         = qRequest.reason[1];
                variables.creationDate   = qRequest.creationDate[1];
                variables.admin          = new user(qRequest.adminUserId[1]);
                variables.responseDate   = qRequest.responseDate[1];
                variables.comment        = qRequest.comment[1];
            }
            else {
                throw(type = "nephthys.notFound.general", message = "Conversation could not be found");
            }
        }
        else {
            variables.user           = request.user;
            variables.module         = new module(null);
            variables.permissionRole = new permissionRole(null);
            variables.status         = 0;
            variables.reason         = "";
            variables.creationDate   = now();
            variables.admin          = new user(null);
            variables.responseDate   = null;
            variables.comment        = "";
        }
    }
}