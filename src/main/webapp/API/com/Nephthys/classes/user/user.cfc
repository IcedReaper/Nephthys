component {
    public user function init(numeric userId = 0) {
        variables.userId = arguments.userId;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public user function setUserName(required string userName) {
        variables.userName = arguments.userName;
        
        return this;
    }
    public user function setEmail(required string email) {
        variables.email = arguments.email;
        
        return this;
    }
    public user function setPassword(required string password) {
        variables.password = arguments.password
        
        return this;
    }
    public user function setActiveStatus(required numeric active) {
        variables.active = arguments.active;
        
        return this;
    }
    
    public user function uploadAvatar() {
        if(variables.userId != 0) {
            variables.oldAvatarFilename = variables.avatarFilename;
            
            var uploaded = fileUpload(expandPath("/upload/com.Nephthys.user/avatar/"), "avatar", "image/*", "MakeUnique");
            
            var imageFunctionCtrl = createObject("component", "API.com.Nephthys.controller.tools.imageFunctions");
            imageFunctionCtrl.resize(expandPath("/upload/com.Nephthys.user/avatar/") & uploaded.serverFile, 1024);
            
            variables.avatarFilename = uploaded.serverFile;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot upload an avatar to a non existing user.");
        }
        
        return this;
    }
    
    // G E T T E R
    public numeric function getUserId() {
        return variables.userId;
    }
    public string function getUserName() {
        return variables.userName;
    }
    public string function getEmail() {
        return variables.eMail;
    }
    public string function getPassword() {
        return variables.password; // todo: check for security reasons
    }
    public theme function getTheme() {
        if(! structKeyExists(variables, "theme")) {
            variables.theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(variables.themeId);
        }
        return theme;
    }
    public numeric function getActiveStatus() {
        return variables.active;
    }
    public date function getRegistrationDate() {
        return variables.registrationDate;
    }
    public string function getAvatarFilename() {
        return variables.avatarFilename;
    }
    public string function getAvatarPath() {
        if(variables.userId != 0 && variables.userId != null) {
            return "/upload/com.Nephthys.user/avatar/" & variables.avatarFilename;
        }
        else {
            return "/upload/com.Nephthys.user/avatar/anonymous.jpg";
        }
    }
    
    public boolean function hasPermission(required string moduleName, string roleName = "") {
        if(variables.userId == 0 || variables.userId == null)
            return false;
        
        var permissionHandler = createObject("component", "API.com.Nephthys.controller.security.permissionHandler").init();
        
        return permissionHandler.hasPermission(variables.userId, arguments.moduleName, arguments.roleName);
    }
    
    // C R U D
    public user function save() {
        if(variables.userId == 0) { // create a new user
            variables.userId = new Query().setSQL("INSERT INTO nephthys_user
                                                               (
                                                                   userName,
                                                                   eMail,
                                                                   password,
                                                                   active,
                                                                   themeId,
                                                                   avatarFilename
                                                               )
                                                        VALUES (
                                                                   :userName,
                                                                   :eMail,
                                                                   :password,
                                                                   :active,
                                                                   :themeId,
                                                                   :avatarFilename
                                                               );
                                                  SELECT currval('seq_nephthys_user_id' :: regclass) newUserId;") // directly loading the current value of the sequence
                                          .addParam(name = "userName",       value = variables.userName,                              cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "eMail",          value = variables.eMail,                                 cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "password",       value = variables.password,                              cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "active",         value = variables.active,                                cfsqltype = "cf_sql_bit")
                                          .addParam(name = "themeId",        value = application.system.settings.getDefaultThemeId(), cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "avatarFilename", value = variables.avatarFilename,                        cfsqltype = "cf_sql_varchar")
                                          .execute()
                                          .getResult()
                                          .newUserId[1];
        }
        else { // update an existing user
            new Query().setSQL("UPDATE nephthys_user 
                                   SET email          = :eMail,
                                       password       = :password,
                                       active         = :active,
                                       avatarFilename = :avatarFilename
                                 WHERE userId = :userId")
                       .addParam(name = "userId",         value = variables.userId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "eMail",          value = variables.eMail,          cfsqltype = "cf_sql_varchar")
                       .addParam(name = "password",       value = variables.password,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",         value = variables.active,         cfsqltype = "cf_sql_bit")
                       .addParam(name = "avatarFilename", value = variables.avatarFilename, cfsqltype = "cf_sql_varchar")
                       .execute();
            
            if(structKeyExists(variables, "oldAvatarFilename") && oldAvatarFilename != "" && fileExists(expandPath("/upload/com.Nephthys.user/avatar/") & oldAvatarFilename)) {
                fileDelete(expandPath("/upload/com.Nephthys.user/avatar/") & oldAvatarFilename);
            }
        }
        return this;
    }
    
    public void function delete() {
        // todo: implement a check if the user has done something yet.
        // todo: if the user has done something yet, change the user to anonymous
        new Query().setSQL("DELETE
                              FROM nephthys_user
                             WHERE userId = :userId ")
                   .addParam(name = "userId", value = variables.userId, cfsqltype="cf_sql_numeric")
                   .execute();
        
        variables.userId = -1; // user isn't existing anymore... // todo: change this to delete the calling struct - if possible
    }
    
    // I N T E R N A L
    private void function loadDetails() {
        if(variables.userId != 0 && variables.userId != null) {
            var qUser = new Query().setSQL("SELECT *
                                              FROM nephthys_user
                                             WHERE userId = :userId")
                                   .addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric")
                                   .execute()
                                   .getResult()
            
            if(qUser.getRecordCount() == 1) {
                variables.userName         = qUser.username[1];
                variables.eMail            = qUser.email[1];
                variables.active           = qUser.active[1];
                variables.password         = qUser.password[1];
                variables.registrationDate = qUser.registrationDate[1];
                variables.avatarFilename   = qUser.avatarFilename[1];
                variables.themeId          = qUser.themeId[1];
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Could not find user by ID ", detail = variables.userId);
            }
        }
        else {
            variables.userName         = "Not registrated";
            variables.eMail            = "";
            variables.password         = "";
            variables.active           = 0;
            variables.registrationDate = now();
            variables.themeId          = application.system.settings.getDefaultThemeId();
            variables.avatarFilename   = "anonymous.jpg"; // todo
        }
        
        variables.extendedProperties = createObject("component", "extendedProperties").init(variables.userId);
    }
}