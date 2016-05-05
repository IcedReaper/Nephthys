component {
    // Galleries and their details
    remote array function getList() {
        var galleryFilterCtrl = createObject("component", "API.modules.com.IcedReaper.gallery.filter").init();
        
        var galleries = galleryFilterCtrl.execute().getResult();
        var data = [];
        
        for(var i = 1; i <= galleries.len(); i++) {
            data.append(prepareDetailStruct(galleries[i]));
        }
        
        return data;
    }
    
    remote struct function getDetails(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        return prepareDetailStruct(gallery);
    }
    
    remote array function loadPictures(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        return preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/");
    }
    
    remote array function loadCategories(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        return prepareCategoryDetails(gallery.getCategories(), false);
    }
    
    remote array function loadAutoCompleteCategories(required string queryString) {
        var categoryLoader = createObject("component", "API.modules.com.IcedReaper.gallery.categoryLoader").init();
        
        var categories = categoryLoader
                             .setName(arguments.queryString)
                             .load();
        
        if(categories.len() != 1 || categories[1].getName() != arguments.queryString) {
            var dummyCategory = createObject("component", "API.modules.com.IcedReaper.gallery.category").init(0)
                                    .setName(arguments.queryString);
            
            categories.append(dummyCategory);
        }
        
        return prepareCategoryDetails(categories, false);
    }
    
    remote struct function save(required numeric galleryId,
                                required string  headline,
                                required string  description,
                                required string  link,
                                required string  foldername,
                                required string  introduction,
                                required string  story,
                                required numeric active,
                                required boolean private) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            if(arguments.galleryId == 0) {
                gallery.setFoldername(attributes.foldername);
            }
            
            gallery.setHeadline(arguments.headline)
                   .setDescription(arguments.description)
                   .setLink(arguments.link)
                   .setIntroduction(arguments.introduction)
                   .setStory(arguments.story)
                   .setActiveStatus(arguments.active)
                   .setPrivate(arguments.private)
                   .save();
            
            return prepareDetailStruct(gallery);
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function delete(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            gallery.delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function activate(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            gallery.setActiveStatus(1)
                   .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function deactivate(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            gallery.setActiveStatus(0)
                   .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function addCategory(required numeric galleryId,
                                       required numeric categoryId,
                                       required string  categoryName) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            var newCategory = createObject("component", "API.modules.com.IcedReaper.gallery.category").init(arguments.categoryId);
            if(arguments.categoryId == 0) {
                newCategory.setName(arguments.categoryName)
                           .save();
            }
            gallery.addCategory(newCategory)
                   .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function removeCategory(required numeric galleryId,
                                          required numeric categoryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            gallery.removeCategory(arguments.categoryId);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function uploadPictures(required numeric galleryId) {
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(gallery.isEditable(request.user.getUserID())) {
            var newPicture = createObject("component", "API.modules.com.IcedReaper.gallery.picture").init(0);
            newPicture.setGalleryId(arguments.galleryId)
                      .upload();
            
            gallery.addPicture(newPicture);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function updatePicture(required numeric pictureId,
                                          required string  caption,
                                          required string  alt,
                                          required string  title) {
        var picture = createObject("component", "API.modules.com.IcedReaper.gallery.picture").init(arguments.pictureId);
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(picture.getGalleryId());
        
        if(gallery.isEditable(request.user.getUserID())) {
            picture.setCaption(arguments.caption)
                   .setAlt(arguments.alt)
                   .setTitle(arguments.title)
                   .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote array function deletePicture(required numeric pictureId) {
        var picture = createObject("component", "API.modules.com.IcedReaper.gallery.picture").init(arguments.pictureId);
        var gallery = createObject("component", "API.modules.com.IcedReaper.gallery.gallery").init(picture.getGalleryId());
        
        if(gallery.isEditable(request.user.getUserID())) {
            gallery.removePicture(arguments.pictureId);
            
            return preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/");
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    // categories and their details
    remote array function getCategoryList() {
        var categoryLoader = createObject("component", "API.modules.com.IcedReaper.gallery.categoryLoader").init();
        
        return prepareCategoryDetails(categoryLoader.load(), true);
    }
    
    remote struct function getCategoryDetails(required numeric categoryId) {
        var category = createObject("component", "API.modules.com.IcedReaper.gallery.category").init(arguments.categoryId);
        
        return prepareCategoryStruct(category);
    }
    
    remote boolean function saveCategory(required numeric categoryId,
                                        required string  name) {
        var category = createObject("component", "API.modules.com.IcedReaper.gallery.category").init(arguments.categoryId);
        
        category.setName(arguments.name)
                .save();
        
        return true;
    }
    
    remote boolean function deleteCategory(required numeric categoryId) {
        var category = createObject("component", "API.modules.com.IcedReaper.gallery.category").init(arguments.categoryId);
        
        category.delete();
        
        return true;
    }
    
    remote struct function getLastVisitChart(required numeric galleryId, required numeric dayCount) {
        if(arguments.dayCount == 0) {
            arguments.dayCount = 20;
        }
        
        var statisticsCtrl = createObject("component", "API.modules.com.IcedReaper.gallery.statistics").init();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var statisticsData = statisticsCtrl.load(arguments.galleryId, dateAdd("d", (dayCount - 1) * -1, now()), now());
        
        var labels = [];
        var data = [];
        for(var i = 1; i <= statisticsData.len(); i++) {
            labels.append(formatCtrl.formatDate(statisticsData[i].date, false));
            data.append(statisticsData[i].count);
        }
        
        return {
            "labels"  = labels,
            "data"    = data
        };
    }
    
    
    // private
    private struct function prepareDetailStruct(required gallery gallery) {
        //var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var categories = [];
        var gCategories = arguments.gallery.getCategories();
        for(var c = 1; c <= gCategories.len(); c++) {
            categories.append(gCategories[c].getName());
        }
        
        return {
            "galleryId"    = arguments.gallery.getGalleryId(),
            "headline"     = arguments.gallery.getHeadline(),
            "description"  = arguments.gallery.getDescription(),
            "link"         = arguments.gallery.getLink(),
            "foldername"   = arguments.gallery.getFoldername(),
            "introduction" = arguments.gallery.getIntroduction(),
            "story"        = arguments.gallery.getStory(),
            //"releaseDate"  = formatCtrl.formatDate(arguments.gallery.getReleaseDate(), false),
            "active"       = toString(arguments.gallery.getActiveStatus()),
            "pictureCount" = arguments.gallery.getPictureCount(),
            "categories"   = categories,
            "private"      = arguments.gallery.getPrivate(),
            "isEditable"   = arguments.gallery.isEditable(request.user.getUserId())
        };
    }
    
    private array function preparePictureStruct(required array pictures, required string relativePath) {
        var gPictures = [];
        for(var p = 1; p <= arguments.pictures.len(); p++) {
            gPictures.append({
                    "pictureId"         = arguments.pictures[p].getPictureId(),
                    "pictureFilename"   = arguments.relativePath & arguments.pictures[p].getPictureFilename(),
                    "thumbnailFilename" = arguments.relativePath & arguments.pictures[p].getThumbnailFilename(),
                    "title"             = arguments.pictures[p].getTitle(),
                    "alt"               = arguments.pictures[p].getAlt(),
                    "caption"           = arguments.pictures[p].getCaption()
                });
        }
        
        return gPictures;
    }
    
    private array function prepareCategoryDetails(required array categories, required boolean getGalleries = false) {
        var gCategories = [];
        var galleryFilterCtrl = createObject("component", "API.modules.com.IcedReaper.gallery.filter").init();
        
        for(var c = 1; c <= arguments.categories.len(); c++) {
            gCategories.append({
                "categoryId" = arguments.categories[c].getCategoryId(),
                "name"       = arguments.categories[c].getName()
            });
            
            if(arguments.getGalleries) {
                var galleries = galleryFilterCtrl.setCategory(arguments.categories[c].getName())
                                                 .execute()
                                                 .getResult();
                
                var preparedGalleries = [];
                for(var g = 1; g <= galleries.len(); g++) {
                    preparedGalleries.append(galleries[g].getHeadline());
                }
                
                gCategories[gCategories.len()].galleries = preparedGalleries;
            }
        }
        
        return gCategories;
    }
    
    private struct function prepareCategoryStruct(required category category) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        return {
            "categoryId"   = arguments.category.getCategoryId(),
            "name"         = arguments.category.getName(),
            "creator"      = getUserInformation(arguments.category.getCreator()),
            "lastEditor"   = getUserInformation(arguments.category.getLastEditor()),
            "creationDate" = formatCtrl.formatDate(arguments.category.getCreationDate()),
            "lastEditDate" = formatCtrl.formatDate(arguments.category.getLastEditDate())
        }
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
}