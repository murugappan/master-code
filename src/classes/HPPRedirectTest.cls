@istest

public class HPPRedirectTest {

static testMethod void myUnitTest(){

    
    
    
    
    ApexPages.currentPage().getParameters().put('weblink','www.google.com');
    
    
    
    test.startTest();
    
    HPPRedirect hpp = new HPPRedirect();
    hpp.mlist= 'www.google.com';
    hpp.redirect();
    
    
    test.stopTest();


}



}