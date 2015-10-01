//set globals for panels and other assets that hold data for the page

	var CategoryPanel;
    var CourseDetailsPanel;
    var CoursePanel;
    var SavedCoursesPanel;
    var CatCrumbsPanel;
    var CourseStore;
    var cats;
    var searchField;
    var reloadSavedCourses;
    
 //helper functions to move to enrollment
    enrollSaved = function() {
		document.location = '/apex/enrollsaved';
	}

	var enrollSingle = function(id) {
		document.location = '/apex/enrollsaved?id=' + id;
	}
	
	//Init the page when its ready. Ext seems to detect the ready after jQuery did so we use the Ext ready to make sure all the components are ready.

    Ext.onReady(function(){
    	
    	
     //Reload saved courses: Used after a course is added or removed to update the dropdown panel.
     reloadSavedCourses = function() {
     	sCourses.get(__sfdcUserId);
     }
     
       Ext.define('Ext.ux.ClearableText', {
		    extend: 'Ext.form.field.Trigger',
		    alias: 'widget.customtrigger',
		    triggerCls: 'clear-icon',
		    // override onTriggerClick
		    onTriggerClick: function() {
		        this.setValue('');
		    },
		    listeners: {
		    	"render": function(e, b) {
		    		Ext.get(this.triggerEl).hide();
		    	}
		    }
		});
     
     //Defines the textfield for filtering the course grid's store.
    	searchField = new Ext.create('Ext.ux.ClearableText', {
    		name: 'search',
    		emptyText: 'Search Courses...',
    		listeners: {
    			specialkey: function(me, e, o) {
    				if (e.keyCode == e.ENTER) {
    					e.preventDefault();
    					return false;
    				}
    			},
    			change: function(thobj, newtxt, oldtxt) {
    				if (newtxt == '') {
    					
    					Ext.get(thobj.triggerEl).hide();
    				}
    				else {
    				
    					Ext.get(thobj.triggerEl).show();
    				}
    				
    				CoursePanel.getStore().filterBy(function(record, id) {
    					return (record.data[prefix + "Course__r"][prefix + "Course_Title__c"].toLowerCase().indexOf(newtxt.toLowerCase()) > -1);
    				});
    			}
    		},
    		renderTo: "searchBox"
    	});
    	//Defines the panel / container used for the drop down.
    	
    	//Tpl defines a template with which to render JSON data when the data is updated.
    	
    	SavedCoursesPanel = Ext.create('Ext.container.Container', {
    		baseCls: 'bb-dropdown',
    		bodyBorder: false,
    		html: '',
        	frame: false,
    		tpl: new Ext.XTemplate(
    		'<ul><li class="paddedOut0"><a href="#">{[values.length]} Saved Course{[(values.length > 1) ? "s" : ""]}</a><ul><li class="paddedOut0 fullWidth">',
    		'<tpl for=".">', 
	    			'<tpl for="' + prefix + 'Course__r">',
	    				'<div class="paddedOut5 savedCourseLine {[(xindex == 1) ? "" : "topLine"]} ">',
	    				'<div class="savedCourse paddedTop10"><div class="savedCourseTitle">{[values[prefix + "Course_Title__c"]]}</div><div class="savedCourseName">{Name}</div></div><div class="deleteIcon paddedTop10 deleteSavedCourse" id="{Id}">&nbsp;</div>',
	    				'</div><div class="clearingBox"></div>',
	    			'</tpl>',
    		'</tpl>',
    		'</div><div class="spacer10">&nbsp;</div></li></ul></li></ul><div class="clearingBoxSF"></div>'),
    		renderTo: "savedDD" //<--- real div's id on the page we want to render the container to; this makes it easy to layout if we use a html skeleton.
    	 
    	});
    	
    	//Creates the panel right of the courses grid.
    	
    	CourseDetailsPanel =  Ext.create('Ext.panel.Panel', {
	    	baseCls: 'bb-panel',
	    	bodyBorder: false,
	    	html: '<div class="courseWrapper"><div class="title courseTitle">Search and Enroll in Courses</div><div class="rule"></div><div class="body paddedTop10 defaultBody"><p>You can find a course by searching the course list to the left or sorting by specific categories in the “Browse by Category” section at the top of this page. Select a course to see its description and other information. Once you have found a course, you can save it (to view it later) by clicking the “Save” button or click the “Enroll Now” button to begin the enrollment process for the course.</p><br/><p>On the enrollment confirmation screen, verify the selected training courses on the right, the selected learners on the left, then click the “Complete Enrollment” button to finalize your enrollment.</p><br/><p>This tab is for enrolling in new courses. Click the tab with your course list to access the courses in which you are enrolled.</p></div></div>',
	    	tpl: new Ext.XTemplate('<div class="courseWrapper"><div class="title courseTitle">{[values[prefix + "Course_Title__c"]]}</div>',
	    	'<div class="rule fullWidth"></div>',
	    	'<div class="courseMargin courseNumber courseSubHeading strong">{Name}</div>',
	    	
	    	'<div class="buttonPanel"><input type="button" class="btn btnPadded btnRight" onClick="saveCourse(\'{Id}\')" value="Save" /><input type="button" class="btn btnBlue btnPadded" onClick="enrollSingle(\'{Id}\')" value="Enroll Now" /></div><div class="clearingBoxSF"></div>',
	    	'<div class="meta">',
	    	'<div class="courseMargin courseSubHeading fullWidth strong">Instructor: <span class="courseData">{[values[prefix + "Instructor__c"]]}</span></div>',
	    	'<div class="courseMargin courseSubHeading courseData fullWidth courseDate">{[this.formatDate(values[prefix + "Date_Range__c"])]}</div>',
	    	'</div>',
	    	'<div class="courseMargin courseDescription">{[values[prefix + "Description__c"]]}</div></div>',
	    	{
	    		formatDate: function(val) {
	    			if (val != null) {
		    			var dates = val.split(" - ");
		    			var ndate = new Date (dates[0]);
		    			var ndate2 = new Date(dates[1]);
						var month_names = new Array ( );
						month_names[month_names.length] = "January";
						month_names[month_names.length] = "February";
						month_names[month_names.length] = "March";
						month_names[month_names.length] = "April";
						month_names[month_names.length] = "May";
						month_names[month_names.length] = "June";
						month_names[month_names.length] = "July";
						month_names[month_names.length] = "August";
						month_names[month_names.length] = "September";
						month_names[month_names.length] = "October";
						month_names[month_names.length] = "November";
						month_names[month_names.length] = "December";
						
						var day_names = new Array ( );
						day_names[day_names.length] = "Sunday";
						day_names[day_names.length] = "Monday";
						day_names[day_names.length] = "Tuesday";
						day_names[day_names.length] = "Wednesday";
						day_names[day_names.length] = "Thursday";
						day_names[day_names.length] = "Friday";
						day_names[day_names.length] = "Saturday";
						
						var outDate = day_names[ndate.getDay()] + ' ' + month_names[ndate.getMonth()] + " " + ndate.getDate() + ", " + ndate.getFullYear();
						if (ndate.getDay() + '' == 'NaN') {
							outDate = '';
						}
						
						var outDate2 = day_names[ndate2.getDay()] + ' ' + month_names[ndate2.getMonth()] + " " + ndate2.getDate() + ", " + ndate2.getFullYear();
						
						if (ndate2.getDay() + '' == 'NaN') {
							outDate2 = '';
						}
						if (outDate == ''  && outDate2 == '') {
							return '';
						}
						else if (outDate == '' && outDate2 != '') {
							return outDate2;
						}
						else if (outDate2 == '' && outDate != '') {
							return outDate;
						}
						else {
		    				return outDate + ' to ' + outDate2;
		    			}
		    		}
		    		else {
		    			return '';
		    		}
	    		}
	    	}
	    	
	    	),
	    	renderTo: "courseDetails"
		});
    	
    	//Defines a data store to keep the JSON we load from Salesforce in memory. Also allows us to do fun things like filter the data locally.
    	CourseStore = new Ext.data.JsonStore({
    		fields: ['Id', 'Name', {name: prefix + "Start_Date__c", type: 'date'}, prefix + 'Course__r.Name', prefix + 'Course__r']
    		
    	});
    
    	//A panel to render the BreadCrumbs based on JSON data we can keep in memory. This is nice because it allows us to track history when were staying on the same page.
    	CatCrumbsPanel = Ext.create('Ext.panel.Panel', {
	    	baseCls: 'bb-panel',
	    	bodyBorder: false,
	    	html: '<p></p>',
	    	tpl: new Ext.XTemplate(
                            '<tpl for=".">',
                            	'<tpl if="xindex &lt; xcount">',
                            		'<a href="{Id}" id="{Name}" class="drillin jump">{Name}</a> &gt; ',
                            	'</tpl>',
                            	'<tpl if="xindex &gt;= xcount">',
                            		'{Name}',
                            	'</tpl>',
                            '</tpl>'),
	    	renderTo: "catCrumbs"
		});
    
    	 //Custom panel to display category hierachy.
    	 
	     CategoryPanel = Ext.create('Ext.panel.Panel', {
	    	baseCls: 'bb-panel',
	    	bodyBorder: false,
	    	html: '<p>Loading....</p>',
	    	emptyText: '<div style="padding-top: 5px; padding-left: 5px; font-family: Arial; font-size: 12px; color: #666666; font-style:italic;">No categories are available in the training catalog.</div>',
	    	tpl: new Ext.XTemplate(
                            '<ul>',
                            '<tpl for=".">',
                            	'<li>',
                            		'<tpl if="this.hasChildren(values.Id)">',
                            		'<a href="{Id}" id="{Name}" class="drillin">{Name} ({[this.childCount(values.Id)]})</a>',
                            		'</tpl>',
                            		'<tpl if="!this.hasChildren(values.Id)">',
                            		'<a href="{Id}" id="{Name}" class="drillin finalcat">{Name}</a>',
                            		'</tpl>',
                            	'</li>',
                            '</tpl>',
                            '</ul>', { //<-- if the last argument to the XTemplate is an object, it can house functions for both rendering data and returning booleans used in conditional block.
                            	hasChildren: function(id) {
                            		return (this.childCount(id) != 0);
                            	},
                            	childCount: function(id) {
                            		return cats.getChildren(id).length;
                            	}
                            }),
	    	renderTo: "categories"
		});
		
		
		//Grid panel for displaying courses
		
		CoursePanel = new Ext.grid.Panel({
	       renderTo: "catalog",
	       viewConfig: {
	       	emptyText: '<div style="padding-top: 5px; padding-left: 5px; font-family: Arial; font-size: 12px; color: #666666; font-style:italic;">No courses are available in this category.</div>'
	       },
	       store: CourseStore,
	       height: 300,
	       frame: false,
	       
	       columns: [
			    {text: 'Course', 
			    xtype:'templatecolumn',
			    sortable: true,
			    dataIndex: prefix + 'Course__r.' + prefix + 'Course_Title__c',
			    tpl: new Ext.XTemplate('<tpl for="' + prefix + 'Course__r"><a class="courseLink" href="#">{[values[prefix + "Course_Title__c"]]}</a></tpl>'),
			    flex: 1
			   
			    }
			    ,
			    {
			        text: 'Dates',
			        sortable: true,
			         xtype:'templatecolumn',
			         dataIndex: 'Date_Range__c',
			        tpl: new Ext.XTemplate('<tpl for="' + prefix + 'Course__r">{[values[prefix + "Date_Range__c"]]}</tpl>'),
			        width: 120
			        
			    }
			],
			listeners: { //<-- we can bind events using the listener block.
		        itemclick: function(con, rec, item, index, event){
		            	event.preventDefault();
		            	
		            	CourseDetailsPanel.update(rec.data[prefix + "Course__r"]);
		        },
		        sortchange: function(ct, column, direction, options) {
        			if (column.text == 'Course') {
        				CoursePanel.getStore().sort(prefix + 'Course_Title__c', direction);
        			}
        			else if (column.text == 'Dates') {
        				CoursePanel.getStore().sort(prefix + "Start_Date__c", direction);
        			}		
			    }
		    }
	   });

		
		
		
		
    
    	crumbs = new CatCrumbs(); //<-- Simple object for storing the category crumbs and also altering the data array, to change the crumb path.
    	
    	var CourseCatalog = new Courses(); //<--- Wrapper class for querying courses from Ajax Toolkit.
    	
    	jQuery(CourseCatalog).bind("dataready", function(e) { //All the wrapper classes dispatch a custom even when they've actually loaded data so that we know we can now render the components.
    		var recs = jQuery(e.target)[0].records;
    	
    		if (typeof(recs) != "undefined") {
    			
    			var realRecs = [];
    			var uniqName = [];
    			for(var i = 0; i < recs.length; i++) {
    				//ensure that we only have the first course record
    				if (typeof(recs[i][prefix + "Course__r"]) == 'undefined') {
    					var n = recs[i].Name;
    					if (typeof(uniqName[n]) == "undefined") {
    						realRecs.push(recs[i][prefix + "Course__r"] = recs[i]);	
    					}
    					uniqName[n] = 1;
    				}
    				else {
    					recs[i].Name = recs[i][prefix + "Course__r"].Name;
    					if (typeof(uniqName[recs[i].Name]) == 'undefined') {
    						recs[i][prefix + "Date_Range__c"] = recs[i][prefix + "Course__r"][prefix + "Date_Range__c"];
    						recs[i][prefix + "Start_Date__c"] = recs[i][prefix + "Course__r"][prefix + "Start_Date__c"];
    						realRecs.push(recs[i]);
    					}
    					uniqName[recs[i].Name] = 1;
    				}
    			}
     			CourseStore.loadData(realRecs, false);
    			CoursePanel.getStore().sort(prefix + 'Course_Title__c', 'ASC');
    		}
    		else {
    			CourseStore.loadData([], false);
    			CoursePanel.getStore().sort(prefix + 'Course_Title__c', 'ASC');
    		}
    		CoursePanel.getEl().unmask();
    		
    		
    		
    	});
    	
    	var loadCoursesByCat = function(id) { //filters courses by category.
    		CoursePanel.getEl().mask("Loading Courses");
    		
    		CourseCatalog.get(id);
    		searchField.setValue('');
    	}
    	
    	jQuery(crumbs).bind('rerender', function(e) { //Updates panel when breadcrumb changes. the breadcrumb class dispatches a rerender event when it changes.
    		CatCrumbsPanel.update(jQuery(e.target)[0].crumbs);
    		
    	});
    	
    	crumbs.init(); //Sets the intial breadcrumb (Catalog).
    	
    	
    	cats = new Categories(); //Simple class that wraps the Ajax Toolkit to return categories.
    	jQuery(".drillin").live('click', function(e) { //Manages drilling into the heirarchy.
    		e.preventDefault();
    		var id = jQuery(e.target).attr("href");
    		
    		idp = id.split("/");
    		id = idp[(idp.length-1)];
    		
    		var title = jQuery(e.target).attr("id");
    		if (!jQuery(this).hasClass("finalcat")) {
    			CategoryPanel.update(cats.getChildren(id));
    			if (!jQuery(this).hasClass("jump")) {
    				crumbs.addCrumb({Name: title, Id: id, finalCat: false});
    			}
    			else {
    				crumbs.setCrumbId(id);
    			}
    		}
    		else {
    			crumbs.addCrumb({Name: title, Id: id, finalCat: true});
	    		jQuery(".drillin").removeClass("active");
    			jQuery(this).addClass("active");
    		}
    		loadCoursesByCat(id);
    	});
    	jQuery(cats).bind('dataready', function(e) { //when we get data back from the wrapper class render the category panel.
    		//console.log(cats);
    		if (cats.records.length == 0) {
    			jQuery("#catHolder").hide();
    			jQuery("#catCrumbs").hide();
    			loadCoursesByCat('null');
    		}
    		else {
    			CategoryPanel.update(cats.records);
    		}
    		loadCoursesByCat('null'); //load all to start
    	});
    	cats.get(); //load category data.
    	
    	
    
    	
    var sCourses = new SavedCourses(); //Wrapper class for Ajax Toolkit to pull Saved Courses | SavedCourses.resource
     jQuery(sCourses).bind('dataready', function(e) { //When new data is ready 
     	
     	SavedCoursesPanel.update(sCourses.records); //rerender the dropdown list via update command
     	
     	//hide stuff if empty
     	if (sCourses.records.length > 0) { //decided if you should show it based on if it has records
     		jQuery("#savedDD").show();
     		jQuery("#enrollAll").show();
     	}
     	else {
     		jQuery("#savedDD").hide();
     		jQuery("#enrollAll").hide();
     	}
     	
     	
     });
     
      sCourses.get(__sfdcUserId); //get saved courses for current user.
      
      jQuery('.deleteSavedCourse').live("click", function(e) { //bind the delete button to remove the course.
      	e.preventDefault();
      	var tid = jQuery(e.target).attr('id');
      	unsaveCourse(tid);
      	jQuery(e.target).closest('li').remove();
      });
      
      jQuery(window).bind("resize", function(e) {
      	CoursePanel.doLayout();
      });
      
    });