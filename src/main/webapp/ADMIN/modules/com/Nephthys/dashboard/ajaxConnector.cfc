component {
    import "API.modules.com.Nephthys.statistics.*";
    import "API.modules.com.Nephthys.page.statistics.*";
    
    remote struct function loginStatistics() {
        var loginStatisticsCtrl = new login();
        
        return {
            "successful" = prepareLoginData(loginStatisticsCtrl.getSuccessful()),
            "failed"     = prepareLoginData(loginStatisticsCtrl.getFailed())
        };
    }
    
    private array function prepareLoginData(required array loginData) {
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
        
        for(var i = 1; i <= arguments.loginData.len(); ++i) {
            arguments.loginData[i].loginDate = formatCtrl.formatDate(arguments.loginData[i].loginDate);
        }
        
        return arguments.loginData;
    }
}