# QueryBuilder Idee:

Die Idee ist es eine Komponente / ein Satz an Komponenten zu installieren/implementieren, die einem Anhand von Parametern eine Query zusammenbauen und zur Verfügung stellen, ohne, dass man als Nutzer dieser auf die Datenbank speziell eingehen muss.
Die Query wird immer gleich aufgerufen. Die Subkomponenten bauen dann die Query im richtigen DB-Dialekt zusammen.

## QueryInitializer:
    public QueryInitializer init()
    public QueryBuilder setDatabase() // if not set will be read from an application variable | tobe defined how it's read | prob from json file | Postgres, Oracle, etc pp
    public QueryBuilder for(module ?, subModule?)
    public QueryInitializer setDatasource(datasource) // if not set will be read from an application variable | tobe defined how it's read | prob from json file

## QueryBuilder:
    public QueryBuilder init()
    
    public QueryBuilder setTable()
    
    public QueryBuilder addColumns(columns)
    
    public QueryBuilder addCondition(column, name, value, type, conditionType = 'AND') // conditionType == AND | OR
    
    public QueryBuilder setConditions(conditionString)
    public QueryBuilder addParam(name, value, type)
    
    public QueryBuilder execute()
    public queryResult getResult()


# Anwendungsbeispiel:
## Normaler Anwendungsfall
    var userList = new QueryInitializer()
                           .for("com.Nephthys.user")
                               .setTable("user")
                               .addColumn("userId, userName")
                               .addCondition("userName", "userName", "IcedReaper", "cf_sql_varchar")
                               .execute()
                               .getResult();

## Inner join Anwendungsfall
    var userList = new QueryInitializer()
                           .for("com.Nephthys.user")
                               .setTable("user, extProperties")
                               .addColumn("user.userId, user.userName, extProperties.value")
                               .addCondition("user.userName", "userName", "IcedReaper", "cf_sql_varchar")
                               .addCondition("extProperties.keyName", "keyName", "Email", "cf_sql_varchar")
                               .execute()
                               .getResult();

# Ordnerstruktur
    API
        interfaces
            QueryBuilder.cfc
        
        QueryBuilder
            QueryInitializer.cfc
            
            Postgres9               (Databasetype)
                com
                    IcedReaper
                        blog    - Implements API.interfaces.QueryBuilder
                    Nephthys
                        user    - Implements API.interfaces.QueryBuilder
                        ...
            Oracle 11g              (Databasetype)
                com
                    IcedReaper
                        blog    - Implements API.interfaces.QueryBuilder
                    Nephthys
                        user    - Implements API.interfaces.QueryBuilder
                        ...

# Offene Fragen
    * INNER JOINS
    *