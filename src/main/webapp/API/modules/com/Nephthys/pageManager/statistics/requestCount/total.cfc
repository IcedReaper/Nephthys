component extends="API.modules.com.Nephthys.pageManager.statistics.abstractStatistic" {
    public statistic function execute() {
        variables.qRes = new Query().setSQL("SELECT COUNT(*) pageRequests
                                               FROM nephthys_page_statistics ps
                                             INNER JOIN nephthys_page_region r ON ps.regionId = r.regionId
                                              WHERE ps.visitDate > NOW() - '1 day' :: interval
                                                AND r.showInStatistics = true ")
                                    .execute()
                                    .getResult();
        return this;
    }
    
    public numeric function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        if(variables.qRes.getRecordCount() == 1) {
            return variables.qRes.pageRequests[1];
        }
        else {
            return 0;
        }
    }
}