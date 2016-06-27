component {
    import "API.modules.com.IcedReaper.blog.*";
    
    remote array function getList() {
        var blogpostFilterCtrl = new filter().setFor("blogpost");
        
        var blogposts = blogpostFilterCtrl.execute().getResult();
        var data = [];
        
        for(var i = 1; i <= blogposts.len(); i++) {
            data.append(prepareDetailStruct(blogposts[i]));
        }
        
        return data;
    }
    
    remote struct function getDetails(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        return prepareDetailStruct(blogpost);
    }
    
    remote array function loadCategories(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        return prepareCategoryDetails(blogpost.getCategories(), false);
    }
    
    remote array function loadAutoCompleteCategories(required string queryString) {
        var categoryFilter = new filter().setFor("category");
        
        var categories = categoryFilter.setName(arguments.queryString)
                                       .execute()
                                       .getResult();
        
        if(categories.len() != 1 || categories[1].getName() != arguments.queryString) {
            var dummyCategory = new category(0).setName(arguments.queryString);
            
            categories.append(dummyCategory);
        }
        
        return prepareCategoryDetails(categories, false);
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
                                required boolean private,
                                required string  fileNames) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
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
                    .setPrivate(arguments.private)
                    .save();
            
            return prepareDetailStruct(blogpost);
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote struct function uploadImages(required string blogpostId,
                                        required string imageSizes) { // jsonString
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            var _is = deserializeJSON(arguments.imageSizes);
            var imageEditor = application.system.settings.getValueOfKey("imageEditLibrary");
            
            var files = fileUploadAll(blogpost.getAbsolutePath(), "*", "Overwrite");
            
            for(var i = 1; i <= files.len(); i++) {
                if(_is.keyExists("is" & i)) {
                    imageEditor.resize(source = blogpost.getAbsolutePath() & "/" & files[i].serverFile,
                                       width  = _is["is" & i].width,
                                       height = _is["is" & i].height);
                }
            }
            
            return {
                "files"      = files,
                "imageSizes" = _is
            };
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function delete(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            blogpost.delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function activate(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            blogpost.setReleased(1)
                    .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function deactivate(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            blogpost.setReleased(0)
                    .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function addCategory(required numeric blogpostId,
                                       required numeric categoryId,
                                       required string  categoryName) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            var newCategory = new category(arguments.categoryId);
            if(arguments.categoryId == 0) {
                newCategory.setName(arguments.categoryName)
                           .save();
            }
            blogpost.addCategory(newCategory)
                    .save();
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function removeCategory(required numeric blogpostId,
                                          required numeric categoryId) {
        var blogpost = new blogpost(arguments.blogpostId);
        
        if(blogpost.isEditable(request.user.getUserID())) {
            blogpost.removeCategory(arguments.categoryId);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    // categories and their details
    remote array function getCategoryList() {
        var categoryFilter = new filter().setFor("category");
        
        return prepareCategoryDetails(categoryFilter.execute().getResult(), true);
    }
    
    remote struct function getCategoryDetails(required numeric categoryId) {
        var category = new category(arguments.categoryId);
        
        return prepareCategoryStruct(category);
    }
    
    remote numeric function saveCategory(required numeric categoryId,
                                         required string  name) {
        var category = new category(arguments.categoryId);
        category.setName(arguments.name)
                .save();
        
        return category.getCategoryId();
    }
    
    remote boolean function deleteCategory(required numeric categoryId) {
        var category = new category(arguments.categoryId);
        
        category.delete();
        
        return true;
    }
    
    remote struct function getLastVisitChart(required numeric blogpostId, required numeric dayCount) {
        if(arguments.dayCount == 0) {
            arguments.dayCount = 20;
        }
        
        var statisticsCtrl = new statistics();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var statisticsData = statisticsCtrl.load(arguments.blogpostId, dateAdd("d", (dayCount - 1) * -1, now()), now());
        
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
    
    remote array function loadComments(required numeric blogpostId) {
        var blogpost = new blogpost(arguments.blogpostId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var bp_comments = blogpost.getComments();
        var comments = [];
        for(var i = 1; i <= bp_comments.len(); i++) {
            comments.append({
                "commentId"    = bp_comments[i].getCommentId(),
                "username"     = bp_comments[i].getUsername(),
                "comment"      = bp_comments[i].getComment(),
                "creationDate" = formatCtrl.formatDate(bp_comments[i].getCreationDate()),
                "published"    = bp_comments[i].isPublished()
            });
        }
        
        return comments;
    }
    
    remote boolean function publishComment(required numeric commentId) {
        var comment = new comment(arguments.commentId);
        
        comment.publish()
               .save();
        
        return true;
    }
    
    remote boolean function deleteComment(required numeric commentId) {
        var comment = new comment(arguments.commentId);
        
        comment.delete();
        
        return true;
    }
    
    remote struct function getSettings() {
        return application.system.settings.getAllSettingsForModuleName("com.IcedReaper.blog");
    }
    
    remote boolean function saveSettings(required string settings) {
        var newSettings = deserializeJSON(arguments.settings);
        
        for(var setting in newSettings) {
            if(newSettings[setting].keyExists("rawValue")) {
                application.system.settings.setValueOfKey(setting, newSettings[setting].rawValue);
            }
        }
        
        application.system.settings.save();
        
        return true;
    }
    
    remote struct function getBlogStatistics(required numeric blogpostId = null, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "DD.MM.YYYY");
        var _toDate   = dateFormat(arguments.toDate, "DD.MM.YYYY");

        return new statistics().getTotal(arguments.blogpostId,
                                         arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getStatisticsSeparatedByBlog(required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "DD.MM.YYYY");
        var _toDate   = dateFormat(arguments.toDate, "DD.MM.YYYY");

        return new statistics().getSplitPerGallery(arguments.sortOrder,
                                                   _fromDate,
                                                   _toDate);
    }
    
    // private
    private struct function prepareDetailStruct(required blogpost blogpost) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
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
            "released"                   = arguments.blogpost.getReleased(),
            "folderName"                 = arguments.blogpost.getFolderName(),
            "releaseDate"                = arguments.blogpost.getReleaseDate() != null ? formatCtrl.formatDate(arguments.blogpost.getReleaseDate()) : null,
            "commentsActivated"          = arguments.blogpost.getCommentsActivated(),
            "anonymousCommentAllowed"    = arguments.blogpost.getAnonymousCommentAllowed(),
            "commentsNeedToGetPublished" = arguments.blogpost.getCommentsNeedToGetPublished(),
            "creatorUserId"              = arguments.blogpost.getCreatorUserId(),
            "categories"                 = categories,
            "private"                    = arguments.blogpost.getPrivate(),
            "isEditable"                 = arguments.blogpost.isEditable(request.user.getUserId())
        };
    }
    
    private array function prepareCategoryDetails(required array categories, required boolean getBlogposts = false) {
        var gCategories = [];
        var blogpostFilterCtrl = new filter().setFor("blogpost");
        
        for(var c = 1; c <= arguments.categories.len(); c++) {
            gCategories.append({
                "categoryId" = arguments.categories[c].getCategoryId(),
                "name"       = arguments.categories[c].getName()
            });
            
            if(arguments.getBlogposts) {
                var blogposts = blogpostFilterCtrl.setCategory(arguments.categories[c].getName())
                                                  .execute()
                                                  .getResult();
                
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