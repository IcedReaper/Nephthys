component interface="API.interfaces.authenticator" {
    public authenticator function init() {
        return this;
    }
    
    public numeric function login(required string username, required string password) {
        var encryptionMethodLoader = new encryptionMethodLoader();
        var _password = encrypt(arguments.password,
                                application.system.settings.getValueOfKey("encryptionKey"),
                                encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId")));
        
        var userId = new Query().setSQL("SELECT userid
                                           FROM nephthys_user
                                          WHERE lower(username) = :username
                                            AND password        = :password
                                            AND active          = :active")
                                .addParam(name = "username", value = lCase(arguments.username), cfsqltype = "cf_sql_varchar")
                                .addParam(name = "password", value = _password,                 cfsqltype = "cf_sql_varchar")
                                .addParam(name = "active",   value = '1',                       cfsqltype = "cf_sql_bit")
                                .execute()
                                .getResult()
                                .userid[1];
        
        var successful = userId != null;
        
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
        
        return userId;
    }
}