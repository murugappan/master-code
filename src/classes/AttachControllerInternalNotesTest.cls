/*
Class Name:AttachControllerInternalNotes
Date:21.05.2013
Author:Nikhil Kumar
*/
@isTest(seealldata=True)
private class AttachControllerInternalNotesTest {

    static testMethod void myUnitTest() {
        
        Account ac = TestMethodUtility.createAccount();
        ac.Name = 'BC';
        ac.BillingCity = 'BC';
        ac.BillingCountry = 'USA';
        ac.BillingPostalCode = 'BC';
        ac.BillingState = 'BC';
        ac.BillingStreet = 'BC';

        insert ac;

        Contact ct= TestMethodUtility.createContact(ac);
        ct.LastName='AB';
        insert ct;
        
        //Core license
	    Core_License__c cr =TestMethodUtility.createCoreLicense();
	    cr.Name='Moodlerooms';
	    insert cr;
	    
       //Asset
	    Asset aset = TestMethodUtility.createAsset(ac,cr);
	    aset.Name = 'Test Asset 111';
	    aset.Installed_Product_ID__c = '123';
	    aset.Status = 'Installed'; 
	    aset.version__c = '9.1';
	    aset.Psft_Product_Id__c = 'AS-LS';
	    aset.Version_Build__c = '9.1.X';
	    insert aset;
        
        Case c = TestMethodUtility.createCase1(ac,aset);        //for angel software solutions
	    c.AccountID = ac.ID;
	    c.ContactID = ct.ID;
	    c.Case_Severity__c = '1';
	    c.Subject = 'test';
	    c.Description = 'test';
	    c.assetID  = aset.ID;
	    insert c;
        
     //   Case c  = new Case();
       // c.AccountID = ac.ID;
       // c.ContactID = ct.ID;
      //  insert c;
        
        ApexPages.CurrentPage().getParameters().Put('caseID',c.ID);
        ApexPages.CurrentPage().getParameters().Put('usrcom','AB\r\nCD');
        ApexPages.CurrentPage().getParameters().Put('con','ACD');
        ApexPages.CurrentPage().getParameters().Put('console','false'); 
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);   
        AttachControllerInternalNotes act = new AttachControllerInternalNotes(controller);
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        act.updatefileinfo(); 
        act.getpolicy();
        act.getSignedPolicy();
        act.getHexPolicy();
        act.getshowAttSec();
        act.delCaseAttach();
        
        
        
        
    }
}