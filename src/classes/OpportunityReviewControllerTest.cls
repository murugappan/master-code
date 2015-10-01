// This is the test class for the controller OpportunityReviewController

@isTest (SeeAllData = true)
private with sharing class OpportunityReviewControllerTest 
{
	static testmethod void testNonMulitYearView()
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
		
		Contact_Role__c cr = TestMethodUtility.createContactRole(a);
		cr.Role__c = 'COLLABORATE - Primary Sales Contact';
		cr.Contact__c = c.Id;
		insert cr;
		
		Contact_Role_Selector__c crs = TestMethodUtility.createContactRoleSelector(cr);
		crs.Opportunity__c = o.Id;
		insert crs;
		
		/* Test Here */
		system.Test.startTest();
		
		PageReference pageRef = Page.OpportunityReview;
		system.Test.setCurrentPage(pageRef);
		
		Opportunity o1 = TestMethodUtility.createOpportunity(a, pb);
		o1.RecordTypeId = rt.Id;
		o1.Type = 'New';
		o1.Multi_Year_Deal__c = 'No';
		ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(o1);
		OpportunityReviewController orc = new OpportunityReviewController(stdController);
		
		system.assert(orc.hasErrors == true); // There is no Opportunity to query for this page
		Boolean errorFlag = false;
		for (ApexPages.Message m : ApexPages.getMessages())
		{
			if (m.getSeverity() == ApexPages.Severity.ERROR && m.getSummary() == 'Your opportunity was not found.')
			{
				errorFlag = true;
				break;
			}
		}
		system.assert(errorFlag == true);

		stdController = new ApexPages.Standardcontroller(o);
		orc = new OpportunityReviewController(stdController);
		
		system.assert(orc.hasErrors == false);
		system.assert(orc.isEdit == false);
		system.assert(orc.hasYear2 == false);
		system.assert(orc.hasYear3 == false);
		system.assert(orc.hasYear4 == false);
		system.assert(orc.hasYear5 == false);
		
		orc.uploadFile();
		system.assert(orc.attachmentList.isEmpty() == true);
		
		system.Test.setCurrentPage(orc.doEdit());
		system.assert(system.currentPageReference().getParameters().get('edit') == '1');
		system.Test.setCurrentPage(orc.doCancel());
		system.assert(system.currentPageReference().getParameters().get('edit') == null);
		system.Test.setCurrentPage(orc.doEdit());
		system.assert(system.currentPageReference().getParameters().get('edit') == '1');
		system.Test.setCurrentPage(orc.doSave());
		system.assert(system.currentPageReference().getParameters().get('edit') == null);
		Datetime afterSaveTime = [Select LastModifiedDate From Opportunity Where Id =: o.Id].LastModifiedDate;
		system.debug(beforeSaveTime);
		system.debug(afterSaveTime);
		//system.assert(afterSaveTime > beforeSaveTime);
		
		system.Test.stopTest();
		
		/* Asserts Here */
		// Inserted asserts above
	}
}