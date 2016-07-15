Array.prototype.move = function (old_index, new_index) {
    if (new_index >= this.length) {
        var k = new_index - this.length;
        while ((k--) + 1) {
            this.push(undefined);
        }
    }
    this.splice(new_index, 0, this.splice(old_index, 1)[0]);
    return this;
};
Array.prototype.sum = function (prop) {
    var total = 0;
    for(var i = 0, _len = this.length; i < _len; i++) {
        total += this[i][prop];
    }
    return total;
};
Array.prototype.sumOfSubArrayLength = function (prop) {
    var total = 0;
    for(var i = 0, _len = this.length; i < _len; i++) {
        total += this[i][prop].length;
    }
    return total;
};
Number.prototype.formatAsTimeSince = function () {
    var sec_num = parseInt(this, 10); // don't forget the second param
    
    var days    = Math.floor(sec_num / (24 * 3600));
    sec_num -= days * (24 * 3600);
    
    var hours   = Math.floor(sec_num / 3600);
    sec_num -= hours * 3600;
    
    var minutes = Math.floor(sec_num / 60);
    var seconds = sec_num - minutes * 60;
    
    var result = "";
    if(days > 0) {
        result += days + 'D ';
    }
  
    if(hours > 0 || result != "") {
        if(hours < 10) {hours   = "0"+hours;}
    
        result += hours+'h ';
    }
    if(minutes > 0 || result != "") {
        if (minutes < 10) {minutes   = "0"+minutes;}
    
        result += minutes+'m ';
    }
    if(seconds > 0 || result != "") {
        if (seconds < 10) {seconds   = "0"+seconds;}
    
        result += seconds+'s ';
    }
  
    return result;
};
Date.prototype.toAjaxFormat = function () {
    if(! isNaN(this.getFullYear())) {
        return this.getFullYear() + '/' + (this.getMonth() + 1) + '/' + this.getDate();
    }
    else {
        return "";
    }
};
Date.prototype.toUrlFormat = function () {
    if(! isNaN(this.getFullYear())) {
        return this.getFullYear() + '' + (this.getMonth() + 1 > 10 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1)) + '' + (this.getDate() >= 10 ? this.getDate() : '0' + this.getDate());
    }
    else {
        return "";
    }
};

String.prototype.urlFormatToDate = function () {
    if(this.length === 8) {
        var year = parseInt(this.substr(0, 4), 10);
        var month = parseInt(this.substr(4, 2), 10) - 1;
        var day = parseInt(this.substr(6, 2), 10);
        
        return new Date(year, month, day);
    }
    return null;
}

structDeepCopy = function (struct) {
    return JSON.parse(JSON.stringify(struct));
};

structIsEmpty = function (struct) {
    return Object.keys(struct).length === 0 && struct.constructor === Object;
};