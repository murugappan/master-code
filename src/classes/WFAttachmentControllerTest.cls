@isTest(seealldata=true)

private class WFAttachmentControllerTest{
private static testmethod void WFAttachController1Test(){
       
        Account ac = new Account();
        ac.Name = 'BC';
        ac.BillingCity = 'BC';
        ac.BillingCountry = 'USA';
        ac.BillingPostalCode = 'BC';
        ac.BillingState = 'BC';
        ac.BillingStreet = 'BC';

        insert ac;

        Contact ct= new Contact ();
        
        ct.AccountId=ac.id;
        ct.LastName='AB';
        
        insert ct;
        
        Case c  = new Case();
        c.AccountID = ac.ID;
        c.ContactID = ct.ID;
        insert c;
        
        ApexPages.CurrentPage().getParameters().Put('cid',c.ID);
        ApexPages.CurrentPage().getParameters().Put('success','true');
        ApexPages.StandardController controller = new ApexPages.StandardController(c);  
        WFAttachmentController sf = new WFAttachmentController(controller);
        sf.getshowAttSec();
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        sf.updatefileinfo();
        sf.delCaseAttach();
        sf.getPolicy();
        sf.getSignedPolicy();
        sf.getHexPolicy();
        WFAttachmentController.getCounterString();
        sf.getShowSuccess();
        sf.getUploadCounter();
        sf.getsuccessfilename();
        sf.getCaseNote();
        sf.getShowDone();
        sf.getShowAttach();
        sf.getdisableFileInput();
        sf.getShowDelete();
        sf.getfnamenormal();
        
        
    }


}