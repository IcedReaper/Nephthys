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
    
    public category function setCreator(required user creator) {
        variables.creator = arguments.creator;
        return this;
    }
    public category function setLastEditor(required user lastEditor) {
        variables.lastEditor = arguments.lastEditor;
        return this;
    }
    
    
    public numeric function getGenreId() {
        return variables.genreId;
    }
    public string function getName() {
        return variables.name;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public date function getlastEditDate() {
        return variables.lastEditDate;
    }
    
    public genre function save(required user user) {
        var qSave = new Query().addParam(name = "name",   value = variables.name,             cfsqltype = "cf_sql_varchar")
                               .addParam(name = "userId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric");
        
        if(variables.genreId == null) {
            variables.genreId = qSave.setSQL("INSERT INTO IcedReaper_review_genre
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
                                     .execute()
                                     .getResult()
                                     .newGenreId[1];
            
            variables.creator = arguments.user;
            variables.creationDate = now();
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        else {
            qSave.setSQL("UPDATE IcedReaper_review_genre
                             SET name             = :name,
                                 lastEditorUserId = :userId,
                                 lastEditDate     = now()
                           WHERE genreId = :genreId")
                 .addParam(name = "genreId", value = variables.genreId, cfsqltype = "cf_sql_numeric")
                 .execute();
            
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        
        return this;
    }
    
    public void function delete(required user user) {
        new Query().setSQL("DELETE
                              FROM IcedReaper_review_genre
                             WHERE genreId = :genreId")
                   .addParam(name = "genreId", value = variables.genreId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.genreId = null;
    }
    
    private void function loadDetails() {
        if(variables.genreId != null) {
            var qGenre = new Query().setSQL("SELECT *
                                               FROM IcedReaper_review_genre
                                              WHERE genreId = :genreId")
                                    .addParam(name = "genreId", value = variables.genreId, cfsqltype = "cf_sql_numeric")
                                    .execute()
                                    .getResult();
            
            if(qGenre.getRecordCount() == 1) {
                variables.name         = qGenre.name[1];
                variables.creator      = new user(qGenre.creatorUserId[1]);
                variables.creationDate = qGenre.creationDate[1];
                variables.lastEditor   = new user(qGenre.lastEditorUserId[1]);
                variables.lastEditDate = qGenre.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.review.notFound", message = "The genre could not be found", detail = variables.genreId);
            }
        }
        else {
            variables.name         = "";
            variables.creator      = new user(null);
            variables.creationDate = now();
            variables.lastEditor   = new user(null);
            variables.lastEditDate = now();
        }
    }
}