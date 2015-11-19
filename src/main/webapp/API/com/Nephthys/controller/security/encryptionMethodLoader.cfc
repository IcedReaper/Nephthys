component {
    public encryptionMethodLoader function init() {
        return this;
    }
    
    public array function getEncryptionMethods(required numeric active = 1) {
        var qryEncryptionMethods = new Query();
        var sql = "SELECT encryptionMethodId,
                          algorithm
                     FROM nephthys_encryptionMethod";
        
        if(arguments.active != 0) {
            sql &= " WHERE active = :active";
            qryEncryptionMethods.addParam(name = "active", value = arguments.active, cfsqltype = "cf_sql_bit");
        }
        
        sql &= " ORDER BY algorithm ASC";
        
        var qEncryptionMethods = qryEncryptionMethods.setSQL(sql)
                                                     .execute()
                                                     .getResult();
        
        var encryptionMethods = [];
        for(var i = 1; i <= qEncryptionMethods.getRecordCount(); i++) {
            encryptionMethods.append({
                    "encryptionMethodId" = qEncryptionMethods.encryptionMethodId[i],
                    "algorithm"          = qEncryptionMethods.algorithm[i]
                });
        }
        
        return encryptionMethods;
    }
    
    public string function getAlgorithm(required numeric encryptionMethodId) {
        return new Query().setSQL("SELECT algorithm
                                     FROM nephthys_encryptionMethod
                                    WHERE encryptionMethodId = :encryptionMethodId")
                          .addParam(name = "encryptionMethodId", value = arguments.encryptionMethodId, cfsqltype = "cf_sql_numeric")
                          .execute()
                          .getResult()
                          .algorithm[1];
    }
}