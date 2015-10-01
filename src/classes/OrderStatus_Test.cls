@istest(SeeAllData=True)

public class OrderStatus_Test {

private static testMethod void testOrderStatus(){

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


        //https://qax-blackboard.cs30.force.com/apex/OrderStatus?id=0067000000adRfr/%20totalv=$2159.92/totaloliv=$2000.0/totaltaxv=$159.92/$(LEARN%20COMMERCIAL%20DEVELOPER,%20ANGEL%20LMS%20ADDL%20TEST/DEV%20LIC,%20COURSE%20DELIVERY%20DEVELOPER)/BBDN-0067000000adRfr_1425865351036


        ApexPages.currentPage().getParameters().put('id','0067000000adRfr/totalv=$2159.92/totaloliv=$2000.0/totaltaxv=$159.92/$(LEARN COMMERCIAL DEVELOPER, ANGEL LMS ADDL TEST/DEV LIC, COURSE DELIVERY DEVELOPER)/BBDN-0067000000adRfr_1425865351036');
        orderstatus  controller  = new orderstatus();


}




}