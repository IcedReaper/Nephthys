interface {
    public templateRenderer function init();
    
    public templateRenderer function setThemeFolderName(required string themeFolderName);
    public templateRenderer function setModulePath(required string modulePath);
    public templateRenderer function addParam(required string name, required any data);
    public templateRenderer function setTemplate(required string template);
    public string function render();
}