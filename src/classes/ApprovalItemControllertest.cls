@isTest(seeAllData=true)
private class ApprovalItemControllertest 
{

    static testMethod void myUnitTest() 
    {
        Account acc = TestMethodUtility.createAccount();
        acc.Industry = 'Corporate';
        acc.Region__c = 'NORTH AMERICA';
        insert acc;
        
        contact c= TestMethodUtility.createContact(acc);
        insert c;
        
        contact c3= TestMethodUtility.createContact(acc);
        c3.Email='testmail@abc.com';
        insert c3;
           
        Product2 pr =TestMethodUtility.createProduct();
        pr.Type__c='Services';
        insert pr;
        
        //Standard pricebook
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        
        Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
        
        PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
        pes.UseStandardPrice = false;
        insert pes;
        
        PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
        pe.UseStandardPrice = false;
        insert pe;
        
        Profile p =[select id from Profile where Name='Bb - P100 - CPQ' limit 1];
        
        User u = TestMethodUtility.createUser(p);
        u.Approval_Routing_Discount_Tier__c ='Strategic';
        insert u;
       
        Opportunity op =TestMethodUtility.createOpportunity(acc,pb);
        insert op;
        op.CPQ_Is_Discount_Approval__c = True;
        op.CPQ_Is_Treasury_Approval__c = True;
        op.owner = u;
        op.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'CPQ New Sales Opportunity Record Type'].Id;
        update op;
        
        System.RunAs(u)
        {
        ApprovalItemController cont = new ApprovalItemController();
        cont.RecordId = op.Id;
        cont.relatedRecordId = op.Id;
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(op.Id);
        //Approval.ProcessResult reqResult = Approval.process(testReq);
            
        //System.assert(reqResult.isSuccess(),'Unable to submit new Order Request record for approval');
        }
            
        //Id wrkitem = reqResult.getNewWorkitemIds()[0];
        /*
         Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
            testRej.setComments('Rejecting request with a comment.');
            testRej.setAction  ('Pending');
            testRej.setWorkItemId(wrkitem );
        
            Test.startTest();        
            
            // Process the rejection
            Approval.ProcessResult testRejResult =  Approval.process(testRej);
            
            Test.stopTest();
            
         */
    }
    static testMethod void myUnitTest2() 
    {
        Account acc = TestMethodUtility.createAccount();
        insert acc;
        
        contact c= TestMethodUtility.createContact(acc);
        insert c;
        
        contact c3= TestMethodUtility.createContact(acc);
        c3.Email='testmail@abc.com';
        insert c3;
           
        Product2 pr =TestMethodUtility.createProduct();
        pr.Type__c='Services';
        insert pr;
        
        //Standard pricebook
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
        
        Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
        
        PricebookEntry pes = TestMethodUtility.createPricebookEntry(standardPB,pr);
        pes.UseStandardPrice = false;
        insert pes;
        
        PricebookEntry pe = TestMethodUtility.createPricebookEntry(pb,pr);
        pe.UseStandardPrice = false;
        insert pe;
        
        Profile p =[select id from Profile where Name='System Administrator'];
        
        User u = TestMethodUtility.createUser(p);
        u.Approval_Routing_Discount_Tier__c ='BD -1 Tier';
        insert u;
       
        System.RunAs(u)
        {
            Opportunity op =TestMethodUtility.createOpportunity(acc,pb);
            op.CPQ_Is_Discount_Approval__c = True;
            op.CPQ_Is_Perpetual_Approval__c = True;
            op.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'CPQ New Sales Opportunity Record Type'].Id;
            insert op;
            
            Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
            testReq.setObjectId(op.Id);
          
        }
            
        
    }
       
}