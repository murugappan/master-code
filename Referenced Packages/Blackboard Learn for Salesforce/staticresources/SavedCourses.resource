SavedCourses = function(){
	var cobj = {
	       records: null,
	       allrecords: null,
		   get: function(userId) {
		   		var context = this;
		   	 	jQuery(this.callback).bind('dataready', function(e) { //binds callback to return data to object listening to this object.
		   	 		context.records = (typeof(e.jsondata.records) == 'undefined') ? [] : e.jsondata.records; //sets objects record key
		   	 		context.allrecords = context.records;
		   	 		jQuery(context).trigger('dataready'); //lets listening objects know data is ready.
		   	 		delete context; //we dont the context need this anymore
		   	 	});
		   	   sforce.connection.query(
	          "Select Id, Name, " + prefix + "User__c, " + prefix + "Course__c, " + prefix + "Course__r.Id, " + prefix + "Course__r.Name, " + prefix + "Course__r." + prefix + "Course_Title__c FROM " + SavedCourseAPI + " WHERE " + prefix + "User__c = '" + escape(userId) + "'",
	           this.callback); //Query the salesforce API for category data via SOQL.
		   },
		   get_by_id: function(courseId) {
		   		var context = this;
		   	 	jQuery(this.callback).bind('dataready', function(e) { //binds callback to return data to object listening to this object.
		   	 		
		   	 		context.records = (typeof(e.jsondata.records) == 'undefined') ? [] : e.jsondata.records; //sets objects record key
		   	 		context.allrecords = context.records;
		   	 		
		   	 		jQuery(context).trigger('dataready'); //lets listening objects know data is ready.
		   	 		delete context; //we dont the context need this anymore
		   	 	});
		   	   sforce.connection.query(
	          "Select Id, Name, " + prefix + "Course_Title__c FROM " + CourseAPI + " WHERE Id = '" + courseId + "'",
	           this.callback); //Query the salesforce API for category data via SOQL.
		   },
	       callback: { //Callback when response comes from salesforce API
	          responder: function(data, source) {  //Successful Response.
	          		var dataready = jQuery.Event("dataready");
	          		
	          		dataready.jsondata = {"records": data.getArray("records")};
	          		jQuery(this).trigger(dataready);
	          },
		   	  queryFailed: function(e) { //console.log(e) 
		   	  }, //Failed Response
	          onSuccess: function(data, source) { this.responder(data,source) },
	          onFailure: function(e) { this.queryFailed(e) },
	          source: {}
		   },
		   constructor : function () { 
		   	//avoid ASYNC here.
		   }
	}
	cobj.constructor();
	return cobj;
}