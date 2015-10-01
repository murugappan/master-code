@isTest

public Without Sharing class SalesforceCanvasTest
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
        
        Account ac2 = TestMethodUtility.createAccount();
        insert ac2;
        
        
        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.LastPasswordChange__c= DateTime.now();
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
               
          User u1= new User();
          u1.ProfileID = [Select Id From Profile Where Name='SRV - BTBB User'].id;
          u1.EmailEncodingKey = 'ISO-8859-1';
          u1.LanguageLocaleKey = 'en_US';
          u1.TimeZoneSidKey = 'America/New_York';
          u1.LocaleSidKey = 'en_US';
          u1.FirstName = 'first';
          u1.LastName = 'last';
          u1.Username = 'test@bb.com';   
          u1.CommunityNickname = 'testUser123';
          u1.Alias = 't1';
          u1.Email = 'no@email.com';
          u1.IsActive = true;
          u1.ContactId = cont.Id;
          insert u1; 
        
        
          User u2=[Select id,ProfileID,EmailEncodingKey ,LanguageLocaleKey,LocaleSidKey,FirstName,LastName,Username,CommunityNickname,Alias,Email,IsActive,ContactId ,contact.LastPasswordChange__c from User where id=:u1.id ];   
           

          system.runas(u2)
          {
              salesforcecanvas controller= new salesforcecanvas();
              PageReference pageRef = Page.CanvasPage;
              test.setcurrentpage(pageref);
              controller.Redirect(); 
              controller.getmessage();
          }

           User guestuser= [Select id from user where username like 'btbb@blackboard.force%' limit 1];
        
          system.runas(guestuser)
          {
            salesforcecanvas controller2= new salesforcecanvas();
            PageReference pageRef2 = Page.CanvasPage;
            test.setcurrentpage(pageref2);
            controller2.Redirect();
         }
     }
   }
}