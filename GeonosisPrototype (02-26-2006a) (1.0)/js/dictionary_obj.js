/*
 dictionary_obj.js -- DictonaryObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

DictonaryObj = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
	this.keys = [];
	this.cache = [];
};

DictonaryObj.instances = [];

DictonaryObj.getInstance = function(aSpec) {
	var i = -1;
	var ar = [];
	var ar2 = [];
	// the object.id is the position within the array that holds onto the objects...
	// aSpec is a key=value, list from which the dictionary can be created with contents...
	var instance = DictonaryObj.instances[DictonaryObj.instances.length];
	if(instance == null) {
		instance = DictonaryObj.instances[DictonaryObj.instances.length] = new DictonaryObj(DictonaryObj.instances.length);
	}
	if (aSpec != null) {
		ar = aSpec.split(',');
		for (i = 0; i < ar.length; i++) {
			ar2 = ar[i].split('=');
			if (ar2.length == 2) {
				instance.push(ar2[0], ar2[1]);
			}
		}
	}
	return instance;
};

DictonaryObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < DictonaryObj.instances.length) ) {
		var instance = DictonaryObj.instances[id];
		if (instance != null) {
			DictonaryObj.instances[id] = object_destructor(instance);
			ret_val = (DictonaryObj.instances[id] == null);
		}
	}
	return ret_val;
};

DictonaryObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < DictonaryObj.instances.length; i++) {
		DictonaryObj.removeInstance(i);
	}
	return ret_val;
};

DictonaryObj.prototype = {
	id : -1,
	keys : [],
	cache : [],
	toString : function() {
		var aKey = -1;
		var s = '(';
		s += '\n';
		for (var i = 0; i < this.keys.length; i++) {
			aKey = this.keys[i];
			s += aKey + ' = [' + this.getValueFor(aKey) + ']' + '\n';
		}
		s += ')';
		return s;
	},
	push : function(key, value) {
		var _f = -1;
		var _key = key.trim().toUpperCase();
		for (var i = 0; i < this.keys.length; i++) {
			if (this.keys[i].trim().toUpperCase() == _key) {
				_f = i;
				break;
			}
		}
		if (_f == -1) {
			this.keys.push(key);
			this.cache[key] = value;
			return true;
		} else { // key already has a value so make the value into a DictionaryObj so it can store many values, if necessary...
			if (typeof this.cache[key] != const_object_symbol) {
				var a = [];
				a.push(this.cache[key]);
				this.cache[key] = a;
			}
			this.cache[key].push(value);
		}
		return false;
	},
	put : function(key, value) {
		if (this.cache[key] != null) {
			this.cache[key] = value;
		}
	},
	getValueFor : function(key) {
		return (this.cache[key]);
	},
	getKeys : function() {
		return (this.keys);
	},
	getKeysMatching : function(f) { // f(val) returns true or false to determine if the value matches a known pattern that is governed by the function f...
		var k = this.keys;
		if (typeof f == const_function_symbol) {
			k = [];
			for (var i = 0; i < this.keys.length; i++) {
				if (f(this.keys[i])) {
					k.push(this.keys[i]);
				}
			}
		}
		return (k); // this returns either all the keys or only those that match the function f()...
	},
	length : function() {
		return (this.keys.length);
	},
	destructor : function() {
		return (this.id = DictonaryObj.instances[this.id] = this.keys = this.cache = null);
	},
	dummy : function() {
		return false;
	}
};
