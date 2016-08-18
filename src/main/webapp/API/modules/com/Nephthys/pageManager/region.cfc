component {
    public region function init(required numeric regionId) {
        variables.regionId = arguments.regionId;
        
        variables.attributesChanged = false;
        
        load();
        
        return this;
    }
    
    public region function setName(required string name) {
        variables.name = arguments.name;
        variables.attributesChanged = true;
        return this;
    }
    
    public region function setDescription(required string description) {
        variables.description = arguments.description;
        variables.attributesChanged = true;
        return this;
    }
    
    
    public numeric function getRegionId() {
        return variables.regionId;
    }
    
    public string function getName() {
        return variables.name;
    }
    
    public string function getDescription() {
        return variables.description;
    }
    
    
    public region function save(required user user) {
        var qSave = new Query().addParam(name = "name",        value = variables.name,        cfsqltype = "cf_sql_varchar")
                               .addParam(name = "description", value = variables.description, cfsqltype = "cf_sql_varchar");
        if(variables.regionId == null) {
            variables.regionId = qSave.setSQL("INSERT INTO nephthys_page_region
                                                           (
                                                               name,
                                                               description
                                                           )
                                                    VALUES (
                                                               :name,
                                                               :description
                                                           );
                                               SELECT currval('nephthys_page_region_regionId_seq') newRegionId;")
                                      .execute()
                                      .getResult()
                                      .newRegionId[1];
        }
        else{
            qSave.setSQL("UPDATE nephthys_page_region
                             SET name = :name,
                                 description = :description
                           WHERE regionId = :regionId")
                 .addParam(name = "regionId", value = variables.regionId, cfsqltype = "cf_sql_numeric")
                 .execute();
        }
        
        return this;
    }
    
    private void function load() {
        if(variables.regionId != null) {
            var qRegion = new Query().setSQL("SELECT *
                                                FROM nephthys_page_region
                                               WHERE regionId = :regionId")
                                     .addParam(name = "regionId", value = variables.regionId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
            
            if(qRegion.getRecordCount() == 1) {
                variables.name        = qRegion.name[1];
                variables.description = qRegion.description[1];
            }
            else {
                throw(type = "nephthys.notFound.page", message = "Could not find the region");
            }
        }
        else {
            variables.name = "";
            variables.description = "";
        }
    }
}