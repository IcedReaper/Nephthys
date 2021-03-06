component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public review function init(required numeric reviewId) {
        variables.reviewId = arguments.reviewId;
        
        variables.genreAdded = [];
        variables.genreDeleteList = [];
        
        loadDetails();
        
        return this;
    }
    
    
    public review function setType(required type type) {
        variables.type = arguments.type;
        return this;
    }
    public review function setRating(required string rating) {
        variables.rating = arguments.rating;
        return this;
    }
    public review function setDescription(required string description) {
        variables.description = arguments.description;
        return this;
    }
    public review function setHeadline(required string headline) {
        variables.headline = arguments.headline;
        return this;
    }
    public review function setIntroduction(required string introduction) {
        variables.introduction = arguments.introduction;
        return this;
    }
    public review function setReviewText(required string reviewText) {
        variables.reviewText = arguments.reviewText;
        return this;
    }
    public review function setLink(required string link) {
        variables.link = arguments.link;
        return this;
    }
    public review function addGenre(required genre genre) {
        variables.genre.append(arguments.genre);
        
        variables.genreAdded.append(arguments.genre.getGenreId());
        
        return this;
    }
    public review function addGenreById(required numeric genreId) {
        variables.genre.append(new genre(arguments.genreId));
        
        variables.genreAdded.append(arguments.genreId);
        
        return this;
    }
    
    public review function removeGenreById(required numeric genreId) {
        for(var i = 1; i <= variables.genre.len(); ++i) {
            if(variables.genre[i].getGenreId() == arguments.genreId) {
                variables.genreDeleteList.append(variables.genre[i].getGenreId());
                variables.genre.deleteAt(i);
                
                break;
            }
        }
        
        return this;
    }
    public review function removeGenreByName(required string genreName) {
        for(var i = 1; i <= variables.genre.len(); ++i) {
            if(variables.genre[i].getName() == arguments.genreName) {
                variables.genreDeleteList.append(variables.genre[i].getGenreId());
                variables.genre.deleteAt(i);
                
                break;
            }
        }
        
        return this;
    }
    public review function uploadImage() {
        if(variables.reviewId != null) {
            variables.oldImagePath = variables.imagePath;
            
            var uploaded = fileUpload(expandPath("/upload/com.IcedReaper.review/"), "image", "image/*", "MakeUnique");
            
            var imageFunctionCtrl = application.system.settings.getValueOfKey("imageEditLibrary");
            imageFunctionCtrl.resize(expandPath("/upload/com.IcedReaper.review/" & uploaded.serverFile), 1024);
            imageFunctionCtrl.resize(expandPath("/upload/com.IcedReaper.review/" & uploaded.serverFile), 400, expandPath("/upload/com.IcedReaper.review/thumb_" & variables.reviewId & "." & uploaded.serverFileExt));
            
            variables.imagePath = uploaded.serverFile;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "Cannot upload an image to a non existing review.");
        }
        
        return this;
    }
    public review function setPrivate(required boolean private) {
        variables.private = arguments.private;
        
        return this;
    }
    
    public review function incrementViewCounter() {
        variables.viewCounter = new Query().setSQL("UPDATE IcedReaper_review_review
                                                       SET viewCounter = viewCounter + 1
                                                     WHERE reviewId = :reviewId;
                                                    SELECT viewCounter
                                                      FROM IcedReaper_review_review
                                                     WHERE reviewId = :reviewId;")
                                           .addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric")
                                           .execute()
                                           .getResult()
                                           .viewCounter[1];
        
        return this;
    }
    
    public numeric function getReviewId() {
        return variables.reviewId;
    }
    public numeric function getRating() {
        return variables.rating;
    }
    public string function getDescription() {
        return variables.description;
    }
    public string function getHeadline() {
        return variables.headline;
    }
    public string function getIntroduction() {
        return variables.introduction;
    }
    public string function getReviewText() {
        return variables.reviewText;
    }
    public string function getImagePath() {
        if(variables.imagePath != "") {
            return "/upload/com.IcedReaper.review/" & variables.imagePath;
        }
        else {
            return "";
        }
    }
    public numeric function getViewCounter() {
        return variables.viewCounter;
    }
    public string function getLink() {
        return variables.link;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public date function getlastEditDate() {
        return variables.lastEditDate;
    }
    public user function getCreator() {
        return variables.creator;
    }
    public user function getLastEditor() {
        return variables.lastEditor;
    }
    public array function getGenre() {
        return variables.genre;
    }
    public type function getType() {
        return variables.type;
    }
    public boolean function getPrivate() {
        return variables.private == 1;
    }
    
    public boolean function isEditable(required user user) {
        if(variables.private) {
            return variables.creator.getUserId() == arguments.user.getUserId();
        }
        else {
            return true;
        }
    }
    
    
    public review function save(required user user) {
        var qSave = new Query().addParam(name = "typeId",       value = variables.type.getTypeId(), cfsqltype = "cf_sql_numeric")
                               .addParam(name = "rating",       value = variables.rating,           cfsqltype = "cf_sql_numeric")
                               .addParam(name = "description",  value = variables.description,      cfsqltype = "cf_sql_varchar")
                               .addParam(name = "headline",     value = variables.headline,         cfsqltype = "cf_sql_varchar")
                               .addParam(name = "introduction", value = variables.introduction,     cfsqltype = "cf_sql_varchar")
                               .addParam(name = "reviewText",   value = variables.reviewText,       cfsqltype = "cf_sql_varchar")
                               .addParam(name = "imagePath",    value = variables.imagePath,        cfsqltype = "cf_sql_varchar")
                               .addParam(name = "viewCounter",  value = variables.viewCounter,      cfsqltype = "cf_sql_numeric")
                               .addParam(name = "link",         value = variables.link,             cfsqltype = "cf_sql_varchar")
                               .addParam(name = "private",      value = variables.private,          cfsqltype = "cf_sql_bit")
                               .addParam(name = "userId",       value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric");
        
        if(variables.reviewId == null) {
            variables.reviewId = qSave.setSQL("INSERT INTO IcedReaper_review_review
                                                           (
                                                               typeId,
                                                               rating,
                                                               description,
                                                               headline,
                                                               introduction,
                                                               reviewText,
                                                               imagePath,
                                                               viewCounter,
                                                               link,
                                                               private,
                                                               creatorUserId,
                                                               lastEditorUserId
                                                           )
                                                    VALUES (
                                                               :typeId,
                                                               :rating,
                                                               :description,
                                                               :headline,
                                                               :introduction,
                                                               :reviewText,
                                                               :imagePath,
                                                               :viewCounter,
                                                               :link,
                                                               :private,
                                                               :userId,
                                                               :userId
                                                           );
                                               SELECT currval('seq_icedreaper_review_reviewId') newReviewId;")
                                      .execute()
                                      .getResult()
                                      .newReviewId[1];
            
            variables.creator = arguments.user;
            variables.creationDate = now();
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        else {
            qSave.setSQL("UPDATE IcedReaper_review_review
                             SET typeId           = :typeId,
                                 rating           = :rating,
                                 description      = :description,
                                 headline         = :headline,
                                 introduction     = :introduction,
                                 reviewText       = :reviewText,
                                 imagePath        = :imagePath,
                                 viewCounter      = :viewCounter,
                                 link             = :link,
                                 private          = :private,
                                 lastEditorUserId = :userId
                           WHERE reviewId = :reviewId ")
                 .addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric")
                 .execute();
            
            variables.lastEditor = arguments.user;
            variables.lastEditDate = now();
        }
        
        if(variables.genreAdded.len() > 0) {
            for(var genreId in variables.genreAdded) {
                new Query().setSQL("INSERT INTO IcedReaper_review_reviewGenre
                                                (
                                                    reviewId,
                                                    genreId,
                                                    creatorUserId
                                                )
                                         VALUES (
                                                    :reviewId,
                                                    :genreId,
                                                    :userId
                                                )")
                          .addParam(name = "reviewId", value = variables.reviewId,         cfsqltype = "cf_sql_numeric")
                          .addParam(name = "genreId",  value = genreId,                    cfsqltype = "cf_sql_numeric")
                          .addParam(name = "userId",   value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                          .execute();
            }
        }
        
        if(variables.genreDeleteList.len() > 0) {
            for(var genreId in variables.genreDeleteList) {
                new Query().setSQL("DELETE FROM IcedReaper_review_reviewGenre
                                          WHERE reviewId = :reviewId
                                            AND genreId  = :genreId")
                          .addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric")
                          .addParam(name = "genreId",  value = genreId,            cfsqltype = "cf_sql_numeric")
                          .execute();
            }
        }
        
        return this;
    }
    public void function delete(required user user) {
        new Query().setSQL("DELETE
                             FROM IcedReaper_review_review
                            WHERE reviewId = :reviewId")
                   .addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        fileDelete(expandPath("/upload/com.IcedReaper.review/" & variables.imagePath));
        
        variables.reviewId = null;
    }
    
    
    private void function loadDetails() {
        if(variables.reviewId != null) {
            var qReview = new Query().setSQL("SELECT *
                                                FROM IcedReaper_review_review
                                               WHERE reviewId = :reviewId")
                                     .addParam(name = "reviewId", value = variables.reviewId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
            
            if(qReview.getRecordCount() == 1) {
                variables.type         = new type(qReview.typeId[1]);
                variables.rating       = qReview.rating[1];
                variables.description  = qReview.description[1];
                variables.headline     = qReview.headline[1];
                variables.introduction = qReview.introduction[1];
                variables.reviewText   = qReview.reviewText[1];
                variables.imagePath    = qReview.imagePath[1];
                variables.viewCounter  = qReview.viewCounter[1];
                variables.creator      = new user(qReview.creatorUserId[1]);
                variables.creationDate = qReview.creationDate[1];
                variables.lastEditor   = new user(qReview.lastEditorUserId[1]);
                variables.lastEditDate = qReview.lastEditDate[1];
                variables.link         = qReview.link[1];
                variables.private      = qReview.private[1];
                variables.genre        = [];
                
                loadGenre();
            }
            else {
                throw(type = "icedreaper.review.notFound", message = "The genre could not be found", detail = variables.genreId);
            }
        }
        else {
            variables.type         = new type(null);
            variables.rating       = 0;
            variables.description  = "";
            variables.headline     = "";
            variables.introduction = "";
            variables.reviewText   = "";
            variables.imagePath    = "";
            variables.viewCounter  = 0;
            variables.creator      = new user(null);
            variables.creationDate = now();
            variables.lastEditor   = new user(null);
            variables.lastEditDate = now();
            variables.link         = "";
            variables.genre        = [];
            variables.private      = false;
        }
    }
    
    private void function loadGenre() {
        variables.genre = new filter().for("genre")
                                      .setReview(this)
                                      .execute()
                                      .getResult();
    }
}