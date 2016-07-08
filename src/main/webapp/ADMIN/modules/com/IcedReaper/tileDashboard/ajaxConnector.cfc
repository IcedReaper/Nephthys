component {
    remote numeric function getUptime() {
        return dateDiff("s", server.startupTime, now());
    }
    
    remote numeric function getNewRegistrations() {
        return createObject("component", "API.modules.com.Nephthys.user.filter").setFor("user")
                                                                                .setRegistrationFromDate(dateAdd("h", -24, now()))
                                                                                .execute()
                                                                                .getResultCount();
    }
    
    remote numeric function getErrorCount() {
        return createObject("component", "API.modules.com.Nephthys.error.filter").setFor("error")
                                                                                 .setFromDate(dateAdd("h", -24, now()))
                                                                                 .execute()
                                                                                 .getResultCount();
    }
    
    remote numeric function getTotalPageRequests() {
        return createObject("component", "API.modules.com.Nephthys.pages.statistics").getTotalPageRequestCount(dateAdd("h", -24, now()), now());
    }
    
    remote struct function getTopPageRequest() {
        return createObject("component", "API.modules.com.Nephthys.pages.statistics").getTopPageRequestCount(dateAdd("h", -24, now()), now());
    }
    
    remote struct function getLast24HourRequests() {
        return createObject("component", "API.modules.com.Nephthys.pages.statistics").getLast24HoursTotal();
    }
    
    remote struct function getServerStatus() {
        return {
            maintenanceMode = application.system.settings.getValueOfKey("maintenanceMode") == "true",
            online          = application.system.settings.getValueOfKey("active") == "true"
        };
    }
}