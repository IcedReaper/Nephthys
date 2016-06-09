component {
    import "API.modules.com.Nephthys.page.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList() {
        var pageFilterCtrl = new filter().setFor("page").execute();
        
        var pageData = [];
        for(var page in pageFilterCtrl.getResult()) {
            var actualPageVersion = page.getActualPageVersion();
            
            pageData.append({
                "pageId"             = page.getPageId(),
                "pageVersionId"      = actualPageVersion.getPageVersionId(),
                "linktext"           = actualPageVersion.getLinktext(),
                "link"               = actualPageVersion.getLink(),
                "title"              = actualPageVersion.getTitle(),
                "description"        = actualPageVersion.getDescription(),
                "useDynamicSuffixes" = actualPageVersion.getUseDynamicSuffixes(),
                "creator"            = getUserInformation(actualPageVersion.getCreator()),
                "creationDate"       = formatCtrl.formatDate(actualPageVersion.getCreationDate()),
                "lastEditor"         = getUserInformation(actualPageVersion.getLastEditor()),
                "lastEditDate"       = formatCtrl.formatDate(actualPageVersion.getLastEditDate()),
                "isOnline"           = actualPageVersion.isOnline(),
                "statusId"           = actualPageVersion.getStatusId(),
                "statusName"         = actualPageVersion.getStatus().getName(),
                "version"            = actualPageVersion.getVersion(),
                "majorVersion"       = actualPageVersion.getMajorVersion(),
                "minorVersion"       = actualPageVersion.getMinorVersion()
            });
        }
        
        return pageData;
    }
    
    remote array function getPageVersionInTasklist() {
        var statusFilterCtrl = new filter().setFor("status")
                                           .setPagesRequireAction(true)
                                           .execute();
        
        var pageVersionFilterCtrl = new filter().setFor("pageVersion");
        
        var statusData = [];
        var index = 0;
        for(var status in statusFilterCtrl.execute().getResult()) {
            index++;
            statusData[index] = prepareStatusAsArray(status);
            statusData[index]["pages"] = [];
            
            for(var pageVersion in pageVersionFilterCtrl.setStatusId(status.getStatusId()).execute().getResult()) {
                statusData[index]["pages"].append({
                    "pageId"        = pageVersion.getPageId(),
                    "pageVersionId" = pageVersion.getPageVersionId(),
                    "linktext"      = pageVersion.getLinktext(),
                    "link"          = pageVersion.getLink(),
                    "title"         = pageVersion.getTitle(),
                    "description"   = pageVersion.getDescription(),
                    "creator"       = getUserInformation(pageVersion.getCreator()),
                    "creationDate"  = formatCtrl.formatDate(pageVersion.getCreationDate()),
                    "lastEditor"    = getUserInformation(pageVersion.getLastEditor()),
                    "lastEditDate"  = formatCtrl.formatDate(pageVersion.getLastEditDate()),
                    "version"       = pageVersion.getVersion(),
                    "majorVersion"  = pageVersion.getMajorVersion(),
                    "minorVersion"  = pageVersion.getMinorVersion()
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
    
    remote struct function getDetails(required numeric pageId) {
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
        if((arguments.pageId != null && arguments.pageId != 0) || (page.getPageVersionId() != null && page.getPageVersionId() != 0)) {
            var actualPageVersion = page.getActualPageVersion();
            
            returnValue["actualVersion"]["major"] = actualPageVersion.getMajorVersion();
            returnValue["actualVersion"]["minor"] = actualPageVersion.getMinorVersion();
            
            returnValue.versions[actualPageVersion.getMajorVersion()] = {};
            returnValue.versions[actualPageVersion.getMajorVersion()][actualPageVersion.getMinorVersion()] = preparePageVersion(actualPageVersion);;
            
            var pageVersions = new filter().setFor("pageVersion").setPageId(page.getPageId()).execute().getResult();
            for(var pageVersion in pageVersions) {
                if(! returnValue["availableVersions"].keyExists(pageVersion.getMajorVersion())) {
                    returnValue["availableVersions"][pageVersion.getMajorVersion()] = [];
                }
                
                returnValue["availableVersions"][pageVersion.getMajorVersion()].append(pageVersion.getMinorVersion);
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
        return preparePageVersion(new filter().setFor("pageVersion")
                                              .setPageId(arguments.pageId)
                                              .setMajorVersion(arguments.majorVersion)
                                              .setMinorVersion(arguments.minorVersion)
                                              .execute()
                                              .getResult()[1]);
    }
    
    remote struct function save(required numeric pageId,
                                required struct  pageVersion,
                                required numeric majorVersion,
                                required numeric minorVersion) {
        transaction {
            var page = new page(arguments.pageId);
            var newPage = false;
            if(arguments.pageId == null || arguments.pageId == 0) {
                page.save();
                
                newPage = true;
                arguments.pageId = page.getPageId();
            }
            
            var pageVersion = new pageVersion(arguments.pageVersion.pageVersionId);
            if(pageVersion.getStatus().arePagesEditable()) {
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
                           .setUseDynamicSuffixes(arguments.pageVersion.useDynamicSuffixes)
                           .setLastEditorById(request.user.getUserId())
                           .setLastEditDate(now())
                           .setStatusId(arguments.pageVersion.statusId);
                
                pageVersion.save();
                
                if(newPage) {
                    page.setPageVersionId(pageVersion.getPageVersionId())
                        .save();
                }
                
                transactionCommit();
                
                return {
                    pageId = arguments.pageId,
                    pageVersionId = pageVersion.getPageVersionId()
                };
            }
            else {
                transactionRollback();
                throw(type = "nephthys.application.notAllowed", message = "The page version is in an non pagesAreEditable status.");
            }
        }
    }
    
    remote boolean function pushToStatus(required numeric pageVersionId, required numeric statusId) {
        new pageVersion(arguments.pageVersionId).pushToStatus(arguments.statusId, request.user);
        
        return true;
    }
    
    remote boolean function delete(required numeric pageId) {
        // TODO: Implement Security check - has permission
        new page(arguments.pageId).delete();
        
        return true;
    }
    
    remote struct function loadStatistics(required numeric pageId) {
        /* TODO: IMplement
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        
        var pageStatistics = createObject("component", "API.modules.com.Nephthys.statistics.pageVisit").init();
        var chartData              = prepareVisitData(pageStatistics.getPageStatistics(dateAdd("d", -30, now()), now(), arguments.pageId));
        var chartWithParameterData = prepareVisitDataWithParameter(pageStatistics.getPageStatistcsWithParameter(dateAdd("d", -10, now()), now(), arguments.pageId));
        
        return {
            "useDynamicSuffixes" = page.getUseDynamicSuffixes(),
            "chart"              = chartData,
            "chartWithParameter" = chartWithParameterData
        };
        */
        return {};
    }
    
    // STATUS
    
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
    
    remote boolean function saveStatus(required struct status) {
        transaction {
            var status = new status(arguments.status.statusId);
            
            status.setActiveStatus(arguments.status.active)
                  .setPagesAreEditable(arguments.status.pagesAreEditable)
                  .setName(arguments.status.name)
                  .setOnlineStatus(arguments.status.online)
                  .setPagesAreDeleteable(arguments.status.pagesAreDeleteable)
                  .setPagesRequireAction(arguments.status.pagesRequireAction)
                  .setLastEditor(request.user)
                  .save();
            
            transactionCommit();
            return true;
        }
    }
    
    remote boolean function deleteStatus(required numeric statusId) {
        if(arguments.statusId == application.system.settings.getValueOfKey("startStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete the start status. Please reset the start status in the system settings");
        }
        if(arguments.statusId == application.system.settings.getValueOfKey("endStatus")) {
            throw(type = "nephthys.application.notAllowed", message = "You cannot remove the end status. Please reset the end status in the system settings");
        }
        
        var pagesStillWithThisStatus = new filter().setFor("page")
                                                   .setStatusId(arguments.statusId)
                                                   .execute()
                                                   .getResultCount();
        var hierarchiesStillWithThisStatus = new filter().setFor("hierarchy")
                                                         .setStatusId(arguments.statusId)
                                                         .execute()
                                                         .getResultCount();
        
        if(pagesStillWithThisStatus == 0 && hierarchiesStillWithThisStatus == 0) {
            new status(arguments.statusId).delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & pagesStillWithThisStatus & " pages and " & hierarchiesStillWithThisStatus & " hierarchies on this status.");
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
    
    // TODO: Workflow
    
    
    
    remote struct function getAvailableSubModules() {
        var moduleFilterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        var modules = moduleFilterCtrl.setAvailableWWW(true)
                                      .execute()
                                      .getResult();
        
        var _modules = {};
        
        for(var i = 1; i <= modules.len(); ++i) {
            _modules[modules[i].getModuleName()] = [];
            
            var subModules = modules[i].getSubModules();
            for(var j = 1; j <= subModules.len(); ++j) {
                _modules[modules[i].getModuleName()].append(subModules[j].getModuleName());
            }
        }
        
        return _modules;
    }
    
    remote struct function getAvailableOptions() {
        var moduleFilterCtrl = createObject("component", "API.modules.com.Nephthys.module.filter").init();
        
        var modules = moduleFilterCtrl.setAvailableWWW(true)
                                      .execute()
                                      .getResult();
        
        var _modules = {};
        
        for(var i = 1; i <= modules.len(); ++i) {
            _modules[modules[i].getModuleName()] = [];
            
            var options = modules[i].getOptions();
            for(var j = 1; j <= options.len(); ++j) {
                _modules[modules[i].getModuleName()][j] = {
                    "dbName"        = options[j].getOptionName(),
                    "description"   = options[j].getDescription(),
                    "type"          = options[j].getType(),
                    "selectOptions" = options[j].getSelectOptions()
                };
            }
        }
        
        return _modules;
    }
    
    remote array function getHierarchy() {
        var regions = new filter().setFor("region")
                                  .execute()
                                  .getResult();
        
        var hierarchies = new filter().setFor("hierarchy")
                                      .execute()
                                      .getResult();
        
        var preparedHierarchies = [];
        for(hierarchy in hierarchies) {
            var preparedApprovalList = prepareApprovalList(new approval(hierarchy.getHierarchyId()).setFor("hierarchyVersion").getApprovalList());
            
            var preparedRegions = [];
            for(region in regions) {
                preparedRegions.append({
                    "name"        = region.getName(),
                    "description" = region.getDescription(),
                    "regionId"    = region.getRegionId(),
                    "pages"       = getSubPagesForHierarchy(null, region.getRegionId(), hierarchy.getHierarchyId())
                });
            }
            
            preparedHierarchies.append({
                "hierarchyId"      = hierarchy.getHierarchyId(),
                "version"          = hierarchy.getVersion(),
                "pagesAreEditable" = hierarchy.getStatus().arePagesEditable(),
                "statusId"         = hierarchy.getStatus().getStatusId(),
                "regions"          = preparedRegions,
                "approvalList"     = preparedApprovalList,
                "offline"          = [{
                    "regionId"    = null,
                    "name"        = null,
                    "description" = "Offline",
                    "pages"       = getSubPagesForHierarchy(null, null, hierarchy.getHierarchyId())
                }]
            });
        }

        return preparedHierarchies;
    }
    
    remote struct function addHierarchyVersion() {
        var hierarchy = getHierarchy();
        
        var lastIndex = hierarchy.len();
        var index = lastIndex + 1;
        
        var statusId = application.system.settings.getValueOfKey("startStatus");
        
        hierarchy[index] = {
            "hierarchyId"      = null,
            "version"          = javaCast("integer", index),
            "pagesAreEditable" = true,
            "statusId"         = javaCast("integer", statusId),
            "regions"          = [],
            "offline"          = []
        };
        
        if(index > 1) {
            // existing hierarchy
            hierarchy[index]["regions"] = duplicate(hierarchy[lastIndex].regions);
            hierarchy[index]["offline"] = duplicate(hierarchy[lastIndex].offline);
        }
        else {
            // without existing completly new
            hierarchy[index]["regions"] = getRegions();
            
            for(var i = 1; i <= hierarchy[index]["regions"].len(); ++i) {
                hierarchy[index]["regions"][i].pages = [];
            }
            
            var notSetIndex = hierarchy[index]["regions"].len();
            
            for(var page in getList()) {
                hierarchy[index]["regions"][notSetIndex].pages.append({
                    "pageId" = page.pageId,
                    "title"  = page.linktext,
                    "pages"  = []
                });
            }
        }
        
        return {
            "newVersion" = javaCast("integer", index),
            "hierarchy"  = hierarchy
        };
    }
    
    remote numeric function saveHierarchy(required struct hierarchy) {
        transaction {
            var hierarchy = new hierarchy(arguments.hierarchy.hierarchyId);
            
            hierarchy.setStatus(new status(arguments.hierarchy.statusId))
                     .setVersion(arguments.hierarchy.version)
                     .setCreator(request.user)
                     .setLastEditor(request.user)
                     .setCreationDate(now())
                     .setLastEditDate(now())
                     .save();
            
            hierarchy.updatePagesByRegion(arguments.hierarchy.regions);
            
            transactionCommit();
        }
        
        return hierarchy.getHierarchyId();
    }
    
    remote boolean function pushHierarchyToStatus(required numeric hierarchyId, required numeric statusId) {
        new hierarchy(arguments.hierarchyId).pushToStatus(new status(arguments.statusId));
        
        return true;
    }
    
    
    
    // P R I V A T E
    private array function getSubPagesForHierarchy(required numeric parentId, required numeric regionId, required numeric hierarchyId) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        
        
        if(arguments.regionId != null) {
            var pageFilterCtrl = new filter().setFor("sitemap")
                                             .setParentId(arguments.parentId)
                                             .setHierarchyId(arguments.hierarchyId)
                                             .setRegionId(arguments.regionId);
        }
        else {
            var pageFilterCtrl = new filter().setFor("pagesNotInHierarchy")
                                             .setHierarchyId(arguments.hierarchyId);
        }
        
        pageFilterCtrl.execute();
        
        var pageData = [];
        for(var page in pageFilterCtrl.getResult()) {
            var pageVersion = page.getActualPageVersion();
            pageData.append({
                "pageId" = page.getPageId(),
                "title"  = pageVersion.getLinktext(),
                "pages"  = arguments.regionId != null ? getSubPagesForHierarchy(page.getPageId(), arguments.regionId, arguments.hierarchyId) : []
            });
        }
        
        return pageData;
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            "userId"   = arguments._user.getUserId(),
            "userName" = arguments._user.getUserName()
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
        var preparedApprovalList = prepareApprovalList(new approval(arguments.pageVersion.getPageVersionId()).setFor("pageVersion").getApprovalList());
        
        return  {
            "pageVersionId"      = arguments.pageVersion.getPageVersionId(),
            "linktext"           = arguments.pageVersion.getLinktext(),
            "link"               = arguments.pageVersion.getLink(),
            "title"              = arguments.pageVersion.getTitle(),
            "description"        = arguments.pageVersion.getDescription(),
            "content"            = arguments.pageVersion.getContent(),
            "useDynamicSuffixes" = arguments.pageVersion.getUseDynamicSuffixes(),
            "isOnline"           = arguments.pageVersion.isOnline(),
            "creator"            = getUserInformation(arguments.pageVersion.getCreator()),
            "creationDate"       = formatCtrl.formatDate(arguments.pageVersion.getCreationDate()),
            "lastEditor"         = getUserInformation(arguments.pageVersion.getLastEditor()),
            "lastEditDate"       = formatCtrl.formatDate(arguments.pageVersion.getLastEditDate()),
            "statusId"           = arguments.pageVersion.getStatusId(),
            "approvalList"       = preparedApprovalList
        };
    }
    
    private struct function prepareStatus(required status status) {
        var nextStatusList = {};
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList[nextStatus.getStatusId()] = {
                    "statusId"         = nextStatus.getStatusId(),
                    "name"             = nextStatus.getName(),
                    "active"           = nextStatus.isActive(),
                    "online"           = nextStatus.isOnline(),
                    "pagesAreEditable" = nextStatus.arePagesEditable()
                };
            }
        }
        
        return {
            "statusId"           = arguments.status.getStatusId(),
            "name"               = arguments.status.getName(),
            "active"             = arguments.status.isActive(),
            "online"             = arguments.status.isOnline(),
            "pagesAreEditable"   = arguments.status.arePagesEditable(),
            "pagesAreDeleteable" = arguments.status.arePagesDeleteable(),
            "pagesRequireAction" = arguments.status.requirePagesAction(),
            "nextStatus"         = nextStatusList
        };
    }
    
    private struct function prepareStatusAsArray(required status status) {
        var nextStatusList = [];
        for(var nextStatus in arguments.status.getNextStatus()) {
            if(nextStatus.isActive()) {
                nextStatusList.append({
                    "statusId"         = nextStatus.getStatusId(),
                    "name"             = nextStatus.getName(),
                    "active"           = nextStatus.isActive(),
                    "online"           = nextStatus.getOnlineStatus(),
                    "pagesAreEditable" = nextStatus.arePagesEditable()
                });
            }
        }
        
        return {
            "statusId"           = arguments.status.getStatusId(),
            "name"               = arguments.status.getName(),
            "active"             = arguments.status.isActive(),
            "online"             = arguments.status.isOnline(),
            "pagesAreEditable"   = arguments.status.arePagesEditable(),
            "pagesAreDeleteable" = arguments.status.arePagesDeleteable(),
            "pagesRequireAction" = arguments.status.requirePagesAction(),
            "nextStatus"         = nextStatusList
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