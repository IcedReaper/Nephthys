component {
    remote boolean function setupLuceeAdminAccess(required struct formData) {
        var hasPassword = false;
        
        admin action="hasPassword" type="server" returnVariable="hasPassword";
        
        if(! hasPassword) {
            admin action="updatePassword" type="server" newPassword=arguments.formData.luceeAdminPassword;
        }
        
        return true;
    }
    
    remote boolean function setupAdminDatasource(required struct formData) {
        var hashedPassword = "";
        // todo: implement more.
        var dbDriver = "PostgreSql";
        
        var driverNames = structnew("linked");
        driverNames = componentListPackageAsStruct("lucee-server.admin.dbdriver", driverNames);
        driverNames = componentListPackageAsStruct("lucee.admin.dbdriver", driverNames);
        driverNames = componentListPackageAsStruct("dbdriver", driverNames);
        
        var driver = createObject("component", driverNames[dbDriver]);
        
        
        admin action         = "hashPassword"
              type           = "server"
              pw             = arguments.formData.luceeAdminPassword
              returnVariable = "hashedPassword";
        
        admin action   = "connect"
              type     = "server"
              password = "#hashedPassword#";
        
        admin action   = "updateDatasource"
              type     = "server"
              password = "#hashedPassword#"
              
              classname = "#driver.getClass()#"
              dsn       = "#driver.getDSN()#"
                          
              name    = "nephthys_admin"
              newName = "nephthys_admin"
              
              host       = arguments.formData.host
              database   = arguments.formData.database
              port       = arguments.formData.port
              timezone   = ""
              dbusername = arguments.formData.adminUsername
              dbpassword = arguments.formData.adminPassword
              
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
              dbdriver       = dbDriver;
        
        return true;
    }
    
    remote boolean function setupWwwDatasource(required struct formData) {
        var hashedPassword = "";
        // todo: implement more.
        var dbDriver = "PostgreSql";
        
        var driverNames = structnew("linked");
        driverNames = componentListPackageAsStruct("lucee-server.admin.dbdriver", driverNames);
        driverNames = componentListPackageAsStruct("lucee.admin.dbdriver", driverNames);
        driverNames = componentListPackageAsStruct("dbdriver", driverNames);
        
        var driver = createObject("component", driverNames[dbDriver]);
        
        
        admin action         = "hashPassword"
              type           = "server"
              pw             = arguments.formData.luceeAdminPassword
              returnVariable = "hashedPassword";
        
        admin action   = "connect"
              type     = "server"
              password = "#hashedPassword#";
        
        admin action   = "updateDatasource"
              type     = "server"
              password = "#hashedPassword#"
              
              classname = "#driver.getClass()#"
              dsn       = "#driver.getDSN()#"
                          
              name    = "nephthys_user"
              newName = "nephthys_user"
              
              host       = arguments.formData.host
              database   = arguments.formData.database
              port       = arguments.formData.port
              timezone   = ""
              dbusername = arguments.formData.userUsername
              dbpassword = arguments.formData.userPassword
              
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
              dbdriver       = dbDriver;
        
        return true;
    }
    
    
    // copied from: https://github.com/lucee/Lucee/blob/9eb38f0e565c94cc3c496f455eb94ba7535b5d94/core/src/main/cfml/context/admin/web_functions.cfm
    // copied to get the sql drivers
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