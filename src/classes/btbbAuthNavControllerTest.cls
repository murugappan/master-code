/**
 * This class contains unit tests for validating the behavior of BtbbAuthNavController.
 *
 */
@isTest
private class btbbAuthNavControllerTest {

    static testMethod void UnitTestforPositiveScenarios1() {
        PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbAuthNavController controller = new btbbAuthNavController();
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
        authcookie.product='Collaborate';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbAuthNavController.getbtbbCommunitylinks();
        boolean b=controller.isreadonly;
        controller.getlogoclass();
        
        
        authcookie.product='Learn';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks1=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks1=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller1 = new btbbAuthNavController();
        controller1.getlogoclass();
        
        
        authcookie.product='Vista';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks2=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks2=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller2 = new btbbAuthNavController();
        controller2.getlogoclass();
        
        
        authcookie.product='Xythos';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks3=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks3=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller3 = new btbbAuthNavController();
        controller3.getlogoclass();
        
        
        authcookie.product='ANGEL';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks4=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks4=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller4 = new btbbAuthNavController();
        controller4.getlogoclass();
        
        authcookie.product='MMMM';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks6=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks6=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller6 = new btbbAuthNavController();
        controller6.getlogoclass();
        
        
        authcookie.product=null;
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks5=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks5=btbbAuthNavController.getbtbbCommunitylinks();
        btbbAuthNavController controller5 = new btbbAuthNavController();
        controller5.getlogoclass();
        boolean b1=controller5.isreadonly;
        
        
    }
     
    
    static testMethod void UnitTestforNegativeScenarios1() {
        PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        List<BtBb_Link__c>  btbbServicelinks=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbAuthNavController.getbtbbCommunitylinks();
        
    }

    static testMethod void UnitTestforPositiveScenariosAnalytics(){

        PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbAuthNavController contrl = new btbbAuthNavController();
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();

        authcookie.product='Analytics';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbAuthNavController.getbtbbCommunitylinks();
        
        contrl.getlogoclass();
        


    }

    static testMethod void UnitTestforPositiveScenariosxpLor(){

        PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbAuthNavController contrl = new btbbAuthNavController();
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();

        authcookie.product='xpLor';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbAuthNavController.getbtbbCommunitylinks();
        
        contrl.getlogoclass();
        


    }

    static testMethod void UnitTestforPositiveScenariosMoodlerooms(){

        PageReference pageref= Page.btbb_home;
        Test.setCurrentPage(pageRef);
        btbbAuthNavController contrl1 = new btbbAuthNavController();
        btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();

        authcookie.product='Moodlerooms';
        authcookie.createcookie();
        List<BtBb_Link__c>  btbbServicelinks=btbbAuthNavController.getbtbbServicelinks();
        List<BtBb_Link__c>  btbbCommunitylinks=btbbAuthNavController.getbtbbCommunitylinks();
        
        contrl1.getlogoclass();
        


    }
}