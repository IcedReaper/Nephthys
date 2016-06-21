component {
    import "API.modules.com.Nephthys.theme.theme";
    
    public user function init(numeric userId = 0) {
        variables.userId = arguments.userId;
        
        variables.avatarFolder = "/upload/com.Nephthys.user/avatar/";
        
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
        variables.password = arguments.password;
        
        return this;
    }
    public user function setActiveStatus(required boolean active) {
        variables.active = arguments.active;
        
        return this;
    }
    public user function setWwwThemeId(required numeric wwwThemeId) {
        variables.wwwThemeId = arguments.wwwThemeId;
        variables.wwwTheme = new theme(variables.wwwThemeId);
        
        return this;
    }
    public user function setAdminThemeId(required numeric adminThemeId) {
        variables.adminThemeId = arguments.adminThemeId;
        variables.adminTheme = new theme(variables.adminThemeId);
        
        return this;
    }
    
    public user function uploadAvatar() {
        if(variables.userId != 0) {
            variables.oldAvatarFilename = variables.avatarFilename;
            
            var uploaded = fileUpload(expandPath(variables.avatarFolder), "avatar", "image/*", "MakeUnique");
            
            var imageFunctionCtrl = application.system.settings.getValueOfKey("imageEditLibrary");
            imageFunctionCtrl.resize(expandPath(variables.avatarFolder) & uploaded.serverFile, 1024);
            
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
    public numeric function getWwwThemeId() {
        return variables.wwwThemeId;
    }
    public numeric function getAdminThemeId() {
        return variables.adminThemeId;
    }
    public theme function getTheme() {
        if(! variables.keyExists("wwwTheme")) {
            variables.wwwTheme = new theme(variables.wwwThemeId);
        }
        return wwwTheme;
    }
    public theme function getWwwTheme() {
        if(! variables.keyExists("wwwTheme")) {
            variables.wwwTheme = new theme(variables.wwwThemeId);
        }
        return wwwTheme;
    }
    public theme function getAdminTheme() {
        if(! variables.keyExists("adminTheme")) {
            variables.adminTheme = new theme(variables.adminThemeId);
        }
        return adminTheme;
    }
    public boolean function getActiveStatus() {
        return variables.active == 1;
    }
    public date function getRegistrationDate() {
        return variables.registrationDate;
    }
    public string function getAvatarFilename() {
        return variables.avatarFilename;
    }
    public string function getAvatarPath(boolean returnAnonymous = true) {
        if(variables.avatarFilename != "" && variables.avatarFilename != null) {
            return variables.avatarFolder & variables.avatarFilename;
        }
        else {
            if(arguments.returnAnonymous) {
                return "/themes/"&request.user.getWwwTheme().getFolderName() & "/img/" & request.user.getWwwTheme().getAnonymousAvatarFilename();
            }
            else {
                return "";
            }
        }
    }
    
    public boolean function isActive() {
        return variables.active == 1;
    }
    public boolean function hasPermission(required string moduleName, string roleName = "") {
        if(variables.userId == 0 || variables.userId == null)
            return false;
        
        var permissionHandler = application.system.settings.getValueOfKey("permissionManager");
        
        return permissionHandler.hasPermission(variables.userId, arguments.moduleName, arguments.roleName);
    }
    
    public extProperties function getExtProperties() {
        return variables.extProperties;
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
                                                                   wwwThemeId,
                                                                   adminThemeId,
                                                                   avatarFilename
                                                               )
                                                        VALUES (
                                                                   :userName,
                                                                   :eMail,
                                                                   :password,
                                                                   :active,
                                                                   :wwwThemeId,
                                                                   :adminThemeId,
                                                                   :avatarFilename
                                                               );
                                                  SELECT currval('seq_nephthys_user_id') newUserId;") // directly loading the current value of the sequence
                                          .addParam(name = "userName",       value = variables.userName,       cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "eMail",          value = variables.eMail,          cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "password",       value = variables.password,       cfsqltype = "cf_sql_varchar")
                                          .addParam(name = "active",         value = variables.active,         cfsqltype = "cf_sql_bit")
                                          .addParam(name = "wwwThemeId",     value = variables.wwwThemeId,     cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "adminThemeId",   value = variables.adminThemeId,   cfsqltype = "cf_sql_numeric")
                                          .addParam(name = "avatarFilename", value = variables.avatarFilename, cfsqltype = "cf_sql_varchar", null = (variables.avatarFilename == "" || variables.avatarFileName == null))
                                          .execute()
                                          .getResult()
                                          .newUserId[1];
        }
        else { // update an existing user
            new Query().setSQL("UPDATE nephthys_user 
                                   SET email          = :eMail,
                                       password       = :password,
                                       active         = :active,
                                       wwwThemeId     = :wwwThemeId,
                                       adminThemeId   = :adminThemeId,
                                       avatarFilename = :avatarFilename
                                 WHERE userId = :userId")
                       .addParam(name = "userId",         value = variables.userId,         cfsqltype = "cf_sql_numeric")
                       .addParam(name = "eMail",          value = variables.eMail,          cfsqltype = "cf_sql_varchar")
                       .addParam(name = "password",       value = variables.password,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",         value = variables.active,         cfsqltype = "cf_sql_bit")
                       .addParam(name = "wwwThemeId",     value = variables.wwwThemeId,     cfsqltype = "cf_sql_numeric")
                       .addParam(name = "adminThemeId",   value = variables.adminThemeId,   cfsqltype = "cf_sql_numeric")
                       .addParam(name = "avatarFilename", value = variables.avatarFilename, cfsqltype = "cf_sql_varchar", null = (variables.avatarFilename == "" || variables.avatarFileName == null))
                       .execute();
            
            if(variables.keyExists("oldAvatarFilename") && variables.oldAvatarFilename != "" && variables.oldAvatarFilename != null && fileExists(expandPath(variables.avatarFolder) & oldAvatarFilename)) {
                fileDelete(expandPath(variables.avatarFolder) & variables.oldAvatarFilename);
            }
        }
        return this;
    }
    
    public void function delete() {
        if(fileExists(expandPath(variables.avatarFolder) & variables.avatarFilename)) {
            fileDelete(expandPath(variables.avatarFolder) & variables.avatarFilename);
        }
        
        new Query().setSQL("DELETE
                              FROM nephthys_user
                             WHERE userId = :userId ")
                   .addParam(name = "userId", value = variables.userId, cfsqltype="cf_sql_numeric")
                   .execute();
        
        variables.userId = null;
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
                variables.wwwThemeId       = qUser.wwwThemeId[1];
                variables.adminThemeId     = qUser.adminThemeId[1];
                variables.avatarFilename   = qUser.avatarFilename[1];
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
            variables.wwwThemeId       = application.system.settings.getValueOfKey("defaultWwwThemeId");
            variables.adminThemeId     = application.system.settings.getValueOfKey("defaultAdminThemeId");
            variables.avatarFilename   = null;
        }
        
        variables.extProperties = new extProperties(variables.userId);
    }
}