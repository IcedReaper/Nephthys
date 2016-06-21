component {
    remote struct function getServerInfo() {
        var memoryUsageCtrl = createObject("component", "API.modules.com.Nephthys.dashboard.memoryUsage").init();
        
        var memory = {
            total          = memoryUsageCtrl.getTotal(),
            used           = memoryUsageCtrl.getUsed(),
            percentageUsed = memoryUsageCtrl.getUsedPercentage()
        };
        
        return {
            memory = memory,
            installedVersion = application.system.settings.getValueOfKey("nephthysVersion"),
            installDate = application.system.settings.getValueOfKey("formatLibrary").formatDate(application.system.settings.getValueOfKey("installDate")),
            maintenanceMode = application.system.settings.getValueOfKey("maintenanceMode") == "true",
            onlineStatus = application.system.settings.getValueOfKey("active") == "true"
        };
    }
}