component {
    // todo: Refactor as filter
    public extPropertyKeyLoader function init() {
        return this;
    }
    
    public array function load() {
        var qGetKeyIds = new Query().setSQL("SELECT extPropertyKeyId
                                               FROM Nephthys_user_extPropertyKey")
                                    .execute()
                                    .getResult();
        
        var extPropertyKeys = [];
        for(var i = 1; i <= qGetKeyIds.getRecordCount(); ++i) {
            extPropertyKeys.append(new extPropertyKey(qGetKeyIds.extPropertyKeyId[i]));
        }
        
        return extPropertyKeys;
    }
}