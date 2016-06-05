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
            if(pageVersion.getPageStatus().isEditable()) {
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
                           .setPageStatusId(arguments.pageVersion.pageStatusId);
                
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
                throw(type = "nephthys.application.notAllowed", message = "The page version is in an non editable status.");
            }
        }
    }
    
    remote string function pushToStatus(required numeric pageVersionId, required numeric pageStatusId) {
        var newPageStatus    = new pageStatus(arguments.pageStatusId);
        var pageVersion      = new pageVersion(arguments.pageVersionId);
        var actualPageStatus = pageVersion.getPageStatus();
        
        var newPageStatusOK = false;
        for(var nextPageStatus in actualPageStatus.getNextStatus()) {
            if(nextPageStatus.getPageStatusId() == newPageStatus.getPageStatusId()) {
                newPageStatusOk = true;
            }
        }
        
        if(newPageStatusOk) {
            if(newPageStatus.isApprovalValid(request.user.getUserId())) {
                transaction {
                    pageVersion.setPageStatusId(newPageStatus.getPageStatusId())
                               .save();
                    
                    var page = new page(pageVersion.getPageId());
                    
                    if(newPageStatus.isOnline()) {
                        // update last page Status
                        var offlinePageStatusId = new filter().setFor("pageStatus")
                                                              .setEndStatus(true)
                                                              .execute()
                                                              .getResult()[1].getPageStatusId();
                        
                        var oldPageVersion = page.getActualPageVersion();
                        if(oldPageVersion.getPageVersionId() != pageVersion.getPageVersionId()) {
                            new approval(oldPageVersion.getPageVersionId()).setFor("pageVersion")
                                                                           .approve(oldPageVersion.getPageStatusId(),
                                                                                    offlinePageStatusId,
                                                                                    request.user.getUserId());
                            
                            oldPageVersion.setPageStatusId(offlinePageStatusId)
                                             .save();
                        }
                        
                        page.setPageVersionId(pageVersion.getPageVersionId())
                            .save();
                    }
                    
                    new approval(arguments.pageVersionId).setFor("pageVersion")
                                                         .approve(actualPageStatus.getPageStatusId(),
                                                                  newPageStatus.getPageStatusId(),
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
        if(page.getPageStatus().isDeleteable()) {
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
        var pageStatusLoader = new filter().setFor("pageStatus");
        
        var prepPageStatus = {};
        
        for(var pageStatus in pageStatusLoader.execute().getResult()) {
            prepPageStatus[pageStatus.getPageStatusId()] = preparePageStatus(pageStatus);
        }
        
        return prepPageStatus;
    }
    
    remote array function getStatusListAsArray() {
        var pageStatusLoader = new filter().setFor("pageStatus");
        
        var prepPageStatus = [];
        
        for(var pageStatus in pageStatusLoader.execute().getResult()) {
            prepPageStatus.append(preparePageStatusAsArray(pageStatus));
        }
        
        return prepPageStatus;
    }
    
    remote struct function getStatusDetails(required numeric pageStatusId) {
        return preparePageStatus(new pageStatus(arguments.pageStatusId));
    }
    
    remote boolean function saveStatus(required struct status) {
        transaction {
            var pageStatus = new pageStatus(arguments.status.pageStatusId);
            
            if(pageStatus.isStartStatus() && ! arguments.status.startStatus) {
                throw(type = "nephthys.application.notAllowed", message = "You cannot remove the start status flag from the start status. Please set another status as start status to remove the start status flag from this status.");
            }
            
            if(pageStatus.isEndStatus() && ! arguments.status.endStatus) {
                throw(type = "nephthys.application.notAllowed", message = "You cannot remove the end status flag from the end status. Please set another status as end status to remove the end status flag from this status.");
            }
            
            if(! pageStatus.isStartStatus() && arguments.status.startStatus) {
                new filter().setFor("pageStatus")
                            .setStartStatus(true)
                            .execute()
                            .getResult()[1].setStartStatus(false)
                                           .save();
            }
            
            if(! pageStatus.isEndStatus() && arguments.status.endStatus) {
                new filter().setFor("pageStatus")
                            .setEndStatus(true)
                            .execute()
                            .getResult()[1].setEndStatus(false)
                                           .save();
            }
            
            pageStatus.setActiveStatus(arguments.status.active)
                      .setEditable(arguments.status.editable)
                      .setEndStatus(arguments.status.endStatus)
                      .setName(arguments.status.name)
                      .setOfflineStatus(arguments.status.offline)
                      .setStartStatus(arguments.status.startStatus)
                      .setDeleteable(arguments.status.deleteable)
                      .save();
            
            transactionCommit();
            return true;
        }
    }
    
    remote boolean function deleteStatus(required numeric pageStatusId) {
        var pagesStillWithThisPageStatus = new filter().setPageStatusId(arguments.pageStatusId).execute().getResultCount();
        var hierarchiesStillWithThisPageStatus = new filter().setFor("hierarchy").setPageStatusId(arguments.pageStatusId).execute.getResultCount();
        if(pagesStillWithThisPageStatus == 0 && hierarchiesStillWithThisPageStatus == 0) {
            new pageStatus(arguments.pageStatusId).delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & pagesStillWithThisPageStatus & " pages and " & hierarchiesStillWithThisPageStatus & " hierarchies on this status.");
        }
    }
    
    remote boolean function activateStatus(required numeric pageStatusId) {
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(true)
                  .save();
        
        return true;
    }
    
    remote boolean function deactivateStatus(required numeric pageStatusId) {
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(false)
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
                var pageStatus = new pageStatus(arguments.statusFlow[i].pageStatusId);
                
                var nextStatus = pageStatus.getNextStatus();
                
                for(j = 1; j <= nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= arguments.statusFlow[i].nextStatus.len() && ! found; ++k) {
                        if(nextStatus[j].getPageStatusId() == arguments.statusFlow[i].nextStatus[k].pageStatusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        pageStatus.removeNextStatus(nextStatus[j].getPageStatusId());
                    }
                }
                
                for(j = 1; j <= arguments.statusFlow[i].nextStatus.len(); ++j) {
                    found = false;
                    for(k = 1; k <= nextStatus.len() && ! found; ++k) {
                        if(nextStatus[k].getPageStatusId() == arguments.statusFlow[i].nextStatus[j].pageStatusId) {
                            found = true;
                        }
                    }
                    
                    if(! found) {
                        pageStatus.addNextStatus(arguments.statusFlow[i].nextStatus[j].pageStatusId);
                    }
                }
                
                pageStatus.save();
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
        var regions = [{
            name = "Kopfnavigation",
            region = "header"
        }, {
            name = "Fußnavigation",
            region = "footer"
        }, {
            name = "Noch nicht gesetzt",
            region = null
        }];
        
        var hierarchy = {
            "versions" = {}
        };
        
        var hierarchyFilterCtrl = new filter().setFor("hierarchy").execute();
        
        for(var hierarchyVersion in hierarchyFilterCtrl.getResult()) {
            var preparedApprovalList = prepareApprovalList(new approval(hierarchyVersion.hierarchyVersionId).setFor("hierarchyVersion").getApprovalList());
            
            var status = new pageStatus(hierarchyVersion.pageStatusId);
            // hierarchyVersionId == version
            hierarchy["versions"][hierarchyVersion.hierarchyVersionId] = {};
            
            hierarchy["versions"][hierarchyVersion.hierarchyVersionId] = {
                "editable"     = status.isEditable(),
                "pageStatusId" = hierarchyVersion.pageStatusId,
                "new"          = false,
                "regions"      = [],
                "approvalList" = preparedApprovalList
            };
            
            for(region in regions) {
                hierarchy["versions"][hierarchyVersion.hierarchyVersionId]["regions"].append({
                    "name"   = region.name,
                    "region" = region.region,
                    "pages"  = getSubPagesForHierarchy(null, region.region, hierarchyVersion.hierarchyVersionId)
                });
            }
        }

        return hierarchy;
    }
    
    remote struct function addHierarchyVersion() {
        var hierarchy = getHierarchy();
        
        var index = 0;
        for(var version in hierarchy["versions"]) {
            index = version;
        }
        index++;
        
        
        var pageStatusId = new filter().setFor("pageStatus")
                                       .setStartStatus(true)
                                       .execute()
                                       .getResult()[1].getPageStatusId();
        
        hierarchy["versions"][index] = {
            "editable"     = true,
            "pageStatusId" = pageStatusId,
            "new"          = true,
            "regions"      = []
        };
        
        hierarchy["versions"][index]["regions"] = duplicate(hierarchy["versions"][version].regions);
        
        return {
            "newVersion" = index,
            "hierarchy"  = hierarchy
        };
    }
    
    remote numeric function saveHierarchy(required numeric hierarchyVersionId, required struct hierarchy) {
        var hierarchyVersionId = arguments.hierarchyVersionId;
        if(arguments.hierarchy.new) {
            hierarchyVersionId = new Query().setSQL("INSERT INTO nephthys_pageHierarchyVersion
                                                                 (
                                                                     pageStatusId,
                                                                     creatorUserId
                                                                 )
                                                          VALUES (
                                                                     :pageStatusId,
                                                                     :userId
                                                                 );
                                                     SELECT currval('seq_nephthys_pageHierarchyVersion_id' :: regclass) newId;")
                                            .addParam(name = "pageStatusId", value = arguments.hierarchy.pageStatusId, cfsqltype = "cf_sql_numeric")
                                            .addParam(name = "userId",       value = request.user.getUserId(),         cfsqltype = "cf_sql_numeric")
                                            .execute()
                                            .getResult()
                                            .newId[1];
        }
        
        new query().setSQL("DELETE FROM nephthys_pageHierarchy
                                  WHERE pageHierarchyVersionId = :hierarchyVersionId")
                   .addParam(name = "hierarchyVersionId", value = hierarchyVersionId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        for(var region in arguments.hierarchy.regions) {
            if(region.region != null) {
                saveHierarchyLevel(hierarchyVersionId, region.region, null, region.pages);
            }
        }
        
        return hierarchyVersionId;
    }
    
    private boolean function saveHierarchyLevel(required numeric hierarchyVersionId, required string region, required numeric parentPageId, required array pages) {
        for(var i = 1; i <= arguments.pages.len(); i++) {
            new Query().setSQL("INSERT INTO nephthys_pageHierarchy
                                            (
                                                pageHierarchyVersionId,
                                                region,
                                                pageId,
                                                parentPageId,
                                                sortOrder
                                            )
                                     VALUES (
                                                :pageHierarchyVersionId,
                                                :region,
                                                :pageId,
                                                :parentPageId,
                                                :sortOrder
                                            )")
                       .addParam(name = "pageHierarchyVersionId", value = arguments.hierarchyVersionId, cfsqltype = "cf_sql_numeric")
                       .addParam(name = "region",                 value = arguments.region,             cfsqltype = "cf_sql_varchar")
                       .addParam(name = "pageId",                 value = arguments.pages[i].id,        cfsqltype = "cf_sql_numeric")
                       .addParam(name = "parentPageId",           value = arguments.parentPageId,       cfsqltype = "cf_sql_numeric", null = arguments.parentPageId == null)
                       .addParam(name = "sortOrder",              value = i,                            cfsqltype = "cf_sql_numeric")
                       .execute();
            
            if(arguments.pages[i].pages.len() > 0) {
                saveHierarchyLevel(arguments.hierarchyVersionId, arguments.region, arguments.pages[i].id, arguments.pages[i].pages);
            }
        }
        
        return true;
    }
    
    remote boolean function pushHierarchyToStatus(required numeric hierarchyVersionId, required numeric pageStatusId) {
        transaction {
            var oldStatusId = new filter().setFor("hierarchy")
                                          .setPageHierarchyVersionId(arguments.hierarchyVersionId)
                                          .execute()
                                          .getResult()[1].pageStatusId;
            
            var newStatus = new pageStatus(arguments.pageStatusId);
            if(newStatus.isOnline()) {
                var offlineStatusId = new filter().setFor("pageStatus")
                                                  .setEndStatus(true)
                                                  .execute()
                                                  .getResult()[1].getPageStatusId();
               
               var actualOnlineVersionId = new filter().setFor("hierarchy")
                                                       .setOnline(true)
                                                       .execute()
                                                       .getResult()[1].hierarchyVersionId;
                
                new Query().setSQL("UPDATE nephthys_pageHierarchyVersion
                                   SET pageStatusId = :pageStatusId
                                 WHERE pageHierarchyVersionId = :hierarchyVersionId")
                       .addParam(name = "pageStatusId",       value = offlineStatusId,       cfsqltype = "cf_sql_numeric")
                       .addParam(name = "hierarchyVersionId", value = actualOnlineVersionId, cfsqltype = "cf_sql_numeric")
                       .execute();
            }
            
            new Query().setSQL("UPDATE nephthys_pageHierarchyVersion 
                                   SET pageStatusId = :pageStatusId
                                 WHERE pageHierarchyVersionId = :hierarchyVersionId")
                       .addParam(name = "pageStatusId",       value = arguments.pageStatusId,       cfsqltype = "cf_sql_numeric")
                       .addParam(name = "hierarchyVersionId", value = arguments.hierarchyVersionId, cfsqltype = "cf_sql_numeric")
                       .execute();
            
            new approval(arguments.hierarchyVersionId).setFor("hierarchyVersion")
                                                      .approve(oldStatusId, pageStatusId, request.user.getUserId());
            
            transactionCommit();
        }
        
        return false;
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
                "pageStatusId"       = pageVersion.getPageStatusId(),
                "pageStatusName"     = pageVersion.getPageStatus().getName(),
                "version"            = page.getActualVersion()
            });
        }
        
        return pageData;
    }
    
    private array function getSubPagesForHierarchy(required numeric parentId, required string region, required numeric hierarchyVersionId) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var pageFilterCtrl = new filter().setFor("sitemap")
                                         .setParentId(arguments.parentId)
                                         .setHierarchyVersionId(arguments.hierarchyVersionId);
        
        if(arguments.region != null) {
            pageFilterCtrl.setRegion(arguments.region);
        }
        else {
            pageFilterCtrl.setFor("pagesNotInHierarchy");
        }
        
        pageFilterCtrl.execute();
        
        var pageData = [];
        for(var page in pageFilterCtrl.getResult()) {
            var pageVersion = page.getActualPageVersion();
            pageData.append({
                "id"    = page.getPageId(),
                "title" = pageVersion.getLinktext(),
                "pages" = arguments.region != null ? getSubPagesForHierarchy(page.getPageId(), arguments.region, arguments.hierarchyVersionId) : []
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
            "pageStatusId"       = arguments.pageVersion.getPageStatusId(),
            "approvalList"       = preparedApprovalList
        };
    }
    
    private struct function preparePageStatus(required pageStatus pageStatus) {
        var nextStatusList = {};
        for(var nextStatus in arguments.pageStatus.getNextStatus()) {
            if(nextStatus.getActiveStatus()) {
                nextStatusList[nextStatus.getPageStatusId()] = {
                    "pageStatusId" = nextStatus.getPageStatusId(),
                    "name"         = nextStatus.getName(),
                    "active"       = nextStatus.getActiveStatus(),
                    "offline"      = nextStatus.getOfflineStatus(),
                    "editable"     = nextStatus.isEditable()
                };
            }
        }
        
        return {
            "id"           = arguments.pageStatus.getPageStatusId(),
            "pageStatusId" = arguments.pageStatus.getPageStatusId(),
            "title"        = arguments.pageStatus.getName(),
            "name"         = arguments.pageStatus.getName(),
            "active"       = arguments.pageStatus.getActiveStatus(),
            "offline"      = arguments.pageStatus.getOfflineStatus(),
            "editable"     = arguments.pageStatus.isEditable(),
            "startStatus"  = arguments.pageStatus.isStartStatus(),
            "endStatus"    = arguments.pageStatus.isEndStatus(),
            "deleteable"   = arguments.pageStatus.isDeleteable(),
            "nextStatus"   = nextStatusList
        };
    }
    
    private struct function preparePageStatusAsArray(required pageStatus pageStatus) {
        var nextStatusList = [];
        for(var nextStatus in arguments.pageStatus.getNextStatus()) {
            if(nextStatus.getActiveStatus()) {
                nextStatusList.append({
                    "pageStatusId" = nextStatus.getPageStatusId(),
                    "name"         = nextStatus.getName(),
                    "active"       = nextStatus.getActiveStatus(),
                    "offline"      = nextStatus.getOfflineStatus(),
                    "editable"     = nextStatus.isEditable()
                });
            }
        }
        
        return {
            "id"           = arguments.pageStatus.getPageStatusId(),
            "pageStatusId" = arguments.pageStatus.getPageStatusId(),
            "title"        = arguments.pageStatus.getName(),
            "name"         = arguments.pageStatus.getName(),
            "active"       = arguments.pageStatus.getActiveStatus(),
            "offline"      = arguments.pageStatus.getOfflineStatus(),
            "editable"     = arguments.pageStatus.isEditable(),
            "startStatus"  = arguments.pageStatus.isStartStatus(),
            "endStatus"    = arguments.pageStatus.isEndStatus(),
            "deleteable"   = arguments.pageStatus.isDeleteable(),
            "nextStatus"   = nextStatusList
        };
    }
    
    private array function prepareApprovalList(required array approvalList) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var preparedApprovalList = [];
        for(var approval in arguments.approvalList) {
            preparedApprovalList.append({
                "user" = getUserInformation(approval.user),
                "approvalDate" = formatCtrl.formatDate(approval.approvalDate),
                "oldPageStatusName" = approval.oldPageStatus.getName(),
                "newPageStatusName" = approval.newPageStatus.getName()
            });
        }
        
        return preparedApprovalList;
    }
}