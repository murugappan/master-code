@istest

public class btbb_deactivedisplay_test{


static testMethod void myUnitTest(){

    Account acc = new Account();
    acc.Name = 'Test Univ';
    acc.Market__c = 'K12';
    acc.PS_Company_Id__c = '12345';
    insert acc;
    
    ApexPages.currentPage().getParameters().put('id',acc.id);
    

    test.startTest(); 
    
    btbb_deactivedisplay cont = new btbb_deactivedisplay();
    
    
    ApexPages.currentPage().getParameters().put('id','');
     btbb_deactivedisplay cont1 = new btbb_deactivedisplay();
    
    test.stopTest();

}



}