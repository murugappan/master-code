/*
This is test class for AddattchmentController
Date:21.05.2013
*/
@isTest
private class AddAttachmentControllerTest {

    static testMethod void myUnitTest() {
        
       
        Account ac = TestMethodUtility.createAccount();
        ac.Name = 'BC';
        ac.BillingCity = 'BC';
        ac.BillingCountry = 'USA';
        ac.BillingPostalCode = 'BC';
        ac.BillingState = 'BC';
        ac.BillingStreet = 'BC';

        insert ac;

        Contact ct=TestMethodUtility.createContact(ac);
        ct.LastName='AB';
        insert ct;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense(); 
        insert cr;
        
        Asset aset=TestMethodUtility.createAsset(ac,cr);
        insert aset;
        
        Case c  =TestMethodUtility.createCase1(ac,aset);
        c.ContactID = ct.ID;
        insert c;
        
        Case c1 = TestMethodUtility.createCase1(ac,aset);
        
        Amazon_Credentials__c amacred =TestMethodUtility.createAmazonCredentials();
        amacred.Key__c='1234';
        amacred.Secret__c='test';
        
        insert amacred;
        
        learnJIRA__c lj =TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        learnJIRA__c lj1 =TestMethodUtility.createSupportIncident(c1);
        insert lj1;
        
        
        
        ApexPages.CurrentPage().getParameters().Put('recordId',c.ID);
        ApexPages.CurrentPage().getParameters().Put('success','true');
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(new Case[]{c});  
        AddAttachmentController sf = new AddAttachmentController(controller);
        sf.supportIncidentObj=lj;
        sf.getshowAttSec();
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        sf.updatefileinfo();
        sf.delCaseAttach();
        AddAttachmentController.getCounterString();
        sf.getShowSuccess();
        sf.getUploadCounter();
        Test.StartTest();
        sf.getsuccessfilename();
        sf.getCaseNote();
        sf.getShowDone();
        sf.getShowAttach();
        sf.getdisableFileInput();
        sf.getShowDelete();
        sf.getPolicy();
        sf.getfnamenormal();
        sf.getSignedPolicy();
        sf.getHexPolicy();
        ApexPages.CurrentPage().getParameters().put('counterstring','124');
        sf.getUploadCounter();
        
        ApexPages.CurrentPage().getParameters().Put('recordId',c1.ID);
        ApexPages.CurrentPage().getParameters().Put('fname','nik.txt');
        ApexPages.CurrentPage().getParameters().put('success','');
        ApexPages.StandardSetController controller1 = new ApexPages.StandardSetController(new Case[]{c1});  
        AddAttachmentController sf1 = new AddAttachmentController(controller1);
        sf1.supportIncidentObj=lj;
        sf1.updatefileinfo();
        sf1.getHexPolicy();
        sf1.getsuccessfilename();
        Test.StopTest();
    } 
 }