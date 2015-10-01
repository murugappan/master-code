Enrollments = function(){
	var cobj = {
	       records: null,
	       allrecords: null,
		   get: function(courseIds) {
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
		   	 	
		   	   if (courseIds.length > 0) {
		   	   	
		   	   	   var inClause = '(' + courseIds.join(',') + ')';
		   	   
			   	   sforce.connection.query(
		          "Select " + prefix + "Status__c, " + prefix + "Person__c, " + prefix + "Display__c, " + prefix + "Course_ID__c From " + EnrollmentsAPI + " WHERE " + prefix + "Course_ID__c IN " + inClause,
		           this.callback); //Query the salesforce API for category data via SOQL.
	           }
		   },
		   findEnrollmentsByUserId: function(uid) {
		   		
		   		var enrollments = [];
		   		if (this.records.length > 0) {
			   		for(var i = 0; i < this.records.length; i++) {
			   			if (this.records[i][prefix + "Person__c"].indexOf(uid) > -1) {
			   				enrollments.push(this.records[i]);
			   			}
			   		}
		   		}
		   		return enrollments;
		   },
	       callback: { //Callback when response comes from salesforce API
	          responder: function(data, source) {  //Successful Response.
	          		var dataready = jQuery.Event("pdataready");
	          		dataready.jsondata = {"records": data.getArray("records")};
	          		jQuery(this.context).trigger(dataready);
	          },
		   	  queryFailed: function(e) { //console.log(e) 
		   	  },
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