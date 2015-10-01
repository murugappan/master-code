@isTest
private class CRDecisionTriggerHandlerTest {

    static testMethod void myUnitTest() {
    
    Change_Request__c Cr = new Change_Request__c();
    Cr.CurrencyIsoCode='GBP';
    //Cr.Name='Test Test';
    Cr.Admin_Dev_Tasks__c='Configuration - Field';
    insert Cr;
    
    
    CR_Approver_Group__c Ca = new CR_Approver_Group__c();
    Ca.Name='Test name';
    Ca.CurrencyIsoCode='GBP';
    insert Ca;
    
    CR_Decision__c  Crd = new CR_Decision__c();
    Crd.CurrencyIsoCode='GBP';
    Crd.Change_Request__c=Cr.id;
    Crd.CR_Approver_Group__c=Ca.id;
    Crd.Status__c='Pending';
    insert Crd;
    
    list<CR_Decision__c> oldList = new list<CR_Decision__c>();
    oldList.add(Crd);
    
    
    Crd.Status__c='Approved';
    Crd.Comments__c='Decision has been approved';
    update Crd;
    
    list<CR_Decision__c> newList = new list<CR_Decision__c>();
    newList.add(Crd);
    
    CR_Approver_Group__c Cra = new CR_Approver_Group__c();
    Cra.Name='Test group';
    Cra.CurrencyIsoCode='GBP';
    Insert Cra;
    
    
    CR_Approver_Group_Member__c Cagm = new CR_Approver_Group_Member__c();
    Cagm.CurrencyIsoCode='GBP';
    Cagm.CR_Approver_Group__c=Ca.id;
    Cagm.Type__c='Primary Approver';
    Insert Cagm;
    
    CR_Approver_Group_Member__c Cagm1 = new CR_Approver_Group_Member__c();
    Cagm1.CurrencyIsoCode='GBP';
    Cagm1.CR_Approver_Group__c=Cra.id;
   // Cagm.Type__c='Primary Approver';
    Insert Cagm1;
    
    
    CR_Decision__c  Crd1 = new CR_Decision__c();
    Crd1.CurrencyIsoCode='GBP';
    Crd1.Change_Request__c=Cr.id;
    Crd1.CR_Approver_Group__c=Cra.id;
    Crd1.Status__c='Pending';
    insert Crd1;
    
    
    list<CR_Decision__c> newList1 = new list<CR_Decision__c>();
    newList1.add(Crd1);
    
    
    CRDecisionTriggerHandler con = new CRDecisionTriggerHandler();
    con.beforeInsert(newList);
    con.beforeUpdate(newList,oldList);
    con.afterInsert(newList);
    CRDecisionTriggerHandler con1 = new CRDecisionTriggerHandler();
    con1.afterInsert(newList1);
    
    
    
       
       }
   }