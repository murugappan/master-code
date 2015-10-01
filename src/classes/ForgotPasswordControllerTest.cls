@isTest

public Without Sharing class ForgotPasswordControllerTest
{
    @testSetup
    public static void DataSetup()
    {
       Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 
        
        
        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.LastPasswordChange__c= DateTime.now();
        cont.PS_Person_Id__c='67367332';
        insert cont;
    }

    public static TestMethod void TestMethod1()
    {
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.cemail = 'testxyhakak@bb.com';        
        System.assertEquals(controller.forgotPassword(),null); 

        controller = new ForgotPasswordController();
        controller.cemail = 'testxyhakak@blackboard.com';        
        System.assertEquals(controller.forgotPassword(),null); 
        
        controller = new ForgotPasswordController();       
        System.assertEquals(controller.forgotPassword(),null); 
        contact cont=[select id from contact where PS_Person_Id__c='67367332'];
        test.starttest();
               
          User u1= new User();
          u1.ProfileID = [Select Id From Profile Where Name='SRV - BTBB User'].id;
          u1.EmailEncodingKey = 'ISO-8859-1';
          u1.LanguageLocaleKey = 'en_US';
          u1.TimeZoneSidKey = 'America/New_York';
          u1.LocaleSidKey = 'en_US';
          u1.FirstName = 'first';
          u1.LastName = 'last';
          u1.Username = 'test@email.com';   
          u1.CommunityNickname = 'testUser123';
          u1.Alias = 't1';
          u1.Email = 'testabxno@email.com';
          u1.IsActive = true;
          u1.ContactId = cont.Id;
          u1.NOV_Preferred_Site__c='Learn';
          insert u1; 

        test.stoptest(); 

        controller = new ForgotPasswordController();
        controller.cemail = 'testabxno@email.com';        
        System.assertEquals(controller.forgotPassword().getURL(),Page.ForgotPasswordConfirm.getURL()); 

    } 
}