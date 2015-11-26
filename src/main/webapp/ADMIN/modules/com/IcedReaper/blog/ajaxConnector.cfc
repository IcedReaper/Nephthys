component {
    // Galleries and their details
    remote struct function getList() {
        var blogpostSearchCtrl = createObject("component", "API.com.IcedReaper.blog.search").init();
        
        var galleries = blogpostSearchCtrl.execute();
        var data = [];
        
        for(var i = 1; i <= galleries.len(); i++) {
            data.append(prepareDetailStruct(galleries[i]));
        }
        
        return {
            "success" = true,
            "data"    = data
        };
    }
    
    remote struct function getDetails(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        return {
            "success" = true,
            "data"    = prepareDetailStruct(blogpost)
        };
    }
    
    remote struct function loadCategories(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        
        return {
            "success"    = true,
            "categories" = prepareCategoryDetails(blogpost.getCategories(), false)
        };
    }
    
    remote struct function loadAutoCompleteCategories(required string queryString) {
        var categoryLoader = createObject("component", "API.com.IcedReaper.blog.categoryLoader").init();
        
        var categories = categoryLoader.setName(arguments.queryString)
                                       .load();
        
        if(categories.len() != 1 || categories[1].getName() != arguments.queryString) {
            var dummyCategory = createObject("component", "API.com.IcedReaper.blog.category").init(0)
                                    .setName(arguments.queryString);
            
            categories.append(dummyCategory);
        }
        
        return {
            "success"    = true,
            "categories" = prepareCategoryDetails(categories, false)
        };
    }
    
    remote struct function save(required numeric blogpostId,
                                required string  headline,
                                required string  description,
                                required string  link,
                                required string  introduction,
                                required string  story,
                                required numeric active) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        
        if(arguments.blogpostId == 0) {
            blogpost.setFoldername(attributes.foldername);
        }
        
        blogpost.setHeadline(arguments.headline)
                .setDescription(arguments.description)
                .setLink(arguments.link)
                .setIntroduction(arguments.introduction)
                .setStory(arguments.story)
                .setActiveStatus(arguments.active)
                .save();
        
        return {
            "success" = true,
            "data"    = prepareDetailStruct(blogpost)
        };
    }
    
    remote struct function delete(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        blogpost.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function activate(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        blogpost.setActiveStatus(1)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        blogpost.setActiveStatus(0)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function addCategory(required numeric blogpostId,
                                       required numeric categoryId,
                                       required string  categoryName) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        var newCategory = createObject("component", "API.com.IcedReaper.blog.category").init(arguments.categoryId);
        if(arguments.categoryId == 0) {
            newCategory.setName(arguments.categoryName)
                       .save();
        }
        blogpost.addCategory(newCategory)
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function removeCategory(required numeric blogpostId,
                                          required numeric categoryId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        
        blogpost.removeCategory(arguments.categoryId);
        
        return {
            "success" = true
        };
    }
    
    // categories and their details
    remote struct function getCategoryList() {
        var categoryLoader = createObject("component", "API.com.IcedReaper.blog.categoryLoader").init();
        
        return {
            "success" = true,
            "data"    = prepareCategoryDetails(categoryLoader.load(), true)
        };
    }
    
    remote struct function getCategoryDetails(required numeric categoryId) {
        var category = createObject("component", "API.com.IcedReaper.blog.category").init(arguments.categoryId);
        
        return {
            "success" = true,
            "data"    = prepareCategoryStruct(category)
        };
    }
    
    remote struct function saveCategory(required numeric categoryId,
                                        required string  name) {
        var category = createObject("component", "API.com.IcedReaper.blog.category").init(arguments.categoryId);
        category.setName(arguments.name)
                .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deleteCategory(required numeric categoryId) {
        var category = createObject("component", "API.com.IcedReaper.blog.category").init(arguments.categoryId);
        
        category.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function getLastVisitChart(required numeric blogpostId, required numeric dayCount) {
        if(arguments.dayCount == 0) {
            arguments.dayCount = 20;
        }
        
        var statisticsCtrl = createObject("component", "API.com.IcedReaper.blog.statistics").init();
        
        var statisticsData = statisticsCtrl.load(arguments.blogpostId, dateAdd("d", (dayCount - 1) * -1, now()), now());
        
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
    private struct function prepareDetailStruct(required blogpost blogpost) {
        var categories = [];
        var gCategories = arguments.blogpost.getCategories();
        for(var c = 1; c <= gCategories.len(); c++) {
            categories.append(gCategories[c].getName());
        }
        
        return {
            "blogpostId"    = arguments.blogpost.getGalleryId(),
            "headline"     = arguments.blogpost.getHeadline(),
            "description"  = arguments.blogpost.getDescription(),
            "link"         = arguments.blogpost.getLink(),
            "story"        = arguments.blogpost.getStory(),
            //"releaseDate"  = application.tools.formatter.formatDate(arguments.blogpost.getReleaseDate(), false),
            "creator"      = arguments.blogpost.getCreator().getUsername(), // todo: check if required or has to get changed
            "lastEditor"   = arguments.blogpost.getLastEditor().getUsername(),
            "active"       = toString(arguments.blogpost.getActiveStatus()),
            "pictureCount" = arguments.blogpost.getPictureCount(),
            "categories"   = categories
        };
    }
    
    private array function prepareCategoryDetails(required array categories, required boolean getGalleries = false) {
        var gCategories = [];
        var blogpostSearcher = createObject("component", "API.com.IcedReaper.blog.search").init();
        
        for(var c = 1; c <= arguments.categories.len(); c++) {
            gCategories.append({
                "categoryId" = arguments.categories[c].getCategoryId(),
                "name"       = arguments.categories[c].getName()
            });
            
            if(arguments.getGalleries) {
                var galleries = blogpostSearcher.setCategory(arguments.categories[c].getName())
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