component {
    public filter function init() {
        return this;
    }
    
    public filter function for(required string for) {
        switch(arguments.for) {
            case "theme": {
                arguments.for = uCase(arguments.for.left(1)) & arguments.for.right(arguments.for.len() - 1);
                return createObject("component", "filter.filter" & arguments.for).init();
            }
        }
        
        throw(type = "nephthys.notFound.general", message = "Could not find the required filter");
    }
}