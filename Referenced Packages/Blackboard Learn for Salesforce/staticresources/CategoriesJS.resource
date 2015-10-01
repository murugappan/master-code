Categories = function(){
	var cobj = {
	       records: null,
	       allrecords: null,
		   get: function() {
		   		var context = this;
		   	 	jQuery(this.callback).bind('dataready', function(e) { //binds callback to return data to object listening to this object.
		   	 		context.records = e.jsondata.records; //sets objects record key
		   	 		context.allrecords = context.records;
		   	 		context.records = context.getChildren(null);
		   	 		jQuery(context).trigger('dataready'); //lets listening objects know data is ready.
		   	 		delete context; //we dont the context need this anymore
		   	 	});
		   	   sforce.connection.query(
	          "Select Id, Name, " + prefix + "Visible__c, " + prefix + "Course_Category_Parent__c FROM " + CourseCategoryAPI + " WHERE " + prefix + "Visible__c = true",
	           this.callback); //Query the salesforce API for category data via SOQL.
		   },
		   getChildren: function (id) {
		   		id = (id == "null") ? null : id;
		   		var records = [];
		   		for (var i = 0; i < this.allrecords.length; i++) {
		   			if (this.allrecords[i][prefix + "Course_Category_Parent__c"] == id) {
		   				records.push(this.allrecords[i]);
		   			}
		   		}
		   		return records;
		   },
	       callback: { //Callback when response comes from salesforce API
	          responder: function(data, source) {  //Successful Response.
	          		var dataready = jQuery.Event("dataready");
	          		dataready.jsondata = {"records": data.getArray("records")};
	          		jQuery(this).trigger(dataready);
	          },
		   	  queryFailed: function(e) { 
		   	  //console.log(e) 
		   	  }, //Failed Response
	    
	          onSuccess: function(data, source) { this.responder(data,source) },
	          onFailure: function(e) { this.queryFailed(e) } ,
	          source: {}
		   },
		   constructor : function () { 
		   	//avoid ASYNC here.
		   }
	}
	cobj.constructor();
	return cobj;
}