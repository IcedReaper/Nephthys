component {
    import "API.modules.com.Nephthys.page.*";
    
    remote array function getList() {
        return getSubPages(null, 'header').append(getSubPages(null, 'footer'), true);
    }
    
    remote struct function getActualUser() {
        return {
            "userId" = request.user.getUserId(),
            "userName" = request.user.getUserName()
        };
    }
    
    remote struct function getDetails(required numeric pageId) {
        var page = new page(arguments.pageId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var returnValue = {
            "pageId"        = page.getPageId(),
            "versions"      = page.getStructuredPageVersions(),
            "actualVersion" = {
                "major" = page.getActualMajorVersion(),
                "minor" = page.getActualMinorVersion()
            }
        };
        
        // prepare data
        // TODO: check if it's the best to always return all versions or only actual version and the other version numbers and request the version then on request to reduce bandwidth
        for(var majorVersion in returnValue["versions"]) {
            for(var minorVersion in returnValue["versions"][majorVersion]) {
                returnValue["versions"][majorVersion][minorVersion] = {
                    "pageVersionId"      = returnValue["versions"][majorVersion][minorVersion].getPageVersionId(),
                    "parentPageId"       = returnValue["versions"][majorVersion][minorVersion].getParentPageId(),
                    "linktext"           = returnValue["versions"][majorVersion][minorVersion].getLinktext(),
                    "link"               = returnValue["versions"][majorVersion][minorVersion].getLink(),
                    "title"              = returnValue["versions"][majorVersion][minorVersion].getTitle(),
                    "description"        = returnValue["versions"][majorVersion][minorVersion].getDescription(),
                    "content"            = returnValue["versions"][majorVersion][minorVersion].getContent(),
                    "sortOrder"          = returnValue["versions"][majorVersion][minorVersion].getSortOrder(),
                    "useDynamicSuffixes" = returnValue["versions"][majorVersion][minorVersion].getUseDynamicSuffixes(),
                    "region"             = returnValue["versions"][majorVersion][minorVersion].getRegion(),
                    "isOnline"           = returnValue["versions"][majorVersion][minorVersion].isOnline(),
                    "creator"            = getUserInformation(returnValue["versions"][majorVersion][minorVersion].getCreator()),
                    "creationDate"       = formatCtrl.formatDate(returnValue["versions"][majorVersion][minorVersion].getCreationDate()),
                    "lastEditor"         = getUserInformation(returnValue["versions"][majorVersion][minorVersion].getLastEditor()),
                    "lastEditDate"       = formatCtrl.formatDate(returnValue["versions"][majorVersion][minorVersion].getLastEditDate()),
                    "pageStatusId"       = returnValue["versions"][majorVersion][minorVersion].getPageStatusId()
                };
            }
        }
        
        return returnValue;
    }
    
    remote struct function save(required numeric pageId,
                                required struct  pageVersion,
                                required numeric majorVersion,
                                required numeric minorVersion) {
        transaction {
            var page = new page(arguments.pageId);
            if(arguments.pageId == null) {
                page.save();
                
                arguments.pageId = page.getPageId();
            }
            
            var pageVersion = new pageVersion(arguments.pageVersion.pageVersionId);
            if(arguments.pageVersion.pageVersionId == null) {
                pageVersion.setPageId(arguments.pageId)
                           .setMajorVersion(arguments.majorVersion)
                           .setMinorVersion(arguments.minorVersion);
            }
            
            if(pageVersion.getPageStatus().isEditable()) {
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
    
    remote boolean function pushToStatus(required numeric pageVersionId, required numeric pageStatusId) {
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
                        
                        var actualPageVersion = page.getActualPageVersion();
                        if(actualPageVersion.getPageVersionId() != pageVersion.getPageVersionId()) {
                            actualPageVersion.setPageStatusId(offlinePageStatusId)
                                             .save();
                        }
                        
                        // TODO: update hierarchy...
                        
                        
                        page.setPageVersionId(pageVersion.getPageVersionId())
                            .save();
                    }
                    else {
                        // if the actual status is online the new status is not online we have to update the page. // TODO: check if required.
                        if(actualPageStatus.isOnline() && ! newPageStatus.isOnline()) {
                            page.setPageStatusId(newPageStatus.getPageStatusId())
                                .save();
                        }
                    }
                    
                    // TODO: update approvals
                    
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
        /* TODO: IMplement
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.delete();
        
        return true;
        */
        return false;
    }
    
    remote boolean function activate(required numeric pageId) {
        /* TODO: IMplement
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.setActiveStatus(1)
            .setLastEditorUserId(request.user.getUserId())
            .save();
        
        return true;
        */
        return false;
    }
    
    remote boolean function deactivate(required numeric pageId) {
        /* TODO: IMplement
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.setActiveStatus(0)
            .setLastEditorUserId(request.user.getUserId())
            .save();
        
        return true;
        */
        return false;
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
            var nextStatusList = {};
            for(var nextStatus in pageStatus.getNextStatus()) {
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
            
            prepPageStatus[pageStatus.getPageStatusId()] = {
                "pageStatusId" = pageStatus.getPageStatusId(),
                "name"         = pageStatus.getName(),
                "active"       = pageStatus.getActiveStatus(),
                "offline"      = pageStatus.getOfflineStatus(),
                "editable"     = pageStatus.isEditable(),
                "startStatus"  = pageStatus.isStartStatus(),
                "nextStatus"   = nextStatusList
            };
        }
        
        return prepPageStatus;
    }
    
    remote struct function getStatusDetails(required numeric pageStatusId) {
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        return {
            "pageStatusId" = pageStatus.getPageStatusId(),
            "name"         = pageStatus.getName(),
            "active"       = pageStatus.getActiveStatus(),
            "offline"      = pageStatus.getOfflineStatus(),
            "editable"     = pageStatus.isEditable()
        };
    }
    
    remote boolean function saveStatus(required numeric pageStatusId,
                                       required string  name,
                                       required numeric active,
                                       required numeric offline,
                                       required boolean editable) {
        /*var pageStatus = pageStatus(arguments.pageStatusId);
        
        pageStatus.setName(arguments.name)
                  .setActiveStatus(arguments.active)
                  .setOfflineStatus(arguments.offline)
                  .setEditable(arguments.editable)
                  .save();
        
        return true;*/
    }
    
    remote boolean function deleteStatus(required numeric pageStatusId) {
        /* TODO: IMplement
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        pageStatus.delete();
        
        return true;
        */
        return false;
    }
    
    remote boolean function activateStatus(required numeric pageStatusId) {
        /* TODO: IMplement
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(true)
                  .save();
        
        return true;
        */
        return false;
    }
    
    remote boolean function deactivateStatus(required numeric pageStatusId) {
        /* TODO: IMplement
        var pageStatus = new pageStatus(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(false)
                  .save();
        
        return true;
        */
        return false;
    }
    
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
                'pageId'             = page.getPageId(),
                'parentId'           = pageVersion.getParentPageId(),
                'linktext'           = pageVersion.getLinktext(),
                'link'               = pageVersion.getLink(),
                'title'              = pageVersion.getTitle(),
                'description'        = pageVersion.getDescription(),
                'content'            = serializeJSON(pageVersion.getContent()),
                'sortOrder'          = pageVersion.getSortOrder(),
                'region'             = pageVersion.getRegion(),
                'useDynamicSuffixes' = pageVersion.getUseDynamicSuffixes(),
                'creator'            = getUserInformation(pageVersion.getCreator()),
                'creationDate'       = formatCtrl.formatDate(pageVersion.getCreationDate()),
                'lastEditor'         = getUserInformation(pageVersion.getLastEditor()),
                'lastEditDate'       = formatCtrl.formatDate(pageVersion.getLastEditDate()),
                'subPages'           = getSubPages(pageVersion.getPageId(), pageVersion.getRegion()),
                'isOnline'           = pageVersion.isOnline(),
                "pageStatusId"       = pageVersion.getPageStatusId(),
                "pageStatusName"     = pageVersion.getPageStatus().getName(),
                "version"            = page.getActualVersion()
            });
        }
        
        return pageData;
    }
    
    private struct function getUserInformation(required user _user) {
        return {
            'userId'   = arguments._user.getUserId(),
            'userName' = arguments._user.getUserName()
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
}