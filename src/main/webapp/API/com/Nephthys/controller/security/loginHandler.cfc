component {
    public loginHandler function init() {
        return this;
    }
    
    public numeric function loginUser(required string username, required string password) {
        var _password = encrypt(arguments.password,
                                application.system.settings.getEncryptionKey(),
                                application.system.settings.getEncryptionAlgorithm());
        
        var userId = new Query().setSQL("SELECT userid
                                           FROM nephthys_user
                                          WHERE username = :username
                                            AND password = :password
                                            AND active   = :active")
                                .addParam(name = "username", value = arguments.username, cfsqltype = "cf_sql_varchar")
                                .addParam(name = "password", value = _password,          cfsqltype = "cf_sql_varchar")
                                .addParam(name = "active",   value = '1',                cfsqltype = "cf_sql_bit")
                                .execute()
                                .getResult()
                                .userid[1];
        
        var successful = userId != null;
        // check to move somewhero elso
        new Query().setSQL("INSERT INTO nephthys_statistics_login
                                        (
                                            username,
                                            successful
                                        )
                                 VALUES (
                                            :username,
                                            :successful
                                        )")
                   .addParam(name = "username",   value = arguments.username, cfsqltype = "cf_sql_varchar")
                   .addParam(name = "successful", value = successful,        cfsqltype = "cf_sql_bit")
                   .execute();
        
        return successful;
    }
    
    public boolean function checkForUser(numeric userId = 0, string username = "") {
        return new Query().setSQL("SELECT userid
                                     FROM nephthys_user
                                    WHERE (userId = :userId OR username = :username)
                                      AND active = :active")
                          .addParam(name = "userId",   value = arguments.userId,   cfsqltype = "cf_sql_numeric")
                          .addParam(name = "username", value = arguments.username, cfsqltype = "cf_sql_varchar")
                          .addParam(name = "active",   value = '1',                cfsqltype = "cf_sql_bit")
                          .execute()
                          .getResult()
                          .getRecordCount() == 1;
    }
}