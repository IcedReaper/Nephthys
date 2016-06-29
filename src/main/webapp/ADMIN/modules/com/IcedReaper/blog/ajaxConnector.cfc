component {
    import "API.modules.com.IcedReaper.blog.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
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
    
    remote numeric function save(required numeric blogpostId,
                                required string  headline,
                                required string  link,
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
                blogpost.setReleaseDate(dateFormat(arguments.releaseDate, "YYYY/MM/DD"));
            }
            else {
                blogpost.clearReleaseDate();
            }
            
            blogpost.setHeadline(arguments.headline)
                    .setLink(arguments.link)
                    .setFolderName(arguments.folderName)
                    .setStory(arguments.story, deserializeJSON(arguments.fileNames))
                    .setCommentsActivated(arguments.commentsActivated)
                    .setAnonymousCommentAllowed(arguments.anonymousCommentAllowed)
                    .setCommentsNeedToGetPublished(arguments.commentsNeedToGetPublished)
                    .setPrivate(arguments.private)
                    .save();
            
            return blogpost.getBlogpostId();
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

        return new statistics().getSplitPerBlogpost(arguments.sortOrder,
                                                    _fromDate,
                                                    _toDate);
    } 
    remote boolean function pushToStatus(required numeric blogpostId, required numeric statusId) {
        return new blogpost(arguments.blogpostId)
            .pushToStatus(arguments.statusId, request.user)
            .isEditable(request.user.getUserId());
    }
    
    remote struct function getStatusList() {
        var statusLoader = new filter().setFor("status");
        
        var prepStatus = {};
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus[status.getStatusId()] = prepareStatus(status);
        }
        
        return prepStatus;
    }
    
    remote array function getStatusListAsArray() {
        var statusLoader = new filter().setFor("status");
        
        var prepStatus = [];
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus.append(prepareStatusAsArray(status));
        }
        
        return prepStatus;
    }
    
    remote struct function getStatusDetails(required numeric statusId) {
        return prepareStatus(new status(arguments.statusId));
    }
    
    remote numeric function saveStatus(required struct status) {
        var status = new status(arguments.status.statusId);
        
        status.setActiveStatus(arguments.status.active)
              .setEditable(arguments.status.editable)
              .setName(arguments.status.name)
              .setOnlineStatus(arguments.status.online)
              .setDeleteable(arguments.status.deleteable)
              .setShowInTasklist(arguments.status.showInTasklist)
              .setLastEditor(request.user)
              .save();
        
        return status.getStatusId();
    }
    
    remote boolean function deleteStatus(required numeric statusId) {
        if(arguments.statusId == application.system.settings.getValueOfKey("com.IcedReaper.blog.startStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete the start status. Please reset the start status in the system settings");
        }
        
        var blogpostsStillWithThisStatus = new filter().setFor("blogpost")
                                                       .setStatusId(arguments.statusId)
                                                       .execute()
                                                       .getResultCount();
        
        if(blogpostsStillWithThisStatus == 0) {
            new status(arguments.statusId).delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & blogpostsStillWithThisStatus & " blog posts on this status.");
        }
    }
    
    remote boolean function activateStatus(required numeric statusId) {
        var status = new status(arguments.statusId);
        
        status.setActiveStatus(true)
              .save();
        
        return true;
    }
    
    remote boolean function deactivateStatus(required numeric statusId) {
        new status(arguments.statusId).setActiveStatus(false)
                                      .save();
        
        return true;
    }
    
    remote boolean function saveStatusFlow(required array statusFlow) {
        var i = 0;
        var j = 0;
        var k = 0;
        var found = false;
        transaction {
            for(i = 1; i <= arguments.statusFlow.len(); ++i) {
                var status = new status(arguments.statusFlow[i].statusId);
                
                var nextStatus = status.getNextStatus();
                
                for(j = 1; j <= nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= arguments.statusFlow[i].nextStatus.len() && ! found; ++k) {
                        if(nextStatus[j].getStatusId() == arguments.statusFlow[i].nextStatus[k].statusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        status.removeNextStatus(nextStatus[j].getStatusId());
                    }
                }
                
                for(j = 1; j <= arguments.statusFlow[i].nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= nextStatus.len() && ! found; ++k) {
                        if(nextStatus[k].getStatusId() == arguments.statusFlow[i].nextStatus[j].statusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        status.addNextStatus(arguments.statusFlow[i].nextStatus[j].statusId);
                    }
                }
                
                status.save();
            }
            
            transactionCommit();
        }
        
        return false;
    }
    
    remote array function getBlogpostsInTasklist() {
        var statusFilterCtrl = new filter().setFor("status")
                                           .setShowInTasklist(true)
                                           .execute();
        
        var blogpostFilterCtrl = new filter().setFor("blogpost");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilterCtrl.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["blogposts"] = [];
            
            for(var blogpost in blogpostFilterCtrl.setStatusId(status.getStatusId()).execute().getResult()) {
                statusData[index]["blogposts"].append(prepareDetailStruct(blogpost));
            }
        }
        
        return statusData;
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
            "folderName"                 = arguments.blogpost.getFolderName(),
            "releaseDate"                = arguments.blogpost.getReleaseDate() != null ? dateFormat(arguments.blogpost.getReleaseDate(), "YYYY/MM/DD") : "",
            "commentsActivated"          = arguments.blogpost.getCommentsActivated(),
            "anonymousCommentAllowed"    = arguments.blogpost.getAnonymousCommentAllowed(),
            "commentsNeedToGetPublished" = arguments.blogpost.getCommentsNeedToGetPublished(),
            "creatorUserId"              = arguments.blogpost.getCreatorUserId(),
            "categories"                 = categories,
            "private"                    = arguments.blogpost.getPrivate(),
            "isEditable"                 = arguments.blogpost.isEditable(request.user.getUserId()),
            "creator"                    = getUserInformation(arguments.blogpost.getCreator()),
            "creationDate"               = formatCtrl.formatDate(arguments.blogpost.getCreationDate()),
            "lastEditor"                 = getUserInformation(arguments.blogpost.getLastEditor()),
            "lastEditDate"               = formatCtrl.formatDate(arguments.blogpost.getLastEditDate()),
            "statusId"                   = arguments.blogpost.getStatus().getStatusId()
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
            'userName' = arguments._user.getUserName(),
            "avatar"   = arguments._user.getAvatarPath()
        };
    }
    
    
    private struct function prepareStatus(required status status) {
        var nextStatusList = {};
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList[nextStatus.getStatusId()] = {
                    "statusId" = nextStatus.getStatusId(),
                    "name"     = nextStatus.getName(),
                    "active"   = nextStatus.isActive(),
                    "online"   = nextStatus.isOnline(),
                    "editable" = nextStatus.getEditable()
                };
            }
        }
        
        return {
            "statusId"       = arguments.status.getStatusId(),
            "name"           = arguments.status.getName(),
            "active"         = arguments.status.isActive(),
            "online"         = arguments.status.isOnline(),
            "editable"       = arguments.status.getEditable(),
            "deleteable"     = arguments.status.getDeleteable(),
            "showInTasklist" = arguments.status.getShowInTasklist(),
            "nextStatus"     = nextStatusList
        };
    }
    
    private struct function prepareStatusAsArray(required status status) {
        var nextStatusList = [];
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList.append({
                    "statusId" = nextStatus.getStatusId(),
                    "name"     = nextStatus.getName(),
                    "active"   = nextStatus.isActive(),
                    "online"   = nextStatus.isOnline(),
                    "editable" = nextStatus.getEditable()
                });
            }
        }
        
        return {
            "statusId"       = arguments.status.getStatusId(),
            "name"           = arguments.status.getName(),
            "active"         = arguments.status.isActive(),
            "online"         = arguments.status.isOnline(),
            "editable"       = arguments.status.getEditable(),
            "deleteable"     = arguments.status.getDeleteable(),
            "showInTasklist" = arguments.status.getShowInTasklist(),
            "nextStatus"     = nextStatusList
        };
    }
    
    private array function prepareApprovalList(required array approvalList) {
        var preparedApprovalList = [];
        for(var approval in arguments.approvalList) {
            preparedApprovalList.append({
                "user"               = getUserInformation(approval.user),
                "approvalDate"       = formatCtrl.formatDate(approval.approvalDate),
                "previousStatusName" = approval.previousStatus.getName(),
                "newStatusName"      = approval.newStatus.getName()
            });
        }
        
        return preparedApprovalList;
    }
}