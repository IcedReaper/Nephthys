interface {
    public statistic function init();
    
    public statistic function setFromDate(required date _date);
    public statistic function setToDate(required date _date);
    
    public statistic function execute();
    
    public query function getQuery();
    public array function getResult();
}