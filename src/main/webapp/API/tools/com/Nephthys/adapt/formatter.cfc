component interface="API.interfaces.formatter" {
    public formatter function init() {
        return this;
    }
    
    public string function formatDate(required date date,
                                      required boolean formatTime = true,
                                      required string dateFormat = "DD. MMM YYYY",
                                      required string timeFormat = "HH:MM:SS",
                                      required string locale = 'de-DE') {
        if(arguments.date != 0) {
            return lsDateFormat(arguments.date, arguments.dateFormat, arguments.locale) & ((arguments.formatTime) ? (" " & timeFormat(arguments.date, arguments.timeFormat)) : "");
        }
        else {
            return "";
        }
    }
}