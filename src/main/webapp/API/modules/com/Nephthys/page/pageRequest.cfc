component {
    import "API.modules.com.Nephthys.user.*";
    
    public pageRequest function init(required string link, required string version = "actual") {
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
        
        variables.version = arguments.version;
        loadPage(arguments.link);
        
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
        
        return this;
    }
    public pageRequest function setDescription(required string description) {
        variables.description = arguments.description;
        
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
    public boolean function getUseDynamicSuffixes() {
        return variables.pageVersion.getUseDynamicSuffixes();
    }
    public numeric function getCreatorUserId() {
        return variables.pageVersion.getCreator().getUserId();
    }
    public date function getCreationDate() {
        return variables.pageVersion.getCreationDate();
    }
    public numeric function getLastEditorUserId() {
        return variables.pageVersion.getLastEditor().getUserId();
    }
    public date function getLastEditDate() {
        return variables.pageVersion.getLastEditDate();
    }
    public page function getParentPage() {
        return variables.pageVersion.getParentPage();
    }
    /*public array function getChildPages() {
        return variables.page.getChildPages();
    }*/
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
    
    public pageRequest function saveToStatistics() {
        // TODO: Move to separate statistics component
        new Query().setSQL("INSERT INTO nephthys_statistics
                                        (
                                            link,
                                            referrer
                                        )
                                 VALUES (
                                            :link,
                                            :referrer
                                        )")
                   .addParam(name = "link",     value = getLink() & variables.parameter, cfsqltype = "cf_sql_varchar")
                   .addParam(name = "referrer", value = cgi.REFERRER,                    cfsqltype = "cf_sql_varchar")
                   .execute();
        
        return this;
    }
    
    private void function loadPage(required string link) {
        // TODO: add to filter
        var qGetPage = new Query().setSQL("SELECT page.pageId,
                                                  page.preparredLink,
                                                  regexp_matches(:link, page.preparredLink || page.suffix || '$', 'i') parameter,
                                                  page.suffix
                                             FROM (    SELECT p.pageId,
                                                              '^' || replace(pv.link, '/', '\/') preparredLink,
                                                              CASE 
                                                                WHEN pv.useDynamicSuffixes = true THEN 
                                                                  '(?:\/(\w*|\-|\s|\.)*)*'
                                                                ELSE 
                                                                  ''
                                                              END suffix
                                                         FROM nephthys_page_page p
                                                   INNER JOIN nephthys_page_pageVersion   pv ON p.pageId       = pv.pageId
                                                   INNER JOIN nephthys_page_status        ps ON pv.statusId    = ps.statusId
                                                   INNER JOIN nephthys_page_sitemapPage hp ON p.pageId       = hp.pageId
                                                   INNER JOIN nephthys_page_sitemap     h  ON hp.sitemapId = h.sitemapId
                                                   INNER JOIN nephthys_page_status        hs ON h.statusId     = hs.statusId
                                                        WHERE ps.online = :online
                                                          AND hs.online = :online) page")
                                  .addParam(name = "link",   value = arguments.link, cfsqltype = "cf_sql_varchar")
                                  .addParam(name = "active", value = 1,              cfsqltype = "cf_sql_bit")
                                  .addParam(name = "online", value = 1,              cfsqltype = "cf_sql_bit")
                                  .execute()
                                  .getResult();
        
        if(qGetPage.getRecordCount() == 1) {
            variables.parameter = "";
            if(qGetPage.suffix[1] != '') {
                /*
                 * replace the link from the database from the url link
                 * DB: /Gallery
                 * URL: /Gallery/My-Gallery-1
                 * Parameter => /My-Gallery-1
                 */
                variables.parameter = reReplaceNoCase(arguments.link, qGetPage.preparredLink[1], "");
            }
            
            variables.page = new page(qGetPage.pageId[1]);
            
            if(variables.version == "actual") {
                variables.pageVersion = variables.page.getActualPageVersion();
            }
            else {
                if(variables.page.versionExists(variables.version)) {
                    variables.pageVersion = variables.page.getPageVersion(variables.version);
                }
                else {
                    throw(type = "nephthys.notFound.page", message = "The version of the page could not be found.", detail = variables.version);
                }
            }
        }
        else {
            throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = arguments.link);
        }
    }
}