component {
    import "API.modules.com.IcedReaper.gallery.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList() {
        var galleryFilterCtrl = new filter().for("gallery");
        
        var galleries = galleryFilterCtrl.execute().getResult();
        var data = [];
        
        for(var i = 1; i <= galleries.len(); i++) {
            data.append(prepareDetailStruct(galleries[i], false));
        }
        
        return data;
    }
    
    remote struct function getDetails(required numeric galleryId = null) {
        var gallery = new gallery(arguments.galleryId);
        
        return prepareDetailStruct(gallery, true);
    }
    
    remote array function loadPictures(required numeric galleryId = null) {
        var gallery = new gallery(arguments.galleryId);
        
        return preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/");
    }
    
    remote array function loadCategories(required numeric galleryId = null) {
        var gallery = new gallery(arguments.galleryId);
        
        return prepareCategoryDetails(gallery.getCategories(), false);
    }
    
    remote array function loadAutoCompleteCategories(required string queryString) {
        var categoryFilter = new filter().for("category");
        
        var categories = categoryFilter.setName(arguments.queryString)
                                       .execute()
                                       .getResult();
        
        if(categories.len() != 1 || categories[1].getName() != arguments.queryString) {
            var dummyCategory = new category(null).setName(arguments.queryString);
            
            categories.append(dummyCategory);
        }
        
        return prepareCategoryDetails(categories, false);
    }
    
    remote struct function save(required numeric galleryId = null,
                                required string  headline,
                                required string  description,
                                required string  title,
                                required string  link,
                                required string  foldername,
                                required string  introduction,
                                required string  story,
                                required boolean private) {
        var gallery = new gallery(arguments.galleryId);
        
        if(gallery.isEditable(request.user)) {
            if(arguments.galleryId == null) {
                gallery.setFoldername(arguments.foldername);
            }
            
            gallery.setHeadline(arguments.headline)
                   .setDescription(arguments.description)
                   .setTitle(arguments.title)
                   .setLink(arguments.link)
                   .setIntroduction(arguments.introduction)
                   .setStory(arguments.story)
                   .setPrivate(arguments.private)
                   .save(request.user);
            
            return prepareDetailStruct(gallery, true);
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function delete(required numeric galleryId) {
        var gallery = new gallery(arguments.galleryId);
        
        if(gallery.isEditable(request.user)) {
            gallery.delete(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function addCategory(required numeric galleryId,
                                        required numeric categoryId,
                                        required string  categoryName) {
        var gallery = new gallery(arguments.galleryId);
        
        if(gallery.isEditable(request.user)) {
            var newCategory = new category(arguments.categoryId);
            if(arguments.categoryId == null) {
                newCategory.setName(arguments.categoryName)
                           .save(request.user);
            }
            gallery.addCategory(newCategory)
                   .save(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function removeCategory(required numeric galleryId,
                                          required numeric categoryId) {
        var gallery = new gallery(arguments.galleryId);
        
        if(gallery.isEditable(request.user)) {
            gallery.removeCategory(arguments.categoryId);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote boolean function uploadPictures(required numeric galleryId) {
        var gallery = new gallery(arguments.galleryId);
        
        if(gallery.isEditable(request.user)) {
            var newPicture = new picture(null);
            newPicture.setGalleryId(arguments.galleryId)
                      .upload(request.user);
            
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
        var picture = new picture(arguments.pictureId);
        var gallery = new gallery(picture.getGalleryId());
        
        if(gallery.isEditable(request.user)) {
            picture.setCaption(arguments.caption)
                   .setAlt(arguments.alt)
                   .setTitle(arguments.title)
                   .save(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    remote array function deletePicture(required numeric pictureId) {
        var picture = new picture(arguments.pictureId);
        var gallery = new gallery(picture.getGalleryId());
        
        if(gallery.isEditable(request.user)) {
            gallery.removePicture(arguments.pictureId, request.user);
            
            return preparePictureStruct(gallery.getPictures(), gallery.getRelativePath() & "/");
        }
        else {
            throw(type = "nephthys.permission.notAuthorized", message = "You are not allowed to edit this blog");
        }
    }
    
    // categories and their details
    remote array function getCategoryList() {
        var categoryFilter = new filter().for("category");
        
        return prepareCategoryDetails(categoryFilter.execute().getResult(), true);
    }
    
    remote struct function getCategoryDetails(required numeric categoryId = null) {
        var category = new category(arguments.categoryId);
        
        return prepareCategoryStruct(category);
    }
    
    remote numeric function saveCategory(required numeric categoryId = null,
                                         required string  name) {
        var category = new category(arguments.categoryId);
        
        category.setName(arguments.name)
                .save(request.user);
        
        return category.getCategoryId();
    }
    
    remote boolean function deleteCategory(required numeric categoryId) {
        var category = new category(arguments.categoryId);
        
        category.delete(request.user);
        
        return true;
    }
    
    remote struct function getGalleryStatistics(required numeric galleryId = null, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getTotal(arguments.galleryId,
                                         arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getStatisticsSeparatedByGallery(required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getSplitPerGallery(arguments.sortOrder,
                                                   _fromDate,
                                                   _toDate);
    }
    
    // STATUS 
    remote boolean function pushToStatus(required numeric galleryId, required numeric statusId) {
        new gallery(arguments.galleryId).pushToStatus(new status(arguments.statusId), request.user);
        
        return true;
    }
    
    remote struct function getStatusList() {
        var statusLoader = new filter().for("status");
        
        var prepStatus = {};
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus[status.getStatusId()] = prepareStatus(status);
        }
        
        return prepStatus;
    }
    
    remote array function getStatusListAsArray() {
        var statusLoader = new filter().for("status");
        
        var prepStatus = [];
        
        for(var status in statusLoader.execute().getResult()) {
            prepStatus.append(prepareStatusAsArray(status));
        }
        
        return prepStatus;
    }
    
    remote struct function getStatusDetails(required numeric statusId = null) {
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
              .save(request.user);
        
        return status.getStatusId();
    }
    
    remote boolean function deleteStatus(required numeric statusId) {
        if(arguments.statusId == application.system.settings.getValueOfKey("com.IcedReaper.gallery.startStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete the start status. Please reset the start status in the system settings");
        }
        
        var galleriesStillWithThisStatus = new filter().for("gallery")
                                                       .setStatusId(arguments.statusId)
                                                       .execute()
                                                       .getResultCount();
        
        if(galleriesStillWithThisStatus == 0) {
            new status(arguments.statusId).delete(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & galleriesStillWithThisStatus & " galleries on this status.");
        }
    }
    
    remote boolean function activateStatus(required numeric statusId) {
        var status = new status(arguments.statusId);
        
        status.setActiveStatus(true)
              .save(request.user);
        
        return true;
    }
    
    remote boolean function deactivateStatus(required numeric statusId) {
        new status(arguments.statusId).setActiveStatus(false)
                                      .save(request.user);
        
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
                
                status.save(request.user);
            }
            
            transactionCommit();
        }
        
        return true;
    }
    
    remote array function getGalleriesInTasklist() {
        var statusFilterCtrl = new filter().for("status")
                                           .setShowInTasklist(true)
                                           .execute();
        
        var galleryFilterCtrl = new filter().for("gallery");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilterCtrl.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["galleries"] = [];
            
            for(var gallery in galleryFilterCtrl.setStatusId(status.getStatusId()).execute().getResult()) {
                var lastApproverFilter = new filter().for("approval")
                                                     .setGalleryId(gallery.getGalleryId())
                                                     .setLimit(1)
                                                     .setSortDirection("DESC")
                                                     .execute();
                var lastApprover = {};
                var lastApprovalDate = "";
                if(lastApproverFilter.getResultCount() == 1) {
                    var approval = lastApproverFilter.getResult()[1];
                    lastApprover = getUserInformation(approval.getApprover());
                    lastApprovalDate = formatCtrl.formatDate(approval.getApprovalDate());
                }
                
                statusData[index]["galleries"].append(prepareDetailStruct(gallery, false));
                statusData[index]["galleries"].last()["lastApprover"] = lastApprover;
                statusData[index]["galleries"].last()["lastApprovalDate"] = lastApprovalDate;
            }
        }
        
        return statusData;
    }
    
    remote array function updatePictureSorting(required array pictures) {
        var updated = [];
        transaction {
            for(var i = 1; i <= arguments.pictures.len(); ++i) {
                var pic = new picture(arguments.pictures[i].pictureId);
                
                if(pic.getSortId() != i) {
                    updated.append({
                        picId = pic.getPictureId(),
                        oldSort = pic.getSortId(),
                        newSort = i
                    });
                    
                    pic.setSortId(i)
                       .save(request.user);
                }
            }
            
            transactionCommit();
        }
        
        return updated;
    }
    
    // private
    private struct function prepareDetailStruct(required gallery gallery, required boolean addApprovalList) {
        var categories = [];
        var gCategories = arguments.gallery.getCategories();
        for(var c = 1; c <= gCategories.len(); c++) {
            categories.append(gCategories[c].getName());
        }
        
        var galleryDetails = {
            "galleryId"    = arguments.gallery.getGalleryId(),
            "headline"     = arguments.gallery.getHeadline(),
            "description"  = arguments.gallery.getDescription(),
            "title"        = arguments.gallery.getTitle(),
            "link"         = arguments.gallery.getLink(),
            "foldername"   = arguments.gallery.getFoldername(),
            "introduction" = arguments.gallery.getIntroduction(),
            "story"        = arguments.gallery.getStory(),
            "pictureCount" = arguments.gallery.getPictureCount(),
            "categories"   = categories,
            "private"      = arguments.gallery.getPrivate(),
            "isEditable"   = arguments.gallery.isEditable(request.user),
            "statusId"     = arguments.gallery.getStatus().getStatusId(),
            "creator"      = getUserInformation(arguments.gallery.getCreator()),
            "creationDate" = formatCtrl.formatDate(arguments.gallery.getCreationDate()),
            "lastEditor"   = getUserInformation(arguments.gallery.getLastEditor()),
            "lastEditDate" = formatCtrl.formatDate(arguments.gallery.getLastEditDate()),
        }
        
        
        if(arguments.addApprovalList && arguments.gallery.getGalleryId() != null) {
            var preparedApprovalList = prepareApprovalList(new filter().for("approval")
                                                                       .setGalleryId(arguments.gallery.getGalleryId())
                                                                       .setSortDirection("DESC")
                                                                       .execute()
                                                                       .getResult());
            
            galleryDetails["approvalList"] = preparedApprovalList;
        }
        
        return galleryDetails;
    }
    
    private array function preparePictureStruct(required array pictures, required string relativePath) {
        var gPictures = [];
        for(var p = 1; p <= arguments.pictures.len(); p++) {
            gPictures.append({
                "pictureId"         = arguments.pictures[p].getPictureId(),
                "sortId"            = arguments.pictures[p].getSortId(),
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
        var galleryFilterCtrl = new filter().for("gallery");
        
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
            "userId"   = arguments._user.getUserId(),
            "userName" = arguments._user.getUserName(),
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
                "approver"           = getUserInformation(approval.getApprover()),
                "approvalDate"       = formatCtrl.formatDate(approval.getApprovalDate()),
                "previousStatusName" = approval.getPrevStatus().getName(),
                "newStatusName"      = approval.getNewStatus().getName()
            });
        }
        
        return preparedApprovalList;
    }
}