component {
    remote struct function getList() {
        return {
            'success' = true,
            'data'    = getSubPages(0, 'header').append(getSubPages(0, 'footer'), true)
        }
    }
    
    remote struct function getDetails(required numeric pageId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        return {
            'success' = true,
            'page'    = {
                'pageId'             = page.getPageId(),
                'parentId'           = page.getParentId(),
                'linktext'           = page.getLinktext(),
                'link'               = page.getLink(),
                'title'              = page.getTitle(),
                'description'        = page.getDescription(),
                'content'            = page.getContent(),
                'sortOrder'          = page.getSortOrder(),
                'useDynamicSuffixes' = toString(page.getUseDynamicSuffixes()),
                'region'             = page.getRegion(),
                'active'             = toString(page.getActiveStatus()),
                'creator'            = getUserInformation(page.getCreator()),
                'creationDate'       = formatCtrl.formatDate(page.getCreationDate()),
                'lastEditor'         = getUserInformation(page.getLastEditor()),
                'lastEditDate'       = formatCtrl.formatDate(page.getLastEditDate()),
                'subPages'           = getSubPages(page.getPageId(), page.getRegion()),
                "pageStatusId"       = toString(page.getPageStatusId()),
                "pageStatusName"     = page.getPageStatus().getName()
            }
        };
    }
    
    remote struct function save(required numeric pageId,
                                required numeric parentId,
                                required string  linkText,
                                required string  link,
                                required string  title,
                                required string  description,
                                required array   content,
                                required numeric sortOrder,
                                required string  region,
                                required numeric useDynamicSuffixes,
                                required numeric active,
                                required numeric pageStatusId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        
        page.setParentId(arguments.parentId)
            .setLinkText(arguments.linkText)
            .setLink(arguments.link)
            .setTitle(arguments.title)
            .setDescription(arguments.description)
            .setContent(arguments.content)
            .setSortOrder(arguments.sortOrder)
            .setRegion(arguments.region)
            .setUseDynamicSuffixes(arguments.useDynamicSuffixes)
            .setActiveStatus(arguments.active)
            .setLastEditorUserId(request.user.getUserId())
            .setPageStatusId(arguments.pageStatusId);
        
        if(arguments.pageId == 0) {
            page.setCreatorUserId(request.user.getUserId());
        }
        
        page.save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function delete(required numeric pageId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.delete();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activate(required numeric pageId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.setActiveStatus(1)
            .setLastEditorUserId(request.user.getUserId())
            .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate(required numeric pageId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        page.setActiveStatus(0)
            .setLastEditorUserId(request.user.getUserId())
            .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function loadStatistics(required numeric pageId) {
        var page = createObject("component", "API.modules.com.Nephthys.page.page").init(arguments.pageId);
        
        var pageStatistics = createObject("component", "API.modules.com.Nephthys.statistics.pageVisit").init();
        var chartData              = prepareVisitData(pageStatistics.getPageStatistics(dateAdd("d", -30, now()), now(), arguments.pageId));
        var chartWithParameterData = prepareVisitDataWithParameter(pageStatistics.getPageStatistcsWithParameter(dateAdd("d", -10, now()), now(), arguments.pageId));
        
        return {
            'success'            = true,
            'useDynamicSuffixes' = page.getUseDynamicSuffixes(),
            'chart'              = chartData,
            'chartWithParameter' = chartWithParameterData
        };
    }
    
    // STATUS
    
    remote struct function getStatusList() {
        var pageStatusLoader = createObject("component", "API.modules.com.Nephthys.page.pageStatusFilter").init();
        
        var prepPageStatus = [];
        
        for(var pageStatus in pageStatusLoader.execute().getResult()) {
            prepPageStatus.append({
                "pageStatusId" = pageStatus.getPageStatusId(),
                "name"         = pageStatus.getName(),
                "active"       = toString(pageStatus.getActiveStatus()),
                "offline"      = toString(pageStatus.getOfflineStatus())
            });
        }
        
        return {
            "success" = true,
            "data"    = prepPageStatus
        };
    }
    
    remote struct function getStatusDetails(required numeric pageStatusId) {
        var pageStatus = createObject("component", "API.modules.com.Nephthys.page.pageStatus").init(arguments.pageStatusId);
        
        return {
            "success" = true,
            "data"    = {
                "pageStatusId" = pageStatus.getPageStatusId(),
                "name"         = pageStatus.getName(),
                "active"       = toString(pageStatus.getActiveStatus()),
                "offline"      = toString(pageStatus.getOfflineStatus())
            }
        };
    }
    
    remote struct function saveStatus(required numeric pageStatusId,
                                      required string  name,
                                      required numeric active,
                                      required numeric offline) {
        var pageStatus = createObject("component", "API.modules.com.Nephthys.page.pageStatus").init(arguments.pageStatusId);
        
        pageStatus.setName(arguments.name)
                  .setActiveStatus(arguments.active)
                  .setOfflineStatus(arguments.offline)
                  .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deleteStatus(required numeric pageStatusId) {
        var pageStatus = createObject("component", "API.modules.com.Nephthys.page.pageStatus").init(arguments.pageStatusId);
        
        pageStatus.delete();
        
        return {
            "success" = true
        };
    }
    
    remote struct function activateStatus(required numeric pageStatusId) {
        var pageStatus = createObject("component", "API.modules.com.Nephthys.page.pageStatus").init(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(true)
                  .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivateStatus(required numeric pageStatusId) {
        var pageStatus = createObject("component", "API.modules.com.Nephthys.page.pageStatus").init(arguments.pageStatusId);
        
        pageStatus.setActiveStatus(false)
                  .save();
        
        return {
            "success" = true
        };
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
        var pageFilterCtrl = createObject("component", "API.modules.com.Nephthys.page.filter").init();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        var pageArray = pageFilterCtrl.setParentId(arguments.parentId)
                                      .setRegion(arguments.region)
                                      .execute()
                                      .getResult();
        
        var pageData = [];
        for(var i = 1; i <= pageArray.len(); i++) {
            pageData.append({
                'pageId'             = pageArray[i].getPageId(),
                'parentId'           = pageArray[i].getParentId(),
                'linktext'           = pageArray[i].getLinktext(),
                'link'               = pageArray[i].getLink(),
                'title'              = pageArray[i].getTitle(),
                'description'        = pageArray[i].getDescription(),
                'content'            = serializeJSON(pageArray[i].getContent()),
                'sortOrder'          = pageArray[i].getSortOrder(),
                'region'             = pageArray[i].getRegion(),
                'useDynamicSuffixes' = pageArray[i].getUseDynamicSuffixes(),
                'creator'            = getUserInformation(pageArray[i].getCreator()),
                'creationDate'       = formatCtrl.formatDate(pageArray[i].getCreationDate()),
                'lastEditor'         = getUserInformation(pageArray[i].getLastEditor()),
                'lastEditDate'       = formatCtrl.formatDate(pageArray[i].getLastEditDate()),
                'subPages'           = getSubPages(pageArray[i].getPageId(), pageArray[i].getRegion()),
                'active'             = toString(pageArray[i].getActiveStatus()),
                "pageStatusId"       = toString(pageArray[i].getPageStatusId()),
                "pageStatusName"     = pageArray[i].getPageStatus().getName()
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