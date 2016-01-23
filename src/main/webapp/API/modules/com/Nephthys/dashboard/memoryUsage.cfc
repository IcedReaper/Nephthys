component {
    public memoryUsage function init() {
        var qHeapMemory = getMemoryUsage('heap');
        variables.totalHeapMemory = 0;
        variables.totalUsedMemory = 0;
        for(var i = 1; i <= qHeapMemory.getRecordCount(); i++) {
            variables.totalHeapMemory += qHeapMemory.max[i];
            variables.totalUsedMemory += qHeapMemory.used[i];
        }
        
        return this;
    }
    
    public numeric function getTotal(required string unit = "MB") {
        return calculate(variables.totalHeapMemory, arguments.unit);
    }
    
    public numeric function getUsed(required string unit = "MB") {
        return calculate(variables.totalUsedMemory, arguments.unit);
    }
    
    public numeric function getUsedPercentage() {
        return ceiling((variables.totalUsedMemory / variables.totalHeapMemory) * 100);
    }
    
    private numeric function calculate(required numeric bytes, required string unit) {
        var calculatedValue = arguments.bytes;
        
        switch(lcase(arguments.unit)) { // the breaks are missing on purpose
            case 'GB': {
                calculatedValue = calculatedValue / 1024;
            }
            case 'MB': {
                calculatedValue = calculatedValue / 1024;
            }
            case 'KB': {
                calculatedValue = calculatedValue / 1024;
            }
        }
        
        return ceiling(calculatedValue);
    }
}