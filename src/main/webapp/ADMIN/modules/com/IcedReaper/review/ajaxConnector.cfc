component {
    import "API.modules.com.IcedReaper.review.*";
    
    remote array function getList() {
        var reviewFilter = new filter();
        
        reviewFilter.setSortBy("description")
                    .setSortDirection("ASC");
        
        var reviewList = [];
        for(var review in reviewFilter.execute().getResult()) {
            reviewList.append({
                "reviewId"     = review.getReviewId(),
                "typeId"       = review.getTypeId(),
                "typeName"     = review.getType().getName(),
                "rating"       = review.getRating(),
                "description"  = review.getDescription(),
                "headline"     = review.getHeadline(),
                "introduction" = review.getIntroduction(),
                "reviewText"   = review.getReviewText(),
                "imagePath"    = review.getImagePath(),
                "link"         = review.getLink(),
                "viewCounter"  = review.getViewCounter(),
                "creator"      = getUserInformation(review.getCreator()),
                "lastEditor"   = getUserInformation(review.getLastEditor())
            });
        }
        
        return reviewList;
    }
    
    remote struct function getDetails(required numeric reviewId) {
        var review = new review(arguments.reviewId);
        return {
            "reviewId"     = review.getReviewId(),
            "typeId"       = toString(review.getTypeId()),
            "typeName"     = review.getType().getName(),
            "rating"       = toString(review.getRating()),
            "description"  = review.getDescription(),
            "introduction" = review.getIntroduction(),
            "headline"     = review.getHeadline(),
            "reviewText"   = review.getReviewText(),
            "imagePath"    = review.getImagePath(),
            "link"         = review.getLink(),
            "viewCounter"  = review.getViewCounter(),
            "creator"      = getUserInformation(review.getCreator()),
            "lastEditor"   = getUserInformation(review.getLastEditor())
        };
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
    
    remote array function loadAutoCompleteGenre(required string queryString) {
        return [];
    }
    
    remote numeric function save(required numeric reviewId,
                                 required numeric typeId,
                                 required numeric rating,
                                 required string  description,
                                 required string  headline,
                                 required string  introduction,
                                 required string  reviewText,
                                 required string  link) {
        var review = new review(arguments.reviewId);
        
        review.setTypeId(arguments.typeId)
              .setRating(arguments.rating)
              .setDescription(arguments.description)
              .setHeadline(arguments.headline)
              .setIntroduction(arguments.introduction)
              .setReviewText(arguments.reviewText)
              .setLink(arguments.link)
              .save();
        
        return review.getReviewId();
    }
    
    remote string function uploadImage(required numeric reviewId) {
        var review = new review(arguments.reviewId);
        
        review.uploadImage()
              .save();
        
        return review.getImagePath();
    }
    
    remote boolean function delete(required numeric reviewId) {
        new review(arguments.reviewId)
            .delete();
        
        return true;
    }
    
    remote boolean function addGenre(required numeric reviewId,
                                     required numeric genreId,
                                     required string  genreName) {
        return true;
    }
    
    remote boolean function removeGenre(required numeric reviewId,
                                        required numeric genreId) {
        return true;
    }
    
    // genre and their details
    remote array function getGenreList() {
        var genreFilter = new genreFilter();
        
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
    
    remote struct function getGenreDetails(required numeric genreId) {
        var genre = new genre(arguments.genreId);
        
        return {
            "genreId"    = genre.getGenreId(),
            "name"       = genre.getName(),
            "creator"    = getUserInformation(genre.getCreator()),
            "lastEditor" = getUserInformation(genre.getLastEditor())
        };
    }
    
    remote boolean function saveGenre(required numeric genreId, required string name) {
        new genre(arguments.genreId)
            .setName(arguments.name)
            .save();
        
        return true;
    }
    
    remote boolean function deleteGenre(required numeric categoryId) {
        var genre = new genre(arguments.genreId);
        
        genre.delete();
        
        return true;
    }
    
    // types and their details
    remote array function getTypeList() {
        var typeFilter = new typeFilter();
        
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
    
    remote struct function getTypeDetails(required numeric typeId) {
        var type = new type(arguments.typeId);
        
        return {
            "typeId"    = type.gettypeId(),
            "name"       = type.getName(),
            "creator"    = getUserInformation(type.getCreator()),
            "lastEditor" = getUserInformation(type.getLastEditor())
        };
    }
    
    remote boolean function saveType(required numeric typeId, required string name) {
        new type(arguments.typeId)
            .setName(arguments.name)
            .save();
        
        return true;
    }
    
    remote boolean function deleteType(required numeric typeId) {
        new type(arguments.typeId).delete();
        
        return true;
    }
    
    // private
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
}