component {
    remote struct function getList() {
        var qErrorList = new Query().setSQL("  SELECT errorCode, COUNT(*) count
                                                 FROM nephthys_error
                                             GROUP BY errorCode
                                             ORDER BY COUNT(*) DESC")
                                    .execute()
                                    .getResult();
        
        var errorList = [];
        
        for(var i = 1; i <= qErrorList.getRecordCount(); i++) {
            errorList.append({
                    "errorCode" = qErrorList.errorCode[i],
                    "count"     = qErrorList.count[i]
                });
        }
        
        return {
            "success"   = true,
            "errorList" = errorList
        };
    }
}