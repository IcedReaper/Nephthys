component {
    public extProperty function init(required numeric extPropertyId) {
        variables.extPropertyId = arguments.extPropertyId;
        
        variables.attributesChanged = false;
        
        load();
        
        return this;
    }
    
    
    public extProperty function setUser(required user user) {
        if(variables.extPropertyId == null) {
            variables.user = arguments.user;
        }
        return this;
    }
    public extProperty function setExtPropertyKey(required extPropertyKey extPropertyKey) {
        if(variables.extPropertyId == null) {
            variables.extPropertyKey = arguments.extPropertyKey;
        }
        return this;
    }
    
    public extProperty function setValue(required string value) {
        variables.attributesChanged = (variables.value != arguments.value);
        
        variables.value = arguments.value;
        return this;
    }
    public extProperty function setPublic(required boolean public) {
        variables.attributesChanged = (variables.public != arguments.public);
        
        variables.public = arguments.public;
        return this;
    }
    
    
    public numeric function getExtPropertyId() {
        return variables.extPropertyId;
    }
    public user function getUser() {
        return variables.user;
    }
    public string function getValue() {
        return variables.value;
    }
    public boolean function getPublic() {
        return variables.public == 1;
    }
    public extPropertyKey function getExtPropertyKey() {
        return variables.extPropertyKey;
    }
    
    
    public extProperty function save() {
        var qSave = new Query().addParam(name = "userId",           value = variables.user.getUserId(),                     cfsqltype = "cf_sql_numeric")
                               .addParam(name = "extPropertyKeyId", value = variables.extPropertyKey.getExtPropertyKeyId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "value",            value = variables.value,                                cfsqltype = "cf_sql_varchar")
                               .addParam(name = "public",           value = variables.public,                               cfsqltype = "cf_sql_bit");
        if(variables.extPropertyId == null) {
            var extPropertyId = qSave.setSQL("INSERT INTO nephthys_user_extProperty
                                                          (
                                                              userId,
                                                              extPropertyKeyId,
                                                              value,
                                                              public
                                                          )
                                                   VALUES (
                                                              :userId,
                                                              :extPropertyKeyId,
                                                              :value,
                                                              :public
                                                          );
                                              SELECT currval('seq_nephthys_user_extproperty_id') extPropertyId;")
                                     .execute()
                                     .getResult()
                                     .extPropertyId[1];
        }
        else {
            if(variables.attributesChanged) {
                qSave.setSQL("UPDATE nephthys_user_extProperty
                                 SET value  = :value,
                                     public = :public
                               WHERE extPropertyId = :extPropertyId")
                     .addParam(name = "extPropertyId", value = variables.extPropertyId, cfsqltype = "cf_sql_numeric")
                     .execute();
            }
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_user_extProperty
                                  WHERE extPropertyId = :extPropertyId")
                   .addParam(name = "extPropertyId", value = variables.extPropertyId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    private void function load() {
        if(variables.extPropertyId != null) {
            var qExtProperty = new Query().setSQL("SELECT *
                                                     FROM nephthys_user_extProperty
                                                    WHERE extPropertyId = :extPropertyId")
                                          .addParam(name = "extPropertyId", value = variables.extPropertyId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qExtProperty.getRecordCount() == 1) {
                variables.user           = new user(qExtProperty.userId[1]);
                variables.value          = qExtProperty.value[1];
                variables.public         = qExtProperty.public[1];
                variables.extPropertyKey = new extPropertyKey(qExtProperty.extPropertyKeyId[1]);
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find extended property by ID ", detail = variables.extPropertyId);
            }
        }
        else {
            variables.user           = null;
            variables.value          = "";
            variables.public         = false;
            variables.extPropertyKey = null;
        }
    }
}