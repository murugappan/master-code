 	//Page globals for panels and stores.

    var SavedCoursesPanel;
    var SelectedLearners;
    var SelectedLearnersPanel;
    var SavedCoursesStore;
    var LearnerListPanel;
    var uLearners;
    var sCourses;
    var reloadSavedCourses;
    var sEnrollments;
    var SelectedLearnersStore;
    var recalcEnrollments;
    var refreshSelected;
    var amichecked = true;
    var hasLearners = true;
    var hasCourses = true;
        
    var refreshSelected = function() { //command to dispatch an event to refresh the the Learners store, which in turn will refresh the panel. This happens on modal close.
    	SelectedLearnersStore.fireEvent('refreshView', SelectedLearnersStore);
    }
    
    var updateShowEnroll = function(hl, hc) {
    	if (hl && hc) {
    		jQuery("#enrollAll").show();
    	}
    	else {
    		jQuery("#enrollAll").hide();
    	}
    }
    
    var enrollSelected = function() { //serializes the list of enrolled learners and passes it to apex (Salesforce), the controller class for the page does the heavy lifting of actually inserting records via a ActionFunction defined in the page.
    	//build list of ids to enroll into saved courses
    	LearnerIds = [];
    	for (var i = 0; i < SelectedLearnersStore.data.items.length; i++) {
    		var tid = SelectedLearnersStore.data.items[i].data.Id;
    		if (tid != __sfdcUserId) {
    			LearnerIds.push(tid);
    		}
    		else {
    			if (jQuery('#enrollMe').attr('checked') == 'checked') {
    				LearnerIds.push(tid);
    			}
    		}
    	}
    	var serialLearners = '';
    	serialLearners = LearnerIds.join(',');
    	enrollLearners(serialLearners);
    }
    
    
    var addLearner = function() { //Pops the add learners dialog.
    
    	var addModal = new SFDCDialog();
    	
    	
    	addModal.modal({
    		title: "Add Learners", 
    		content: '<div id="dialog-LearnerList"></div>', //defines a place holder we will render our custom panel control to.
    		options: {
    			onClose: function (dialog) { //runs when we close the dialog to refresh the selected learners panel.
    				refreshSelected();
    				LearnerListPanel.searchField.setValue('');
    				Ext.get(LearnerListPanel.gridPanel.getEl()).removeAllListeners();
    				jQuery.modal.close();
    				
    			}
    		}
    	});
    	
    	LearnerListPanel = new Ext.ux.SFDCUserPickerPanel({ //Creates our custom picker panel, passing in data from the page such as existing enrollments, already selected users and a list of all Learners (Users)
    		baseCls: 'bb-sidebar',
    		bodyBorder: false,
    		enrollments: sEnrollments,
    		selectedList: SelectedLearnersStore,
    		learners: uLearners,
    		ds: Ext.create('Ext.data.JsonStore', {
    			model: 'Learner',
    			pageSize: 9
    			}),
    		renderTo: 'dialog-LearnerList' //renders the dialog to the place holder we made in our modal.
    	});
    	//trim records to not include self
    	
    	var learnRecords = [];
    	
    	for (var i = 0; i < uLearners.records.length; i++) { //makes sure we dont add ourselves to the modal.
    		if (uLearners.records[i].Id != __sfdcUserId) {
    			learnRecords.push(uLearners.records[i]);
    		}
    	}
    	LearnerListPanel.getStore().sort('LastName', 'ASC');
    	LearnerListPanel.getStore().loadData(learnRecords, false); //loads the learners into the Panel's store.
    	
    }
    
    
    
    var recalcEnrollments = function() { //grabs a fresh list of enrollments mainly if we delete a Saved Course.
    	 	
     	var courseIds = [];
     	
     	for (var i = 0; i < SavedCoursesStore.data.items.length; i++) {
     		var cid = "'" + SavedCoursesStore.data.items[i].data[prefix + "Course__r"].Id.substr(0, 15) + "'";
     		courseIds.push(cid);
     	}
     	
     	sEnrollments.get(courseIds);
    
    }
    
    
    
    Ext.onReady(function(){ //Bootstraps the page when it's done loading all the assets.
    	
    	SavedCoursesStore = Ext.create('Ext.data.JsonStore', { //defines a store for Saved Coursed.
    		fields: ['Id', 'Name', prefix + 'Course__r', prefix + 'Course__c']
    	});
    	
    	SelectedLearnersStore = Ext.create('Ext.data.JsonStore', { //defines a store for Leaners (Users).
    		model: 'Learner'
    	});
    	
    	SelectedLearnersStore.addListener('refreshView', function(st) { //binds the refreshView event to the store so we can update the panel when the event is fired.
    		SelectedLearnersPanel.update(SelectedLearnersStore.data.items, false);
    		var count = 0;
    		for(var i = 0; i < SelectedLearnersStore.data.items.length; i++) {
    			if (SelectedLearnersStore.data.items[i].data.Id != __sfdcUserId) {
    				count++;
    			}
    		}
    		if (jQuery('#enrollMe').attr('checked') == 'checked') {
    			count++;
    		}
    		if (count > 0) {
    			hasLearners = true;
    		}
    		else {
    			hasLearners = false;
    		}
    		
    		updateShowEnroll(hasLearners, hasCourses);
    		
    	});
    	
    	
    	
    	SavedCoursesStore.addListener('datachanged', function(st) { //Called on load and after a delete to update the Saved Courses panel and to calculate what enrollments are relevant.
    		SavedCoursesPanel.update(SavedCoursesStore.data.items, false);
    		if (SavedCoursesStore.data.items.length > 0) {
    			hasCourses = true;
    		}
    		else {
    			hasCourses = false;
    		}
    		updateShowEnroll(hasLearners, hasCourses);
    		recalcEnrollments();
    	});
    	
    	
    	jQuery("#enrollMe").live("click", function(e) {
    		if (jQuery(e.currentTarget).attr('checked') == 'checked') {
    			amichecked = true;
    		}
    		else {
    			amichecked = false;
    		}
    		var count = 0;
    		for(var i = 0; i < SelectedLearnersStore.data.items.length; i++) {
    			if (SelectedLearnersStore.data.items[i].data.Id != __sfdcUserId) {
    				count++;
    			}
    		}
    		if (jQuery('#enrollMe').attr('checked') == 'checked') {
    			count++;
    		}
    		if (count > 0) {
    			hasLearners = true;
    		}
    		else {
    			hasLearners = false;
    		}
    		updateShowEnroll(hasLearners, hasCourses);
    		
    		
    	});
    	
    	
    	SavedCoursesPanel = Ext.create('Ext.panel.Panel', { //Creates the panel to display Saved Courses.
    		baseCls: 'bb-sidebar',
    		bodyBorder: false,
    		html: '',
    		tpl: new Ext.XTemplate(
    		'<tpl for=".">',
    				'<tpl for="data">',
		    			'<tpl for="' + prefix + 'Course__r">',
		    				'<div class="paddedOut5"><div class="savedCourseLine fullWidth {[(xindex == 1) ? "" : "topLine"]} ">',
		    				'<div class="savedCourseSide paddedTop10">',
		    				'<tpl if="!this.isReal(values.realCourse)">',
		    				'<a href="#" id="{Id}" class="deleteSavedCourse"><div class="deleteIcon toTheLeft width10">&nbsp;</div></a>',
		    				'</tpl>',
		    				'<tpl if="this.isReal(values.realCourse)">',
		    				'<div class="toTheLeft width10">&nbsp;</div>',
		    				'</tpl>',
		    				'<div class="toTheLeft width85"><div class="savedCourseTitle toTheLeft paddedOut0 fullWidth">{[values[prefix + "Course_Title__c"]]}</div><div class="savedCourseName toTheLeft paddedOut0 fullWidth">{Name}</div><div class="clearingBoxSF"></div></div></div>',
		    				'<div class="clearingBox"></div></div><div class="clearingBox"></div></div>',
		    				'</div>',
		    			'</tpl>',
	    			'</tpl>',
    		'</tpl>',
    		'<div class="clearingBoxSF"></div>',
    		{
    			isReal: function(val) { //real means is it a course proxied through the Saved_Course object or is it a implicitally called enrollment via the ID parameter, this happens when you click Enroll me now from the catalog.
    				return val;
    			}
    		}),
    		listeners: {
    			"render": function() { //Bind the remove buttons once the component has rendered.
					Ext.get(this.getEl()).on('click', function(e, b) { //we listen for the event on the entire panel, and filter with the delegate on the end. This allows us to catch events for matching items even if they arent rendered yet.
						e.preventDefault();
						
						SavedCoursesStore.remove(SavedCoursesStore.findRecord(prefix + 'Course__c', Ext.get(b).id)); //removes the record from the store.
				    	SavedCoursesStore.fireEvent('datachanged', SavedCoursesStore); //alert the store we changed something.
				    	deleteSavedCourse(Ext.get(b).id); //tell salesforce to delete the saved course record.
					}, null, {delegate: 'a.deleteSavedCourse'});
				}
    		},
    		renderTo: "savedDD" //tells the panel what div id to render to.
    	});
    	
    	
    SelectedLearnersPanel = Ext.create('Ext.panel.Panel', { //Creates a panel to render the names of people who have been selected to be enrolled in the course.
    		baseCls: 'bb-sidebar',
    		bodyBorder: false,
    		html: '',
    		tpl: new Ext.XTemplate(
    		'<tpl for=".">',
    			'<tpl for="data">',
	    				'<div class="row">',
	    				
	    				'<tpl if="this.isMe(values.Id)">',
	    					'<tpl if="!this.amEnrolled()">',
		    					'<tpl if="this.amChecked()">',
		    						'<div class="col toggle"><input id="enrollMe" type="checkbox" checked="checked" /></div>',
		    					'</tpl>',
		    					'<tpl if="!this.amChecked()">',
		    						'<div class="col toggle"><input id="enrollMe" type="checkbox" /></div>',
		    					'</tpl>',
		    				'</tpl>',
		    				'<tpl if="this.amEnrolled()">',
		    					'<div class="col toggle keySF"></div>',
		    				'</tpl>',
	    				'</tpl>',
	    				'<tpl if="!this.isMe(values.Id)">',
	    					'<div class="col toggle"><a id="{Id}" href="#" class="deleteLearner"><div class="deleteIcon">&nbsp;</div></a></div>',
	    				'</tpl>',
	    				'<div class="col image"><div class="media removeRightPad">',
	    				'<tpl if="values.SmallPhotoUrl">',
	    				'<a href="" class="img icon"><img src="{SmallPhotoUrl}" alt="" height="32" width="32"/></a>',
	    				'</tpl>',
	    				'<div class="bd"><p class="ptn">{Name} <span class="title detail">{Title}</span></div></div></div>',
	    				'<tpl if="this.isMe(values.Id)">',
	    					'<tpl if="!this.amEnrolled()">',
	    						'<div class="col info"><div class="paddedOut10">You have been automatically added as a Learner. Deselect the checkbox to the left if you do not want to be included in this enrollment.</div></div>',
	    					'</tpl>',
	    					'<tpl if="this.amEnrolled()">',
	    							'<div class="col info"><div class="paddedOut10">You have already enrolled in all the courses selected and therefore are not elligible for enrollment. However you may enroll other learners.</div></div>',
	    					'</tpl>',
	    				'</tpl>',
	    				'<div class="lineRule toTheLeft">&nbsp;</div>',
	    				'</div><div class="clearingBox"></div>',
	    				'</div>',
	    		'</tpl>', 
    		'</tpl>',
    		'<div class="row last paddedOut10"><input type="button" class="btn btnPadded" value="Add Other Learners" onClick="addLearner()" /></div>',
    		'<div class="clearingBoxSF"></div>',
    		{
    			isMe: function(val) {
    			
    				return (val == __sfdcUserId); //figure out if im interating me and then let the template know.
    			},
    			amChecked: function() {
    				return amichecked;
    			},
    			amEnrolled: function() {
    				
    				var enl = sEnrollments.findEnrollmentsByUserId(__sfdcUserId);
    				if (enl.length > 0) {
	    				for (var i = 0; i < enl.length; i++) {
	    					
	    					if (enl[i].Display == 'Available') {
	    						return false;
	    						break;
	    					}
	    				}
    				}
    				else {
    					return false;
    				}
    				return true;
    				}
    			}
    		),
    		listeners: {
    			"render": function() {
    				
			     	Ext.get(this.getEl()).on('click', function(e, b) { //manages removing a user from the Selected Learners store.
			     		
			     		e.preventDefault();
				    	SelectedLearnersStore.remove(SelectedLearnersStore.findRecord('Id', Ext.get(b).id));
				    	SelectedLearnersStore.fireEvent('refreshView', SelectedLearnersStore);
				    	
			     	}, null, {delegate: 'a.deleteLearner'});
			     }
    		},
    		renderTo: "SelectedLearners"
    	});
    	

	
     
     /* The following blocks basically implement the Wrapper classes for the Ajax toolkit as explained in the CatalogPage.resource */
     uLearners = new Learners();
     
     jQuery(uLearners).bind('dataready', function(e) {
     	//SelectedLearnersPanel.update(e.target.records);
     	//Load just me into the store to start
     	
     	var iam = e.target.findById(__sfdcUserId);
     	SelectedLearnersStore.add(iam);
     	SelectedLearnersStore.fireEvent('refreshView', SelectedLearnersStore);
     	SelectedLearnersPanel.getEl().unmask();
     });
     SelectedLearnersPanel.getEl().mask("Loading Learners");
     uLearners.get();
     
     sEnrollments = new Enrollments();
     jQuery(sEnrollments).bind('dataready', function(e) {
     
     	SelectedLearnersStore.fireEvent('refreshView', SelectedLearnersStore);
     });
     
      
     
    	
    sCourses = new SavedCourses();
     jQuery(sCourses).bind('dataready', function(e) {
     	
     	var cRecs = [];
     	
     
     	
     	for (var i = 0; i < sCourses.records.length; i++) { //We want to allow for a static enrollment taking place from a Enroll me now button. This basically acts as an interface between a Course object and a Saved Course object.
     	
     		if (typeof(sCourses.records[i][prefix + "Course__r"]) == 'undefined') {
     			sCourses.records[i][prefix + "Course__r"] = sCourses.records[i];
     			sCourses.records[i][prefix + "Course__r"].realCourse = true;
     		}
     		cRecs.push(sCourses.records[i]);
     	}
     	
     	SavedCoursesStore.loadData(cRecs, false); //Load data into the store, false means don't append replace.
    	
     	
     	
     
     	
     });
 
      if (document.location.search.length > 0) { //Quick and dirty code to create Key value pairs for GET params. Used to see if the page was passed a static course id from enrollment. If thats the case we will use it rather than loading the saved courses.
      	var query = document.location.search;
      	query = query.replace('?', '');
      	var qsparams = query.split('&');
      	
      	var kv = {};
      	
      	for (var i = 0; i < qsparams.length; i++) {
      		var kvpair = qsparams[i];
      		var key = kvpair.split("=")[0];
      		var kvalue = kvpair.split("=")[1];
      		kv[key] = kvalue;
      	}
      	sCourses.get_by_id(kv.id);
      }
      else {
      	sCourses.get(__sfdcUserId);
      }
      
    });