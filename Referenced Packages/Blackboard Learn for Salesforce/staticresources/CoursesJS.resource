Courses = function(){
	var cobj = {
	       records: null,
	       allrecords: null,
		   get: function(id) {
		   		if (typeof(id) == 'undefined') {
		   			id = null;
		   		}
		   		id = (id == 'null') ? null : id;
		   		
		   		var context = this;
		   	 	jQuery(this).bind('datadone', function(e) {
		   			
		   			context.allrecords = context.records;
		   			
		   			jQuery(context).trigger('dataready');
		   			
		   		});
		   	 	jQuery(this).bind('pdataready', function(e) { //binds callback to return data to object listening to this object.
		   	 		e.stopPropagation()
		   	 		
		   	 		if (context.records == null) {
		   	 			context.records = [];
		   	 		}
		   	 		
		   	 		var itrecs = (typeof(e.jsondata.records) == 'undefined') ? [] : e.jsondata.records; //sets objects record key
		   	 		
		   	 		for (var i = 0; i < itrecs.length; i++) {
		   	 			context.records.push(itrecs[i]);
		   	 			
		   	 			
		   	 		}
		   	 		
		   	 	
		   	 		
		   	 	});
		   	 	context.records = null;
		   	 	context.allrecords = null;
		   	 	if (id == null) {
		   	 		 /*
		   	 		 * BLS-518 -- only show courses that are categorized.  Do not display courses which have no category association.
		   	 		 * note this may result in duplicate values.  
		   	 		 * sforce.connection.query("Select Id, Name, " + prefix + "Start_Date__c, " + prefix + "Course_Title__c, " + prefix + "Description__c, " + prefix + "Visible__c, " + prefix + "Date_Range__c, " + prefix + "Instructor__c FROM " + CourseAPI + " WHERE " + prefix + "Visible__c = true", this.callback);
		   	 		 */
		   	 		 sforce.connection.query("Select Id, " + prefix + "Course__r." + prefix + "Start_Date__c, " + prefix + "Course__r.Id, " + prefix + "Course__r." + prefix + "Visible__c, " + prefix + "Course__r.Name, " + prefix + "Course__r." + prefix + "Course_Title__c, " + prefix + "Course__r." + prefix + "Description__c, " + prefix + "Course__r." + prefix + "Date_Range__c, " + prefix + "Course__r." + prefix + "Instructor__c FROM " + CourseCategoryMembershipAPI + " WHERE " + prefix + "Course__r." + prefix + "Visible__c = true", this.callback);

		   	 	}
		   	 	else {
		   	 		sforce.connection.query("Select Id, " + prefix + "Course__r." + prefix + "Start_Date__c, " + prefix + "Course__r.Id, " + prefix + "Course__r." + prefix + "Visible__c, " + prefix + "Course__r.Name, " + prefix + "Course__r." + prefix + "Course_Title__c, " + prefix + "Course__r." + prefix + "Description__c, " + prefix + "Course__r." + prefix + "Date_Range__c, " + prefix + "Course__r." + prefix + "Instructor__c FROM " + CourseCategoryMembershipAPI + " WHERE " + prefix + "Course__r." + prefix + "Visible__c = true AND " + prefix + "Course_Category__c = '" + escape(id) + "'", this.callback);
		   	 	}
		   },
	      callback: { //Callback when response comes from salesforce API
	          responder: function(data, source) {  //Successful Response.
					
	          		var dataready = jQuery.Event("pdataready");
	          		
	          		dataready.jsondata = {"records": data.getArray("records")};
	          		
	          		jQuery(this.context).trigger(dataready);
	          },
		   	  queryFailed: function(e) { //console.log(e) 
		   	  }, //Failed Response
	          onSuccess: function(data, source) { 
	          	
	          	this.responder(data,source)
	        
	      		if (data.queryLocator) { 
	      			cbObj = {context: this.context, responder: this.responder, onSuccess : this.onSuccess, queryFailed: this.queryFailed, onFailure : this.onFailure}
	      			
	      			sforce.connection.queryMore(data.queryLocator, cbObj);
					
				}
				else {
					jQuery(this.context).trigger('datadone');
				}
	          },
	          onFailure: function(e) { this.queryFailed(e) },
	          source: {}
		   },
		   constructor : function () { 
		   	//avoid ASYNC here.
		   	this.callback.context = this;
		   }
	}
	cobj.constructor();
	return cobj;
}