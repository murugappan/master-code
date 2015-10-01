// This is the test class for the controller ModifyContactRoleConnectorController

@isTest (SeeAllData = true)
private with sharing class ModifyContactRoleConnectorControllerTest 
{
	static testmethod void testController()
	{
		/* Data Setup */
		Account a = TestMethodUtility.createAccount();
		a.CPQ_PO_Required__c = 'Yes';
		insert a;
		
		RecordType rt = [Select Id From RecordType Where SobjectType = 'Opportunity' And Name = 'CPQ New Sales Opportunity Record Type' limit 1];
		Pricebook2 pb = [Select Id From Pricebook2 Where IsActive = true And IsStandard = true limit 1];
		
		Opportunity o = TestMethodUtility.createOpportunity(a, pb);
		o.RecordTypeId = rt.Id;
		o.Type = 'New';
		o.Multi_Year_Deal__c = 'No';
		o.CPQ_PO_Required__c = 'No';
		insert o;
		Datetime beforeSaveTime = system.now();
		
		Contact c = TestMethodUtility.createContact(a);
		c.PS_Person_Id__c = '99912345';
		insert c;
		
		Contact c1 = TestMethodUtility.createContact(a);
		c1.PS_Person_Id__c = '999912345';
		insert c1;
		
		Contact_Role__c cr = TestMethodUtility.createContactRole(a);
		cr.Role__c = 'COLLABORATE - Primary Sales Contact';
		cr.Contact__c = c.Id;
		insert cr;
		
		Contact_Role__c cr1 = TestMethodUtility.createContactRole(a);
		cr1.Role__c = 'COLLABORATE - Primary Technical Contact';
		cr1.Contact__c = c1.Id;
		insert cr1;
		
		Contact_Role_Selector__c crs1 = TestMethodUtility.createContactRoleSelector(cr);
		crs1.Opportunity__c = o.Id;
		insert crs1;
		
		Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
		crs.Opportunity__c = o.Id;
		//insert crs;
		
		/* Test Here */
		system.Test.startTest();
		
		PageReference pageRef = Page.ModifyContactRoleConnector;
		system.Test.setCurrentPage(pageRef);
		ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(crs);
		ModifyContactRoleConnectorController mcrcc = new ModifyContactRoleConnectorController(stdController);
		system.assert(mcrcc.connector.Id == null);
		insert crs;
		
		stdController = new ApexPages.Standardcontroller(crs);
		mcrcc = new ModifyContactRoleConnectorController(stdController);
		
		mcrcc.displayNewContactRoleSection();
		mcrcc.cancelNewRole();
		mcrcc.selectedBusinessUnit = 'Collaborate';
		mcrcc.selectedRole = 'Primary Sales Contact';
		mcrcc.cRole.Contact__c = c.Id;
		mcrcc.cRole.Account__c = a.Id;
		mcrcc.addNewRole();
		
		for (Integer i = 0; i < mcrcc.cRoleList.size(); i++)
		{
			if (!mcrcc.cRoleList[i].selected)
			{
				mcrcc.cRoleList[i].doAdd();
			}
			else
			{
				mcrcc.cRoleList[i].doRemove();
			}
		}
		
		system.Test.setCurrentPage(mcrcc.doSave());
		system.assert(system.currentPageReference().getUrl() == ('/' + o.Id));
		system.Test.setCurrentPage(mcrcc.doCancel());
		system.assert(system.currentPageReference().getUrl() == ('/' + o.Id));
		
		system.Test.stopTest();
		
		/* Asserts Here */
		// Inserted asserts above
	}
}