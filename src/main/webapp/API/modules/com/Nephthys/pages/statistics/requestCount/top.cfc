component extends="API.modules.com.Nephthys.pages.statistics.abstractStatistic" {
    public statistic function execute() {
        variables.qRes = new Query().setSQL("    SELECT pageStats.pageRequests,
                                                        pv.linktext
                                                   FROM (  SELECT COUNT(*) pageRequests,
                                                                  pageId
                                                             FROM nephthys_page_statistics ps
                                                            WHERE ps.visitDate > NOW() - '1 day' :: interval
                                                         GROUP BY ps.pageId
                                                         ORDER BY COUNT(*) DESC
                                                            LIMIT 1) pageStats
                                             INNER JOIN nephthys_page_page p ON pageStats.pageId = p.pageId
                                             INNER JOIN nephthys_page_pageVersion pv ON p.pageId = pv.pageId AND p.pageVersionId = pv.pageVersionId ")
                                    .execute()
                                    .getResult();
        return this;
    }
    
    public struct function getResult() {
        if(! isQuery(variables.qRes)) {
            throw(type = "nephthys.application.invalidResource", message = "Please be sure that you called execute() before you're trying to get the result count");
        }
        
        var topPageRequest = {};
        if(variables.qRes.getRecordCount() == 1) {
            topPageRequest = {
                title = variables.qRes.linktext[1],
                requests = variables.qRes.pageRequests[1]
            };
        }
        
        return topPageRequest;
    }
}