/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @isTest(SeeAllData=true)
private class TestTaskStamping {

    static testMethod void myUnitTest()  
    {

        String accountId = '0017000000SeU0BAAV';
        String contactId = '0037000000bnL3ZAAU';
        String opportunityId = '0067000000EhPorAAF';

        Task t = new Task ();
        t.OwnerId = UserInfo.getUserId();
        t.Subject = 'Email: SFDC: Please Approve Quote for Jon Lal';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        
        t.WhatId = opportunityId;
        t.WhoId = contactId;
        insert t;

        delete t;
    }

    static testMethod void myUnitTest2() 
    {
        Lead l = new Lead(Company = 'Test Co',LastName='Test',Status='Prospect',Rejection_Reason__c='Refer for technical follow-up',Secondary_Market__c='K12');
        insert l;

        Account a = TestMethodUtility.createAccount();
        insert a;
        
        contact c= TestMethodUtility.createContact(a);
        c.Email='testmail@abc.com';
        insert c;

        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
        Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
        
        Opportunity opp = TestMethodUtility.createOpportunity(a,pb);
        insert opp;
        System.debug('Opp'+opp);
        
        Date dt = System.today();
        //Task tsk = new Task(Type ='Faculty Engagement (NAHE)',Subject = 'Email: SFDC: Please Approve Quote for',Status='Completed',ActivityDate=dt,Priority = 'Normal',Whatid = a.id );
        //insert tsk;

        Task tsk2 = new Task(Type ='Faculty Engagement (NAHE)',Subject = 'Testing',WhoId = c.id,Status='Completed',Priority = 'Normal',Whatid = a.id );
        insert tsk2;

        Task tsk3 = new Task(Type ='Faculty Engagement (NAHE)',Subject = 'Testing',Status='Completed',Priority = 'Normal',ActivityDate=dt,Whatid = opp.id );
        insert tsk3;

        Task tsk4 = new Task(Type ='Email',OwnerId= UserInfo.getUserId(),Subject = 'Testing',Status='Completed',Priority = 'Normal',ActivityDate=dt,WhoId=l.Id );
        insert tsk4;

     /*   Task tsk5 = new Task(Type ='Faculty Engagement (NAHE)',Subject = 'Email: SFDC: Please Approve Quote for ',Status='Completed',ActivityDate=dt,Priority = 'Normal',Whatid = opp.id );
        insert tsk5;  */
    }
}