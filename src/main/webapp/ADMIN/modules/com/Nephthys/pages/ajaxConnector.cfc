component {
    import "API.modules.com.Nephthys.page.*";
    
    remote array function getList() {
        return getSubPages(new filter().execute());
    }
    
    remote struct function getActualUser() {
        return {
            "userId" = request.user.getUserId(),
            "userName" = request.user.getUserName()
        };
    }
    
    remote struct function getDetails(required numeric pageId) {
        var page = new page(arguments.pageId);
        
        var returnValue = {
            "pageId"        = page.getPageId(),
            "versions"      = {},
            "actualVersion" = {
                "major" = page.getActualMajorVersion(),
                "minor" = page.getActualMinorVersion()
            },
            "availableVersions" = {}
        };
        
        // if it's not a new page and we have at least a version
        if((arguments.pageId != null && arguments.pageId != 0) || (page.getPageVersionId() != null && page.getPageVersionId() != 0)) {
            var actualPageVersion = page.getActualPageVersion();
            
            returnValue.versions[actualPageVersion.getMajorVersion()] = {};
            returnValue.versions[actualPageVersion.getMajorVersion()][actualPageVersion.getMinorVersion()] = preparePageVersion(actualPageVersion);;
            
            var versions = page.getStructuredPageVersions();
            for(var majorVersion in versions) {
                for(var minorVersion in versions[majorVersion]) {
                    if(! returnValue["availableVersions"].keyExists(majorVersion)) {
                        returnValue["availableVersions"][majorVersion] = [];
                    }
                    
                    returnValue["availableVersions"][majorVersion].append(minorVersion);
                }
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
        var page = new page(arguments.pageId);
        
        return preparePageVersion(page.getPageVersion(arguments.majorVersion, arguments.minorVersion));
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
    
    remote string function pushToStatus(required numeric pageVersionId, required numeric statusId) {
        var newStatus    = new status(arguments.statusId);
        var pageVersion      = new pageVersion(arguments.pageVersionId);
        var actualStatus = pageVersion.getStatus();
        
        var newStatusOK = false;
        for(var nextStatus in actualStatus.getNextStatus()) {
            if(nextStatus.getStatusId() == newStatus.getStatusId()) {
                newStatusOk = true;
            }
        }
        
        if(newStatusOk) {
            if(newStatus.isApprovalValid(request.user.getUserId())) {
                transaction {
                    pageVersion.setStatusId(newStatus.getStatusId())
                               .save();
                    
                    var page = new page(pageVersion.getPageId());
                    
                    if(newStatus.isOnline()) {
                        // update last page Status
                        var offlineStatusId = application.system.settings.getValueOfKey("endStatus");
                        
                        var oldPageVersion = page.getActualPageVersion();
                        if(oldPageVersion.getPageVersionId() != pageVersion.getPageVersionId()) {
                            new approval(oldPageVersion.getPageVersionId()).setFor("pageVersion")
                                                                           .approve(oldPageVersion.getStatusId(),
                                                                                    offlineStatusId,
                                                                                    request.user.getUserId());
                            
                            oldPageVersion.setStatusId(offlineStatusId)
                                             .save();
                        }
                        
                        page.setPageVersionId(pageVersion.getPageVersionId())
                            .save();
                    }
                    
                    new approval(arguments.pageVersionId).setFor("pageVersion")
                                                         .approve(actualStatus.getStatusId(),
                                                                  newStatus.getStatusId(),
                                                                  request.user.getUserId());
                    
                    transactionCommit();
                }
                
                return true;
            }
        }
        else {
            return false;
        }
    }
    
    remote boolean function delete(required numeric pageId) {
        var page = new page(arguments.pageId);
        if(page.getStatus().arePagesDeleteable()) {
            page.delete();
        }
        
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
        
        var pagesStillWithThisStatus = new filter().setStatusId(arguments.statusId)
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
        var status = new status(arguments.statusId);
        
        status.setActiveStatus(false)
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
    
    remote struct function getHierarchy() {
        var regions = getRegions();
        
        var hierarchy = {
            "versions" = []
        };
        
        var hierarchyFilterCtrl = new filter().setFor("hierarchy").execute();
        
        for(var hierarchyVersion in hierarchyFilterCtrl.getResult()) {
            var preparedApprovalList = prepareApprovalList(new approval(hierarchyVersion.hierarchyId).setFor("hierarchyVersion").getApprovalList());
            
            var preparedRegions = [];
            for(region in regions) {
                preparedRegions.append({
                    "name"        = region.name,
                    "description" = region.description,
                    "regionId"    = region.regionId,
                    "pages"       = getSubPagesForHierarchy(null, region.regionId, hierarchyVersion.hierarchyId)
                });
            }
            
            var status = new status(hierarchyVersion.statusId);
            hierarchy["versions"].append({
                "hierarchyId"      = hierarchyVersion.hierarchyId,
                "version"          = hierarchyVersion.version,
                "pagesAreEditable" = status.arePagesEditable(),
                "statusId"         = hierarchyVersion.statusId,
                "regions"          = preparedRegions,
                "approvalList"     = preparedApprovalList,
                "offline"          = [{
                    "regionId"    = null,
                    "name"        = null,
                    "description" = "Offline",
                    "pages"       = getSubPagesForHierarchy(null, null, hierarchyVersion.hierarchyId)
                }]
            });
        }

        return hierarchy;
    }
    
    remote struct function addHierarchyVersion() {
        var hierarchy = getHierarchy();
        
        var lastIndex = hierarchy["versions"].len();
        var index = lastIndex + 1;
        
        var statusId = application.system.settings.getValueOfKey("startStatus");
        
        hierarchy["versions"][index] = {
            "hierarchyId"      = null,
            "version"          = javaCast("integer", index),
            "pagesAreEditable" = true,
            "statusId"         = javaCast("integer", statusId),
            "regions"          = [],
            "offline"          = []
        };
        
        if(index > 1) {
            // existing hierarchy
            hierarchy["versions"][index]["regions"] = duplicate(hierarchy["versions"][lastIndex].regions);
            hierarchy["versions"][index]["offline"] = duplicate(hierarchy["versions"][lastIndex].offline);
        }
        else {
            // without existing completly new
            hierarchy["versions"][index]["regions"] = getRegions();
            
            for(var i = 1; i <= hierarchy["versions"][index]["regions"].len(); ++i) {
                hierarchy["versions"][index]["regions"][i].pages = [];
            }
            
            var notSetIndex = hierarchy["versions"][index]["regions"].len();
            
            for(var page in getList()) {
                hierarchy["versions"][index]["regions"][notSetIndex].pages.append({
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
        var hierarchyId = arguments.hierarchy.hierarchyId;
        transaction {
            if(arguments.hierarchy.hierarchyId == null) {
                hierarchyId = new Query().setSQL("INSERT INTO nephthys_page_hierarchy
                                                                     (
                                                                         statusId,
                                                                         version,
                                                                         creationUserId
                                                                     )
                                                              VALUES (
                                                                         :statusId,
                                                                         :version,
                                                                         :userId
                                                                     );
                                                         SELECT currval('nephthys_page_hierarchy_hierarchyid_seq' :: regclass) newId;")
                                                .addParam(name = "statusId", value = arguments.hierarchy.statusId, cfsqltype = "cf_sql_numeric")
                                                .addParam(name = "version",  value = arguments.hierarchy.version,  cfsqltype = "cf_sql_numeric")
                                                .addParam(name = "userId",   value = request.user.getUserId(),     cfsqltype = "cf_sql_numeric")
                                                .execute()
                                                .getResult()
                                                .newId[1];
            }
            
            new query().setSQL("DELETE FROM nephthys_page_hierarchyPage
                                      WHERE hierarchyId = :hierarchyId")
                       .addParam(name = "hierarchyId", value = hierarchyId, cfsqltype = "cf_sql_numeric")
                       .execute();
            
            for(var region in arguments.hierarchy.regions) {
                saveHierarchyLevel(hierarchyId, region.regionId, null, region.pages);
            }
            transactionCommit();
        }
        return hierarchyId;
    }
    
    private boolean function saveHierarchyLevel(required numeric hierarchyId, required numeric regionId, required numeric parentPageId, required array pages) {
        for(var i = 1; i <= arguments.pages.len(); i++) {
            new Query().setSQL("INSERT INTO nephthys_page_hierarchyPage
                                            (
                                                hierarchyId,
                                                regionId,
                                                pageId,
                                                parentPageId,
                                                sortOrder
                                            )
                                     VALUES (
                                                :hierarchyId,
                                                :regionId,
                                                :pageId,
                                                :parentPageId,
                                                :sortOrder
                                            )")
                       .addParam(name = "hierarchyId",  value = arguments.hierarchyId,     cfsqltype = "cf_sql_numeric")
                       .addParam(name = "regionId",     value = arguments.regionId,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "pageId",       value = arguments.pages[i].pageId, cfsqltype = "cf_sql_numeric")
                       .addParam(name = "parentPageId", value = arguments.parentPageId,    cfsqltype = "cf_sql_numeric", null = arguments.parentPageId == null)
                       .addParam(name = "sortOrder",    value = i,                         cfsqltype = "cf_sql_numeric")
                       .execute();
            
            if(arguments.pages[i].pages.len() > 0) {
                saveHierarchyLevel(arguments.hierarchyId, arguments.regionId, arguments.pages[i].pageId, arguments.pages[i].pages);
            }
        }
        
        return true;
    }
    
    remote boolean function pushHierarchyToStatus(required numeric hierarchyId, required numeric statusId) {
        transaction {
            // TODO: Move to hierarchy model
            var oldStatusId = new filter().setFor("hierarchy")
                                          .setHierarchyId(arguments.hierarchyId)
                                          .execute()
                                          .getResult()[1].statusId;
            
            var newStatus = new status(arguments.statusId);
            if(newStatus.isOnline()) {
                var offlineStatusId = application.system.settings.getValueOfKey("endStatus");
               
               var actualOnlineCtrl = new filter().setFor("hierarchy")
                                                  .setOnline(true)
                                                  .execute();
               
               if(actualOnlineCtrl.getResultCount() == 1) {
                   var actualOnlineVersionId = actualOnlineCtrl.getResult()[1].hierarchyId;
                    
                    new Query().setSQL("UPDATE nephthys_page_hierarchy
                                           SET statusId = :statusId
                                         WHERE hierarchyId = :hierarchyId")
                               .addParam(name = "statusId",    value = offlineStatusId,       cfsqltype = "cf_sql_numeric")
                               .addParam(name = "hierarchyId", value = actualOnlineVersionId, cfsqltype = "cf_sql_numeric")
                               .execute();
                }
            }
            
            new Query().setSQL("UPDATE nephthys_page_hierarchy 
                                   SET statusId = :statusId
                                 WHERE hierarchyId = :hierarchyId")
                       .addParam(name = "statusId",    value = arguments.statusId,    cfsqltype = "cf_sql_numeric")
                       .addParam(name = "hierarchyId", value = arguments.hierarchyId, cfsqltype = "cf_sql_numeric")
                       .execute();
            
            new approval(arguments.hierarchyId).setFor("hierarchyVersion")
                                               .approve(oldStatusId, statusId, request.user.getUserId());
            
            transactionCommit();
        }
        
        return true;
    }
    
    
    
    // P R I V A T E
    private array function getSubPages(required filter pageFilterCtrl) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var pageData = [];
        for(var page in arguments.pageFilterCtrl.getResult()) {
            var pageVersion = page.getActualPageVersion();
            pageData.append({
                "pageId"             = page.getPageId(),
                "pageVersionId"      = pageVersion.getPageVersionId(),
                "linktext"           = pageVersion.getLinktext(),
                "link"               = pageVersion.getLink(),
                "title"              = pageVersion.getTitle(),
                "description"        = pageVersion.getDescription(),
                "content"            = serializeJSON(pageVersion.getContent()),
                "useDynamicSuffixes" = pageVersion.getUseDynamicSuffixes(),
                "creator"            = getUserInformation(pageVersion.getCreator()),
                "creationDate"       = formatCtrl.formatDate(pageVersion.getCreationDate()),
                "lastEditor"         = getUserInformation(pageVersion.getLastEditor()),
                "lastEditDate"       = formatCtrl.formatDate(pageVersion.getLastEditDate()),
                "isOnline"           = pageVersion.isOnline(),
                "statusId"           = pageVersion.getStatusId(),
                "statusName"         = pageVersion.getStatus().getName(),
                "version"            = page.getActualVersion()
            });
        }
        
        return pageData;
    }
    
    private array function getSubPagesForHierarchy(required numeric parentId, required numeric regionId, required numeric hierarchyId) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var pageFilterCtrl = new filter().setFor("sitemap")
                                         .setParentId(arguments.parentId)
                                         .setHierarchyId(arguments.hierarchyId);
        
        if(arguments.regionId != null) {
            pageFilterCtrl.setRegionId(arguments.regionId);
        }
        else {
            pageFilterCtrl.setFor("pagesNotInHierarchy");
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
    
    // todo: optimize ?
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
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
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
            "nextStatus"         = nextStatusList
        };
    }
    
    private array function prepareApprovalList(required array approvalList) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
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
    
    private  array function getRegions() {
        // TODO implement to get Regions from db
        return [{
            regionId    = 1,
            description = "Kopfnavigation",
            name        = "header"
        }, {
            regionId    = 2,
            description = "Fußnavigation",
            name        = "footer"
        }, {
            regionId    = 3,
            description = "Systemlinks",
            name        = "system"
        }];
    }
}