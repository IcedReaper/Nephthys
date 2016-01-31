component {
    public extProperties function init(required numeric userId) {
        variables.userId = arguments.userId;
        variables.extProperties = {};
        
        variables.newProps     = [];
        variables.updatedProps = [];
        variables.removeProps  = [];
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public extProperties function set(required string key, required string value, required boolean public) {
        if(variables.extProperties.keyExists(arguments.key)) {
            variables.extProperties[arguments.key].value  = arguments.value;
            variables.extProperties[arguments.key].public = arguments.public;
            
            variables.updatedProps.append(arguments.key);
        }
        else {
            var extPropertyKey = new extPropertyKey(keyName=arguments.key);
            
            variables.extProperties[arguments.key] = {
                extPropertyId    = 0,
                extPropertyKeyid = extPropertyKey.getExtPropertyKeyId(),
                public           = arguments.public,
                value            = arguments.value,
                description      = extPropertyKey.getDescription()
            };
            
            variables.newProps.append(arguments.key);
        }
        
        return this;
    }
    public extProperties function setValue(required string key, required string value) {
        if(variables.extProperties.keyExists(arguments.key)) {
            variables.extProperties[arguments.key].value  = arguments.value;
            
            variables.updatedProps.append(arguments.key);
        }
        else {
            set(arguments.key, arguments.value, false);
        }
        
        return this;
    }
    public extProperties function setPublic(required string key, required string public) {
        if(variables.extProperties.keyExists(arguments.key)) {
            variables.extProperties[arguments.key].public  = arguments.public;
            
            variables.updatedProps.append(arguments.key);
        }
        else {
            set(arguments.key, "", arguments.public);
        }
        
        return this;
    }
    
    public extProperties function remove(required string key) {
        if(variables.extProperties.keyExists(arguments.key)) {
            variables.removeProps.append(variables.extProperties[arguments.key].extPropertyId);
            variables.extProperties.delete(arguments.key);
        }
        return this;
    }
    
    // GETTER
    public struct function get(required string key, boolean onlyPublic = true) {
        if(variables.extProperties.keyExists(arguments.key)) {
            if(! arguments.onlyPublic || arguments.onlyPublic && variables.extProperties[arguments.key].public) {
                return {
                    extPropertyId = variables.extProperties[arguments.key].extPropertyId,
                    public        = variables.extProperties[arguments.key].public,
                    value         = variables.extProperties[arguments.key].value,
                    description   = variables.extProperties[arguments.key].description
                };
            }
            else {
                return {};
            }
        }
        else {
            return {};
        }
    }
    public string function getValue(required string key, boolean onlyPublic = true) {
        if(variables.extProperties.keyExists(arguments.key)) {
            if(! arguments.onlyPublic || arguments.onlyPublic && variables.extProperties[arguments.key].public) {
                return variables.extProperties[arguments.key].value;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
    }
    public string function getDescription(required string key, boolean onlyPublic = true) {
        if(variables.extProperties.keyExists(arguments.key)) {
            if(! arguments.onlyPublic || arguments.onlyPublic && variables.extProperties[arguments.key].public) {
                return variables.extProperties[arguments.key].description;
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
    }
    
    public array function getAll(boolean onlyPublic = true) {
        var properties = [];
        for(var key in variables.extProperties) {
            if(! arguments.onlyPublic || arguments.onlyPublic && variables.extProperties[key].public) {
                properties.append({
                    extPropertyId = variables.extProperties[key].extPropertyId,
                    public        = variables.extProperties[key].public,
                    value         = variables.extProperties[key].value,
                    description   = variables.extProperties[key].description
                });
            }
        }
        
        return properties;
    }
    
    public struct function getAllDetailed() {
        return duplicate(variables.extProperties);
    }
    
    // CRUD
    public extProperties function save() {
        if(variables.userId != 0 && variables.userId != null) {
            transaction {
                for(var prop in variables.newProps) {
                    var newId = new Query().setSQL("INSERT INTO nephthys_user_extProperty
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
                                                   SELECT currval('seq_nephthys_user_extProperty_id' :: regclass) newId;")
                                           .addParam(name = "userId",           value = variables.userId,                               cfsqltype = "cf_sql_numeric")
                                           .addParam(name = "extPropertyKeyId", value = variables.extProperties[prop].extPropertyKeyid, cfsqltype = "cf_sql_numeric")
                                           .addParam(name = "value",            value = variables.extProperties[prop].value,            cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "public",           value = variables.extProperties[prop].public,           cfsqltype = "cf_sql_bit")
                                           .execute()
                                           .getResult()
                                           .newId[1];
                    
                    variables.extProperties[prop].extPropertyId = newId;
                }
                variables.newProps.clear();
                
                for(var prop in variables.updatedProps) {
                    new Query().setSQL("UPDATE nephthys_user_extProperty
                                           SET value  = :value,
                                               public = :public
                                         WHERE extPropertyId = :extPropertyId
                                           AND userId        = :userId")
                              .addParam(name = "value",         value = variables.extProperties[prop].value,         cfsqltype = "cf_sql_varchar")
                              .addParam(name = "public",        value = variables.extProperties[prop].public,        cfsqltype = "cf_sql_bit")
                              .addParam(name = "extPropertyId", value = variables.extProperties[prop].extPropertyId, cfsqltype = "cf_sql_numeric")
                              .addParam(name = "userId",        value = variables.userId,                            cfsqltype = "cf_sql_numeric")
                              .execute();
                }
                variables.updatedProps.clear();
                
                for(var extPropertyId in variables.removeProps) {
                    new Query().setSQL("DELETE FROM nephthys_user_extProperty
                                              WHERE extPropertyId = :extPropertyId
                                                AND userId        = :userId")
                              .addParam(name = "extPropertyId", value = extPropertyId,    cfsqltype = "cf_sql_numeric")
                              .addParam(name = "userId",        value = variables.userId, cfsqltype = "cf_sql_numeric")
                              .execute();
                }
                variables.removeProps.clear();
                
                transactionCommit();
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot save the extended user properties to an undefined user");
        }
        
        return this;
    }
    
    // PRIVATE
    private void function loadDetails() {
        if(variables.userId != 0 && variables.userId != null) {
            var qExtProperty = new Query().setSQL("    SELECT ep.extPropertyId,
                                                              ep.extPropertyKeyid,
                                                              ep.value,
                                                              ep.public,
                                                              epk.keyName,
                                                              epk.description
                                                           FROM nephthys_user_extProperty ep
                                                     INNER JOIN nephthys_user_extPropertyKey epk ON ep.extPropertyKeyId = epk.extPropertyKeyId
                                                          WHERE ep.userId = :userId")
                                            .addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult();
            
            for(var i = 1; i <= qExtProperty.getRecordCount(); ++i) {
                variables.extProperties[qExtProperty.keyName[i]] = {
                    extPropertyId    = qExtProperty.extPropertyId[i],
                    extPropertyKeyid = qExtProperty.extPropertyKeyid[i],
                    public           = qExtProperty.public[i],
                    value            = qExtProperty.value[i],
                    description      = qExtProperty.description[i]
                };
            }
        }
    }
}