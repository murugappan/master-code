@isTest
private class UpdateSendEmailTriggerTest {

    public static testmethod void sendemailtest(){
    
    Account a = new Account();
    a.Name = 'Test Account';
    a.BillingStreet = 'Test Street';
    a.BillingCity = 'Test City';
    a.BillingState = 'Test State';
    a.BillingCountry = 'Test Country'; 
    a.BillingPostalCode = 'Test Code';
    a.Type = 'Partner';
    
    insert a;
    
   
    
    Case cas = new Case();
    cas.AccountID = a.ID;
    cas.Case_severity__c =  '1';
    cas.Status = 'New';
    insert cas;
    
    Case_Recurring_Email__c cr = new Case_Recurring_Email__c();
    cr.Case__c = cas.ID;
    cr.Pending_User_9_days__c=1234;
    insert cr;
   cr.Pending_User_9_days__c=12345; 
   update cr;
    
    Case_Recurring_Email__c cr1 = new Case_Recurring_Email__c(ID = cr.ID);
    cr1.Send_Email__c = 1;
    Update cr1;
        
    }

}