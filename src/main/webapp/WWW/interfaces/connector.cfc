interface {
    public connector function init();
    
    public string function getName();
    public string function render(required struct options, required boolean rootElement, required string childContent);
}