interface {
    public connector function init();
    
    public string function getName();
    public boolean function checkPermission(required user user);
    public void function render();
}