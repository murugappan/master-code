 Ext.define('Ext.ux.ClearableText', {
		    extend: 'Ext.form.field.Trigger',
		    alias: 'widget.customtrigger',
		    triggerCls: 'clear-icon-modal',
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



Ext.define('Ext.ux.SFDCUserPickerPanel', { //defines a custom panel that extends a standard panel.
	extend: 'Ext.panel.Panel', 
	searchValue: null,
	ds: null,
	enrollments: null,
	selectedList: null,
	learners: null,
	gridPanel: Ext.create('Ext.panel.Panel', { //A psudeo-grid panel for learners. No reason to extend Ext.grid.Panel as it would be alot of hacking to make it look right, we'll just roll our own.
    		baseCls: 'bb-sidebar-Modal',
    		bodyBorder: false,
    		html: 'test',
    		
    		tpl: new Ext.XTemplate(
    		'<tpl for=".">',
    			
    			'<tpl for="data">',
		    				//'<tpl if="!this.isMe(values.Id)">',
			    				'<div class="rowModal">',
			    				'<div class="col image imageModal"><div class="media"><span class="img icon">',
			    				'<tpl if="values.SmallPhotoUrl">',
			    				'<img src="{SmallPhotoUrl}" alt="img" height="32" width="32"/>',
			    				'</tpl>',
			    				'</span><div class="bd"><div class="ptn">{Name} <span class="detail">{Title}</span></div></div></div></div>',
			    				'<div class="col licenseModal">{LicenseName}</div>',
			    				'<div class="col option">',
			    				'<tpl if="this.isSelected(values.Id)">',
			    					'<div class="selected rightSideModal selectionTopper">',
			    					'<div class="forceLeft checkSF">&nbsp;</div><div class="selectedText forceLeft">Selected</div><a href="#" class="deleteLearner" id="{Id}"><div class="deleteIcon forceLeft">&nbsp;</div></a>',
			    					'<div class="clearingBoxSF"></div></div>',
			    				'</tpl>',
			    				'<tpl if="this.isLocked(values.Id)">',
			    					'<div class="locked rightSideModal selectionTopper">',
			    					'<div class="keySF forceLeft">&nbsp;</div><div class="selectedText forceLeft">Locked</div>',
			    					'</div>',
			    				'</tpl>',
			    				'<tpl if="this.isAvailable(values.Id)">',
			    					'<div class="available rightSideModal buttonTopper forceLeft">',
			    					'<input type="button" class="btn addLearner btnPadded" id="{Id}" value="Add" />',
			    					'</div>',
			    				'</tpl>',
			    				'</div>',
			    				'</div><div class="clearingBox"></div>',
			    				'</div>',

		    	'</tpl>',
    		'</tpl>',
    		//'</tpl>',
    		'<div class="closeBottom"><input type="button" class="btn modal-close-btn" value="Done" /></div><div class="clearingBoxSF"></div>',
    		{
    			isMe: function(val) {
    				return (val == __sfdcUserId);
    			},
    			isSelected: function(val) {
    				for(var i = 0; i < this.selectedList.data.items.length; i++) {
    					if (this.selectedList.data.items[i].data.Id == val) {
    						return true;
    						break;
    					}
    				}
    				return false;
    			},
    			isLocked: function(val) {
    				var enl = this.enrollments.findEnrollmentsByUserId(val);
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
    			},
    			isAvailable: function(val) {
    				if (this.isSelected(val)) {
	    				return false;
	    			}
    				var enl = this.enrollments.findEnrollmentsByUserId(val);
	    			if (enl.length > 0) {
	    				for (var i = 0; i < enl.length; i++) {
	    					//console.log(enl[i].Display);
	    					if (enl[i].Display == 'Available') {
	    						return true;
	    						break;
	    					}
	    				}
	    			}
	    			else {
	    				return true;
	    			}
    				return false;
    			}
    		}
    		)
    }),
    getStore: function() { return this.ds; },
    searchField: new Ext.create('Ext.ux.ClearableText', { //Filters the store for matches
    		name: 'search',
    		cls: 'modalsearchbox',
    		emptyText: 'Find Users',
    		width:133,
    		size:10,
    		listeners: {
    			change: function(thobj, newtxt, oldtxt) {
    				if (newtxt == '') {
    					
    					Ext.get(thobj.triggerEl).hide();
    				}
    				else { 
    				
    					Ext.get(thobj.triggerEl).show();
    				}
    				
    				thobj.context.getStore().filterBy(function(record, id) {
    					return (record.data.Name.toLowerCase().indexOf(newtxt.toLowerCase()) > -1);
    				});
    				thobj.context.getStore().fireEvent('filtered', thobj.context.getStore());
    			}
    		}
    }),
    pager: Ext.create('Ext.panel.Panel', { //quick and dirty pager that grabs records and calculates records per page.
    	baseCls: 'buttonPanelBB',
    	setPage: function(pg) {
    		
    		this.context.getStore().currentPage = pg;
    		beginIndex = (this.context.getStore().currentPage - 1) * this.context.getStore().pageSize;
    		lastIndex = (beginIndex + this.context.getStore().pageSize) - 1;
    		thispage = this.context.getStore().getRange(beginIndex, lastIndex);
    		this.panel.gridPanel.update(thispage,false);
    		
    		var cpage = this.context.getStore().currentPage;
    		var tpage = Math.ceil(this.context.getStore().count() / this.context.getStore().pageSize);
    		
    		
    		
    		if (cpage == 1) {
    			this.prevBtn.hide();
    		}
    		else {
    			this.prevBtn.show();
    		}
    		if (cpage == tpage) {
    				this.nextBtn.hide();
    		}
    		else {
    			this.nextBtn.show();
    		}
    		
    		if (tpage == 0) {
    			this.nextBtn.hide();
    			this.prevBtn.hide();
    		}
    		
    		
    		
    	},
    	nextBtn: Ext.create('Ext.Button', {
				    text: 'Next <img src="/s.gif" class="nextSF"/>',   
				    border: 0,
				    cls: 'link-btn-next',
				    baseCls: '',  
				    handler: function() {
				       this.context.pager.setPage(this.context.getStore().currentPage + 1);
				    }
				}),
				
    	prevBtn: Ext.create('Ext.Button', {
				    text: '<img src="/s.gif" class="prevSF"/> Previous',
				    border: 0,
				    cls: 'link-btn-prev',
				    baseCls: '',  
				    handler: function() {
				        this.context.pager.setPage(this.context.getStore().currentPage - 1);
				    }
			    }), 
			    
		
		items: []
    }),
    
    
    initComponent: function() { //Wires all the panels together allowing them communicate principally through our root node.
    	var context = this;
    	this.pager.context = this;
    	this.pager.nextBtn.context = this;
    	this.pager.prevBtn.context = this;
    	this.searchField.context = this;
    	
    	this.gridPanel.tpl.enrollments = this.enrollments;
    	this.gridPanel.tpl.selectedList = this.selectedList;
    	
    	this.pager.add(this.pager.prevBtn);
    	this.pager.add(this.pager.nextBtn);
    	
    	this.pager.panel = this;
    	
    	this.pager.setPage(this.getStore().currentPage);
    	
    	this.storeSize = this.getStore().count();
    	
    	
    	this.getStore().addListener('datachanged', function(st) {
    		context.pager.setPage(context.getStore().currentPage);
    	});
    
    	
    	
    	this.getStore().addListener('filtered', function(st) {
    		context.pager.setPage(1);
    	
    	});

		if (this.gridPanel.rendered) { //might have rendered already if it did just bind
			Ext.get(context.gridPanel.getEl()).on('click', function(e, b) {
	    		context.selectedList.add(context.learners.findById(Ext.get(b).id));
	    		context.getStore().fireEvent('datachanged', context.ds);
	    		
	    	}, null, {delegate: 'input.addLearner'});
	    
	    	Ext.get(context.gridPanel.getEl()).on('click', function(e, b) {
	    		e.preventDefault();
	    		context.selectedList.remove(context.selectedList.findRecord('Id', Ext.get(b).id));
	    		context.getStore().fireEvent('datachanged', context.ds);
	    	}, null, {delegate: 'a.deleteLearner'});
		
		} else { //if not wait for render then bind
    
    	this.gridPanel.addListener('render', function() {

	    	Ext.get(context.gridPanel.getEl()).on('click', function(e, b) {
	    		context.selectedList.add(context.learners.findById(Ext.get(b).id));
	    		context.getStore().fireEvent('datachanged', context.ds);
	    		
	    	}, null, {delegate: 'input.addLearner'});
	    
	    	Ext.get(context.gridPanel.getEl()).on('click', function(e, b) {
	    		e.preventDefault();
	    		context.selectedList.remove(context.selectedList.findRecord('Id', Ext.get(b).id));
	    		context.getStore().fireEvent('datachanged', context.ds);
	    	}, null, {delegate: 'a.deleteLearner'});
	    	
	    	
    	});
		}
    
    	
    	delete context; //we're done with the context
    	this.items = [this.searchField, this.gridPanel, this.pager]; //layout our panel
    	this.callParent(arguments); //call SUPER();
    		
    	
    }
});
    	