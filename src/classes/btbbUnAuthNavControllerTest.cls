@istest

public class btbbUnAuthNavControllerTest{


 static testMethod void UnitTestforPositiveScenarios1() {
        PageReference pageref= Page.btbb_publichome;
        Test.setCurrentPage(pageRef);
        btbbUnAuthNavController controller = new btbbUnAuthNavController();
        btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
           
        authcookie.product = 'collaborate';
        authcookie.createcookie();
        
        List<BtBb_Link__c>  btbbServicelinks=btbbUnAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbUnAuthNavController.getbtbbCommunitylinks();
        boolean b=controller.isCollabuser;
        
        
       

}






static testMethod void UnitTestforNegativeScenarios1() {
        PageReference pageref= Page.btbb_publichome;
        Test.setCurrentPage(pageRef);
        List<BtBb_Link__c>  btbbServicelinks=btbbUnAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbUnAuthNavController.getbtbbCommunitylinks();
        
    }




}