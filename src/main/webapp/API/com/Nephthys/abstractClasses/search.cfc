component interface="API.interfaces.search" {
    public search function init() {
        variables.searchPhrase = "";
        variables.results = {};
        variables.resultCount = 0;
        
        return this;
    }
    
    public search function setSearchPhrase(required string searchPhrase) {
        variables.searchPhrase = arguments.searchPhrase;
        
        return this;
    }
    
    public struct function getResult() {
        return variables.results;
    }
    
    public numeric function getCount() {
        return variables.resultCount;
    }
}