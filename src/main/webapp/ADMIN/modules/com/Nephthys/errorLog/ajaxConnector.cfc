component {
    import "API.modules.com.Nephthys.errorLog.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList(required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getTotalSplitPerType(_fromDate,
                                                     _toDate);
    }
    
    remote struct function getDetails(required string errorCode, required string fromDate, required string toDate, numeric errorId = null) {
        var error = null;
        var previousErrorId = null;
        var nextErrorId = null;
        var errorFilter = new filter().for("error")
                                      .setFromDate(arguments.fromDate)
                                      .setToDate(arguments.toDate)
                                      .setSortOrder("DESC")
                                      .setLimit(1)
                                      .setErrorCode(arguments.errorCode);
        
        if(arguments.errorId != null) {
            error = new error(arguments.errorId);
        }
        else {
            errorFilter.execute();
            
            if(errorFilter.getResultCount() > 0) {
                error = errorFilter.getResult()[1];
            }
        }
        
        var details = {};
        if(! isNull(error)) {
            var previousErrorFilter = new filter().for("error")
                                                  .setFromDate(arguments.fromDate)
                                                  .setToDate(arguments.toDate)
                                                  .setSortOrder("ASC")
                                                  .setLimit(1)
                                                  .setErrorCode(arguments.errorCode)
                                                  .setMinErrorId(error.getErrorId())
                                                  .execute();
            
            if(previousErrorFilter.getResultCount() > 0) {
                previousErrorId = previousErrorFilter.getResult()[1].getErrorId();
            }
            var nextErrorFilter = duplicate(errorFilter);
            nextErrorFilter.setMaxErrorId(error.getErrorId())
                               .execute();
            
            if(nextErrorFilter.getResultCount() > 0) {
                nextErrorId = nextErrorFilter.getResult()[1].getErrorId();
            }
            
            details = {
                errorId    = error.getErrorId(),
                link       = error.getLink(),
                message    = error.getMessage(),
                errorCode  = error.getErrorCode(),
                details    = error.getDetails(),
                stacktrace = error.getStacktrace(),
                user       = {
                    userId   = error.getUser().getUserId(),
                    username = error.getUser().getUsername(),
                    avatar   = error.getUser().getAvatarPath()
                },
                errorDate  = formatCtrl.formatDate(error.getDate()),
                referrer   = error.getReferrer(),
                userAgent  = error.getUserAgent()
            };
        }
        
        return {
            details         = details,
            previousErrorId = previousErrorId,
            nextErrorId     = nextErrorId
        };
    }
    
    
    remote struct function getStatisticsChartTotal(required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getTotal(arguments.sortOrder,
                                         _fromDate,
                                         _toDate);
    }
    
    remote struct function getStatisticsChartSeparatedByType(required string sortOrder, required string fromDate, required string toDate) {
        var _fromDate = dateFormat(arguments.fromDate, "YYYY/MM/DD");
        var _toDate   = dateFormat(arguments.toDate, "YYYY/MM/DD");

        return new statistics().getSplitPerType(arguments.sortOrder,
                                                _fromDate,
                                                _toDate);
    }
}