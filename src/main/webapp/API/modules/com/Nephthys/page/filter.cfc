component {
    public filter function init() {
        return this;
    }
    
    public filter function setFor(required string for) {
        switch(arguments.for) {
            case "page":
            case "sitemap":
            case "hierarchy":
            case "hierarchyPage":
            case "pagesNotInHierarchy":
            case "region":
            case "pageVersion":
            case "status": {
                arguments.for = uCase(arguments.for.left(1)) & arguments.for.right(arguments.for.len() - 1);
                return createObject("component", "filter.filter" & arguments.for).init();
            }
        }
    }
}