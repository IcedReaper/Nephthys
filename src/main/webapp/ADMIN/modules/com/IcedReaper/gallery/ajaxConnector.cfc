component {
    // Galleries and their details
    remote struct function getList() {
        var gallerySearchCtrl = createObject("component", "API.com.IcedReaper.gallery.search").init();
        
        var galleries = gallerySearchCtrl.execute();
        var data = [];
        
        for(var i = 1; i <= galleries.len(); i++) {
            data.append(prepareDetailStruct(galleries[i]));
        }
        
        return {
            "success" = true,
            "data"    = data
        };
    }
    
    remote struct function getDetails(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        return {
            "success" = true,
            "data"    = prepareDetailStruct(gallery)
        };
    }
    
    remote struct function loadPictures(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        return {
            "success"  = true,
            "pictures" = preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/")
        };
    }
    
    remote struct function loadCategories(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        return {
            "success"    = true,
            "categories" = prepareCategoryDetails(gallery.getCategories(), false)
        };
    }
    
    remote struct function loadAutoCompleteCategories(required string queryString) {
        var categoryLoader = createObject("component", "API.com.IcedReaper.gallery.categoryLoader").init();
        
        var categories = categoryLoader
                             .setName(arguments.queryString)
                             .load();
        
        if(categories.len() != 1 || categories[1].getName() != arguments.queryString) {
            var dummyCategory = createObject("component", "API.com.IcedReaper.gallery.category").init(0)
                                    .setName(arguments.queryString);
            
            categories.append(dummyCategory);
        }
        
        return {
            "success"    = true,
            "categories" = prepareCategoryDetails(categories, false)
        };
    }
    
    remote struct function save(required numeric galleryId,
                                required string  headline,
                                required string  description,
                                required string  link,
                                required string  foldername,
                                required string  introduction,
                                required string  story,
                                required numeric active) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        if(arguments.galleryId == 0) {
            gallery.setFoldername(attributes.foldername);
        }
        
        gallery.setHeadline(arguments.headline)
               .setDescription(arguments.description)
               .setLink(arguments.link)
               .setIntroduction(arguments.introduction)
               .setStory(arguments.story)
               .setActiveStatus(arguments.active)
               .save();
        
        return {
            "success" = true,
            "data"    = prepareDetailStruct(gallery)
        };
    }
    
    remote struct function delete(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        gallery.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function activate(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        gallery.setActiveStatus(1)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        gallery.setActiveStatus(0)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function addCategory(required numeric galleryId,
                                       required numeric categoryId,
                                       required string  categoryName) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        var newCategory = createObject("component", "API.com.IcedReaper.gallery.category").init(arguments.categoryId);
        if(arguments.categoryId == 0) {
            newCategory.setName(arguments.categoryName)
                       .save();
        }
        gallery.addCategory(newCategory)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function removeCategory(required numeric galleryId,
                                          required numeric categoryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        gallery.removeCategory(arguments.categoryId);
        
        return {
            "success" = true
        };
    }
    
    remote struct function uploadPictures(required numeric galleryId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(arguments.galleryId);
        
        var newPicture = createObject("component", "API.com.IcedReaper.gallery.picture").init(0);
        newPicture.setGalleryId(arguments.galleryId)
                  .upload();
        
        gallery.addPicture(newPicture);
        
        return {
            "success"  = true
        };
    }
    
    remote struct function updatePicture(required numeric pictureId,
                                         required string  caption,
                                         required string  alt,
                                         required string  title) {
        var picture = createObject("component", "API.com.IcedReaper.gallery.picture").init(arguments.pictureId);
        
        picture.setCaption(arguments.caption)
               .setAlt(arguments.alt)
               .setTitle(arguments.title)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deletePicture(required numeric pictureId) {
        var gallery = createObject("component", "API.com.IcedReaper.gallery.gallery").init(picture.getGalleryId());
        gallery.removePicture(arguments.pictureId);
        
        return {
            "success"  = true,
            "pictures" = preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/")
        };
    }
    
    // categories and their details
    remote struct function getCategoryList() {
        var categoryLoader = createObject("component", "API.com.IcedReaper.gallery.categoryLoader").init();
        
        return {
            "success" = true,
            "data"    = prepareCategoryDetails(categoryLoader.load(), true)
        };
    }
    
    remote struct function getCategoryDetails(required numeric categoryId) {
        var category = createObject("component", "API.com.IcedReaper.gallery.category").init(arguments.categoryId);
        
        return {
            "success" = true,
            "data"    = prepareCategoryStruct(category)
        };
    }
    
    remote struct function saveCategory(required numeric categoryId,
                                        required string  name) {
        var category = createObject("component", "API.com.IcedReaper.gallery.category").init(arguments.categoryId);
        category.setName(arguments.name)
                .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deleteCategory(required numeric categoryId) {
        var category = createObject("component", "API.com.IcedReaper.gallery.category").init(arguments.categoryId);
        
        category.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function getLastVisitChart(required numeric galleryId, required numeric dayCount) {
        if(arguments.dayCount == 0) {
            arguments.dayCount = 20;
        }
        
        var statisticsCtrl = createObject("component", "API.com.IcedReaper.gallery.statistics").init();
        
        var statisticsData = statisticsCtrl.load(arguments.galleryId, dateAdd("d", (dayCount - 1) * -1, now()), now());
        
        var labels = [];
        var data = [];
        for(var i = 1; i <= statisticsData.len(); i++) {
            labels.append(application.tools.formatter.formatDate(statisticsData[i].date, false));
            data.append(statisticsData[i].count);
        }
        
        return {
            "success" = true,
            "labels"  = labels,
            "data"    = data
        };
    }
    
    
    // private
    private struct function prepareDetailStruct(required gallery gallery) {
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
            //"releaseDate"  = application.tools.formatter.formatDate(arguments.gallery.getReleaseDate(), false),
            "creator"      = arguments.gallery.getCreator().getUsername(), // todo: check if required or has to get changed
            "lastEditor"   = arguments.gallery.getLastEditor().getUsername(),
            "active"       = toString(arguments.gallery.getActiveStatus()),
            "pictureCount" = arguments.gallery.getPictureCount(),
            "categories"   = categories
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
        var gallerySearcher = createObject("component", "API.com.IcedReaper.gallery.search").init();
        
        for(var c = 1; c <= arguments.categories.len(); c++) {
            gCategories.append({
                "categoryId" = arguments.categories[c].getCategoryId(),
                "name"       = arguments.categories[c].getName()
            });
            
            if(arguments.getGalleries) {
                var galleries = gallerySearcher.setCategory(arguments.categories[c].getName())
                                               .execute();
                
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
        return {
            "categoryId"   = arguments.category.getCategoryId(),
            "name"         = arguments.category.getName(),
            "creator"      = getUserInformation(arguments.category.getCreator()),
            "lastEditor"   = getUserInformation(arguments.category.getLastEditor()),
            "creationDate" = application.tools.formatter.formatDate(arguments.category.getCreationDate()),
            "lastEditDate" = application.tools.formatter.formatDate(arguments.category.getLastEditDate())
        }
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
        };
    }
}