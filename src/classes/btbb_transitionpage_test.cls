@isTest 
public class btbb_transitionpage_test {


static testMethod void myUnitTest() {

    apexpages.currentpage().getparameters().put('web','web1');
    test.startTest();
    btbb_transitionpage cont = new btbb_transitionpage();
    cont.redirect();
    test.stopTest();

}

    


}