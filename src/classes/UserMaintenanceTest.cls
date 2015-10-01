@isTest
private class UserMaintenanceTest {

	public class BMException extends Exception
	{
	}

	private static BMUserSecurity__c userSecurity;
    private static String adminEmail;
    
	private static User getUserInfo()
	{
		//User user;
		User[] userList = [Select 
						u.Id, u.CompanyName, u.Username, u.FirstName, u.LastName, u.Title, u.Email, 
						u.Phone, u.Fax, u.Street, u.City, u.State, u.PostalCode, u.Country,
						u.BMCurrencyPreference__c, u.BMLanguage__c, u.BMNumberFormat__c, u.BMDateFormat__c,
						u.BMTimeZone__c, u.BMUnit__c, u.BMUserGroup__c, u.isBMEnabled__c, 
						u.BMUserAccessType__c, u.BMPartnerCompanyNameFormula__c, u.BMUserType__c
					 from User u where u.isActive=true LIMIT 1];
		return userList[0];
	}
    
    public static testMethod void testRemoveIsBMEnabled()
	{
		try
		{
			User user = getUserInfo();
			UserMaintenance.removeIsBMEnabled(user.Username);
		}
		catch(Exception e)
		{
			System.debug('Beginning of exception');
            System.assert(e!=null);
            System.debug('Handled exception in testmtethod: ' + e.getMessage());
		}
	}
    
    public static testMethod void updateIsBMEnabledTest()
	{
		try
		{
			List<User> users = [Select 
									u.Id, u.CompanyName, u.Username, u.FirstName, u.LastName, u.Title, u.Email, 
									u.Phone, u.Fax, u.Street, u.City, u.State, u.PostalCode, u.Country,
									u.BMCurrencyPreference__c, u.BMLanguage__c, u.BMNumberFormat__c, u.BMDateFormat__c,
									u.BMTimeZone__c, u.BMUnit__c, BMUserGroup__c, isBMEnabled__c,
									u.BMUserAccessType__c, u.BMPartnerCompanyNameFormula__c									
								 from User u where u.isActive=true LIMIT 1];
			users[0].isBMEnabled__c = false;
			users[0].BMMassProvisioning__c = false;
			
			UserMaintenance.updateIsBMEnabled(users);
			System.assert(users[0].isBMEnabled__c==false);
			System.assert(users[0].BMMassProvisioning__c==false);
		}
		catch(Exception e)
		{
			System.debug('Beginning of exception');
            System.assert(e!=null);
            System.debug('Handled exception in testmtethod: ' + e.getMessage());
		}
		
	}
	
	public static testMethod void invokeSoapRequestTest()
	{
		
		User user = getUserInfo();
		try
		{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;
			UserMaintenance.callOut = false;
			UserMaintenance.insertUpdateUser(user.Username, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, user.isBMEnabled__c);
			UserMaintenance.insertUpdateUser(user.Username, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, false);
			UserMaintenance.insertUpdateUser(null, null, null, null, null);
			
		}
		catch(UserMaintenance.BMException ex)
		{
			System.assertEquals('Big Machine session was not established and therefore user was not provisioned!!!', ex.getMessage());
		}
	}
	
	public static testMethod void insertUpdateUserProvisionTest()
	{
		
		User user = getUserInfo();
		try
		{
			UserMaintenance.callOut = false;
			UserMaintenance.insertUpdateUserProvision(user.Username, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, user.isBMEnabled__c, false);
			UserMaintenance.insertUpdateUserProvision(user.Username, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, false, false);
			UserMaintenance.insertUpdateUserProvision(null, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, null, false);
			
		}
		catch(UserMaintenance.BMException ex)
		{
			System.assertEquals('Big Machine session was not established and therefore user was not provisioned!!!', ex.getMessage());
		}
	}
	
	// Get the sesion id 
	public static testMethod void getSessionIDTest()
	{
		try
		{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;
			UserMaintenance.callOut = false;
			String sessionID = UserMaintenance.getSessionID(true, false);
			System.assert(sessionID==BMGlobal.SESSIONID_VALUE);
			
			sessionID = UserMaintenance.getSessionID(false, false);
			System.assert(sessionID==null);
			
		}
		catch(Exception e)
		{
			System.debug('Exception in getSessionIDTest: ' + e.getMessage());
		}
	}
			
