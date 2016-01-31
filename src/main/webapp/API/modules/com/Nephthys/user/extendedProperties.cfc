component {
    public extendedProperties function init(required numeric userId) {
        variables.userId = arguments.userId;
        variables.extProperties = {};
        
        variables.newProps     = [];
        variables.updatedProps = [];
        variables.removeProps  = [];
        
        loadDetails();
        
        return this;
    }
    
    public extendedProperties function add(required string key, required string value) {
        if(! variables.extProperties.keyExists(lCase(arguments.key))) {
            variables.extProperties[lCase(arguments.key)] = {
                id    = 0,
                value = arguments.value
            };
            
            variables.newProps.append(lCase(arguments.key));
        }
        else {
            update(arguments.key, arguments.value);
        }
        
        return this;
    }
    
    public extendedProperties function update(required string key, required string value) {
        if(variables.extProperties.keyExists(lCase(arguments.key))) {
            variables.extProperties[lCase(arguments.key)].value = arguments.value;
            
            variables.updatedProps.append(arguments.key);
        }
        else {
            add(arguments.key, arguments.value);
        }
        
        return this;
    }
    
    public extendedProperties function remove(required string key) {
        if(variables.extProperties.keyExists(lCase(arguments.key))) {
            var id = variables.extProperties[lCase(arguments.key)].id;
            variables.extProperties.remove(lCase(arguments.key));
            variables.removeProps.append(id);
        }
        return this;
    }
    
    
    public string function get(required string key) {
        if(variables.extProperties.keyExists(lCase(arguments.key))) {
            return variables.extProperties[lCase(arguments.key)].value;
        }
        else {
            return null;
        }
    }
    
    
    public extendedProperties function save() {
        if(variables.userId != 0 && variables.userId != null) {
            transaction {
                for(var i = 1; i <= variables.newProps.len(); ++i) {
                    var newId = new Query().setSQL("INSERT INTO nephthys_user_extProperties
                                                                (
                                                                    userId,
                                                                    key,
                                                                    value
                                                                )
                                                         VALUES (
                                                                    :userId,
                                                                    :key,
                                                                    :value
                                                                );
                                                   SELECT currval('seq_nephthys_user_extProperties_id' :: regclass) newId;")
                                           .addParam(name = "userId", value = variables.userId,                                            cfsqltype = "cf_sql_numeric")
                                           .addParam(name = "key",    value = lCase(variables.newProps[i]),                                cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "value",  value = variables.extProperties[lCase(variables.newProps[i])].value, cfsqltype = "cf_sql_varchar")
                                           .execute()
                                           .getResult()
                                           .newId[1];
                    variables.extProperties[variables.newProps[i]].id = newId;
                }
                variables.newProps.clear();
                
                for(var i = 1; i <= variables.updatedProps.len(); ++i) {
                    new Query().setSQL("UPDATE nephthys_user_extProperties
                                           SET value = :value
                                         WHERE extPropertiesId = :extPropertiesId
                                           AND userId          = :userId")
                              .addParam(name = "value",           value = variables.extProperties[lCase(variables.updatedProps[i])].value, cfsqltype = "cf_sql_varchar")
                              .addParam(name = "extPropertiesId", value = variables.extProperties[lCase(variables.updatedProps[i])].id,    cfsqltype = "cf_sql_numeric")
                              .addParam(name = "userId",          value = variables.userId,                                                cfsqltype = "cf_sql_numeric")
                              .execute();
                }
                variables.updatedProps.clear();
                
                for(var i = 1; i <= variables.removeProps.len(); ++i) {
                    new Query().setSQL("DELETE FROM nephthys_user_extProperties
                                              WHERE extPropertiesId = :extPropertiesId
                                                AND userId          = :userId")
                              .addParam(name = "extPropertiesId", value = variables.removeProps[i], cfsqltype = "cf_sql_numeric")
                              .addParam(name = "userId",          value = variables.userId,         cfsqltype = "cf_sql_numeric")
                              .execute();
                }
                variables.removeProps.clear();
                
                transactionCommit();
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot save the extended user properties to an undefined user");
        }
    }
    
    private void function loadDetails() {
        if(variables.userId != 0 && variables.userId != null) {
            var qExtProperties = new Query().setSQL("SELECT *
                                                       FROM nephthys_user_extProperties
                                                      WHERE userId = :userId")
                                            .addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            for(var i = 1; i <= qExtProperties.getRecordCount(); ++i) {
                variables.extProperties[lCase(qExtProperties.key[i])] = {
                    id    = qExtProperties.extPropertiesId[i],
                    value = qExtProperties.value[i]
                };
            }
        }
    }
}