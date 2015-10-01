
SFDCDialog = function(settings){ //simple modal wrapper to give us flexibility to throw a extjs panel into it.
	var mObj = {
		settings: null,
		modal : function (settings) {
			 if (typeof(settings) != 'undefined') {
			 	this.settings = settings;
			 }
			 if (typeof(this.settings.options) == 'undefined') {
			 	this.settings.options = {};
			 }
			 var modal = jQuery.modal('<div class="title"><div class="padded8 fullwidth">' + this.settings.title + '</div></div>' + this.settings.content, settings.options);
			 jQuery('input.modal-close-btn').live("click",function(e) {
			 	try {
			 		modal.o.onClose();
			 	}
			 	catch (ex) {
			 		jQuery.modal.close();
			 	}
			 });
			
		},
		constructor: function (settings) { this.settings = settings }
	}
	mObj.constructor(settings); //lets keep it oo and run a constructor.
	return mObj; //return the object we build.
}