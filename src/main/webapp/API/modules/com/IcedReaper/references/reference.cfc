component {
    import "API.modules.com.Nephthys.userManager.user";
    
    public reference function init(required numeric referenceId) {
        variables.referenceId = arguments.referenceId;
        
        variables.oldImageName = "";
        variables.imageFolder = "/upload/com.IcedReaper.references/";
        
        load();
        
        return this;
    }
    
    public reference function setName(required string name) {
        variables.name = arguments.name;
        return this;
    }
    public reference function setSince(required date since) {
        variables.since = arguments.since;
        return this;
    }
    public reference function setQuote(required string quote) {
        variables.quote = arguments.quote;
        return this;
    }
    public reference function setHomepage(required string homepage) {
        variables.homepage = arguments.homepage;
        return this;
    }
    public reference function setPosition(required numeric position) {
        variables.position = arguments.position;
        return this;
    }
    
    public reference function uploadNewImage() {
        if(variables.referenceId != 0 && variables.referenceId != null) {
            variables.oldimageName = variables.imageName;
            
            if(! directoryExists(variables.imageFolder)) {
                directoryCreate(expandPath(variables.imageFolder));
            }
            
            if(form.keyExists("newImage")) {
                var uploaded = fileUpload(expandPath(variables.imageFolder), "newImage", "image/*", "MakeUnique");
                if(uploaded.fileWasSaved) {
                    if(isImageFile(expandPath(variables.imageFolder) & uploaded.serverFile)) {
                        var imageFunctionCtrl = application.system.settings.getValueOfKey("imageEditLibrary");
                        imageFunctionCtrl.resize(expandPath(variables.imageFolder) & uploaded.serverFile, 512);
                        
                        variables.imageName = uploaded.serverFile;
                    }
                    else {
                        fileDelete(expandPath(variables.imageFolder) & uploaded.serverFile);
                        throw(type = "nephthys.application.invalidResource", message = "The new image was not an image");
                    }
                }
                else {
                    throw(type = "nephthys.application.uploadFailed", message = "Fehler während des Uploads");
                }
            }
            else {
                throw(type = "nephthys.application.uploadFailed", message = "Form.image not found", detail = serializeJSON(form));
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot upload an image to a non existing user.");
        }
        
        return this;
    }
    
    
    public numeric function getReferenceId() {
        return variables.referenceId;
    }
    public string function getName() {
        return variables.name;
    }
    public any function getSince() {
        return variables.since;
    }
    public string function getQuote() {
        return variables.quote;
    }
    public string function getHomepage() {
        return variables.homepage;
    }
    public string function getimageName() {
        return variables.imageName;
    }
    public string function getImagePath() {
        return variables.imageFolder & variables.imageName;
    }
    public numeric function getPosition() {
        return variables.position;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    
    public reference function save(required user user) {
        var qSave = new Query().addParam(name = "name",             value = variables.name,                   cfsqltype = "cf_sql_varchar")
                               .addParam(name = "since",            value = variables.since,                  cfsqltype = "cf_sql_timestamp")
                               .addParam(name = "quote",            value = variables.quote,                  cfsqltype = "cf_sql_varchar")
                               .addParam(name = "homepage",         value = variables.homepage,               cfsqltype = "cf_sql_varchar")
                               .addParam(name = "imageName",        value = variables.imageName,              cfsqltype = "cf_sql_varchar")
                               .addParam(name = "position",         value = variables.position,               cfsqltype = "cf_sql_numeric")
                               .addParam(name = "creatorUserId",    value = variables.creator.getUserId(),    cfsqltype = "cf_sql_numeric")
                               .addParam(name = "creationDate",     value = variables.creationDate,           cfsqltype = "cf_sql_timestamp")
                               .addParam(name = "lastEditorUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "lastEditDate",     value = variables.lastEditDate,           cfsqltype = "cf_sql_timestamp");
        
        if(variables.referenceId == null || variables.referenceId == 0) {
            variables.referenceId = qSave.setSQL("INSERT INTO IcedReaper_references_reference
                                                              (
                                                                  name,
                                                                  since,
                                                                  quote,
                                                                  homepage,
                                                                  imageName,
                                                                  position,
                                                                  creatorUserId,
                                                                  creationDate,
                                                                  lastEditorUserId,
                                                                  lastEditDate
                                                              )
                                                       VALUES (
                                                                  :name,
                                                                  :since,
                                                                  :quote,
                                                                  :homepage,
                                                                  :imageName,
                                                                  :position,
                                                                  :creatorUserId,
                                                                  :creationDate,
                                                                  :lastEditorUserId,
                                                                  :lastEditDate
                                                              );
                                                  SELECT currval('icedreaper_references_reference_referenceid_seq') newReferenceId;")
                                         .execute()
                                         .getResult()
                                         .newReferenceId[1];
        }
        else {
            qSave.setSQL("UPDATE IcedReaper_references_reference
                             SET name             = :name,
                                 since            = :since,
                                 quote            = :quote,
                                 homepage         = :homepage,
                                 imageName        = :imageName,
                                 position         = :position,
                                 lastEditorUserId = :lastEditorUserId,
                                 lastEditDate     = now()
                           WHERE referenceId = :referenceId ")
                 .addParam(name = "referenceId", value = variables.referenceId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        if(variables.oldImageName != "") {
            fileDelete(expandPath(variables.imageeFolder & variables.oldImageName));
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        fileDelete(expandPath(variables.imageeFolder & variables.imageName));
        
        new Query().setSQL("DELETE FROM IcedReaper_references_reference
                                  WHERE referenceId = :referenceId")
                   .addParam(name = "referenceId", value = variables.referenceId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    
    private void function load() {
        if(variables.referenceId != null && variables.referenceId != 0) {
            var qGetReference = new Query().setSQL("SELECT *
                                                      FROM IcedReaper_references_reference
                                                     WHERE referenceId = :referenceId")
                                           .addParam(name = "referenceId", value = variables.referenceId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult();
            
            if(qGetReference.getRecordCount() == 1) {
                variables.name         = qGetReference.name[1];
                variables.since        = qGetReference.since[1];
                variables.quote        = qGetReference.quote[1];
                variables.homepage     = qGetReference.homepage[1];
                variables.imageName    = qGetReference.imageName[1];
                variables.position     = qGetReference.position[1];
                variables.creator      = new user(qGetReference.creatorUserId[1]);
                variables.creationDate = qGetReference.creationDate[1];
                variables.lastEditor   = new user(qGetReference.lastEditorUserId[1]);
                variables.lastEditDate = qGetReference.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.reference.notFound", message = "The reference could not be found", detail = variables.referenceId);
            }
        }
        else {
            variables.name      = "";
            variables.since     = now();
            variables.quote     = "";
            variables.homepage  = "";
            variables.imageName = "";
            
            variables.position = new filter().for("reference").execute().getResultCount() + 1;
            
            variables.creator      = request.user;
            variables.creationDate = now();
            variables.lastEditor   = request.user;
            variables.lastEditDate = now();
        }
    }
}