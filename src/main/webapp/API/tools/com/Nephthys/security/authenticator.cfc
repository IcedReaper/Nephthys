component interface="API.interfaces.authenticator" {
    import "API.modules.com.Nephthys.userManager.*";
    
    public authenticator function init() {
        return this;
    }
    
    public numeric function login(required string username, required string password) {
        var encryptionMethodLoader = new encryptionMethodLoader();
        var _password = encrypt(arguments.password,
                                application.system.settings.getValueOfKey("encryptionKey"),
                                encryptionMethodLoader.getAlgorithm(application.system.settings.getValueOfKey("encryptionMethodId")));
        
        var user = new filter().for("user")
                               .setUsername(arguments.username)
                               .setPassword(_password)
                               .setActive(true)
                               .execute()
                               .getResult();
        
        new Query().setSQL("INSERT INTO nephthys_user_statistics
                                        (
                                            username,
                                            successful
                                        )
                                 VALUES (
                                            :username,
                                            :successful
                                        )")
                   .addParam(name = "username",   value = arguments.username, cfsqltype = "cf_sql_varchar")
                   .addParam(name = "successful", value = user.len() == 1,    cfsqltype = "cf_sql_bit")
                   .execute();
        
        return user.len() == 1 ? user[1].getUserId() : null;
    }
}