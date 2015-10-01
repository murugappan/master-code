@isTest //(seeallData=True)

public Without Sharing class LoginPageControllerTest
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
        
       /* Account ac2 = TestMethodUtility.createAccount();
        insert ac2; */
        
        
        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.LastPasswordChange__c= DateTime.now();
        cont.PS_Person_Id__c='67367332';
        insert cont;
        
            test.starttest();
               
          User u1= new User();
          u1.ProfileID = [Select Id From Profile Where Name='SRV - BTBB User'].id;
          u1.EmailEncodingKey = 'ISO-8859-1';
          u1.LanguageLocaleKey = 'en_US';
          u1.TimeZoneSidKey = 'America/New_York';
          u1.LocaleSidKey = 'en_US';
          u1.FirstName = 'first';
          u1.LastName = 'last';
          u1.Username = 'test@appirio.com';   
          u1.CommunityNickname = 'testUser123';
          u1.Alias = 't1';
          u1.Email = 'testabxno@email.com';
          u1.IsActive = true;
          u1.ContactId = cont.Id;
          u1.NOV_Preferred_Site__c='Learn';
          insert u1; 
          ResetPasswordResult rpr = System.resetPassword(u1.id,false);
          
          
    
			PageReference pageRef = Page.login;	
			test.setcurrentpage(pageref);

			LoginpageController controller=new LoginpageController();	
      controller.redirect();

      //Login with wrong credential
      controller.login();
      controller.cemail='testabxno@email.com';
      controller.password='testpassword';
			controller.login();

      
      //Login with right credential
      controller=new LoginpageController(); 
      controller.cemail='testabxno@email.com';
      controller.password=rpr.getPassword();
      controller.login();

      pageRef = Page.login; 
      pageref.getparameters().put('TARGET','/btbb_casesearch');
      test.setcurrentpage(pageref);
      controller=new LoginpageController(); 
      controller.cemail='testabxno@email.com';
      controller.password=rpr.getPassword();
      controller.login();

      
      pageRef = Page.login; 
      pageref.getparameters().put('TARGET','/stgbehind.blackboard.com/s/');
      test.setcurrentpage(pageref);
      controller=new LoginpageController(); 
      controller.cemail='testabxno@email.com';
      controller.password=rpr.getPassword();
      controller.login();
      user u2=[select id,NOV_Preferred_Site__c from user where id=:u1.id];
      u2.NOV_Preferred_Site__c='Transact';
      update u2;
      pageRef = Page.login; 
      test.setcurrentpage(pageref);
      controller=new LoginpageController(); 
      controller.cemail='testabxno@email.com';
      controller.password=rpr.getPassword();
      controller.login();
      controller.redirect();
		//	u1.Psft_Operator_ID__c='ss3456';
		//	update u1;
		  test.stoptest();
  
    }

  }
}