component {
    public pageRequest function init(required string link) {
        variables.resources = {
            "css" = [],
            "js"  = []
        };
        variables.title = "";
        variables.description = "";
        variables.specialCssClasses = {
            "html"   = "",
            "body"   = "",
            "header" = "",
            "main"   = "",
            "footer" = ""
        };
        variables.openGraphInfo = {
            "url"         = "",
            "type"        = "",
            "title"       = "",
            "description" = "",
            "image"       = ""
        };
        
        variables.versionLoaded = false;
        variables.link = arguments.link;
        variables.content = "";
        variables.sitemapPage = null;
        loadPage();
        
        return this;
    }
    
    public pageRequest function addResource(required string type, required string fileName) {
        switch(arguments.type) {
            case "js":
            case "css": {
                variables.resources[arguments.type].append(arguments.fileName);
                
                return this;
            }
            default: {
                throw(type = "nephthys.application.invalidResource", message = "Could not add the required resource type");
            }
        }
    }
    public pageRequest function setTitle(required string title) {
        variables.title = arguments.title;
        variables.openGraphInfo.title = arguments.title;
        
        return this;
    }
    public pageRequest function setDescription(required string description) {
        variables.description = arguments.description;
        variables.openGraphInfo.description = arguments.description;
        
        return this;
    }
    
    public string function getParameter() {
        return variables.parameter;
    }
    public struct function getAllResources() {
        return variables.resources;
    }
    public array function getResources(required string type) {
        switch(arguments.type) {
            case "js":
            case "css": {
                return variables.resources[arguments.type];
            }
            default: {
                throw(type = "nephthys.application.invalidResource", message = "Could not find the required resource type");
            }
        }
    }
    public string function renderResources(required string type="") {
        var resources = "";
        
        if(arguments.type == "") {
            resources &= renderResources("css");
            resources &= renderResources("js");
            
            return resources;
        }
        
        
        if(arguments.type == "css") {
            for(var i = 1; i <= variables.resources.css.len(); i++) {
                resources &= "<link rel='stylesheet' href='" & variables.resources.css[i] & "'>";
            }
        }
        
        if(arguments.type == "js") {
            for(var i = 1; i <= variables.resources.js.len(); i++) {
                resources &= "<script src='" & variables.resources.js[i] & "'></script>";
            }
        }
        
        return resources;
    }
    
    public pageRequest function setOpenGraphTitle(required string title) {
        variables.openGraphInfo.title = arguments.title;
        return this;
    }
    public pageRequest function setOpenGraphDescription(required string description) {
        variables.openGraphInfo.description = arguments.description;
        return this;
    }
    public pageRequest function setOpenGraphUrl(required string url) {
        if(arguments.url != "default") {
            variables.openGraphInfo.url = arguments.url;
        }
        else {
            variables.openGraphInfo.url = getDeepLink();
        }
        return this;
    }
    public pageRequest function setOpenGraphType(required string type) {
        if(arguments.type != "default") {
            variables.openGraphInfo.type = arguments.type;
        }
        else {
            variables.openGraphInfo.type = "article";
        }
        return this;
    }
    public pageRequest function setOpenGraphImage(required string image) {
        variables.openGraphInfo.image = arguments.image;
        return this;
    }
    public string function renderOpenGraphInfo() {
        var ogInfoString = "";
        for(var ogInfo in variables.openGraphInfo) {
            if(variables.openGraphInfo[ogInfo] != "") {
                ogInfoString &= "<meta property=""og:" & ogInfo & """ content=""" & variables.openGraphInfo[ogInfo].replace("""", "", "ALL") & """ />";
            }
        }
        
        return ogInfoString;
    }
    
    public pageRequest function setSpecialCssClass(required string for, required string value, required boolean append = true) {
        switch(arguments.for) {
            case "html":
            case "body":
            case "header":
            case "main":
            case "footer": {
                if(arguments.append) {
                    variables.specialCssClasses[arguments.for] &= " " & arguments.value;
                }
                else {
                    variables.specialCssClasses[arguments.for] = arguments.value;
                }
                break;
            }
            default: {
                throw(type = "nephthys.application.notAllowed", message = "The type " & arguments.for & " isn't supported");
            }
        }
        
        return this;
    }
    
    public boolean function isSpecialCssClassSet(required string for) {
        switch(arguments.for) {
            case "html":
            case "body":
            case "header":
            case "main":
            case "footer": {
                return variables.specialCssClasses[arguments.for] != "";
            }
            default: {
                throw(type = "nephthys.application.notAllowed", message = "The type " & arguments.for & " isn't supported");
            }
        }
    }
    
    public string function getSpecialCssClass(required string for) {
        switch(arguments.for) {
            case "html":
            case "body":
            case "header":
            case "main":
            case "footer": {
                return variables.specialCssClasses[arguments.for];
            }
            default: {
                throw(type = "nephthys.application.notAllowed", message = "The type " & arguments.for & " isn't supported");
            }
        }
    }
    
    // inhertitations of page class
    public numeric function getPageId() {
        return variables.page.getPageId();
    }
    public numeric function getPageVersionId() {
        return variables.pageVersion.getPageVersionId();
    }
    public numeric function getParentId() {
        return variables.pageVersion.getParentId();
    }
    public string function getLinkText() {
        return variables.pageVersion.getLinkText();
    }
    public string function getLink() {
        return variables.pageVersion.getLink();
    }
    public string function getTitle() {
        return variables.title != "" ? variables.title & " - " & variables.pageVersion.getTitle() : variables.pageVersion.getTitle();
    }
    public string function getDescription() {
        return variables.description != "" ? variables.description : variables.pageVersion.getDescription();
    }
    public array function getContent() {
        return variables.pageVersion.getContent();
    }
    public numeric function getSortOrder() {
        return variables.pageVersion.getSortOrder();
    }
    public boolean function getuseDynamicUrlSuffix() {
        return variables.pageVersion.getuseDynamicUrlSuffix();
    }
    public date function getCreationDate() {
        return variables.pageVersion.getCreationDate();
    }
    public date function getLastEditDate() {
        return variables.pageVersion.getLastEditDate();
    }
    public page function getParentPage() {
        return variables.pageVersion.getParentPage();
    }
    public user function getCreator() {
        return variables.pageVersion.getCreator();
    }
    public user function getLastEditor() {
        return variables.pageVersion.getLastEditor();
    }
    public string function getRegion() {
        return variables.pageVersion.getRegion();
    }
    public numeric function getStatusId() {
        return variables.pageVersion.getStatusId();
    }
    public pageStatus function getPageStatus() {
        return new status(variables.pageVersion.getStatusId());
    }
    public boolean function isOnline() {
        return variables.pageVersion.isOnline();
    }
    public boolean function isOffline() {
        return ! isOnline();
    }
    public boolean function isPreview() {
        return variables.versionLoaded;
    }
    public string function getEncodedLink(required boolean withDomain = true) {
        return urlEncode((arguments.withDomain ? application.system.settings.getValueOfKey("wwwDomain") : "") & getLink());
    }
    public string function getEncodedDeepLink(required boolean withDomain = true) {
        return urlEncode((arguments.withDomain ? application.system.settings.getValueOfKey("wwwDomain") : "") & variables.link);
    }
    public string function getDeepLink(required boolean withDomain = true) {
        return (arguments.withDomain ? application.system.settings.getValueOfKey("wwwDomain") : "") & variables.link;
    }
    public pageRequest function generateContent() {
        variables.content = renderPageContent(variables.pageVersion.getContent(), variables.parameter);
        return this;
    }
    public string function getRenderedContent() {
        return variables.content;
    }
    
    public pageRequest function saveToStatistics() {
        if(! variables.versionLoaded && ! isNull(variables.sitemapPage)) {
            new Query().setSQL("INSERT INTO nephthys_page_statistics
                                            (
                                                pageId,
                                                completeLink,
                                                regionId
                                            )
                                     VALUES (
                                                :pageId,
                                                :link,
                                                :regionId
                                            )")
                       .addParam(name = "pageId",   value = variables.page.getPageId(),                      cfsqltype = "cf_sql_numeric")
                       .addParam(name = "link",     value = getLink() & variables.parameter,                 cfsqltype = "cf_sql_varchar")
                       .addParam(name = "regionId", value = variables.sitemapPage.getRegion().getRegionId(), cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        return this;
    }
    
    private void function loadPage() {
        if(url.keyExists("pageVersionId")) {
            var adminLink = application.system.settings.getValueOfKey("adminDomain");
            if(left(cgi.HTTP_REFERER, adminLink.len()) == adminLink) {
                variables.pageVersion = new pageVersion(url.pageVersionId);
                variables.page        = new page(variables.pageVersion.getPageId());
                variables.parameter   = replaceNoCase(variables.link, variables.pageVersion.getLink(), "");
                
                variables.versionLoaded = true;
            }
            else {
                throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = variables.link);
            }
        }
        else {
            var pageRequestFilter = new filter().for("pageRequest")
                                                .setLink(variables.link);
            
            if(pageRequestFilter.execute().getResultCount() == 1) {
                var filterResult = pageRequestFilter.getResult()[1];
                variables.page      = filterResult.page;
                variables.parameter = filterResult.parameter;
                
                var sitemap = new filter().for("sitemap")
                                          .setOnline(true)
                                          .execute()
                                          .getResult();
                if(sitemap.len() >= 1) {
                    var sitemapId = sitemap[1].getSitemapId();
                    
                    var sitemapPages = new filter().for("sitemapPage")
                                                   .setSitemapId(sitemapId)
                                                   .setPageId(variables.page.getPageId())
                                                   .execute()
                                                   .getResult();
                    
                    if(sitemapPages.len() >= 1) {
                        variables.sitemapPage = sitemapPages[1];
                    }
                }
            }
            else {
                if(application.system.settings.getValueOfKey("useFirstPageAsStartPage") && 
                   pageRequestFilter.getResultCount() == 0 && variables.link == "/") {
                    // if we have the root page and it doesn't exist we'll get the first existing page
                    variables.parameter = "";
                    
                    var sitemap = new filter().for("sitemap")
                                              .setOnline(true)
                                              .execute()
                                              .getResult();
                    if(sitemap.len() >= 1) {
                        var sitemapId = sitemap[1].getSitemapId();
                        
                        var sitemapPages = new filter().for("sitemapPage")
                                                       .setSitemapId(sitemapId)
                                                       .execute()
                                                       .getResult();
                        
                        if(sitemapPages.len() >= 1) {
                            variables.sitemapPage = sitemapPages[1];
                            variables.page = variables.sitemapPage.getPage();
                            
                            if(application.system.settings.getValueOfKey("redirectToFirstPage")) {
                                location(addtoken = false, statuscode = "301", url = variables.page.getActualPageVersion().getLink());
                            }
                        }
                        else {
                            throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = variables.link);
                        }
                    }
                    else {
                        throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = variables.link);
                    }
                }
                else {
                    throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = variables.link);
                }
            }
        
            variables.pageVersion = variables.page.getActualPageVersion();
        }
    }
    
    private string function renderPageContent(required array pageContent, required string parameter) {
        var content = "";
        
        for(var i = 1; i <= arguments.pageContent.len(); i++) {
            if(permissionsOk(arguments.pageContent[i].type, arguments.pageContent[i].options)) {
                var entityConnector = createObject("component", "WWW.modules." & arguments.pageContent[i].type & ".connector").init();
                
                content &= entityConnector.render(arguments.pageContent[i].options,
                                                  renderPageContent(arguments.pageContent[i].children, arguments.parameter));
            }
        }
        return content;
    }
    
    private boolean function permissionsOk(required string moduleName, required struct options) {
        if(arguments.options.keyExists("roleName")) {
            return request.user.hasPermission(arguments.moduleName, arguments.options.roleName);
        }
        else {
            if(arguments.options.keyExists("onlyVisibleToLoggedInUser")) {
                return arguments.options.onlyVisibleToLoggedInUser ? request.user.getStatus().getCanLogin() : true;
            }
            else {
                if(arguments.options.keyExists("onlyVisibleToLoggedOutUser")) {
                    return arguments.options.onlyVisibleToLoggedOutUser ? (! request.user.getStatus().getCanLogin()) : true;
                }
                else {
                    return true;
                }
            }
        }
    }
}