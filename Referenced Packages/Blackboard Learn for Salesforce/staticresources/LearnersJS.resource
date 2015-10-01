/*
  LearnersJS 
  Load a list of learners from the system.  See also the LearnerModelJS and the enrollsaved page.
*/


Learners = function(){ //Salesforce Ajax toolkit wrapper that makes the code a bit more self contained.
//	var learnerQueryWithChatter = "Select Id, Name, FirstName, LastName, Title, SmallPhotoUrl, Profile.UserLicenseId FROM User WHERE UserType = 'Standard' AND isActive = true"
//	var learnerQueryWithoutChatter = "Select Id, Name, FirstName, LastName, Title, Profile.UserLicenseId FROM User WHERE UserType = 'Standard' AND isActive = true";
	var learnerQueryWithChatter = "Select Id, Name, FirstName, LastName, Title, SmallPhotoUrl FROM User WHERE isActive = true"
	var learnerQueryWithoutChatter = "Select Id, Name, FirstName, LastName, Title FROM User WHERE isActive = true";

	var learnerQuery = learnerQueryWithChatter;
	
	var cobj = {
	       records: null,
	       allrecords: null,
	       licenserecords: null,
	       getLicense: function(licenseId) {
	        
	       	for (var i = 0; i < this.licenserecords.length; i++) {
	       		if (this.licenserecords[i].Id == licenseId) {
	       			return this.licenserecords[i].Name;
	       			break;
	       		}
	       	}
	       	return 'Unknown';
	       },
		   get: function() {
		   		var context = this;
		   		jQuery(this).bind('datadone', function(e) {
		   			
		   			context.allrecords = context.records;
		   			jQuery(context).trigger('dataready');
		   			
		   		});
				jQuery(this).bind("failedUserList", function(e) {
					 context.callback.queryFailed = function(e) { 
					 	//so attempt to load 
					 	alert("Unable to load user list");
					 	//console.log(e);
					 }
					 //the user list failed, try to get the user list wihtout chatter instead
					 //update context.callback.queryFailed above to panic out if it totally fails
					 sforce.connection.query(
	          			learnerQueryWithoutChatter,
	           			context.callback
	           		 ); //Query the salesforce API for learner data via SOQL.
				}); //end failedUserList
		   	 	jQuery(this).bind('pdataready', function(e) { //binds callback to return data to object listening to this object.
		   	 		e.stopPropagation();
		   	 		if (context.records == null) {
		   	 			context.records = [];
		   	 		}
		   	 		var itrecs = (typeof(e.jsondata.records) == 'undefined') ? [] : e.jsondata.records; //sets objects record key
		   	 		
		   	 		for (var i = 0; i < itrecs.length; i++) {	
		   	 			//itrecs[i].LicenseName = context.getLicense(itrecs[i].Profile.UserLicenseId);
		   	 			context.records.push(itrecs[i]);
		   	 		}
		   	 	}); //end pdataready event
		   	  	var contextObj = this;
		   		context.callback.queryFailed =  function(e) {
		   			 //loading the records failed, so trigger the event.
					var failedEvent = jQuery.Event("failedUserList");
					jQuery(contextObj).trigger(failedEvent);
		   		}
		   		sforce.connection.query(
	          		learnerQueryWithChatter,
	           		context.callback
	           	); //Query the salesforce API for learner data via SOQL.
	       },
		   findById: function(id) {
		   		//get a record from the list of records using an id.
				for (var i = 0; i < this.records.length; i++) {
					record = this.records[i];
					record = (typeof(record.data) == 'undefined') ? record : record.data;
		   			if (record.Id.indexOf(id) > -1) {
		   				return record;
		   				break;
		   			}
		   			
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
	      			cbObj = {context: this.context, responder: this.responder, queryFailed: this.queryFailed, onSuccess : this.onSuccess, onFailure : this.onFailure}
	      			sforce.connection.queryMore(data.queryLocator, cbObj);
					
				}
				else {
					jQuery(this.context).trigger('datadone');
				}
	          },
	          onFailure: function(e) { this.queryFailed(e) },
	          onError: function(e) { this.queryFailed(e) },
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