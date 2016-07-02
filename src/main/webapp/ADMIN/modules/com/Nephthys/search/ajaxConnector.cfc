component {
    import "API.modules.com.Nephthys.search.*";
    
    remote struct function getSearchStatistics(required boolean total, required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");
        
        if(arguments.total) {
            return new statistics().getTotal(arguments.sortOrder,
                                             _fromDate,
                                             _toDate);
        }
        else {
            return new statistics().getDetailed(arguments.sortOrder,
                                                _fromDate,
                                                _toDate);
        }
    }
    
    remote array function getSearchOverview(required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");
        
        return new statistics().getOverview(_fromDate,
                                            _toDate);
    }
}