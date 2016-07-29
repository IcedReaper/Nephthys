component {
    import "API.modules.com.IcedReaper.review.*";
    
    remote array function getList() {
        var reviewFilter = new filter().for("review");
        
        reviewFilter.setSortBy("description")
                    .setSortDirection("ASC");
        
        var reviewList = [];
        for(var review in reviewFilter.execute().getResult()) {
            reviewList.append(prepareReviewData(review));
        }
        
        return reviewList;
    }
    
    remote struct function getDetails(required numeric reviewId = null) {
        var review = new review(arguments.reviewId);
        
        return prepareReviewData(review);
    }
    
    remote array function loadGenre(required numeric reviewId) {
        var review = new review(arguments.reviewId);
        var genreList = [];
        
        for(var genre in review.getGenre()) {
            genreList.append({
                "genreId"    = genre.getGenreId(),
                "name"       = genre.getName(),
                "creator"    = getUserInformation(genre.getCreator()),
                "lastEditor" = getUserInformation(genre.getLastEditor())
            });
        }
        return [];
    }
    
    remote array function loadAutoCompleteGenres(required string queryString) {
        var genreFilter = new filter().for("genre");
        
        var genres = genreFilter
                        .setLikeName(arguments.queryString)
                        .execute()
                        .getResult();
        
        if(genreFilter.getResultCount() != 1 || genres[1].getName() != arguments.queryString) {
            var dummyGenre = new genre(null).setName(arguments.queryString);
            
            genres.append(dummyGenre);
        }
        
        var genreList = [];
        
        for(genre in genres) {
            genreList.append({
                "genreId" = genre.getGenreId(),
                "name"    = genre.getName()
            });
        }
        
        return genreList;
    }
    
    remote numeric function save(required numeric reviewId = null,
                                 required numeric typeId,
                                 required numeric rating,
                                 required string  description,
                                 required string  headline,
                                 required string  introduction,
                                 required string  reviewText,
                                 required string  link,
                                 required boolean private) {
        var review = new review(arguments.reviewId);
        
        if(review.isEditable(request.user.getUserId())) {
            review.setTypeId(arguments.typeId)
                  .setRating(arguments.rating)
                  .setDescription(arguments.description)
                  .setHeadline(arguments.headline)
                  .setIntroduction(arguments.introduction)
                  .setReviewText(arguments.reviewText)
                  .setLink(arguments.link)
                  .setPrivate(arguments.private)
                  .save(request.user);
            
            return review.getReviewId();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this review");
        }
    }
    
    remote string function uploadImage(required numeric reviewId) {
        var review = new review(arguments.reviewId);
        
        if(review.isEditable(request.user.getUserId())) {
            review.uploadImage()
                  .save(request.user);
            
            return review.getImagePath();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this review");
        }
    }
    
    remote boolean function delete(required numeric reviewId) {
        new review(arguments.reviewId);
        
        if(review.isEditable(request.user.getUserId())) {
            review.delete(request.user);
        
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this review");
        }
    }
    
    remote array function loadGenres(required numeric reviewId) {
        var review = new review(arguments.reviewId);
        
        var genreList = [];
        for(var genre in review.getGenre()) {
            genreList.append({
                "genreId" = genre.getGenreId(),
                "name"    = genre.getName()
            });
        }
        return genreList;
    }
    
    remote numeric function addGenre(required numeric reviewId,
                                     required numeric genreId,
                                     required string  genreName) {
        var review = new review(arguments.reviewId);
        
        if(review.isEditable(request.user.getUserId())) {
            if(arguments.genreId == null) {
                var genre = new genre(null).setName(arguments.genreName)
                                           .save(request.user);
            }
            else {
                var genre = new genre(arguments.genreId);
            }
            
            review.addGenre(genre)
                  .save(request.user);
            
            return genre.getGenreId();
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this review");
        }
    }
    
    remote boolean function removeGenre(required numeric reviewId,
                                        required numeric genreId) {
        var review = new review(arguments.reviewId);
        
        if(review.isEditable(request.user.getUserId())) {
            review
                .removeGenreById(arguments.genreId)
                .save(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this review");
        }
    }
    
    // genre and their details
    remote array function getGenreList() {
        var genreFilter = new filter().for("genre");
        
        genreFilter.setSortBy("name")
                   .setSortDirection("ASC");
        
        var genreList = [];
        for(var genre in genreFilter.execute().getResult()) {
            genreList.append({
                "genreId"    = genre.getGenreId(),
                "name"       = genre.getName(),
                "creator"    = getUserInformation(genre.getCreator()),
                "lastEditor" = getUserInformation(genre.getLastEditor())
            });
        }
        
        return genreList;
    }
    
    remote struct function getGenreDetails(required numeric genreId = null) {
        var genre = new genre(arguments.genreId);
        
        return {
            "genreId"    = genre.getGenreId(),
            "name"       = genre.getName(),
            "creator"    = getUserInformation(genre.getCreator()),
            "lastEditor" = getUserInformation(genre.getLastEditor())
        };
    }
    
    remote numeric function saveGenre(required numeric genreId = null, required string name) {
        return new genre(arguments.genreId).setName(arguments.name)
                                           .save(request.user)
                                           .getGenreId();
    }
    
    remote boolean function deleteGenre(required numeric genreId) {
        var genre = new genre(arguments.genreId);
        
        genre.delete(request.user);
        
        return true;
    }
    
    // types and their details
    remote array function getTypeList() {
        var typeFilter = new filter().for("type");
        
        typeFilter.setSortBy("name")
                  .setSortDirection("ASC");
        
        var typeList = [];
        for(var type in typeFilter.execute().getResult()) {
            typeList.append({
                "typeId"     = type.getTypeId(),
                "name"       = type.getName(),
                "creator"    = getUserInformation(type.getCreator()),
                "lastEditor" = getUserInformation(type.getLastEditor())
            });
        }
        
        return typeList;
    }
    
    remote struct function getTypeDetails(required numeric typeId = null) {
        var type = new type(arguments.typeId);
        
        return {
            "typeId"    = type.gettypeId(),
            "name"       = type.getName(),
            "creator"    = getUserInformation(type.getCreator()),
            "lastEditor" = getUserInformation(type.getLastEditor())
        };
    }
    
    remote numeric function saveType(required numeric typeId = null,
                                     required string name) {
        return new type(arguments.typeId).setName(arguments.name)
                                         .save(request.user)
                                         .getTypeId();
    }
    
    remote boolean function deleteType(required numeric typeId) {
        new type(arguments.typeId).delete(request.user);
        
        return true;
    }
    
    // private
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
    
    private struct function prepareReviewData(required review review) {
        return {
                "reviewId"     = arguments.review.getReviewId(),
                "typeId"       = arguments.review.getTypeId(),
                "typeName"     = arguments.review.getType().getName(),
                "rating"       = arguments.review.getRating(),
                "description"  = arguments.review.getDescription(),
                "headline"     = arguments.review.getHeadline(),
                "introduction" = arguments.review.getIntroduction(),
                "reviewText"   = arguments.review.getReviewText(),
                "imagePath"    = arguments.review.getImagePath(),
                "link"         = arguments.review.getLink(),
                "viewCounter"  = arguments.review.getViewCounter(),
                "private"      = arguments.review.getPrivate(),
                "isEditable"   = arguments.review.isEditable(request.user.getUserId()),
                "creator"      = getUserInformation(arguments.review.getCreator()),
                "lastEditor"   = getUserInformation(arguments.review.getLastEditor())
        };
    }
}