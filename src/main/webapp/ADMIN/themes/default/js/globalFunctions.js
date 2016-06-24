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
}

structDeepCopy = function (struct) {
    return JSON.parse(JSON.stringify(struct));
};

structIsEmpty = function (struct) {
    return Object.keys(struct).length === 0 && struct.constructor === Object;
};