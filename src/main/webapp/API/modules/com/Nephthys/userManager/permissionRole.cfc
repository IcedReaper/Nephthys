component {
    public permissionRole function init(required numeric permissionRoleId) {
        variables.permissionRoleId = arguments.permissionRoleId;
        
        load();
        
        return this;
    }
    
    public permissionRole function setName(required string name) {
        if(variables.permissionRoleId == null) {
            variables.name = arguments.name;
        }
        return this;
    }
    public permissionRole function setValue(required numeric value) {
        if(variables.permissionRoleId == null) {
            variables.value = arguments.value;
        }
        return this;
    }
    
    
    public numeric function getpermissionRoleId() {
        return variables.permissionRoleId;
    }
    public string function getName() {
        return variables.name;
    }
    public numeric function getValue() {
        return variables.value;
    }
    
    
    public permissionRole function save(required user user) {
        if(variables.permissionRoleId == null) {
            variables.permissionRoleId = new Query().setSQL("INSERT INTO nephthys_user_permissionRole
                                                                           (
                                                                               name,
                                                                               value
                                                                           )
                                                                    VALUES (
                                                                               :name,
                                                                               :value
                                                                           );
                                                              SELECT currval('nephthys_user_permissionrole_permissionroleid_seq') newPermissionRoleId;")
                                                    .addParam(name = "name",  value = variables.name,  cfsqltype = "cf_sql_varchar")
                                                    .addParam(name = "value", value = variables.value, cfsqltype = "cf_sql_varchar")
                                                    .execute()
                                                    .getResult()
                                                    .newPermissionRoleId[1];
        }
        
        return this;
    }
    
    
    private void function load() {
        if(variables.permissionRoleId != null) {
            var qGetRole = new Query().setSQL("SELECT *
                                                 FROM nephthys_user_permissionRole
                                                WHERE permissionRoleId = :permissionRoleId")
                                      .addParam(name = "permissionRoleId", value = variables.permissionRoleId, cfsqltype = "cf_sql_numeric")
                                      .execute()
                                      .getResult();
            
            if(qGetRole.getRecordCount() == 1) {
                variables.name  = qGetRole.name[1];
                variables.value = qGetRole.value[1];
            }
            else {
                throw(type = "nephthys.notFound.role", message = "Could not find permission role by ID ", detail = variables.permissionRoleId);
            }
        }
        else {
            variables.name  = "";
            variables.value = "";
        }
    }
}