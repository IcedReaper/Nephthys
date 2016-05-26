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
    public numeric function getParentId() {
        return variables.page.getParentId();
    }
    public string function getLinkText() {
        return variables.page.getLinkText();
    }
    public string function getLink() {
        return variables.page.getLink();
    }
    public string function getTitle() {
        return variables.title != "" ? variables.title & " - " & variables.page.getTitle() : variables.page.getTitle();
    }
    public string function getDescription() {
        return variables.description != "" ? variables.description : variables.page.getDescription();
    }
    public array function getContent() {
        return variables.page.getContent();
    }
    public numeric function getSortOrder() {
        return variables.page.getSortOrder();
    }
    public boolean function getUseDynamicSuffixes() {
        return variables.page.getUseDynamicSuffixes();
    }
    public numeric function getCreatorUserId() {
        return variables.page.getCreatorUserId();
    }
    public date function getCreationDate() {
        return variables.page.getCreationDate();
    }
    public numeric function getLastEditorUserId() {
        return variables.page.getLastEditorUserId();
    }
    public date function getLastEditDate() {
        return variables.page.getLastEditDate();
    }
    public numeric function getActiveStatus() {
        return variables.page.getActiveStatus();
    }
    public page function getParentPage() {
        return variables.page.getParentPage();
    }
    public array function getChildPages() {
        return page.getChildPages();
    }
    public user function getCreator() {
        return variables.page.getCreator();
    }
    public user function getLastEditor() {
        return variables.page.getLastEditor();
    }
    public string function getRegion() {
        return variables.page.getRegion();
    }
    public numeric function getPageStatusId() {
        return variables.page.getPageStatusId();
    }
    public boolean function isOnline() {
        return variables.page.isOnline();
    }
    public boolean function isOffline() {
        return variables.page.isOffline();
    }
    public struct function getPageStatus() {
        return variables.page.getPageStatus();
    }
    
    public pageRequest function saveToStatistics() {
        new Query().setSQL("INSERT INTO nephthys_statistics
                                        (
                                            link,
                                            referrer
                                        )
                                 VALUES (
                                            :link,
                                            :referrer
                                        )")
                   .addParam(name = "link",     value = variables.page.getLink() & variables.parameter, cfsqltype = "cf_sql_varchar")
                   .addParam(name = "referrer", value = cgi.REFERRER,                                   cfsqltype = "cf_sql_varchar")
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
                                                         FROM nephthys_page p
                                                   INNER JOIN nephthys_pageVersion pv ON p.pageId = pv.pageId
                                                   INNER JOIN nephthys_pageStatus ps ON pv.pageStatusId = ps.pageStatusId
                                                        WHERE pv.active = :active
                                                          AND ps.offline = :online
                                                          AND ps.active  = :active) page")
                                  .addParam(name = "link",   value = arguments.link, cfsqltype = "cf_sql_varchar")
                                  .addParam(name = "active", value = 1,              cfsqltype = "cf_sql_bit")
                                  .addParam(name = "online", value = 0,              cfsqltype = "cf_sql_bit")
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
            
            // TODO: version handling
            variables.page = new page(qGetPage.pageId[1], 'actual');
        }
        else {
            throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = arguments.link);
        }
    }
}