component {
    public pageRequest function init(required numeric pageId, string parameter = "") {
        variables.parameter = arguments.parameter;
        variables.resources = {
            "css" = [],
            "js"  = []
        };
        variables.title = "";
        variables.description = "";
        
        variables.page = createObject("component", "API.com.Nephthys.classes.page.page").init(arguments.pageId);
        
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
    
    public pageRequest function saveToStatistics() {
        new Query().setDatasource("nephthys_admin") // todo: change to user when user can write to this table
                   .setSQL("INSERT INTO nephthys_statistics
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
}