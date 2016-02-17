component {
    remote struct function getList() {
        var filterCtrl = createObject("component", "API.modules.com.Nephthys.theme.filter").init();
        
        var themeData = [];
        for(var theme in filterCtrl.execute().getResult()) {
            themeData.append({
                    "themeId"    = theme.getThemeId(),
                    "name"       = theme.getName(),
                    "foldername" = theme.getFoldername(),
                    "default"    = theme.getThemeId() == application.system.settings.getValueOfKey("defaultThemeId"),
                    "active"     = toString(theme.getActiveStatus())
                });
        }
        
        return {
            "success" = true,
            "data" = themeData
        };
    }
    
    remote struct function getDetails(required numeric themeId) {
        var theme = createObject("component", "API.modules.com.Nephthys.theme.theme").init(arguments.themeId);
        
        return {
            "success" = true,
            "data" = {
                "themeId"    = theme.getThemeId(),
                "name"       = theme.getName(),
                "foldername" = theme.getFoldername(),
                "default"    = theme.getThemeId() == application.system.settings.getValueOfKey("defaultThemeId"),
                "active"     = toString(theme.getActiveStatus())
            }
        };
    }
    
    remote struct function save(required numeric themeId,
                                required string  name,
                                required string  foldername,
                                required numeric active) {
        var theme = createObject("component", "API.modules.com.Nephthys.theme.theme").init(arguments.themeId);
        theme.setName(arguments.name);
        
        if(arguments.themeId != 0) {
            if(arguments.active == 1 || (arguments.active == 0 && themeList[i].getThemeId() != application.system.settings.getValueOfKey("defaultThemeId"))) {
                theme.setActive(arguments.active);
            }
        }
        else {
            theme.uploadAsZip(arguments.foldername);
        }
        
        theme.save();
        
        return {
            "success" = true,
            "data" = {
                "themeId"    = theme.getThemeId(),
                "name"       = theme.getName(),
                "foldername" = theme.getFoldername(),
                "default"    = theme.getThemeId() == application.system.settings.getValueOfKey("defaultThemeId"),
                "active"     = toString(theme.getActiveStatus())
            }
        };
    }
    
    remote struct function activate(required numeric themeId) {
        var theme = createObject("component", "API.modules.com.Nephthys.theme.theme").init(arguments.themeId);
        
        theme.setActiveStatus(1)
             .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric themeId) {
        var theme = createObject("component", "API.modules.com.Nephthys.theme.theme").init(arguments.themeId);
        
        if(themeList[i].getThemeId() != application.system.settings.getValueOfKey("defaultThemeId")) {
            theme.setActiveStatus(0)
                 .save();
        }
        else {
            throw(type = "nephthys.application.deleteFailed", message = "Cannot delete the default theme. Please change the systems default theme first.");
        }
        
        return {
            "success" = true
        };
    }
    
    remote struct function delete() {
        var theme = createObject("component", "API.modules.com.Nephthys.theme.theme").init(arguments.themeId);
        
        theme.delete();
        
        return {
            "success" = true
        };
    }
}