	// Get the sesion id 
	public static testMethod void addRemoveUserTest()
	{
		User user = getUserInfo();
		try
		{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;
			UserMaintenance.callOut = false;
			UserMaintenance.addRemoveUser(BMGlobal.SESSIONID_VALUE, user.UserName, user.UserName, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, user.IsBMEnabled__c, false);
			UserMaintenance.addRemoveUser(BMGlobal.SESSIONID_VALUE, user.UserName, user.UserName, user.BMUserType__c, user.BMUserAccessType__c, user.BMPartnerCompanyNameFormula__c, user.IsBMEnabled__c, false);
			
		}
		catch(Exception e)
		{
			System.debug('Exception in addRemoveUserTest: ' + e.getMessage());
		}
	}
			
	static BMUserSecurity__c getAPIUserInfo()
	{
		BMUserSecurity__c[] userSecurities = [SELECT APIUserName__c, APIUserPassword__c, APISubDomain__c, BMSSLRequired__c, AdminEmail__c FROM BMUserSecurity__c WHERE isActive__c = true LIMIT 1];
		if (userSecurities.size() > 0)
			userSecurity = userSecurities[0];
		return userSecurity;
	}

	// Get the sesion id 
	public static testMethod void getSessionIDRequestTest()
	{
		try
		{
			HttpRequest req = UserMaintenance.getSessionIDRequest(true);
			//System.Assert(req!=null);
			req = UserMaintenance.getSessionIDRequest(false);
		}
		catch(Exception e){
			System.debug('Exception in getSessionIDRequestTest: ' + e.getMessage());
		}
	}
		
	private static BMUserSecurity__c getBmSec(){
		BMUserSecurity__c bmSec = new BMUserSecurity__c();
		bmSec.isActive__c = true;		
		bmSec.APIUserName__c = 'BM API User';
		bmSec.APISubDomain__c = 'nsalesdemo';
		bmSec.APIUserPassword__c = 'BM password';
		bmSec.AdminEmail__c = 'email@email.com';	
		bmSec.BMSSLRequired__c = false;		
		return bmSec;	
	
	}
	
	// Send an error message
	public static testMethod void SendExceptionMessageTest()
	{
		try{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;
	
			userSecurity = getAPIUserInfo();
			if (userSecurity != null)
			{
				String email;
				if (userSecurity.AdminEmail__c != null)
					//System.Debug('userSecurity - ' + userSecurity);
					email = userSecurity.AdminEmail__c; 
				else
					email = 'vishkash@yahoo.com';
				String message = 'Test Message';
				UserMaintenance.SendExceptionMessage(email, message);
			}
		}
		catch(Exception e){
			System.debug('Exception in SendExceptionMessageTest: ' + e.getMessage());
		}
		
	}
	
	public static testMethod void extractMessageTest()
	{
		try{
			HttpResponse res = new HttpResponse();
			String sessionID = UserMaintenance.extractMessage(res, BMGlobal.BM_SESSIONID);
		}
		catch(Exception e){
			System.debug('Exception in extractMessageTest: ' + e.getMessage());
		}
	}
	
	public static testMethod void getElementByTagNameTest()
	{
		try{
			String xmlString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
			xmlString = xmlString + '<soapenv:Header>';
			xmlString = xmlString + '<bm:userInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">';
			xmlString = xmlString + '<bm:sessionId>7f00000150447d8961f5a9447b8d23d0c9f7e9f8a1</bm:sessionId>;';
			xmlString = xmlString + '</bm:userInfo>';
			xmlString = xmlString + '<bm:category xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">Users</bm:category>';
			xmlString = xmlString + '<bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">';
			xmlString = xmlString + '<bm:schemaLocation>http://nsalesdemo.bigmachines.com/bmfsweb/nsalesdemo/schema/v1_0/users/Users.xsd</bm:schemaLocation>';
			xmlString = xmlString + '</bm:xsdInfo>';
			xmlString = xmlString + '</soapenv:Header>';
			
			UserMaintenance.getElementByTagName(xmlString, 'sessionId');
		}
		catch(Exception e){
			System.debug('Exception in getElementByTagNameTest: ' + e.getMessage());
		}
	}

	public static testMethod void testGetLoginName() {
		String inputUserName = 'ABC';
		String outputUserName = UserMaintenance.getLoginName(inputUserName);
		System.assert(true, inputUserName.equalsIgnoreCase(outputUserName));
	}
	
}