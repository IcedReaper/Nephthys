interface {
    public connector function init();
    
    public string function getName();
    public string function render(required struct options, required string childContent);
}