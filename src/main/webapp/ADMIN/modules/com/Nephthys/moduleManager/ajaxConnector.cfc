component {
    remote struct function getList() {
        var moduleOverviewCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
        
        var installedModules = moduleOverviewCtrl.getList();
        var preparedModules = [];
        
        for(var i = 1; i <= installedModules.len(); i++) {
            preparedModules.append({
                    'moduleId'     = installedModules[i].getModuleId(),
                    'moduleName'   = installedModules[i].getModuleName(),
                    'description'  = installedModules[i].getDescription(),
                    'active'       = toString(installedModules[i].getActiveStatus()),
                    'systemModule' = toString(installedModules[i].getSystemModule())
                });
        }
        
        return {
            'success' = true,
            'data'    = preparedModules
        };
    }
    
    remote struct function getDetails(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        
        return {
            'success' = true,
            'data' = {
                'moduleId'     = module.getModuleId(),
                'moduleName'   = module.getModuleName(),
                'description'  = module.getDescription(),
                'active'       = toString(module.getActiveStatus()),
                'systemModule' = toString(module.getSystemModule())
            }
        };
    }
    
    remote struct function save(required numeric moduleId,
                                required string  moduleName,
                                required string  description,
                                required numeric active) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        
        if(arguments.moduleId == 0) {
            var moduleOverviewCtrl = createObject("component", "API.com.Nephthys.controller.modules.overview").init();
            var maxSortOrder = moduleOverviewCtrl.getMaxSortOrder();
            
            module.setSortOrder(maxSortOrder + 1);
        }
        
        module.setModuleName(arguments.moduleName)
              .setDescription(arguments.description)
              .setActiveStatus(arguments.active)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function delete(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.delete();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activate(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.setActiveStatus(1)
              .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate(required numeric moduleId) {
        var module = createObject("component", "API.com.Nephthys.classes.module.module").init(arguments.moduleId);
        module.setActiveStatus(0)
              .save();
        
        return {
            'success' = true
        };
    }
}