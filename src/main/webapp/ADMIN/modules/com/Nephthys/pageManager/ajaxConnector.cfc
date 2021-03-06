component {
    import "API.modules.com.Nephthys.pageManager.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList() {
        var pageFilter = new filter().for("page").execute();
        
        var pageData = [];
        for(var page in pageFilter.getResult()) {
            var actualPageVersion = page.getActualPageVersion();
            
            pageData.append({
                "pageId"             = page.getPageId(),
                "pageVersionId"      = actualPageVersion.getPageVersionId(),
                "linktext"           = actualPageVersion.getLinktext(),
                "link"               = actualPageVersion.getLink(),
                "title"              = actualPageVersion.getTitle(),
                "description"        = actualPageVersion.getDescription(),
                "useDynamicUrlSuffix" = actualPageVersion.getuseDynamicUrlSuffix(),
                "creator"            = getUserInformation(actualPageVersion.getCreator()),
                "creationDate"       = formatCtrl.formatDate(actualPageVersion.getCreationDate()),
                "lastEditor"         = getUserInformation(actualPageVersion.getLastEditor()),
                "lastEditDate"       = formatCtrl.formatDate(actualPageVersion.getLastEditDate()),
                "isOnline"           = actualPageVersion.isOnline(),
                "statusId"           = actualPageVersion.getStatus().getStatusId(),
                "statusName"         = actualPageVersion.getStatus().getName(),
                "version"            = actualPageVersion.getVersion(),
                "majorVersion"       = actualPageVersion.getMajorVersion(),
                "minorVersion"       = actualPageVersion.getMinorVersion()
            });
        }
        
        return pageData;
    }
    
    remote array function getPageVersionInTasklist() {
        var statusFilter = new filter().for("status")
                                           .setShowInTasklist(true)
                                           .execute();
        
        var pageVersionFilter = new filter().for("pageVersion");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilter.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["pages"] = [];
            
            for(var pageVersion in pageVersionFilter.setStatusId(status.getStatusId()).execute().getResult()) {
                var lastApproverFilter = new filter().for("approval")
                                                     .setPageVersionId(pageVersion.getPageVersionId())
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
                
                statusData[index]["pages"].append({
                    "pageId"           = pageVersion.getPageId(),
                    "pageVersionId"    = pageVersion.getPageVersionId(),
                    "linktext"         = pageVersion.getLinktext(),
                    "link"             = pageVersion.getLink(),
                    "title"            = pageVersion.getTitle(),
                    "description"      = pageVersion.getDescription(),
                    "creator"          = getUserInformation(pageVersion.getCreator()),
                    "creationDate"     = formatCtrl.formatDate(pageVersion.getCreationDate()),
                    "lastEditor"       = getUserInformation(pageVersion.getLastEditor()),
                    "lastEditDate"     = formatCtrl.formatDate(pageVersion.getLastEditDate()),
                    "version"          = pageVersion.getVersion(),
                    "majorVersion"     = pageVersion.getMajorVersion(),
                    "minorVersion"     = pageVersion.getMinorVersion(),
                    "lastApprover"     = lastApprover,
                    "lastApprovalDate" = lastApprovalDate
                });
            }
        }
        
        return statusData;
    }
    
    remote struct function getActualUser() {
        return {
            "userId"   = request.user.getUserId(),
            "userName" = request.user.getUserName()
        };
    }
    
    remote struct function getDetails(required numeric pageId = null) {
        var page = new page(arguments.pageId);
        
        var returnValue = {
            "pageId"        = page.getPageId(),
            "versions"      = {},
            "actualVersion" = {
                "major" = 1,
                "minor" = 0
            },
            "availableVersions" = {}
        };
        
        // if it's not a new page and we have at least a version
        if(arguments.pageId != null || page.getPageVersionId() != null) {
            var actualPageVersion = page.getActualPageVersion();
            
            returnValue["actualVersion"]["major"] = actualPageVersion.getMajorVersion();
            returnValue["actualVersion"]["minor"] = actualPageVersion.getMinorVersion();
            
            returnValue.versions[actualPageVersion.getMajorVersion()] = {};
            returnValue.versions[actualPageVersion.getMajorVersion()][actualPageVersion.getMinorVersion()] = preparePageVersion(actualPageVersion);;
            
            var pageVersions = new filter().for("pageVersion").setPageId(page.getPageId()).execute().getResult();
            for(var pageVersion in pageVersions) {
                if(! returnValue["availableVersions"].keyExists(pageVersion.getMajorVersion())) {
                    returnValue["availableVersions"][pageVersion.getMajorVersion()] = [];
                }
                
                returnValue["availableVersions"][pageVersion.getMajorVersion()].append(pageVersion.getMinorVersion());
            }
        }
        // otherwise we "create" a new blank one
        else {
            returnValue.versions[1] = {
                0 = preparePageVersion(new pageVersion(null))
            };
            
            returnValue["availableVersions"] = {
                1 = [0]
            };
        }
        
        return returnValue;
    }
    
    remote struct function getDetailsForVersion(required numeric pageId, required numeric majorVersion, required numeric minorVersion) {
        return preparePageVersion(new filter().for("pageVersion")
                                              .setPageId(arguments.pageId)
                                              .setMajorVersion(arguments.majorVersion)
                                              .setMinorVersion(arguments.minorVersion)
                                              .execute()
                                              .getResult()[1]);
    }
    
    remote struct function save(required numeric pageId = null,
                                required struct  pageVersion,
                                required numeric majorVersion,
                                required numeric minorVersion) {
        transaction {
            var page = new page(arguments.pageId);
            var newPage = false;
            if(arguments.pageId == null) {
                page.save(request.user);
                
                newPage = true;
                arguments.pageId = page.getPageId();
            }
            
            var pageVersion = new pageVersion(arguments.pageVersion.pageVersionId);
            if(pageVersion.getStatus().getEditable()) {
                if(arguments.pageVersion.pageVersionId == null) {
                    pageVersion.setPageId(arguments.pageId)
                               .setMajorVersion(arguments.majorVersion)
                               .setMinorVersion(arguments.minorVersion);
                }
                
                pageVersion.setLinktext(arguments.pageVersion.linktext)
                           .setLink(arguments.pageVersion.link)
                           .setTitle(arguments.pageVersion.title)
                           .setDescription(arguments.pageVersion.description)
                           .setContent(arguments.pageVersion.content)
                           .setuseDynamicUrlSuffix(arguments.pageVersion.useDynamicUrlSuffix)
                           .setStatus(new status(arguments.pageVersion.statusId))
                           .save(request.user);
                
                if(newPage) {
                    page.setPageVersionId(pageVersion.getPageVersionId())
                        .save(request.user);
                }
                
                transactionCommit();
                
                return {
                    pageId = arguments.pageId,
                    pageVersionId = pageVersion.getPageVersionId()
                };
            }
            else {
                transactionRollback();
                throw(type = "nephthys.application.notAllowed", message = "The page version is in an non showInTasklist status.");
            }
        }
    }
    
    remote boolean function pushToStatus(required numeric pageVersionId, required numeric statusId) {
        new pageVersion(arguments.pageVersionId).pushToStatus(new status(arguments.statusId), request.user);
        
        return true;
    }
    
    remote boolean function delete(required numeric pageId) {
        if(request.user.hasPermission("com.Nephthys.userManager", "admin")) {
            new page(arguments.pageId).delete(request.user);
            return true;
        }
        else {
            throw(type = "nephthys.application.insufficientPermissions", message = "You have insufficient permissions. You need the role 'Admin' for the modile com.Nephthys.userManager");
        }
    }
    
    // STATUS
    
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
        transaction {
            var status = new status(arguments.status.statusId);
            
            status.setActiveStatus(arguments.status.active)
                  .setEditable(arguments.status.editable)
                  .setName(arguments.status.name)
                  .setOnlineStatus(arguments.status.online)
                  .setDeleteable(arguments.status.deleteable)
                  .setShowInTasklist(arguments.status.showInTasklist)
                  .save(request.user);
            
            transactionCommit();
        }
        
        return status.getStatusId();
    }
    
    remote boolean function deleteStatus(required numeric statusId) {
        if(arguments.statusId == application.system.settings.getValueOfKey("startStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete the start status. Please reset the start status in the system settings");
        }
        if(arguments.statusId == application.system.settings.getValueOfKey("endStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot remove the end status. Please reset the end status in the system settings");
        }
        
        var pagesStillWithThisStatus = new filter().for("page")
                                                   .setStatusId(arguments.statusId)
                                                   .execute()
                                                   .getResultCount();
        var sitemapsStillWithThisStatus = new filter().for("sitemap")
                                                         .setStatusId(arguments.statusId)
                                                         .execute()
                                                         .getResultCount();
        
        if(pagesStillWithThisStatus == 0 && sitemapsStillWithThisStatus == 0) {
            new status(arguments.statusId).delete(request.user);
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & pagesStillWithThisStatus & " pages and " & sitemapsStillWithThisStatus & " sitemaps on this status.");
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
    
    remote struct function getModule() {
        var moduleFilter = createObject("component", "API.modules.com.Nephthys.moduleManager.filter").init()
                                                                                                  .for("module");
        
        moduleFilter.setAvailableWWW(true)
                        .execute();
        
        var modules = {};
        
        for(var module in moduleFilter.getResult()) {
            modules[module.getModuleName()] = {
                "useDynamicUrlSuffix"           = module.getUseDynamicUrlSuffix(),
                "options"                       = [],
                "subModules"                    = [],
                "canBeRootElement"              = module.getCanBeRootElement(),
                "canBeRootElementMultipleTimes" = module.getCanBeRootElementMultipleTimes()
            };
            
            for(var subModule in module.getSubModules()) {
                modules[module.getModuleName()].subModules.append(subModule.getModuleName());
            }
            
            for(var option in module.getOptions()) {
                modules[module.getModuleName()].options.append({
                    "dbName"        = option.getOptionName(),
                    "description"   = option.getDescription(),
                    "type"          = option.getType(),
                    "selectOptions" = option.getSelectOptions(),
                    "multiple"      = option.isMultiple()
                });
            }
        }
        
        return modules;
    }
    
    remote array function getSitemap() {
        var regions = new filter().for("region")
                                  .execute()
                                  .getResult();
        
        var sitemaps = new filter().for("sitemap")
                                      .execute()
                                      .getResult();
        
        var preparedSitemaps = [];
        for(var sitemap in sitemaps) {
            var preparedApprovalList = prepareApprovalList(new filter().for("approval")
                                                                       .setSitemapId(sitemap.getSitemapId())
                                                                       .setSortDirection("DESC")
                                                                       .execute()
                                                                       .getResult());
            
            var preparedRegions = [];
            for(region in regions) {
                preparedRegions.append({
                    "name"        = region.getName(),
                    "description" = region.getDescription(),
                    "regionId"    = region.getRegionId(),
                    "pages"       = getSubPagesForSitemap(null, region.getRegionId(), sitemap.getSitemapId())
                });
            }
            
            preparedSitemaps.append({
                "sitemapId"        = sitemap.getSitemapId(),
                "version"          = sitemap.getVersion(),
                "showInTasklist" = sitemap.getStatus().getEditable(),
                "statusId"         = sitemap.getStatus().getStatusId(),
                "regions"          = preparedRegions,
                "approvalList"     = preparedApprovalList,
                "offline"          = [{
                    "regionId"    = null,
                    "name"        = null,
                    "description" = "Offline",
                    "pages"       = getSubPagesForSitemap(null, null, sitemap.getSitemapId())
                }]
            });
        }

        return preparedSitemaps;
    }
    
    remote array function getSitemapInTasklist() {
        var statusFilter = new filter().for("status")
                                           .setShowInTasklist(true)
                                           .execute();
        
        var sitemapFilter = new filter().for("sitemap");
        var sitemapPageFilter = new filter().for("sitemapPage");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilter.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["sitemaps"] = [];
            
            for(var sitemap in sitemapFilter.setStatusId(status.getStatusId()).execute().getResult()) {
                var lastApproverFilter = new filter().for("approval")
                                                     .setSitemapId(sitemap.getSitemapId())
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
                
                statusData[index]["sitemaps"].append({
                    "sitemapId"        = sitemap.getSitemapId(),
                    "version"          = sitemap.getVersion(),
                    "showInTasklist" = sitemap.getStatus().getEditable(),
                    "statusId"         = sitemap.getStatus().getStatusId(),
                    "creator"          = getUserInformation(sitemap.getCreator()),
                    "creationDate"     = formatCtrl.formatDate(sitemap.getCreationDate()),
                    "lastEditor"       = getUserInformation(sitemap.getLastEditor()),
                    "lastEditDate"     = formatCtrl.formatDate(sitemap.getLastEditDate()),
                    "pageCount"        = sitemapPageFilter.setSitemapId(sitemap.getSitemapId()).execute().getResultCount(),
                    "lastApprover"     = lastApprover,
                    "lastApprovalDate" = lastApprovalDate
                });
            }
        }
        
        return statusData;
    }
    
    remote struct function addSitemapVersion() {
        var sitemap = getSitemap();
        
        var lastIndex = sitemap.len();
        var index = lastIndex + 1;
        
        var statusId = application.system.settings.getValueOfKey("startStatus");
        
        sitemap[index] = {
            "sitemapId"        = null,
            "version"          = javaCast("integer", index),
            "showInTasklist" = true,
            "statusId"         = javaCast("integer", statusId),
            "regions"          = [],
            "offline"          = []
        };
        
        if(index > 1) {
            // existing sitemap
            sitemap[index]["regions"] = duplicate(sitemap[lastIndex].regions);
            sitemap[index]["offline"] = duplicate(sitemap[lastIndex].offline);
        }
        else {
            // without existing completly new
            sitemap[index]["regions"] = getRegions();
            
            for(var i = 1; i <= sitemap[index]["regions"].len(); ++i) {
                sitemap[index]["regions"][i].pages = [];
            }
            
            var notSetIndex = sitemap[index]["regions"].len();
            
            for(var page in getList()) {
                sitemap[index]["regions"][notSetIndex].pages.append({
                    "pageId" = page.pageId,
                    "title"  = page.linktext,
                    "pages"  = []
                });
            }
        }
        
        return {
            "newVersion" = javaCast("integer", index),
            "sitemap"  = sitemap
        };
    }
    
    remote numeric function saveSitemap(required struct sitemap) {
        transaction {
            var sitemap = new sitemap(arguments.sitemap.sitemapId);
            
            sitemap.setStatus(new status(arguments.sitemap.statusId))
                   .setVersion(arguments.sitemap.version)
                   .save(request.user);
            
            sitemap.updatePagesByRegion(arguments.sitemap.regions);
            
            transactionCommit();
        }
        
        return sitemap.getSitemapId();
    }
    
    remote boolean function pushSitemapToStatus(required numeric sitemapId, required numeric statusId) {
        new sitemap(arguments.sitemapId).pushToStatus(new status(arguments.statusId), request.user);
        
        return true;
    }
    
    // STATISTICS
    remote struct function getPageRequests(required numeric pageId = null, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");
        
        return new statistics().getTotal(arguments.pageId,
                                         arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getPageRequestsSeparatedByPage(required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getTotalSplitPerPage(arguments.sortOrder,
                                                     _fromDate,
                                                     _toDate);
    }
    
    remote struct function getPageRequestsSeparatedByLink(required numeric pageId, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");
        
        return new statistics().getSplitPerPage(arguments.pageId,
                                                arguments.sortOrder,
                                                _fromDate,
                                                _toDate);
    }
    
    
    // P R I V A T E
    private array function getSubPagesForSitemap(required numeric parentId, required numeric regionId, required numeric sitemapId) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        if(arguments.regionId != null) {
            var pageFilter = new filter().for("page")
                                             .setInSitemap(true)
                                             .setParentId(arguments.parentId)
                                             .setSitemapId(arguments.sitemapId)
                                             .setRegionId(arguments.regionId);
        }
        else {
            var pageFilter = new filter().for("pagesNotInSitemap")
                                             .setSitemapId(arguments.sitemapId);
        }
        
        pageFilter.execute();
        
        var pageData = [];
        for(var page in pageFilter.getResult()) {
            var pageVersion = page.getActualPageVersion();
            pageData.append({
                "pageId" = page.getPageId(),
                "title"  = pageVersion.getLinktext(),
                "pages"  = arguments.regionId != null ? getSubPagesForSitemap(page.getPageId(), arguments.regionId, arguments.sitemapId) : []
            });
        }
        
        return pageData;
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            "userId"   = arguments._user.getUserId(),
            "userName" = arguments._user.getUserName(),
            "avatar"   = arguments._user.getAvatarPath()
        };
    }
    
    private struct function prepareVisitData(required array visitData) {
        var labels = [];
        var data   = [];
        
        for(var i = 1; i <= arguments.visitData.len(); i++) {
            labels[i] = arguments.visitData[i].date;
            data[i]   = arguments.visitData[i].count;
        }
        
        return {
            "labels" = labels,
            "data"   = data
        };
    }
    
    private struct function prepareVisitDataWithParameter(required array visitData) {
        var labels = [];
        var series = {};
        var data   = [];
        
        var linkCount = 1;
        var currCount = 0;
        var lastDate = null;
        for(var i = 1; i <= arguments.visitData.len(); i++) {
            if(lastDate != arguments.visitData[i].date) {
                lastDate = arguments.visitData[i].date;
                
                labels.append(arguments.visitData[i].date);
                
                currCount = 1;
            }
            else {
                currCount++;
            }
            
            if(currCount > linkCount) {
                linkCount = currCount;
            }
            
            if(arguments.visitData[i].link != "") {
                series[arguments.visitData[i].link] = true;
            }
        }
        
        series = structKeyArray(series).sort("textnocase", "asc");
        lastDate = null;
        var j = 0;
        var k = 0;
        
        for(j = 1; j <= series.len(); j++) {
            data[j] = [];
            k = 0;
        
            for(i = 1; i <= arguments.visitData.len(); i++) {
                if(lastDate != arguments.visitData[i].date) {
                    lastDate = arguments.visitData[i].date;
                    
                    data[j][++k] = 0;
                }
                
                if(arguments.visitData[i].link  != "" &&
                   arguments.visitData[i].count != "" &&
                   arguments.visitData[i].link  == series[j]) {
                    data[j][k] = arguments.visitData[i].count;
                }
            }
        }
        
        return {
            "labels" = labels,
            "series" = series,
            "data"   = data
        };
    }
    
    private struct function preparePageVersion(required pageVersion pageVersion) {
        var preparedApprovalList = prepareApprovalList(new filter().for("approval")
                                                                   .setPageVersionId(arguments.pageVersion.getPageVersionId())
                                                                   .setSortDirection("DESC")
                                                                   .execute()
                                                                   .getResult());
        
        return  {
            "pageVersionId"      = arguments.pageVersion.getPageVersionId(),
            "linktext"           = arguments.pageVersion.getLinktext(),
            "link"               = arguments.pageVersion.getLink(),
            "title"              = arguments.pageVersion.getTitle(),
            "description"        = arguments.pageVersion.getDescription(),
            "content"            = arguments.pageVersion.getContent(),
            "useDynamicUrlSuffix" = arguments.pageVersion.getuseDynamicUrlSuffix(),
            "isOnline"           = arguments.pageVersion.isOnline(),
            "creator"            = getUserInformation(arguments.pageVersion.getCreator()),
            "creationDate"       = formatCtrl.formatDate(arguments.pageVersion.getCreationDate()),
            "lastEditor"         = getUserInformation(arguments.pageVersion.getLastEditor()),
            "lastEditDate"       = formatCtrl.formatDate(arguments.pageVersion.getLastEditDate()),
            "statusId"           = arguments.pageVersion.getStatus().getStatusId(),
            "approvalList"       = preparedApprovalList,
            "completeLink"       = application.system.settings.getValueOfKey("wwwDomain") & arguments.pageVersion.getLink()
        };
    }
    
    private struct function prepareStatus(required status status) {
        var nextStatusList = {};
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList[nextStatus.getStatusId()] = {
                    "statusId"       = nextStatus.getStatusId(),
                    "name"           = nextStatus.getName(),
                    "active"         = nextStatus.isActive(),
                    "online"         = nextStatus.isOnline(),
                    "showInTasklist" = nextStatus.getEditable()
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
                    "statusId"       = nextStatus.getStatusId(),
                    "name"           = nextStatus.getName(),
                    "active"         = nextStatus.isActive(),
                    "online"         = nextStatus.isOnline(),
                    "showInTasklist" = nextStatus.getEditable()
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