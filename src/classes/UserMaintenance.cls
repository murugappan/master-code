public with sharing class UserMaintenance 
{
	
	public class BMException extends Exception
	{
	}
	
	private static BMUserSecurity__c userSecurity;
    private static String adminEmail;
    
    public static Boolean allowFutureCall = true;
    public static Boolean callOut = true;

	// if both flags are set to false then there is an exception
	public static void removeIsBMEnabled(String userName)
	{				
		User[] users = [SELECT isBMEnabled__c, BMMassProvisioning__c FROM User WHERE Username = :userName];
		System.debug('removeIsBMEnabled - ' + users);
		if (users.size() > 0)
		{
			users[0].isBMEnabled__c = false;
			users[0].BMMassProvisioning__c = false;
			allowFutureCall = false;
			update users;
			allowFutureCall = true;
		}
	}
			
	// Updates user t
	public static void updateIsBMEnabled(List<User> users)
	{
		System.debug('updateIsBMEnabled - ' + users);
		allowFutureCall = false;
		update users;
		allowFutureCall = true;
	}
			
	public static String getLoginName(String userName)
	{
		String loginName;
		System.Debug('userName ' + userName);
		if (userName != null && userName.length() > 0)
		{
			loginName = userName.Split('@', 0)[0];
			//{}|!%#$&'*+-/=?^.`
			//regular expression doesn't seem to work so we are doing it individually
			//"\{|}|\||!|%|\#|\$|\&|\'|\*|\+|\-|\/|=|\?|\^|`|\ |."
			loginName = loginName.replace('.', '');
			loginName = loginName.replace('{', '');
			loginName = loginName.replace('}', '');
			loginName = loginName.replace('|', '');
			loginName = loginName.replace('!', '');
			loginName = loginName.replace('%', '');
			loginName = loginName.replace('#', '');
			loginName = loginName.replace('$', '');
			loginName = loginName.replace('&', '');
			loginName = loginName.replace('\'', '');
			loginName = loginName.replace('*', '');
			loginName = loginName.replace('+', '');
			loginName = loginName.replace('-', '');
			loginName = loginName.replace('/', '');
			loginName = loginName.replace('=', '');
			loginName = loginName.replace('?', '');
			loginName = loginName.replace('^', '');
			loginName = loginName.replace('`', '');
			loginName = loginName.replace(' ', '');
		}	
		System.debug('loginName = ' + loginName);
		return loginName;
	}	
	
	@Future(callout=true)
	public static void insertUpdateUser(String userName, String bmUserType, String bmUserAccessType, String companyName, Boolean isBMEnabled)
	{
		System.Debug('within insertUpdateUser userName = ' + userName);
		insertUpdateUserProvision(userName, bmUserType, bmUserAccessType, companyName, isBMEnabled, false);
	}

	public static void insertUpdateUserProvision(String userName, String bmUserType, String bmUserAccessType, String companyName, Boolean isBMEnabled, Boolean massProvisioning)
	{
		String msg = BMGlobal.ERROR_USER_NOT_PROVISIONED;
		try 
		{
			System.debug('Before Session ID for callout - ' + callOut + ', massprovisioning - ' + massProvisioning);
			String sessionID = getSessionID(true, massProvisioning);
			System.debug('Session value for ' + sessionID);
			if (sessionID != null && sessionID.length() > 0)
			{
				String loginName = getLoginName(userName);
				System.debug('loginName stripped = ' + loginName);
			
				if (loginName != null && loginName.length() > 0)
					addRemoveUser(sessionID, userName, loginName, bmUserType, bmUserAccessType, companyName, isBMEnabled, massProvisioning);
				else
					removeIsBMEnabled(userName);
			}
			else
				removeIsBMEnabled(userName);
		} 
		catch(Exception e) 
		{
			System.Debug('Exception in insertUpdateUser: ' + e);
			if (massProvisioning == false)
			{
				if (adminEmail != null && adminEmail.length() > 0)
				{
					removeIsBMEnabled(userName);	
					SendExceptionMessage(adminEmail, 'BigMachines provisioning of the ' + userName + ' user failed. Error: ' + e.getMessage());
				}
			}
			else
				throw new BMException('BigMachines provisioning of the ' + userName + ' user failed. Error: ' + e.getMessage());
		}   
	}
	
	// Get the sesion id 
	public static String getSessionID(Boolean setValue, Boolean massProvisioning)
	{
		String sessionID;
		try
		{		
			HttpRequest req = getSessionIDRequest(setValue);
			if (req != null)
			{
				System.debug ('Session ID req = ' + req);
				// Get the response for the API Security call 
				HTTPResponse res = getResponse(req);
				
				String exceptionMsg;
				System.Debug('Test sessionID - ' + sessionID);
				if (callOut)
				{
					sessionID = extractMessage(res, BMGlobal.BM_SESSIONID);
					//exceptionMsg = sessionID.length() > 0?'':extractMessage(res, BMGlobal.BM_EXCEPTIONMESSAGE);
					exceptionMsg = sessionID.length() > 0?'':getElementByTagName(res.getBody(), BMGlobal.BM_EXCEPTIONMESSAGE);
				}
				else
					if (setValue)
						sessionID = BMGlobal.SESSIONID_VALUE;
					else
						exceptionMsg = 'Big Machine Security does not have one API record that is active!';

				System.Debug('invalid password message ' + exceptionMsg);
				if (exceptionMsg != null && exceptionMsg.length() > 0)
					throw new BMException(exceptionMsg);
			}
		}
		catch(Exception e)
		{
			System.Debug('Exception in getSessionID: ' + e);
			if (massProvisioning == false)
			{
				if (adminEmail != null && adminEmail.length() > 0)
					SendExceptionMessage(adminEmail, 'BigMachines provisioning of a Salesforce user failed. Error: ' + e.getMessage());
			}
			else
				throw new BMException('BigMachines provisioning of a Salesforce user failed. Error: ' + e.getMessage());					
		}			
		return sessionID;
	}
	
	// API user name and password
	private static BMUserSecurity__c getAPIUserInfo()
	{
		BMUserSecurity__c[] userSecurities = [SELECT APIUserName__c, APIUserPassword__c, APISubDomain__c, BMSSLRequired__c, AdminEmail__c FROM BMUserSecurity__c WHERE isActive__c = true LIMIT 1];
		userSecurity = userSecurities.size() > 0?userSecurities[0]: new BMUserSecurity__c();
			
		return userSecurity;
	}
	
	// Retrieve the SessionID
	public static HttpRequest getSessionIDRequest(Boolean retrieveAPI)
	{
		HttpRequest req;
		userSecurity = retrieveAPI == true?getAPIUserInfo():null;
			
		if (userSecurity != null 						&& 
			userSecurity.AdminEmail__c != null 			&& 
			userSecurity.APISubDomain__c != null 		&&
			userSecurity.APIUserName__c != null 		&&
			userSecurity.APIUserPassword__c != null		&&
			userSecurity.BMSSLRequired__c != null)
		{
			
			System.Debug('userSecurity - ' + userSecurity);
			adminEmail = userSecurity.AdminEmail__c; 

			//Instantiate SecuritySoapFunctions
			SecuritySoapFunctions securitySoapFunctions = new SecuritySoapFunctions();

			// Retrieve the security Soap message
			String body = securitySoapFunctions.generateSecuritySoapMessage(userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, userSecurity.APIUserName__c, userSecurity.APIUserPassword__c);
			//String body = securitySoapFunctions.generateSecuritySoapMessage('Joe', userSecurity.APIUserPassword__c);
			System.Debug('Body = ' + body);

			req = buildWebServiceRequest(BMGlobal.METHOD, userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, body);
		}	
		else
			throw new BMException(BMGlobal.ERROR_NO_CONFIG_RECORD);
		return req;
				
	}

	// Check if the User Exist for a particular loginName
	public static String checkUserExist(String sessionID, String loginName)
	{
		String success;
		String msg = BMGlobal.ERROR_USER_EXIST_CHECK;
		System.Debug('Sending Session id');
		// Get the get user Soap body
		UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
		String body = userSoapFunctions.generateGetUserSoapBody(userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c,userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, sessionID, loginName);
		
		System.Debug('zzz success=' + userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c + ' Body = ' + body);
		
		//Set HTTPRequest 
		HttpRequest req = buildWebServiceRequest(BMGlobal.METHOD, userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, body);
		
		System.Debug('zzz Request is: ' + req.getBody() + ' callout ' + callOut);
		// Get the response for the API Security call 
		HTTPResponse res = getResponse(req);
		
		System.Debug('zzz Response is: ' + res.getBody());
		String bodyElement = (res != null && res.getStatus() == BMGlobal.OK)?res.getBody():null;
		// Check if the body is not null
		success = bodyElement != null?getElementByTagName(bodyElement, BMGlobal.BM_SUCCESS):'';
		System.Debug('zzz before success=' + success);
		success = callOut == false?'true':success;
		System.Debug('zzz success=' + success);
		return success;
	}

	// Add / Remove user from the big machines
	public static void addRemoveUser(String sessionID, String userName, String loginName, String bmUserType, String bmUserAccessType, 
									 String bmCompanyName, Boolean isBMEnabled, Boolean massProvisioning)
	{
		Boolean updateUser = false;
		Boolean removeUser = false;
		String msg = BMGlobal.ERROR_USER_ADD_UPDATE;
				
		try
		{
		
			// Check if the user exist
			System.debug('SessionID: ' + sessionID);
			System.debug('loginName: ' + loginName);
			System.debug('bmUserType: ' + bmUserType);
			System.debug('bmUserAccessType: ' + bmUserAccessType);
			System.debug('bmCompanyName: ' + bmCompanyName);
			System.debug('isBMEnabled: ' + isBMEnabled);
			System.debug('massProvisioning: ' + massProvisioning);
			
			Boolean parentUserExist = false;
			String success = '';
			System.debug('before call checkuserexits from addRemoveUser');
			if (bmUserType == BMGlobal.BM_PARTNER_USER)
			{
				// Partner user, so check if the super user exist for that company, 
				// if not then that company does not exist in Big Machines 
				success = checkUserExist(sessionID, BMGlobal.BM_SUPER_USER + '@' + bmCompanyName);

				// Check if the company exist else send an exception
				if (success.length() > 0)
					// If the company exist then check if we need to add or update the user
					success = checkUserExist(sessionID, loginName + '@' + bmCompanyName);
				else
					throw new BMException('BigMachines provisioning of the ' + userName + ' user failed. The company name: ' + bmCompanyName + ' does not exist on Big Machines.');					
			}
			else
				// Check if the user exist, if it exist then update else add user
				success = checkUserExist(sessionID, loginName);
				
			System.Debug('after call checkuserexits from addRemoveUser');
			
			updateUser = success.length() > 0?true:false;
			System.Debug('updateUser - ' + updateUser);
			removeUser = (updateUser && isBMEnabled == false)?true:false;
			
			if (removeUser == false && isBMEnabled == false)
				System.Debug('User has already been removed!');
			else
			{
				System.Debug('removeUser - ' + removeUser);
				UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
				
				if (bmUserType.equalsIgnoreCase(BMGlobal.BM_INTERNAL_USER)) {
					bmCompanyName = userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c;
				}
				String subDomainName = userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c;
				String httpValue = userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE; 
				String body = userSoapFunctions.generateAddUpdateRemoveUserSoapMessage(subDomainName, httpValue, bmCompanyName, 
					sessionID, userName, loginName, updateUser, removeUser, bmUserAccessType);
				
				System.Debug('body - ' + body);
				//Set HTTPRequest 
				HTTPRequest req = buildWebServiceRequest(BMGlobal.METHOD, userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, body);
				
				// Get the response for the API Security call 
				HTTPResponse res = getResponse(req);
				System.debug('BM response  - ' + res.toString());
				System.Debug('Finished');
				if (res != null && res.getStatus() == BMGlobal.OK)
				{
					success = getElementByTagName(res.getBody(), BMGlobal.BM_SUCCESS);
					if (success.length() == 0)
					{
						String exceptionMsg = getElementByTagName(res.getBody(), BMGlobal.BM_EXCEPTIONMESSAGE);
						System.Debug('exceptionMsg = ' + exceptionMsg);
						if (exceptionMsg != null && exceptionMsg.length() > 0)
							throw new BMException(exceptionMsg);
						else
							throw new BMException(msg);
					}
				}
				else
					if (callOut)
						throw new BMException(msg);
			}
		}
		catch(Exception e)
		{
			System.Debug('Exception in addRemoveUser: ' + e);
			if (massProvisioning == false)
			{
				if (adminEmail != null && adminEmail.length() > 0)
				{
					removeIsBMEnabled(userName);	
					SendExceptionMessage(adminEmail, 'BigMachines provisioning of the ' + userName + ' user failed. Error: ' + e.getMessage());
				}
			}
			else
				throw new BMException('BigMachines provisioning of the ' + userName + ' user failed. Error: ' + e.getMessage());					
		}
	}
	
	// Send an error message
	public static void SendExceptionMessage(String email, String message)
	{
		// Create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		// Assign the addresses for the To mail object.
        mail.setToAddresses(new string[]{email});
        
         // Specify the address used when the recipients reply to the email. 
        //mail.setReplyTo('');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Big Machine Exception Information');
        
        // Specify the subject line for your email address.
        mail.setSubject('Big Machine User Provision');
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody(message);
        
        // Specify the HTML content of the email.
        mail.setHtmlBody('<p>' + message + '</p>');
         
        // Send the email that is created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
	}

	// HTTP Request Utility
	public static HttpResponse getResponse(HttpRequest req)
	{
		// Instantiate the Http 
		Http http = new Http();

		// Send the request and retrieve the response
		HttpResponse res = new HttpResponse();
		res = (callOut == true)?http.send(req):res;
			    
		return res;
	}

	public static HttpRequest buildWebServiceRequest(String methodStr, String subDomain, String httpValue, String body)
	{
	    //Build HTTP Request object
	    HttpRequest req = new HttpRequest();
	    
	    req.setEndpoint(BMGlobal.BM_END_POINT.Replace(BMGlobal.BM_SUB_DOMAIN, subDomain).Replace(BMGlobal.BM_HTTP_REPLACE_VALUE, httpValue)); 
	    req.setMethod(methodStr);
	    req.setBody(body);
	    return req;
	}

	// HTTP Response Utility
	// Return an element by its tag name
	public static String getElementByTagName(String xmlString, String tagName)
	{
		// Initialize the value
		String value = '';
		System.Debug('tagName = ' + tagName);
		
		BMXMLDom dom = new BMXMLDom(xmlString);
		
		// Retrieve a list of values based on its tag name
		List<BMXMLDom.Element> elements = dom.getElementsByTagName(tagName);
		System.Debug('Elements = ' + elements);
		
		// If there are elements present 
		if (elements != null)
		{
			// Check if there are more than one element present in the list
			if (elements.size() > 0)
			{
				// We are only interested in the first one, so return that value
				value = elements[0].nodeValue;
			}
		}
		return value;
	}

	public static String extractMessage(HttpResponse res, String msg)
	{
		String sessionID;
		if (res != null && res.getStatus() == BMGlobal.OK)
		{
			String bodyElement = res.getBody();
			if (bodyElement != null)
			{
				System.Debug('bodyElement ' + bodyElement);
				sessionID = getElementByTagName(bodyElement, msg);
			}
		}
		return sessionID;
	}
	
	public static String validateConfigRecord(){
		return getAPIUserInfo().AdminEmail__c;
	}	
}