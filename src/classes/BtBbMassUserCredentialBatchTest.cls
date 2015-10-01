@isTest
public  Without Sharing class BtBbMassUserCredentialBatchTest {
	
	 public static void test_method_one() {
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
          u1.ismigration__c=true;
          insert u1;

          BtBbMassUserCredentialBatch batchobject = new BtBbMassUserCredentialBatch();
          database.executebatch(batchobject,100) ;
	}
	}
	
}