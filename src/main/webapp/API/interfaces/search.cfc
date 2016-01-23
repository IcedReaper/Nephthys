interface {
    public search function init();
    
    public search function setSearchPhrase(required string searchPhrase);
    public search function search();
    public struct function getResult();
    public numeric function getCount();
}