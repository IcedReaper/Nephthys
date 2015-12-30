component {
    public theme function init(required numeric themeId) {
        variables.themeId = arguments.themeId;
        
        loadDetails();
        
        return this;
    }
    
    // S E T T E R
    public theme function setName(required string name) {
        variables.name = arguments.name;
        
        return this;
    }
    public theme function setActiveStatus(required numeric active) {
        variables.active = arguments.active;
        
        return this;
    }
    
    public theme function uploadAsZip(required string folderName) {
        if(variables.themeId == 0) {
            // upload, unzip and install the theme
            var tmpDirectory = expandPath("/upload/theme/");
            var destFolder   = tmpDirectory & arguments.folderName;
            
            var uploadedAdminThemePath = "/src/main/webapp/ADMIN/themes/" & arguments.folderName;
            var uplodedWwwThemePath    = "/src/main/webapp/WWW/themes/" & arguments.folderName;
            var adminThemePath         = expandPath("/ADMIN/themes/" & arguments.folderName);
            var wwwThemePath           = expandPath("/WWW/themes/" & arguments.folderName);
            
            if(directoryExists(adminThemePath) || directoryExists(wwwThemePath)) {
                throw(type = "nephthys.application.alreadyExists", message = "One of the target folders already exists!");
            }
            
            directoryCreate(tmpDirectory, true, true);
            
            var uploaded = fileUpload(tmpDirectory, "file");
            try {
                if(uploaded.fileWasSaved) {
                    directoryCreate(destFolder);
                    
                    zip action      = "unzip"
                        //charset     = "UTF-8"
                        file        = tmpDirectory & uploaded.serverFile
                        destination = destFolder
                        overwrite   = true
                        recurse     = true;
                    
                    directoryCopy(destFolder & uploadedAdminThemePath, adminThemePath, true, "*", true);
                    directoryCopy(destFolder & uplodedWwwThemePath, wwwThemePath, true, "*", true);
                    
                    fileDelete(tmpDirectory & uploaded.serverFile);
                    directoryDelete(tmpDirectory, true);
                    
                    variables.folderName = arguments.folderName;
                    
                    var avatarFiles = directoryList(destFolder & uplodedWwwThemePath & "/img/", false, "name", "anonymous.*");
                    if(avatarFiles.len() > 0) {
                        variables.anonymousAvatarFilename = avatarFiles[1];
                    }
                    else {
                        variables.anonymousAvatarFilename = "anonymous.png";
                    }
                }
                else {
                    throw(type = "nephthys.application.uploadFailed", message = "The file could not be saved");
                }
            }
            catch(any e) {
                directoryDelete(tmpDirectory, true);
                
                throw(object=e);
            }
        }
        else {
            // further todo: update
            throw(type = "nephthys.application.notAllowed", message = "It is not allowed to overwrite an existing theme");
        }
        
        return this;
    }
    
    // G E T T E R
    public numeric function getThemeId() {
        return variables.themeId;
    }
    public string function getName() {
        return variables.name;
    }
    public numeric function getActiveStatus() {
        return variables.active;
    }
    public string function getFolderName() {
        return variables.folderName;
    }
    public string function getAnonymousAvatarFilename() {
        return variables.anonymousAvatarFilename;
    }
    
    // C R U D
    public theme function save() {
        if(variables.themeId == 0) {
            variables.themeId = new Query().setSQL("INSERT INTO nephthys_theme
                                                                (
                                                                    name,
                                                                    active,
                                                                    folderName,
                                                                    anonymousAvatarFilename
                                                                )
                                                         VALUES (
                                                                    :name,
                                                                    :active,
                                                                    :folderName,
                                                                    :anonymousAvatarFilename
                                                                );
                                                     SELECT last_value newThemeId FROM seq_nephthys_theme_id;")
                                           .addParam(name = "name",                    value = variables.name,                    cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "active",                  value = variables.active,                  cfsqltype = "cf_sql_bit")
                                           .addParam(name = "folderName",              value = variables.folderName,              cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "anonymousAvatarFilename", value = variables.anonymousAvatarFilename, cfsqltype = "cf_sql_varchar")
                                           .execute()
                                           .getResult()
                                           .newThemeId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_theme
                                   SET name       = :name,
                                       active     = :active,
                                       folderName = :folderName
                                 WHERE themeId = :themeId")
                       .addParam(name = "themeId",    value = variables.themeId,    cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",       value = variables.name,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",     value = variables.active,     cfsqltype = "cf_sql_bit")
                       .addParam(name = "folderName", value = variables.folderName, cfsqltype = "cf_sql_varchar")
                       .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_theme
                                   WHERE themeId = :themeId")
                   .addParam(name = "themeId", value = variables.themeId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        directoryDelete("/ADMIN/themes/" & variables.folderName, true);
        directoryDelete("/WWW/themes/" & variables.folderName, true);
    }
    
    // I N T E R N A L
    
    private void function loadDetails() {
        if(variables.themeId != 0 && variables.themeId != null) {
            var qTheme = new Query().setSQL("SELECT *
                                               FROM nephthys_theme
                                              WHERE themeId = :themeId")
                                    .addParam(name = "themeId", value = variables.themeId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qTheme.getRecordCount() == 1) {
                variables.name                    = qTheme.name[1];
                variables.active                  = qTheme.active[1];
                variables.folderName              = qTheme.folderName[1];
                variables.anonymousAvatarFilename = qTheme.AnonymousAvatarFilename[1];
            }
            else {
                throw(type = "themeNotFound", message = "The Theme could not be found", detail = variables.themeId);
            }
        }
        else {
            variables.name                    = "";
            variables.active                  = false;
            variables.folderName              = "";
            variables.anonymousAvatarFilename = null;
        }
    }
}