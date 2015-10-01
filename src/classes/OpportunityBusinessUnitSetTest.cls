@isTest (SeeAllData=True)
private class OpportunityBusinessUnitSetTest {

    static testMethod void createOpportunity() {
        
        KimbleOne__BusinessUnit__c BU1 = [Select ID From KimbleOne__BusinessUnit__c Where KimbleOne__IsOperatingEntity__c = TRUE LIMIT 1];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.KimbleOne__IsCustomer__c = true;
        
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        acc1.KimbleOne__IsCustomer__c = true;
        acc1.KimbleOne__InvoicingCurrencyIsoCode__c = 'USD';
        acc1.KimbleOne__BusinessUnit__c = BU1.Id;
        insert acc1;        
        
        Opportunity opp = new Opportunity();        
        opp.Name = 'Test Sales Opp';
        opp.AccountId = acc.Id;
        opp.KimbleCRMInt__BusinessUnit__c = BU1.Id;
        opp.StageName = 'Initial Stage';
        opp.Probability = 30;
        opp.CloseDate = date.today();
        
        insert opp;
        
        Opportunity opp1 = new Opportunity();       
        opp1.Name = 'Test Sales Opp';
        opp1.AccountId = acc.Id;
        opp1.StageName = 'Initial Stage';
        opp1.Probability = 30;
        opp1.CloseDate = date.today();
        
        insert opp1;
        
        Opportunity opp2 = new Opportunity();        
        opp2.Name = 'Test Sales Opp';
        opp2.AccountId = acc1.Id;
        opp2.StageName = 'Initial Stage';
        opp2.Probability = 30;
        opp2.CloseDate = date.today();
        
        insert opp2;

    }
}