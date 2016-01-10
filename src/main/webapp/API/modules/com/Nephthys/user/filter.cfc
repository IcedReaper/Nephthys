component {
    public filter function init() {
        return this;
    }
    
    public array function getList() {
        var qGetUserIds = new Query().setSQL("  SELECT userId 
                                                  FROM nephthys_user
                                              ORDER BY userId")
                                     .execute()
                                     .getResult();
        var userArray = [];
        
        for(var i = 1; i <= qGetUserIds.getRecordCount(); i++) {
            userArray.append(createObject("component", "API.modules.com.Nephthys.user.user").init(qGetUserIds.userId[i]));
        }
        
        return userArray;
    }
    
    public array function search(required string username, required boolean like) {
        var _username = lcase(arguments.username);
        
        if(arguments.like) {
            _username = "%" & lcase(arguments.username) & "%";
        }
        
        var qGetUserIds = new Query().setSQL("  SELECT userId 
                                                  FROM nephthys_user
                                                 WHERE lower(username) LIKE :userName
                                              ORDER BY userId")
                                     .addParam(name = "username", value = _username, cfsqltype = "cf_sql_varchar")
                                     .execute()
                                     .getResult();
        var userArray = [];
        
        for(var i = 1; i <= qGetUserIds.getRecordCount(); i++) {
            userArray.append(createObject("component", "API.modules.com.Nephthys.user.user").init(qGetUserIds.userId[i]));
        }
        
        return userArray;
    }
}