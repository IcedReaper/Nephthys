component {
    public loader function init() {
        return this;
    }
    
    public pageRequest function getPageId(required string link) {
        var qGetPage = new Query().setSQL("SELECT page.pageId,
                                                  page.preparredLink,
                                                  regexp_matches(:link, page.preparredLink || page.suffix || '$', 'i') parameter,
                                                  page.suffix
                                             FROM (SELECT p.pageId,
                                                          '^' || replace(p.link, '/', '\/') preparredLink,
                                                          CASE 
                                                            WHEN p.useDynamicSuffixes = true THEN 
                                                              '(?:\/(\w*|\-|\s|\.)*)*'
                                                            ELSE 
                                                              ''
                                                          END suffix
                                                     FROM nephthys_page p
                                                    WHERE p.active = :active) page")
                                  .addParam(name = "link",   value = arguments.link, cfsqltype = "cf_sql_varchar")
                                  .addParam(name = "active", value = 1,              cfsqltype = "cf_sql_bit")
                                  .execute()
                                  .getResult();
        
        if(qGetPage.getRecordCount() == 1) {
            var parameter = "";
            if(qGetPage.suffix[1] != '') {
                /*
                 * replace the link from the database from the url link
                 * DB: /Gallery
                 * URL: /Gallery/My-Gallery-1
                 * Parameter => /My-Gallery-1
                 */
                parameter = reReplaceNoCase(arguments.link, qGetPage.preparredLink[1], "");
            }
            return new pageRequest(qGetPage.pageId[1], parameter);
        }
        else {
            throw(type = "nephthys.notFound.page", message = "The page could not be found.", detail = arguments.link);
        }
    }
}