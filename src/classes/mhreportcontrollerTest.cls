@isTest(seeAllData=true)
public class mhreportcontrollerTest {

    public static testMethod void mhreportcontrollerTest() {
		Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
		Profile p =[SELECT Id, Name FROM Profile WHERE Name = 'Bb - BD Partner Portal User'];
   		
   		User portalUser = [SELECT id, Name, ContactId, BTBB_KB_Default_Prod__c 
   						   FROM User
   						   WHERE ContactId != null 
   						     AND isActive = true 
   						     AND profileid = :p.id 
   						   LIMIT 1];
   		
   		List<Contact_Role__c> contactRolesCreate = new List<Contact_Role__c>();
   		
   		Contact_Role__c cr1 = new Contact_Role__c(Account__c= a.Id, Contact__c = portalUser.ContactId, Role__c = 'LEARN');
        contactRolesCreate.add(cr1);
        
        Contact_Role__c cr2 = new Contact_Role__c(Account__c = a.Id, Contact__c = portalUser.ContactId, Role__c = 'ANGEL');
        contactRolesCreate.add(cr2);
        
        insert contactRolesCreate;
   		
        mhreportcontroller mhr = new mhreportcontroller();
        mhr.InsightReportRedirect();
        
        System.runAs(portalUser) {
        	mhr.Redirect();
        }        
    }
}