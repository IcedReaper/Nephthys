interface {
    public pageRequestQuery function init();
    
    public pageRequestQuery function setFromDate(required date _date);
    public pageRequestQuery function setToDate(required date _date);
    
    public pageRequestQuery function execute();
    
    public query function getQuery();
    public array function getResult();
}