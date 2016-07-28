component {
    import "API.modules.com.Nephthys.*";
    
    remote numeric function getUptime() {
        return dateDiff("s", server.startupTime, now());
    }
    
    remote numeric function getNewRegistrations() {
        return new userManager.filter().for("user")
                                       .setRegistrationFromDate(dateAdd("h", -24, now()))
                                       .execute()
                                       .getResultCount();
    }
    
    remote numeric function getErrorCount() {
        return new errorLog.filter().for("error")
                                    .setFromDatetime(dateAdd("h", -24, now()))
                                    .execute()
                                    .getResultCount();
    }
    
    remote numeric function getTotalPageRequests() {
        return new pageManager.statistics().getTotalPageRequestCount(dateAdd("h", -24, now()), now());
    }
    
    remote struct function getTopPageRequest() {
        return new pageManager.statistics().getTopPageRequestCount(dateAdd("h", -24, now()), now());
    }
    
    remote struct function getLast24HourRequests() {
        return new pageManager.statistics().getLast24HoursTotal();
    }
    
    remote struct function getServerStatus() {
        return {
            maintenanceMode = application.system.settings.getValueOfKey("maintenanceMode") == "true",
            online          = application.system.settings.getValueOfKey("active") == "true"
        };
    }
}