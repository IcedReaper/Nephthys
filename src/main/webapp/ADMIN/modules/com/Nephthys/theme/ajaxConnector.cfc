component {
    remote struct function getList() {
        var themeLoaderCtrl = createObject("component", "API.com.Nephthys.controller.system.themeLoader").init();
        
        var themeList = themeLoaderCtrl.getList();
        
        var themeData = [];
        for(var i = 1; i <= themeList.len(); i++) {
            themeData.append({
                    "themeId"    = themeList[i].getThemeId(),
                    "name"       = themeList[i].getName(),
                    "foldername" = themeList[i].getFoldername(),
                    "default"    = themeList[i].getThemeId() == application.system.settings.getDefaultThemeId(),
                    "active"     = toString(themeList[i].getActiveStatus())
                });
        }
        
        return {
            "success" = true,
            "data" = themeData
        };
    }
    
    remote struct function getDetails(required numeric themeId) {
        var theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(arguments.themeId);
        
        return {
            "success" = true,
            "data" = {
                "themeId"    = theme.getThemeId(),
                "name"       = theme.getName(),
                "foldername" = theme.getFoldername(),
                "default"    = theme.getThemeId() == application.system.settings.getDefaultThemeId(),
                "active"     = toString(theme.getActiveStatus())
            }
        };
    }
    
    remote struct function save(required numeric themeId,
                                required string  name,
                                required string  foldername,
                                required numeric active) {
        var theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(arguments.themeId);
        theme.setName(arguments.name);
        
        if(arguments.themeId != 0) {
            if(arguments.active == 0 && themeList[i].getThemeId() != application.system.settings.getDefaultThemeId()) {
                theme.setActive(arguments.active);
            }
        }
        else {
            theme.setFoldername(arguments.foldername);
            
            // upload, unzip and install the theme
            var tmpDirectory = expandPath("/upload/theme/");
            var destFolder   = tmpDirectory & arguments.name;
            
            var uploadedAdminThemePath = "/src/main/webapp/ADMIN/themes/" & arguments.foldername;
            var uplodedWwwThemePath    = "/src/main/webapp/WWW/themes/" & arguments.foldername;
            var adminThemePath         = expandPath("/ADMIN/themes/" & arguments.foldername);
            var wwwThemePath           = expandPath("/WWW/themes/" & arguments.foldername);
            
            if(directoryExists(adminThemePath) || directoryExists(wwwThemePath)) {
                throw(type = "nephthys.application.alreadyExists", message = "One of the target folders already exists!");
            }
            
            directoryCreate(tmpDirectory, true, true);
            
            var uploaded = fileUpload(tmpDirectory, "file");
            if(uploaded.fileWasSaved) {
                directoryCreate(destFolder);
                
                zip action      = "unzip"
                    //charset     = "UTF-8"
                    file        = tmpDirectory & uploaded.serverFile
                    destination = destFolder
                    overwrite   = true
                    recurse     = true;
                
                directoryCopy(destFolder & uploadedAdminThemePath, adminThemePath, true, "*", true);
                directoryCopy(destFolder & uplodedWwwThemePath, wwwThemePath, true, "*", true);
                
                fileDelete(tmpDirectory & uploaded.serverFile);
                directoryDelete(tmpDirectory, true);
            }
            else {
                throw(type = "nephthys.application.uploadFailed", message = "The file could not be saved");
            }
        }
        
        theme.save();
        
        return {
            "success" = true,
            "data" = {
                "themeId"    = theme.getThemeId(),
                "name"       = theme.getName(),
                "foldername" = theme.getFoldername(),
                "default"    = theme.getThemeId() == application.system.settings.getDefaultThemeId(),
                "active"     = toString(theme.getActiveStatus())
            }
        };
    }
    
    remote struct function activate(required numeric themeId) {
        var theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(arguments.themeId);
        
        theme.setActiveStatus(1)
             .save();
        
        return {
            "success" = true
        };
    }
    
    remote struct function deactivate(required numeric themeId) {
        var theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(arguments.themeId);
        
        if(themeList[i].getThemeId() != application.system.settings.getDefaultThemeId()) {
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
        var theme = createObject("component", "API.com.Nephthys.classes.system.theme").init(arguments.themeId);
        
        var adminThemePath = expandPath("/ADMIN/themes/" & theme.getFoldername());
        var wwwThemePath = expandPath("/WWW/themes/" & theme.getFoldername());
        directoryDelete(adminThemePath, true);
        directoryDelete(wwwThemePath, true);
        
        theme.delete();
        
        return {
            "success" = true
        };
    }
}