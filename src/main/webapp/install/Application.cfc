component {
    public boolean function onApplicationStart() {
        application.actualStep = 1;
        
        return true;
    }
    
    public boolean function onRequestStart() {
        // TODO: remove
        if(url.keyExists("step")) {
            application.actualStep = url.step;
        }
        
        if(url.keyExists("proceed") && (url.keyExists("step") && url.step == application.actualStep) && (application.actualStep == 1 || ! form.isEmpty())) {
            switch(application.actualStep) {
                case 2: {
                    // https://github.com/lucee/Lucee/blob/master/core/src/main/cfml/context/admin/services.datasource.create.cfm
                    var hashedPassword = "";
                    
                    var driverNames = structnew("linked");
                    driverNames = componentListPackageAsStruct("lucee-server.admin.dbdriver", driverNames);
                    driverNames = componentListPackageAsStruct("lucee.admin.dbdriver", driverNames);
                    driverNames = componentListPackageAsStruct("dbdriver", driverNames);
                    
                    var driver = createObject("component", driverNames["PostgreSql"]);
                    
                    admin action         = "hashPassword"
                          type           = "server"
                          pw             = "#form.luceeAdminPassword#"
                          returnVariable = "hashedPassword";
                    
                    admin action   = "connect"
                          type     = "server"
                          password = "#hashedPassword#";
                    
                    admin action   = "updateDatasource"
                          type     = "server"
                          password = "#hashedPassword#"
                          
                          classname = "#driver.getClass()#"
                          dsn       = "#driver.getDSN()#"
                                      
                          name    = "test_nephthys_admin"
                          newName = "test_nephthys_admin"
                          
                          host       = "#form.server#"
                          database   = "#form.database#"
                          port       = "#form.port#"
                          timezone   = ""
                          dbusername = "#form.dbAdminUsername#"
                          dbpassword = "#form.dbAdminPassword#"
                          
                          connectionLimit   = "-1"
                          connectionTimeout = ""
                          metaCacheTimeout  = ""
                          blob              = "false"
                          clob              = "false"
                          validate          = "false"
                          storage           = "false"
                          
                          allowed_select = "true"
                          allowed_insert = "true"
                          allowed_update = "true"
                          allowed_delete = "true"
                          allowed_alter  = "true"
                          allowed_drop   = "true"
                          allowed_revoke = "true"
                          allowed_create = "true"
                          allowed_grant  = "true"
                          verify         = "true"
                          custom         = ""
                          dbdriver       = "PostgreSql";
                    
                    admin action   = "updateDatasource"
                          type     = "server"
                          password = "#hashedPassword#"
                          
                          classname = "#driver.getClass()#"
                          dsn       = "#driver.getDSN()#"
                                      
                          name    = "test_nephthys_user"
                          newName = "test_nephthys_user"
                          
                          host       = "#form.server#"
                          database   = "#form.database#"
                          port       = "#form.port#"
                          timezone   = ""
                          dbusername = "#form.dbUserUsername#"
                          dbpassword = "#form.dbUserPassword#"
                          
                          connectionLimit   = "-1"
                          connectionTimeout = ""
                          metaCacheTimeout  = ""
                          blob              = "false"
                          clob              = "false"
                          validate          = "false"
                          storage           = "false"
                          
                          allowed_select = "true"
                          allowed_insert = "true"
                          allowed_update = "true"
                          allowed_delete = "true"
                          allowed_alter  = "false"
                          allowed_drop   = "false"
                          allowed_revoke = "false"
                          allowed_create = "false"
                          allowed_grant  = "false"
                          verify         = "true"
                          custom         = ""
                          dbdriver       = "PostgreSql";
                    
                    break;
                }
                case 3: {
                    break;
                }
                case 4: {
                    break;
                }
                case 5: {
                    break;
                }
            }
            
            application.actualStep++;
        }
        
        return true;
    }
    
    // https://github.com/lucee/Lucee/blob/9eb38f0e565c94cc3c496f455eb94ba7535b5d94/core/src/main/cfml/context/admin/web_functions.cfm
    private struct function ComponentListPackageAsStruct(string package, cfcNames = structNew("linked")) {
        try {
            var _cfcNames = ComponentListPackage(package);
            loop array="#_cfcNames#" index="i" item="el" {
                arguments.cfcNames[el]=package&"."&el;
            }
        }
        catch(e){}
        return arguments.cfcNames;
    }
}