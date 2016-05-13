# QueryBuilder Idee:

Die Idee ist es eine Komponente / ein Satz an Komponenten zu installieren/implementieren, die einem Anhand von Parametern eine Query zusammenbauen und zur Verfügung stellen, ohne, dass man als Nutzer dieser auf die Datenbank speziell eingehen muss.
Die Query wird immer gleich aufgerufen. Die Subkomponenten bauen dann die Query im richtigen DB-Dialekt zusammen.
Jeder QueryBuilder wird die DB Eigenschaften selber handeln.


## QueryInitializer:
    public QueryInitializer init()
    public QueryInitializer setDatabase() // if not set will be read from an application variable | tobe defined how it's read | prob from json file | Postgres, Oracle, etc pp
    public QueryBuilder for(module ?, subModule?)
    public QueryInitializer setDatasource(datasource) // if not set will be read from an application variable | tobe defined how it's read | prob from json file

## QueryBuilder:
    public QueryBuilder init()
    
    public queryBuilder setResultType(required string resultType);
    public QueryBuilder setTable()
    
    public queryBuilder setColumns(required string columns);
    public QueryBuilder addColumns(columns)
    
    public QueryBuilder addCondition(column, name, value, type, conditionType = 'AND') // conditionType == AND | OR
    
    public QueryBuilder setConditions(conditionString)
    public QueryBuilder addParam(name, value, type)
    
    public QueryBuilder execute()
    public array getResult()
    
    
    public boolean isDatabaseSupported(dbType) // for install purposes


# Anwendungsbeispiel:
## Normaler Anwendungsfall
    var userList = new QueryInitializer()
                           .for("com.Nephthys.user")    // returns QueryBuilder
                               .setResultType("compact")
                               .setTable("user")
                               .addCondition("userName", "userName", "IcedReaper", "cf_sql_varchar")
                               .execute()
                               .getResult();

## Inner join Anwendungsfall
    var userList = new QueryInitializer()
                           .for("com.Nephthys.user")    // returns QueryBuilder
                               .setResultType("detailed")
                               .setTable("user, extProperties")
                               .addCondition("user.userName", "userName", "IcedReaper", "cf_sql_varchar")
                               .addCondition("extProperties.keyName", "keyName", "Email", "cf_sql_varchar")
                               .execute()
                               .getResult();

# Ordnerstruktur
    API
        interfaces
            QueryBuilder.cfc
        
        modules
            com
                IcedReaper
                    blog
                        QueryBuilder    - Implements API.interfaces.QueryBuilder
                    ...
                Nephthys
                    user
                        QueryBuilder    - Implements API.interfaces.QueryBuilder
                    ...
                ...
        
        tools
            com
                Nepthyhs
                    QueryBuilder
                        QueryInitializer.cfc

# Offene Fragen
    - CUD Queries
    - Innerer Aufbau