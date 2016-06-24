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

structDeepCopy = function (struct) {
    return JSON.parse(JSON.stringify(struct));
};

structIsEmpty = function (struct) {
    return Object.keys(struct).length === 0 && struct.constructor === Object;
};