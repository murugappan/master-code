@isTest
Private class bb_opportunity_cross_sellTest {

    static testMethod void bb_opportunity_cross_sel()
    {
    Profile p = [select id from profile where name='System Administrator'];
 
    User user = TestMethodUtility.createUser(p);
    insert user;
    Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
    
     Account account = new Account(Name = 'Name',Key_Account__c=True, Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
     insert account;   
     List<Opportunity> op = new List<Opportunity>();
     Opportunity opportunity = new Opportunity(Name = 'Apex Test',RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification',CloseDate = date.today(), AccountID = account.Id,Originating_User__c=user.id);  
     op.add(opportunity); 
     Insert op;
     Opportunity opp = new Opportunity(Name = 'Apex ',xsell_master_opportunity__c=opportunity.id, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification',CloseDate = date.today(), AccountID = account.Id);   
     insert opp;
     //bb_opportunity_cross_sell.cross_sell_oppr(op);
    }
 static testMethod void bb_opportunity_cross_sel1()
    {
    Profile p = [select id from profile where name='System Administrator'];
    Id bbCollabRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Collaborate Unlocked Opportunity'].Id;
    User user = TestMethodUtility.createUser(p);
    insert user;
    
     List<Opportunity> op1 = new List<Opportunity>();
     Account acc = new Account(Name = 'Test Name',Key_Account__c=True, Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
     insert acc;  
     Opportunity opportunity1 = new Opportunity(Name = 'Test Test',RecordTypeId = bbCollabRecordTypeId, Type = 'New Business', Revenue_Type__c = 'New', Contract__c = 'Annual', StageName = '(S) Suspect Qualification',CloseDate = date.today(), AccountID = acc.Id,Originating_User__c=user.id);  
     op1.add(opportunity1);
     insert op1;
     //bb_opportunity_cross_sell.cross_sell_oppr(op1);
       
    
  }
}