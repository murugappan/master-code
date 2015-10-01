@istest

public class btbb_udhp_test {

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
    
    
    
    ApexPages.currentPage().getParameters().put('id',acc.id);
    
    
    
    test.startTest();
    btbb_udhp cont = new btbb_udhp();
    cont.redirect();
    
    ApexPages.currentPage().getParameters().put('id','');
    btbb_udhp cont1 = new btbb_udhp();
    cont.redirect();
    
    
    test.stopTest();


}



}