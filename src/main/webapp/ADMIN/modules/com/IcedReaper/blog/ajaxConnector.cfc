component {
    // Galleries and their details
    remote struct function getList() {
        var blogpostSearchCtrl = createObject("component", "API.com.IcedReaper.blog.search").init();
        
        var blogposts = blogpostSearchCtrl.execute();
        var data = [];
        
        for(var i = 1; i <= blogposts.len(); i++) {
            data.append(prepareDetailStruct(blogposts[i]));
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
                                required string  link,
                                required numeric released,
                                required string  releaseDate,
                                required string  folderName,
                                required string  story,
                                required numeric commentsActivated,
                                required numeric anonymousCommentAllowed,
                                required numeric commentsNeedToGetPublished,
                                required string  fileNames) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        if(arguments.releaseDate != "") {
            // format: 2015-11-27T00:00
            var y  = arguments.releaseDate.left(4);
            var m  = arguments.releaseDate.mid(6, 2);
            var d  = arguments.releaseDate.mid(9, 2);
            var h  = arguments.releaseDate.mid(12, 2);
            var mi = arguments.releaseDate.mid(15, 2);
            var _releaseDate = createDateTime(y, m, d, h, mi, 0);
            
            blogpost.setReleaseDate(_releaseDate);
        }
        else {
            blogpost.clearReleaseDate();
        }
        
        blogpost.setHeadline(arguments.headline)
                .setLink(arguments.link)
                .setReleased(arguments.released)
                .setFolderName(arguments.folderName)
                .setStory(arguments.story, deserializeJSON(arguments.fileNames))
                .setCommentsActivated(arguments.commentsActivated)
                .setAnonymousCommentAllowed(arguments.anonymousCommentAllowed)
                .setCommentsNeedToGetPublished(arguments.commentsNeedToGetPublished)
                .save();
        
        return {
            "success" = true,
            "data"    = prepareDetailStruct(blogpost)
        };
    }
    
    remote struct function uploadImages(required string blogpostId,
                                        required string imageSizes) { // jsonString
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        var _is = deserializeJSON(arguments.imageSizes);
        var imageFunctionCtrl = createObject("component", "API.com.Nephthys.controller.tools.imageFunctions");
        
        var files = fileUploadAll(blogpost.getAbsolutePath(), "*", "Overwrite");
        
        for(var i = 1; i <= files.len(); i++) {
            if(structKeyExists(_is, "is" & i)) {
                imageFunctionCtrl.resize(source = blogpost.getAbsolutePath() & "/" & files[i].serverFile,
                                         width  = _is["is" & i].width,
                                         height = _is["is" & i].height);
            }
        }
        
        return {
            "success" = true,
            "files" = files,
            "imageSizes" = _is
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
        blogpost.setReleased(1)
                .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        blogpost.setReleased(0)
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
    
    remote struct function loadComments(required numeric blogpostId) {
        var blogpost = createObject("component", "API.com.IcedReaper.blog.blogpost").init(arguments.blogpostId);
        
        var bp_comments = blogpost.getComments();
        var comments = [];
        for(var i = 1; i <= bp_comments.len(); i++) {
            comments.append({
                "commentId"    = bp_comments[i].getCommentId(),
                "username"     = bp_comments[i].getUsername(),
                "comment"      = bp_comments[i].getComment(),
                "creationDate" = application.tools.formatter.formatDate(bp_comments[i].getCreationDate()),
                "published"    = bp_comments[i].isPublished()
            });
        }
        
        return {
            "success"  = true,
            "comments" = comments
        };
    }
    
    remote struct function publishComment(required numeric commentId) {
        var comment = createObject("component", "API.com.IcedReaper.blog.comment").init(arguments.commentId);
        
        comment.publish()
               .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deleteComment(required numeric commentId) {
        var comment = createObject("component", "API.com.IcedReaper.blog.comment").init(arguments.commentId);
        
        comment.delete();
        
        return {
            "success" = true
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
            "blogpostId"                 = arguments.blogpost.getBlogpostId(),
            "headline"                   = arguments.blogpost.getHeadline(),
            "link"                       = arguments.blogpost.getLink(),
            "story"                      = arguments.blogpost.getStory(),
            "released"                   = toString(arguments.blogpost.getReleased()),
            "folderName"                 = arguments.blogpost.getFolderName(),
            "releaseDate"                = application.tools.formatter.formatDate(date = arguments.blogpost.getReleaseDate() != null ? arguments.blogpost.getReleaseDate() : 0,
                                                                                  dateFormat = "yyyy-mm-dd", timeFormat = "HH:MM"),
            "commentsActivated"          = toString(arguments.blogpost.getCommentsActivated()),
            "anonymousCommentAllowed"    = toString(arguments.blogpost.getAnonymousCommentAllowed()),
            "commentsNeedToGetPublished" = toString(arguments.blogpost.getCommentsNeedToGetPublished()),
            "creatorUserId"              = arguments.blogpost.getCreatorUserId(),
            "categories"                 = categories
        };
    }
    
    private array function prepareCategoryDetails(required array categories, required boolean getBlogposts = false) {
        var gCategories = [];
        var blogpostSearcher = createObject("component", "API.com.IcedReaper.blog.search").init();
        
        for(var c = 1; c <= arguments.categories.len(); c++) {
            gCategories.append({
                "categoryId" = arguments.categories[c].getCategoryId(),
                "name"       = arguments.categories[c].getName()
            });
            
            if(arguments.getBlogposts) {
                var blogposts = blogpostSearcher.setCategory(arguments.categories[c].getName())
                                                .execute();
                
                var preparedBlogposts = [];
                for(var g = 1; g <= blogposts.len(); g++) {
                    preparedBlogposts.append(blogposts[g].getHeadline());
                }
                
                gCategories[gCategories.len()].blogposts = preparedBlogposts;
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