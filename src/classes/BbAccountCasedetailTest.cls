@istest

public class BbAccountCasedetailTest {

static testMethod void myUnitTest(){

    
    Account acc = new Account();
    acc.Name = 'Test Account';
    acc.KimbleOne__IsCustomer__c = true;
        
    insert acc;
    
    
    
    
    ApexPages.currentPage().getParameters().put('id',acc.id);
    
    
    
    test.startTest();
    
    
    ApexPages.currentPage().getParameters().put('id',acc.id);
    BbAccountCasedetail sendtoC = new BbAccountCasedetail(new ApexPages.StandardController(acc));
    
    
    test.stopTest();


}



}