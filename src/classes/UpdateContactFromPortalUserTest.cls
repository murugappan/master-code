@Istest
  Private class UpdateContactFromPortalUserTest
   {
    static testmethod void testUpdateContacts() {   
        Test.startTest();   
        User u = [SELECT ContactId,Email,FirstName,LastName,UserType,ProfileId,Id, NOV_isNew__c, NOV_Reset_Password__c, NOV_Debug__c, NOV_SFDC_User__c, Psft_Operator_ID__c, isActive FROM User WHERE ContactId<>'' limit 1]; 
        
        u.FirstName='Andres';
        u.Street='123 Sesame Street';
        u.Phone='2021230101';
        u.Fax='2021230202';
        u.Country='USA';
        
        update u;
        
        Test.stopTest();
        
        Contact c = [select 
        FirstName, Email, NOV_isActive__c, LastName, Title, NOV_UserId__c, NOV_UserProfileId__c, NOV_UserLicense__c, NOV_isNew__c, NOV_Reset_Password__c, NOV_Debug__c, NOV_Old_BTBB_User__c, NOV_SFDC_Portal_User__c, Psft_Operator_ID__c, NOV_isPilot__c, NOV_Preferred_Site__c
        from Contact where Id=:u.ContactId];
        
     /*   System.assertEquals(c.FirstName,u.FirstName);
        System.assertEquals(c.LastName,u.LastName);
        System.assertEquals(c.Email,u.Email);
        System.assertEquals(c.NOV_isActive__c,u.isActive);
        System.assertEquals(c.NOV_isNew__c,u.NOV_isNew__c);
        System.assertEquals(c.NOV_Reset_Password__c,u.NOV_Reset_Password__c);
        System.assertEquals(c.NOV_Debug__c,u.NOV_Debug__c);        
        System.assertEquals(c.NOV_Old_BTBB_User__c,u.NOV_PSFT_User__c);
        System.assertEquals(c.NOV_SFDC_Portal_User__c,u.NOV_SFDC_User__c);
        System.assertEquals(c.Psft_Operator_ID__c,u.Psft_Operator_ID__c);        
        System.assertEquals(c.NOV_isPilot__c,u.NOV_isPilot__c);
        System.assertEquals(c.NOV_Preferred_Site__c,u.NOV_Preferred_Site__c);*/

    }
  }