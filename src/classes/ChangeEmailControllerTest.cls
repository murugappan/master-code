@isTest//(seeallData=True)

public Without Sharing class ChangeEmailControllerTest
{
    public static TestMethod void TestMethod1()
    {
    user systemuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
    system.runas(systemuser)
    {
  
          Account ac=TestMethodUtility.createAccount();
          ac.ownerid=userinfo.getuserid();
          ac.PS_Company_ID__c='78907';
          insert ac;
          
          Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
          cont.LastPasswordChange__c= DateTime.now();
          cont.PS_Person_Id__c='67367332';
          insert cont; 
            
         
          User u1= new User();
          u1.ProfileID = [Select Id From Profile Where Name='SRV - BTBB User'].id;
          u1.EmailEncodingKey = 'ISO-8859-1';
          u1.LanguageLocaleKey = 'en_US';
          u1.TimeZoneSidKey = 'America/New_York';
          u1.LocaleSidKey = 'en_US';
          u1.FirstName = 'first';
          u1.LastName = 'last';
          u1.Username= 'test@appirio.com';   
          u1.CommunityNickname = 'testUser123';
          u1.Alias = 't1';
          u1.Email = 'no@email.com';
          u1.IsActive = true;
          u1.ContactId = cont.Id; 
          insert u1;
          
        user guestuser=[select id from user where profileid in (select id from profile where name like 'BTBB profile') limit 1];
         Test.startTest();
           
          system.runas(guestuser)
          {
            ChangeEmailController controller=new ChangeEmailController(); 
           controller.Redirect();       
          }
         system.runas(u1)
          { 
            ChangeEmailController controller=new ChangeEmailController(); 
              controller.cEmail = 'test@xyz.com';
              controller.changeEmail();
              controller.Redirect();
              controller.cancel();
               Test.stopTest();
          }
        
    }
  }
}