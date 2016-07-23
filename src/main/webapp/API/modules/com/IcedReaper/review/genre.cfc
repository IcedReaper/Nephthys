component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public genre function init(required numeric genreId) {
        variables.genreId = arguments.genreId;
        
        loadDetails();
        
        return this;
    }
    
    public genre function setName(required string name) {
        variables.name = arguments.name;
        
        return this;
    }
    
    
    public numeric function getGenreId() {
        return variables.genreId;
    }
    public string function getName() {
        return variables.name;
    }
    public numeric function getCreatorUserId() {
        return variables.creatorUserId;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public numeric function getLastEditorUserId() {
        return variables.lastEditorUserId;
    }
    public date function getlastEditDate() {
        return variables.lastEditDate;
    }
    public user function getCreator() {
        if(! variables.keyExists("creator")) {
            variables.creator = new user(variables.creatorUserId);
        }
        return variables.creator;
    }
    public user function getLastEditor() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = new user(variables.creatorUserId);
        }
        return variables.lastEditor;
    }
    
    public genre function save() {
        if(variables.genreId == null || variables.genreId == 0) {
            variables.genreId = new Query().setSQL("INSERT INTO IcedReaper_review_genre
                                                                (
                                                                    name,
                                                                    creatorUserId,
                                                                    lastEditorUserId
                                                                )
                                                         VALUES (
                                                                    :name,
                                                                    :userId,
                                                                    :userId
                                                                );
                                                      SELECT currval('seq_icedreaper_review_genre_id') newGenreId;")
                                           .addParam(name = "name",   value = variables.name,           cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "userId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult()
                                           .newGenreId[1];
            
            variables.creatorUserId    = request.user.getUserId();
            variables.lastEditorUserId = request.user.getUserId();
            variables.creationDate     = now();
            variables.lastEditDate     = now();
        }
        else {
            new Query().setSQL("UPDATE IcedReaper_review_genre
                                   SET name = :name,
                                       lastEditorUserId = :lastEditorUserId,
                                       lastEditDate     = now()
                                 WHERE genreId = :genreId")
                       .addParam(name = "genreId",          value = variables.genreId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "name",             value = variables.name,           cfsqltype = "cf_sql_varchar")
                       .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
            
            variables.lastEditorUserId = request.user.getUserId();
            variables.lastEditDate     = now();
        }
        
        return this;
    }
    
    public void function delete() {
        new Query().setSQL("DELETE
                              FROM IcedReaper_review_genre
                             WHERE genreId = :genreId")
                   .addParam(name = "genreId", value = variables.genreId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    private void function loadDetails() {
        if(variables.genreId != null && variables.genreId != 0) {
            var qGenre = new Query().setSQL("SELECT *
                                               FROM IcedReaper_review_genre
                                              WHERE genreId = :genreId")
                                    .addParam(name = "genreId", value = variables.genreId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qGenre.getRecordCount() == 1) {
                variables.name             = qGenre.name[1];
                variables.creatorUserId    = qGenre.creatorUserId[1];
                variables.creationDate     = qGenre.creationDate[1];
                variables.lastEditorUserId = qGenre.lastEditorUserId[1];
                variables.lastEditDate     = qGenre.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.review.notFound", message = "The genre could not be found", detail = variables.genreId);
            }
        }
        else {
            variables.name             = "";
            variables.creatorUserId    = null;
            variables.creationDate     = now();
            variables.lastEditorUserId = null;
            variables.lastEditDate     = now();
        }
    }
}