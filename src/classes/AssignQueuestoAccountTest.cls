/*
This is testclass for AssignQueuestoAccount
Date:20.05.2013
*/
@isTest
private class AssignQueuestoAccountTest {

    static testMethod void myUnitTest() {
        
        Account ac = TestMethodUtility.createAccount();
        insert ac;
        string s1;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getLearnList();
        aq.getLearnHList();
        aq.getLearnCList();
        aq.getAngelList();
        aq.getCEList();
        aq.getCEHList();
        aq.getXythosList();
        aq.getMoodleroomsList();

        aq.getTransList();
        aq.getUsers();
        aq.learnselectuser();
        aq.learnselectqueue();
        aq.cevistaselectuser();
        aq.cevistaselectqueue();
        aq.cevistahostedselectuser();
        aq.cevistahostedselectqueue();
        aq.angelselectuser();
        aq.angelselectqueue();
        aq.transselectuser();
        aq.transselectqueue();
        aq.xythoselectuser();
        aq.xythoselectqueue();
        aq.Moodleroomsselectuser();
        aq.Moodleroomsselectqueue();
        aq.learnhostedselectuser();
        aq.learnhostedselectqueue();
        aq.learncompselectuser();
        aq.learncompselectqueue();
        aq.assigntoAccount();
        
        
    } 
    
     static testMethod void myUnitTest1() {
       

       Account ac = TestMethodUtility.createAccount();
       ac.Learn_Queue__c='Aaron Morrison';
       ac.Learn_Hosted_Queue__c='Aaron Morrison';
       ac.Learn_Complex_Queue__c='Aaron Morrison';
       ac.CE_Vista_Queue__c='Aaron Morrison';
       ac.CE_Vista_Hosted__c='Aaron Morrison';
       ac.Transact_Queue__c='Aaron Morrison';
       ac.Xythos_Queue__c='Aaron Morrison';
       ac.Moodlerooms_Queue__c='Aaron Morrison';
        ac.Analytics_Queue__c='Aaron Morrison';
        ac.Angel_Queue__c='Aaron Morrison';
        ac.Collaborate_Queue__c='Aaron Morrison';

        insert ac;
       

       ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.assigntoAccount();
       

     }

     static testMethod void AnalyticsPositiveUnitTest(){

        Account ac = TestMethodUtility.createAccount();
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getAnalyticsList();
        aq.Analyticsselectuser();
        aq.Analyticsselectqueue();
        aq.assigntoAccount();
        }

      static testMethod void ANGELPositiveUnitTest(){

        Account ac = TestMethodUtility.createAccount();
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getAngelList();
        aq.angelselectuser();
        aq.angelselectqueue();
        aq.assigntoAccount();
        }
        static testMethod void CollaboratePositiveUnitTest(){

        Account ac = TestMethodUtility.createAccount();
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getCollabList();
        aq.collabselectuser();
        aq.collabselectqueue();
        aq.assigntoAccount();
        }
        static testMethod void LearnSaaSPositiveUnitTest(){

        Account ac = TestMethodUtility.createAccount();
        ac.Learn_SaaS_Queue__c='Learn Queue';
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getLearnSaaSList();
        aq.learnsaasselectuser();
        aq.learnsaasselectqueue();
        aq.assigntoAccount();
        }

        static testMethod void xpLorPositiveUnitTest(){

        Account ac = TestMethodUtility.createAccount();
        ac.xpLor_Queue__c='xpLor Queue';
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getxpLorList();
        aq.xpLorselectuser();
        aq.xpLorselectqueue();
        aq.assigntoAccount();
        }
     
}