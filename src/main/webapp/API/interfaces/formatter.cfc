interface {
    public formatter function init();
    public string function formatDate(required date date, required boolean formatTime = true, required string dateFormat, required string timeFormat);
}