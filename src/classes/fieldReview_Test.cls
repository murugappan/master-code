@istest(seealldata=True)
private class fieldReview_Test {

    static testMethod void myUnitTest() {
    
        KimbleOne__BusinessUnit__c BU1 = [Select ID From KimbleOne__BusinessUnit__c Where KimbleOne__IsOperatingEntity__c = TRUE LIMIT 1];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.KimbleOne__IsCustomer__c = true;
        
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'oppName', AccountId = acc.Id, StageName = '(S) Suspect Qualification', CloseDate = Date.today());
        insert opp;
        
       
        
                
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        feildReview  ca = new feildReview(controller);
        ca.loadOpportunity();
      
    }
}