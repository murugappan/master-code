@istest

public class btbb_htmldisp_test{

static testMethod void myUnitTest(){

    Account acc = new Account();
    acc.Name = 'Widget';
    acc.Market__c = 'K12';
    insert acc;
    
    
    Univs__c univ = new Univs__c();
    univ.Name = 'Test Univ';
    univ.Active__c = true;
    univ.Website__c = null;
    univ.HTML_Text__c = null;
    univ.Account__c = acc.Id;
    insert univ;
    
    
    ApexPages.currentPage().getParameters().put('sid',acc.id);
    

    test.startTest(); 
    
    btbb_htmldisp cont = new btbb_htmldisp();
    
    
 
    test.stopTest();

}


}