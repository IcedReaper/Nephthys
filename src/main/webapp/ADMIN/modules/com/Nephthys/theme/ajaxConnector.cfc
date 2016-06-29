component {
    import "API.modules.com.Nephthys.theme.*";
    
    remote array function getList() {
        var filterCtrl = new filter();
        
        var themeData = [];
        for(var theme in filterCtrl.execute().getResult()) {
            themeData.append(prepareTheme(theme));
        }
        
        return themeData;
    }
    
    remote struct function getDetails(required numeric themeId) {
        var theme = new theme(arguments.themeId);
        
        return prepareTheme(theme);
    }
    
    remote struct function save(required numeric themeId,
                                required string  name,
                                required string  foldername,
                                required boolean active) {
        var theme = new theme(arguments.themeId);
        theme.setName(arguments.name);
        
        if(arguments.themeId != 0) {
            if(arguments.active == 1 || 
               (arguments.active == 0 && themeList[i].getThemeId() != createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("WWW").getValue() &&
                                         themeList[i].getThemeId() != createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("ADMIN").getValue())) {
                theme.setActiveStatus(arguments.active);
            }
        }
        else {
            theme.uploadAsZip(arguments.foldername);
        }
        
        theme.save();
        
        return prepareTheme(theme);
    }
    
    remote boolean function activate(required numeric themeId) {
        var theme = new theme(arguments.themeId);
        
        theme.setActiveStatus(1)
             .save();
        
        return true;
    }
    
    remote boolean function deactivate(required numeric themeId) {
        var theme = new theme(arguments.themeId);
        
        if(themeList[i].getThemeId() != createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("WWW").getValue() &&
           themeList[i].getThemeId() != createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("ADMIN").getValue()) {
            theme.setActiveStatus(0)
                 .save();
        }
        else {
            throw(type = "nephthys.application.deleteFailed", message = "Cannot delete the default theme. Please change the systems default theme first.");
        }
        
        return true;
    }
    
    remote boolean function delete() {
        var theme = new theme(arguments.themeId);
        
        theme.delete();
        
        return true;
    }
    
    
    private struct function prepareTheme(required theme theme) {
        return {
            "themeId"        = arguments.theme.getThemeId(),
            "name"           = arguments.theme.getName(),
            "foldername"     = arguments.theme.getFoldername(),
            "defaultWww"     = arguments.theme.getThemeId() == createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("WWW").getValue(),
            "defaultAdmin"   = arguments.theme.getThemeId() == createObject("component", "API.modules.com.Nephthys.system.filter").init().setKey("defaultThemeId").setApplication("ADMIN").getValue(),
            "active"         = arguments.theme.getActiveStatus(),
            "availableWww"   = arguments.theme.getAvailableWww(),
            "availableAdmin" = arguments.theme.getAvailableAdmin()
        };
    }
}