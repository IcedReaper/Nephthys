component {
    public formatter function init() {
        return this;
    }
    
    public string function formatDate(required date _date, required boolean formatTime = true) {
        if(arguments._date != 0) {
            return dateFormat(arguments._date, "DD.MMM YYYY") & ((arguments.formatTime) ? (" " & timeFormat(arguments._date, "HH:MM:SS")) : "");
        }
        else {
            return "";
        }
    }
}