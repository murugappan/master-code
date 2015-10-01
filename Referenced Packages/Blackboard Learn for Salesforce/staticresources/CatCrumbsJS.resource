CatCrumbs = function() {
var cobj = {
	crumbs: [{Name: "Catalog", Id: "null", finalCat: false}],
	addCrumb: function(crumb) {
		if (this.crumbs[(this.crumbs.length-1)].finalCat) {
			this.crumbs = this.crumbs.splice(0, (this.crumbs.length-1));
		}
		
		this.crumbs.push(crumb);
		this._rerender(); // I like the application to determine what to do for rendering so this will just dispatch an event
	},
	setCrumbId: function(id) {
		var index = -1;
		for (var i = 0; i < this.crumbs.length; i++) {
			if (this.crumbs[i].Id == id) {
				index = i;
				break;
			}
		}
		
		if (index >= 0) {
			tillEnd = this.crumbs.length - (index + 1);
			if (tillEnd > 0) {
				this.crumbs = this.crumbs.splice(0, index+1);
				this._rerender();
			}
		}
	},
	_rerender: function() {
		jQuery(this).trigger('rerender');
	},
	init: function(crumbs) {
		
		if (typeof(crumbs) != 'undefined') {
			
			this.crumbs = crumbs;
		}
		this._rerender();
	},
	constructor: function() { } //Just a stub;
}
cobj.constructor
return cobj;
}