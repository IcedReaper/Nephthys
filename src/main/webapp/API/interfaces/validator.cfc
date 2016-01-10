interface {
    public validator function init();
    public validator function load();
    public boolean function validate(required string data, required string ruleName, string country = "", string language = "", string locale = "", boolean mandatory = true);
}