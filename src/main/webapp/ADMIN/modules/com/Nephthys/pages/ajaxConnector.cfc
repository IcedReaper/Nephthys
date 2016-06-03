component {
    import "API.modules.com.Nephthys.page.*";
    
    remote array function getList() {
        return getSubPages(null, "header")
                   .append(getSubPages(null, "footer"), true)
                   .append(getSubPages(null, "system"), true);
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
                
                pageVersion.setParentPageId(arguments.pageVersion.parentPageId)
                           .setLinktext(arguments.pageVersion.linktext)
                           .setLink(arguments.pageVersion.link)
                           .setTitle(arguments.pageVersion.title)
                           .setDescription(arguments.pageVersion.description)
                           .setContent(arguments.pageVersion.content)
                           .setSortOrder(arguments.pageVersion.sortOrder)
                           .setUseDynamicSuffixes(arguments.pageVersion.useDynamicSuffixes)
                           .setRegion(arguments.pageVersion.region)
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
                        var offlinePageStatusId = new pageStatusFilter().setEndStatus(true)
                                                                        .execute()
                                                                        .getResult()[1].getPageStatusId();
                        
                        var oldPageVersion = page.getActualPageVersion();
                        if(oldPageVersion.getPageVersionId() != pageVersion.getPageVersionId()) {
                            new pageApproval(oldPageVersion.getPageVersionId()).approve(oldPageVersion.getPageStatusId(),
                                                                                           offlinePageStatusId,
                                                                                           request.user.getUserId());
                            
                            oldPageVersion.setPageStatusId(offlinePageStatusId)
                                             .save();
                        }
                        
                        page.setPageVersionId(pageVersion.getPageVersionId())
                            .save();
                        
                        // If required we also have to update the hierarchy...
                        if(oldPageVersion.getSortOrder() != pageVersion.getSortOrder()) {
                            // TODO: check were to move this stuff...
                            var hierarchyEntryMoved = false;
                            if(oldPageVersion.getParentPageId() != pageVersion.getParentPageId() ||
                               oldPageVersion.getRegion() != pageVersion.getRegion()) {
                                new Query().setSQL("UPDATE nephthys_pageHierarchy
                                                       SET region       = :region,
                                                           parentPageId = :parentPageId,
                                                           sortOrder    = :sortOrder
                                                     WHERE pageId = :pageId;")
                                           .addParam(name = "pageId",       value = pageVersion.getPageId(),       cfsqltype = "cf_sql_numeric")
                                           .addParam(name = "region",       value = pageVersion.getRegion(),       cfsqltype = "cf_sql_varchar")
                                           .addParam(name = "parentPageId", value = pageVersion.getParentPageId(), cfsqltype = "cf_sql_numeric", null = oldPageVersion.getParentPageId() == null)
                                           .addParam(name = "sortOrder",    value = pageVersion.getSortOrder(),    cfsqltype = "cf_sql_numeric")
                                           .execute();
                                
                                if(oldPageVersion.getParentPageId() == null) {
                                    new Query().setSQL("UPDATE nephthys_pageHierarchy
                                                           SET sortOrder = sortOrder - 1
                                                         WHERE region       = :region
                                                           AND parentPageId IS NULL
                                                           AND sortOrder    > :sortOrder")
                                               .addParam(name = "region",       value = oldPageVersion.getRegion(),       cfsqltype = "cf_sql_varchar")
                                               .addParam(name = "parentPageId", value = oldPageVersion.getParentPageId(), cfsqltype = "cf_sql_numeric")
                                               .addParam(name = "sortOrder",    value = oldPageVersion.getSortOrder(),    cfsqltype = "cf_sql_numeric")
                                               .execute();
                                }
                                else {
                                    new Query().setSQL("UPDATE nephthys_pageHierarchy
                                                           SET sortOrder = sortOrder - 1
                                                         WHERE region       = :region
                                                           AND parentPageId = :parentPageId
                                                           AND sortOrder    > :sortOrder")
                                               .addParam(name = "region",       value = oldPageVersion.getRegion(),       cfsqltype = "cf_sql_varchar")
                                               .addParam(name = "parentPageId", value = oldPageVersion.getParentPageId(), cfsqltype = "cf_sql_numeric")
                                               .addParam(name = "sortOrder",    value = oldPageVersion.getSortOrder(),    cfsqltype = "cf_sql_numeric")
                                               .execute();
                                }
                                hierarchyEntryMoved = true;
                            }
                            
                            if(pageVersion.getRegion() != "system") {
                                var pageFilterCtrl = new filter().setParentId(pageVersion.getParentPageId())
                                                                 .setRegion(pageVersion.getRegion())
                                                                 .setOnline(true)
                                                                 .execute();
                                
                                for(var tmpPage in pageFilterCtrl.getResult()) {
                                    if(tmpPage.getPageId() != page.getPageId()) {
                                        var tmpActualPageVersion = page.getActualPageVersion();
                                        var newSortOrder = 0;
                                        
                                        if(tmpActualPageVersion.getSortOrder() >= pageVersion.getSortOrder() && tmpActualPageVersion.getSortOrder() <= oldPageVersion.getSortOrder()) {
                                            newSortOrder = tmpActualPageVersion.getSortOrder() + 1;
                                        }
                                        else if(tmpActualPageVersion.getSortOrder() >= oldPageVersion.getSortOrder() && tmpActualPageVersion.getSortOrder() <= pageVersion.getSortOrder()) {
                                            newSortOrder = tmpActualPageVersion.getSortOrder() - 1;
                                        }
                                        
                                        if(newSortOrder != 0) {
                                            new Query().setSQL("UPDATE nephthys_pageHierarchy
                                                                   SET sortOrder = :sortOrder
                                                                 WHERE pageId       = :pageId")
                                                       .addParam(name = "pageId",    value = tmpPage.getPageId(), cfsqltype = "cf_sql_numeric")
                                                       .addParam(name = "sortOrder", value = newSortOrder,        cfsqltype = "cf_sql_numeric")
                                                       .execute();
                                        }
                                    }
                                    else {
                                        if(! hierarchyEntryMoved) {
                                            new Query().setSQL("UPDATE nephthys_pageHierarchy
                                                                   SET sortOrder = :sortOrder
                                                                 WHERE pageId       = :pageId")
                                                       .addParam(name = "pageId",    value = pageVersion.getPageId(),    cfsqltype = "cf_sql_numeric")
                                                       .addParam(name = "sortOrder", value = pageVersion.getSortOrder(), cfsqltype = "cf_sql_numeric")
                                                       .execute();
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        // if the actual status is online the new status is not online we have to update the page. // TODO: check if required.
                        if(actualPageStatus.isOnline() && ! newPageStatus.isOnline()) {
                            page.setPageStatusId(newPageStatus.getPageStatusId())
                                .save();
                        }
                    }
                    
                    new pageApproval(arguments.pageVersionId).approve(actualPageStatus.getPageStatusId(),
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
        var pageStatusLoader = new pageStatusFilter();
        
        var prepPageStatus = {};
        
        for(var pageStatus in pageStatusLoader.execute().getResult()) {
            prepPageStatus[pageStatus.getPageStatusId()] = preparePageStatus(pageStatus);
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
                new pageStatusFilter()
                    .setStartStatus(true)
                    .execute()
                    .getResult()[1].setStartStatus(false)
                                   .save();
            }
            
            if(! pageStatus.isEndStatus() && arguments.status.endStatus) {
                new pageStatusFilter()
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
            
            // update next status
            
            transactionCommit();
            return true;
        }
    }
    
    remote boolean function deleteStatus(required numeric pageStatusId) {
        var pageFilterCtrl = new filter().setPageStatusId(arguments.pageStatusId).execute();
        if(pageFilterCtrl.getResultCount() == 0) {
            new pageStatus(arguments.pageStatusId).delete();
            
            return true;
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You cannot delete a status that is still used. There are still " & pageFilterCtrl.getResultCount() & " pages on this status.");
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
    
    // P R I V A T E
    private array function getSubPages(required numeric parentId, required string region) {
        var pageFilterCtrl = new filter();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        pageFilterCtrl.setParentId(arguments.parentId)
                      .setRegion(arguments.region)
                      .setVersion("actual")
                      .execute();
        
        var pageData = [];
        for(var page in pageFilterCtrl.getResult()) {
            var pageVersion = page.getActualPageVersion();
            pageData.append({
                "pageId"             = page.getPageId(),
                "pageVersionId"      = pageVersion.getPageVersionId(),
                "parentId"           = pageVersion.getParentPageId(),
                "linktext"           = pageVersion.getLinktext(),
                "link"               = pageVersion.getLink(),
                "title"              = pageVersion.getTitle(),
                "description"        = pageVersion.getDescription(),
                "content"            = serializeJSON(pageVersion.getContent()),
                "sortOrder"          = pageVersion.getSortOrder(),
                "region"             = pageVersion.getRegion(),
                "useDynamicSuffixes" = pageVersion.getUseDynamicSuffixes(),
                "creator"            = getUserInformation(pageVersion.getCreator()),
                "creationDate"       = formatCtrl.formatDate(pageVersion.getCreationDate()),
                "lastEditor"         = getUserInformation(pageVersion.getLastEditor()),
                "lastEditDate"       = formatCtrl.formatDate(pageVersion.getLastEditDate()),
                "subPages"           = getSubPages(pageVersion.getPageId(), pageVersion.getRegion()),
                "isOnline"           = pageVersion.isOnline(),
                "pageStatusId"       = pageVersion.getPageStatusId(),
                "pageStatusName"     = pageVersion.getPageStatus().getName(),
                "version"            = page.getActualVersion()
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
        
        var approvalList = new pageApproval(arguments.pageVersion.getPageVersionId()).getApprovalList();
        
        var preparedApprovalList = [];
        for(var approval in approvalList) {
            preparedApprovalList.append({
                "user" = getUserInformation(approval.user),
                "approvalDate" = formatCtrl.formatDate(approval.approvalDate),
                "oldPageStatusName" = approval.oldPageStatus.getName(),
                "newPageStatusName" = approval.newPageStatus.getName()
            });
        }
        
        return  {
            "pageVersionId"      = arguments.pageVersion.getPageVersionId(),
            "parentPageId"       = arguments.pageVersion.getParentPageId(),
            "linktext"           = arguments.pageVersion.getLinktext(),
            "link"               = arguments.pageVersion.getLink(),
            "title"              = arguments.pageVersion.getTitle(),
            "description"        = arguments.pageVersion.getDescription(),
            "content"            = arguments.pageVersion.getContent(),
            "sortOrder"          = arguments.pageVersion.getSortOrder(),
            "useDynamicSuffixes" = arguments.pageVersion.getUseDynamicSuffixes(),
            "region"             = arguments.pageVersion.getRegion(),
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
            "pageStatusId" = arguments.pageStatus.getPageStatusId(),
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
}