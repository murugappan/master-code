@isTest
private class NOV_UserManagerExtensionTest {
    static testmethod void MyTest()
    {
     Profile p = [select id,Name from profile where name='SRV - BTBB User'];
    // UserRole R =[select id from UserRole where name='Collaborate Product Manager'];
   /*  User testUser = new User();
        testUser.Email = 'test@test.com';
        testUser.Username = 'test123@noemail.com';
  
            
        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = p.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.EmailEncodingKey = 'UTF-8';
       // testUser.UserRoleId = R.id;
        insert testUser;
         if (p.name == 'Customer Portal User')
        {
            //Won't work w/o customer portal  
            Contact c = new Contact(LastName = 'D');
            insert c;
            testUser.contactId = c.id;
        }
        
        Update testUser;
    */
    
    User u =[select id, Name,contactId from user where contactId != Null and isactive= True limit 1]; 
    contact co = new contact(FirstName = 'Anil',LastName = 'Dutt',Email = 'Nikhil.kumar6@wipro.com');
    insert co;
    u.contact=co;
    
    update u;
     
   // update user;
   System.Runas(u)
    
    
    {
    
    
    ApexPages.StandardController con = new ApexPages.StandardController(co);
    NOV_UserManagerExtension ps = new NOV_UserManagerExtension(con); 
    ps.getContactFirstName();
    ps.getContactLastName();
    ps.getContactEmail();
    ps.getContactPersonId();
    ps.getCredentialedDate();
    ps.getCustomerPortalProfiles();
    ps.getContactUserId();
    ps.getActiveUserStatus();
    ps.getNOVisNew();
    ps.getNOVDebug();
    ps.getResetUserPassword();
    ps.getUserEmail();
    ps.getPSFTBTBBAccess();
    ps.getUserOperatorId();
    ps.getUserUsername();
    ps.getSFDCBTBBAccess();
    ps.getPilotUser();
    ps.getUserPreferredSite();
    ps.ResetPassword();
    ps.Deactivate();
    ps.GoToUser();
    ps.CreateUser();
    
    
      }
    }
    
    
   }