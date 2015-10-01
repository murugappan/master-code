public with sharing class ModifyContactRoleConnectorController 
{
	public class ContactRoleWrapper
	{
		public Contact_Role__c cRole {get; set;}
		public Boolean selected {get; set;}
		public Id selectorId {get; set;}
		
		public ContactRoleWrapper(Contact_Role__c cr, Boolean flag)
		{
			cRole = cr;
			selected = flag;
		}
		
		public PageReference doAdd()
		{
			selected = true;
			return null;
		}
		
		public PageReference doRemove()
		{
			selected = false;
			return null;
		}
	}
	
	public Opportunity opp {get; private set;}
	public Contact_Role_Selector__c connector {get; set;}
	public Contact_Role__c cRole {get; set;}
	public Boolean hasConnector {get{if (hasConnector == null) return true; return hasConnector;} private set;}
	public Boolean isNew {get{if (isNew == null) return true; return isNew;} private set;}
	public Boolean showNewContactRole {get{if (showNewContactRole == null) return false; return showNewContactRole;} private set;}
	public Boolean pageError {get{if (pageError == null) return false; return pageError;} private set;}
	public Boolean newContactRoleError {get{if (newContactRoleError == null) return false; return newContactRoleError;} private set;}
	public list<ContactRoleWrapper> cRoleList {get; set;}
	public list<SelectOption> businessUnitList {get; set;}
	public list<SelectOption> roleList {get; set;}
	public String selectedBusinessUnit {get; set;}
	public String selectedRole {get; set;}
	public String pageTitle {get; private set;}
	public String accountName {get; private set;}
	private String theId;
	private Id parentId;
	private Id accountId;
	
	public ModifyContactRoleConnectorController(ApexPages.StandardController stdController)
	{
		theId = ApexPages.currentPage().getParameters().get('id');
		pageTitle = 'Modify Contact Role Selector';
		if (theId == null)
		{
			theId = stdController.getId();
		}
		if (theId != null)
		{
			loadContactRoleConnector();
			pageTitle = connector.Name + pageTitle;
		}
		else
		{
			connector = (Contact_Role_Selector__c)stdController.getRecord();
		}
		if (connector.Opportunity__c != null)
		{
			parentId = connector.Opportunity__c;
			loadOpportunity();
			accountId = opp.AccountId;
			accountName = opp.Account.Name;
		}
		loadAccountRoles();
		if (connector.Opportunity__c != null)
		{
			loadCurrentRoles(connector.Opportunity__c); // Will change later to be scalable
		}
		cRole = new Contact_Role__c();
		createRolePicklists();
	}
	
	private void loadContactRoleConnector()
	{
		try
		{
			connector = [Select Id, Name, Contact_Role__c, Opportunity__c 
						 From Contact_Role_Selector__c 
						 Where Id =: theId];
		}
		catch (Queryexception e)
		{
			ApexPages.addMessages(e);
			pageError = true;
			hasConnector = false;
		}
	}
	
	private void loadOpportunity()
	{
		try
		{
			opp = [Select Id, Name, AccountId, Account.Name From Opportunity Where Id =: connector.Opportunity__c];
		}
		catch (Queryexception e) {}
	}
	
	public void loadAccountRoles()
	{
		cRoleList = new list<ContactRoleWrapper>();
		
		for (Contact_Role__c cr : [Select Id, Name, Role__c, Account__c, Contact__c, Contact__r.Name
								   From Contact_Role__c 
								   Where Account__c =: accountId AND Contact__c!= NULL
								   order by Role__c])
		{
			cRoleList.add(new ContactRoleWrapper(cr, false));
		}
	}
	
	private void loadCurrentRoles(Id parentId)
	{	
		map<Id, Contact_Role_Selector__c> crMap = new map<Id, Contact_Role_Selector__c>();
		
		for (Contact_Role_Selector__c crs : [Select Contact_Role__c, Opportunity__c From Contact_Role_Selector__c Where Opportunity__c =: parentId])
		{
			crMap.put(crs.Contact_Role__c, crs);
		}
		
		for (ContactRoleWrapper crw : cRoleList)
		{
			if (crMap.containsKey(crw.cRole.Id) && crMap.get(crw.cRole.Id).Opportunity__c == parentId)
			{
				crw.selected = true;
				crw.selectorId = crMap.get(crw.cRole.Id).Id;
			}
		}
	}
	
	private void createRolePicklists()
	{
  		businessUnitList = new list<SelectOption>();
  		roleList = new list<SelectOption>();
   		Schema.DescribeFieldResult fieldResult = Contact_Role__C.Role__c.getDescribe();
   		list<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        set<String> buSet = new set<String>();
        set<String> roleSet = new set<String>();
        set<String> restrictedRoleSet = new set<String>{'Bill to Contact', 'Primary Sales Contact', 'Primary Sales Technical Contact', 'Reference', 'Ship to Contact', 'SOA Signatory'};
        String fullRole, bu, role;
        
   		for (Schema.PicklistEntry f : ple)
   		{
   			fullRole = f.getLabel();
   			if (fullRole.indexOf(' - ') != -1)
   			{
   				bu = fullRole.substring(0, fullRole.indexOf(' - '));
   				role = fullRole.substring(fullRole.indexOf(' - ') + 3);
   				bu = bu.trim();
   				role = role.trim();
   				if (!buSet.contains(bu))
   				{
   					buSet.add(bu);
   					businessUnitList.add(new SelectOption(bu, bu));
   				}
   				if (!roleSet.contains(role) && restrictedRoleSet.contains(role))
   				{
   					roleSet.add(role);
   					roleList.add(new SelectOption(role, role));
   				}
   			}
   		}
	}
	
	public void displayNewContactRoleSection()
	{
		showNewContactRole = true;
		if (connector.Opportunity__c != null)
		{
			cRole.Account__c = opp.AccountId;
		}
	}
	
	public PageReference doCancel()
	{
		PageReference pageRef;
		
		if (connector.Opportunity__c != null)
		{
			pageRef = new PageReference('/' + connector.Opportunity__c).setRedirect(true);
		}
		
		return pageRef;
	}
	
	public PageReference doSave()
	{
		list<Contact_Role_Selector__c> newConnectorList = new list<Contact_Role_Selector__c>();
		list<Contact_Role_Selector__c> deleteConnectorList = new list<Contact_Role_Selector__c>();
		PageReference pageRef;
		Contact_Role_Selector__c crc;
		
		for (ContactRoleWrapper crw : cRoleList)
		{
			if (crw.selected && crw.selectorId == null)
			{
				crc = new Contact_Role_Selector__c();
				crc.Contact_Role__c = crw.cRole.Id;
				if (connector.Opportunity__c != null)
				{
					crc.Opportunity__c = connector.Opportunity__c;
				}
				newConnectorList.add(crc);
			}
			else if (!crw.selected && crw.selectorId != null)
			{
				crc = new Contact_Role_Selector__c(Id = crw.selectorId);
				deleteConnectorList.add(crc);
			}
		}
		
		try
		{
			insert newConnectorList;
			delete deleteConnectorList;
			if (connector.Opportunity__c != null)
			{
				pageRef = new PageReference('/' + connector.Opportunity__c).setRedirect(true);
			}
		}
		catch (Dmlexception de)
		{
			ApexPages.addMessages(de);
			pageError = true;
		}
		
		return pageRef;
	}
	
	public PageReference cancelNewRole()
	{
		showNewContactRole = false;
		cRole = new Contact_Role__c();
		return null;
	}
	
	public PageReference addNewRole()
	{
		try
		{
			cRole.Role__c = selectedBusinessUnit + ' - ' + selectedRole;
			system.debug(cRole);
			insert cRole;
			cRole = [Select Id, Name, Role__c, Account__c, Contact__c, Contact__r.Name From Contact_Role__c Where Id =: cRole.Id];
			cRoleList.add(new ContactRoleWrapper(cRole, true));
			showNewContactRole = false;
			cRole = new Contact_Role__c();
		}
		catch (Dmlexception de)
		{
			ApexPages.addMessages(de);
			newContactRoleError = true;
		}
		catch (Queryexception qe)
		{
			
		}
		return null;
	}
}