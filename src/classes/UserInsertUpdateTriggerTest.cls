@isTest
private class UserInsertUpdateTriggerTest {

    private static final String PHONE = '123-123-1234';
    private static final String EMAIL = 'test123@testuser.com';
    private static final String TEST_ACCT_1 = 'test_acct_1';
    private static final String TEST_1 = 'test 1';
    
    static testMethod void testUserInsertWithoutConfigTrigger()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
    
    static testMethod void testUserUpdateWithoutConfigTrigger()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);

            //delete existing records
            userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;

            u.BMNumberFormat__c='####.##';
            u.BMDateFormat__c = 'MM/dd/yyyy HH:mm';
            u.Department = BMGlobal.TEST_USER;
            update u;
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
        
    static testMethod void testUserUpdateTrigger()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);

            u.BMNumberFormat__c='####.##';
            u.BMDateFormat__c = 'MM/dd/yyyy HH:mm';
            u.Department = BMGlobal.TEST_USER;
            update u;
            System.assert(u.BMNumberFormat__c=='####.##');
            System.assert(u.BMDateFormat__c=='MM/dd/yyyy HH:mm');
            
            u.isActive=false; 
            u.isBMEnabled__c = true;
            u.Department = BMGlobal.TEST_USER;
            update u;
            System.assert(u.isActive==false);

            u.isActive=true; 
            u.isBMEnabled__c = false;
            u.Department = BMGlobal.TEST_USER;
            update u;
            System.assert(u.isBMEnabled__c==false);
            
            u.isActive=true; 
            u.isBMEnabled__c = true;
            u.Department = BMGlobal.TEST_USER;
            update u;
            System.assert(u.isBMEnabled__c==true);
            
            u.isActive=false; 
            u.isBMEnabled__c = false;
            u.Department = BMGlobal.TEST_USER;
            update u;
            System.assert(u.isBMEnabled__c==false);
            
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }   

    static testMethod void testInsertUpdateHundredUserTrigger()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            List<User> users = new List<User>();
            for (integer i=0; i <= 100; i++)
            {
                System.debug('Before 100 Insert');
                //Database.DMLOptions dmo = new Database.DMLOptions();
                //dmo.EmailHeader.triggerUserEmail = true;
                User u = TestMethodUtility.createUser(profile);
                u.isBMEnabled__c = true;
                u.Department = BMGlobal.TEST_USER_100;
                //u.setOptions(dmo);
                users.add(u);
                System.debug('After 100 Insert');
            }
            //Now insert data causing an contact trigger to fire. 
            Test.startTest();
            insert users;
            for (integer i=0; i <= 100; i++)
            {
                users[i].isActive = false;
            }       
            update users;
            Test.stopTest();
            System.AssertEquals(users.size(),[Select Name FROM User WHERE Department = :BMGlobal.TEST_USER_100].size());
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update 100 user ' + ex.getMessage());
        }
    }   
        
    private static BMUserSecurity__c getBmSec(){
        BMUserSecurity__c bmSec = new BMUserSecurity__c();
        bmSec.isActive__c = true;       
        bmSec.APIUserName__c = 'BM API User';
        bmSec.APISubDomain__c = 'BM Endpoint';
        bmSec.APIUserPassword__c = 'BM password';
        bmSec.AdminEmail__c = 'email@email.com';    
        bmSec.BMSSLRequired__c = false;
        return bmSec;   
    
    }
    
    static testMethod void testUserInsertWithoutConfigTrigger2()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;
            
            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After testUserInsertWithoutConfigTrigger2 Insert');
            System.assert(u!=null);
            
            u.isBMEnabled__c = false;
            update u;
            System.debug('After testUserInsertWithoutConfigTrigger2 Update');
            System.assert(u!=null);
        
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
        
    static testMethod void testUserInsertUpdateAndInactivateUser()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);
            
            u.isBMEnabled__c = false;
            u.IsActive = false;
            update u;
            System.debug('After Update');
            System.assert(u!=null);
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
    /*
    static testMethod void testUserInsertInvalidConfigTriggerForPortalUser()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Customer Portal Manager'];
            Contact contact = [select c.id from Contact c where Name = 'Sean%' LIMIT 1];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = new User(alias = 'testus', email='vishkash@gmail.com', 
                emailencodingkey='UTF-8', lastname='testuser', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = profileId, isActive=true, BMNumberFormat__c='####,##',
                BMDateFormat__c = 'MM/dd/yyyy h:mm a', timezonesidkey='America/New_York', 
                BMUserType__c = BMGlobal.BM_INTERNAL_USER, BMMassProvisioning__c = false, contactId = contact.Id,
                BMUserAccessType__C = 'FullAccess',         
                username='testuser77@comitydesigns.com' );
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
    
    static testMethod void testUserInsertValidConfigTriggerForPortalUser()
    {
        try
        {
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Customer Portal Manager'];
            Contact contact = [select c.id from Contact c where Name = 'Sean%' LIMIT 1];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');          
            User u = new User(alias = 'testus', email='vishkash@gmail.com', 
                emailencodingkey='UTF-8', lastname='testuser', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = profileId, isActive=true, BMNumberFormat__c='####,##',
                BMDateFormat__c = 'MM/dd/yyyy h:mm a', timezonesidkey='America/New_York', 
                BMUserType__c = BMGlobal.BM_PARTNER_USER, BMMassProvisioning__c = false, contactId = contact.Id,            
                BMUserAccessType__c = 'FullAccess', username='testuser77@comitydesigns.com' );
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            insert u;
            System.debug('After Insert');
            System.assert(u!=null);
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
    */
    // Add test account
    private static Account AddAccount(String accountName)
    {
        // Create a RecordTypeLookup__c 
        Account acct = new Account(Name = accountName);
        insert acct;
        System.debug('account added');
        return acct;
    }
    
    // Add test contact
    private static Contact AddContact(String firstName, String lastName, String accountId)
    {
        // Create a RecordTypeLookup__c 
        Contact contact = new Contact(FirstName = firstName, LastName = lastName, Phone = PHONE, Email = EMAIL, AccountId = accountId);
        insert contact;
        System.debug('contact added');
        return contact;
    }
    
    static testMethod void testUserInsertCheckErrorTrigger()
    {
        try
        {
            // Instantiate Page
            String accountName = TEST_ACCT_1;
            Account acct = AddAccount(TEST_ACCT_1);
            System.debug('acct = ' + acct);
    
            Contact contact = AddContact(TEST_1, TEST_1, acct.Id);
            System.debug('contact = ' + contact);
        
            //delete existing records
            BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
            delete userSecurities;
            
            // Insert new bm security record
            BMUserSecurity__c bmSec = getBmSec();   
            insert bmSec;

            Profile[] profiles = [Select p.name, p.id From Profile p WHERE Name = 'Standard User'];
            Profile profile;
            if (profiles.size() > 0)
                profile = profiles[0];
            System.Debug('User.ProfileId - ' + profile.Id);
            String profileId = profile.Id;
            
            
            //Now insert data causing an user trigger to fire. 
            Test.startTest();
            System.debug('Before Insert');
            
            // User access type not set         
            User u = TestMethodUtility.createUser(profile);
            u.isBMEnabled__c = true;
            u.BMMassProvisioning__c = false;
            u.Department = BMGlobal.TEST_USER;              
            try
            {
                insert u;
            }
            catch(Exception ex)
            {
                System.debug('User access type error = ' + ex.getMessage());
                System.assert(ex.getMessage().contains('Please select valid BM User Access Type.'));
            }
            try
            {
                u.BMUserType__c = BMGlobal.BM_PARTNER_USER;
                insert u;
            }
            catch(Exception ex)
            {
                System.debug('User access type error = ' + ex.getMessage());
                //Commented out by Etienne Coutant on July 14th 2011.
                //System.assert(ex.getMessage().contains('Please select valid BM User Access Type.'));
            }
            System.debug('After Insert');
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            System.debug('Exception for insert/update user ' + ex.getMessage());
        }
    }
}