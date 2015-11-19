component {
    // todo: Impelment
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
    public theme function setFolderName(required string folderName) {
        variables.folderName = arguments.folderName;
        
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
    
    // C R U D
    public theme function save() {
        if(variables.themeId == 0) {
            variables.themeId = new Query().setSQL("INSERT INTO nephthys_theme
                                                                (
                                                                    name,
                                                                    active,
                                                                    foldername
                                                                )
                                                         VALUES (
                                                                    :name,
                                                                    :active,
                                                                    :foldername
                                                                );
                                                     SELECT last_value newThemeId FROM seq_nephthys_theme_id;")
                                           .addParam(name = "name",       value = variables.name,       cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "active",     value = variables.active,     cfsqltype = "cf_sql_bit")
                                           .addParam(name = "foldername", value = variables.foldername, cfsqltype = "cf_sql_varchar")
                                           .execute()
                                           .getResult()
                                           .newThemeId[1];
        }
        else {
            new Query().setSQL("UPDATE nephthys_theme
                                   SET name       = :name,
                                       active     = :active,
                                       foldername = :foldername
                                 WHERE themeId = :themeId")
                       .addParam(name = "themeId",    value = variables.themeId,    cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",       value = variables.name,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "active",     value = variables.active,     cfsqltype = "cf_sql_bit")
                       .addParam(name = "foldername", value = variables.foldername, cfsqltype = "cf_sql_varchar")
                       .execute();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM nephthys_theme
                                   WHERE themeId = :themeId")
                   .addParam(name = "themeId", value = variables.themeId, cfsqltype = "cf_sql_numeric")
                   .execute();
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
                variables.name       = qTheme.name[1];
                variables.active     = qTheme.active[1];
                variables.folderName = qTheme.folderName[1];
            }
            else {
                throw(type = "themeNotFound", message = "The Theme could not be found", detail = variables.themeId);
            }
        }
        else {
            variables.name       = "";
            variables.active     = false;
            variables.folderName = "";
        }
    }
}