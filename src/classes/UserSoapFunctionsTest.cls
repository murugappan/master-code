@isTest
private class UserSoapFunctionsTest {
	
	// API user name and password
	private static BMUserSecurity__c getAPIUserInfo()
	{
		BMUserSecurity__c[] userSecurities = [SELECT APIUserName__c, APIUserPassword__c, APISubDomain__c, BMSSLRequired__c, AdminEmail__c FROM BMUserSecurity__c WHERE isActive__c = true LIMIT 1];
		BMUserSecurity__c userSecurity;
		if (userSecurities != null && userSecurities.size() > 0)
			userSecurity = userSecurities[0];
		
		return userSecurity;
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
	
	static testMethod void generateAddUpdateUserSoapHeaderTest()
	{
		try{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;
			
			BMUserSecurity__c userSecurity = getAPIUserInfo();
			UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
			BMXMLDom.Element userSoapHeader = userSoapFunctions.generateAddUpdateUserSoapHeader(userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, BMGlobal.SESSIONID_VALUE);
	
			BMXMLDom.Element userInfo = userSoapHeader.getElementByTagName(BMGlobal.BM_USER_INFO);
			System.assertEquals(userInfo.nodeName,BMGlobal.BM_USER_INFO);
			System.assertEquals(BMGlobal.XMLNS_BM_URN,userInfo.attributes.get(BMGlobal.XMLNS_BM));
			System.assertEquals(BMGlobal.SOAPENV_ACTOR_URL,userInfo.attributes.get(BMGlobal.SOAPENV_ACTOR));
			System.assertEquals(BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE,userInfo.attributes.get(BMGlobal.SOAPENV_MUSTUNDERSTAND));
	
			BMXMLDom.Element sessionId = userInfo.getElementByTagName(BMGlobal.BM_SESSION_ID);
			System.assertEquals(BMGlobal.BM_SESSION_ID,sessionId.nodeName);
			System.assertEquals(BMGlobal.SESSIONID_VALUE,sessionId.nodeValue);
		
			// Create the big machine category
			BMXMLDom.Element category = userSoapHeader.getElementByTagName(BMGlobal.XMLNS_BM_CATEGORY);
			System.assertEquals(category.nodeName,BMGlobal.XMLNS_BM_CATEGORY);
			System.assertEquals(BMGlobal.XMLNS_BM_URN,category.attributes.get(BMGlobal.XMLNS_BM));
			System.assertEquals(BMGlobal.SOAPENV_ACTOR_URL,category.attributes.get(BMGlobal.SOAPENV_ACTOR));
			System.assertEquals(BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE,category.attributes.get(BMGlobal.SOAPENV_MUSTUNDERSTAND));
			System.assertEquals(BMGlobal.USERS, category.nodeValue);
	
			// Create the big machine category
			BMXMLDom.Element xsdInfo = userSoapHeader.getElementByTagName(BMGlobal.BM_XSDINFO);
			System.assertEquals(xsdInfo.nodeName,BMGlobal.BM_XSDINFO);
			System.assertEquals(BMGlobal.XMLNS_BM_URN,xsdInfo.attributes.get(BMGlobal.XMLNS_BM));
			System.assertEquals(BMGlobal.SOAPENV_ACTOR_URL,xsdInfo.attributes.get(BMGlobal.SOAPENV_ACTOR));
			System.assertEquals(BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE,xsdInfo.attributes.get(BMGlobal.SOAPENV_MUSTUNDERSTAND));
	
			BMXMLDom.Element bmSchemaLocation = xsdInfo.getElementByTagName(BMGlobal.BM_SCHEMA_LOCATION);
			System.assertEquals(BMGlobal.BM_USER_SCHEMA_LOCATION_VALUE.replace(BMGlobal.BM_SUB_DOMAIN, userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c).Replace(BMGlobal.BM_HTTP_REPLACE_VALUE, userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE),bmSchemaLocation.nodeValue);
		}
		catch(Exception e){
			System.debug('Exception in generateAddUpdateUserSoapHeaderTest: ' + e.getMessage());
		}	


	}
	
	private static User getUserInfo()
	{
		//User user;
		User[] userList = [Select 
						u.Id, u.CompanyName, u.Username, u.FirstName, u.LastName, u.Title, u.Email, 
						u.Phone, u.Fax, u.Street, u.City, u.State, u.PostalCode, u.Country,
						u.BMCurrencyPreference__c, u.BMLanguage__c, u.BMNumberFormat__c, 
						u.BMTimeZone__c, u.BMUnit__c, BMUserGroup__c, BMDateFormat__c
					 from User u where u.isActive=true LIMIT 1];
		return userList[0];
	}
	
	static testMethod void generateAddUpdateUserSoapBodyTest()
	{
		try{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;

			BMUserSecurity__c userSecurity = getAPIUserInfo();

			Boolean updateUser = false;
			Boolean removeUser = false;
			
			User user = getUserInfo();
			String userName = user.UserName;
			String loginName = userName.split('@', 0)[0];
			UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
			String bmUserAccessType = '';
			BMXMLDom.Element userSoapBody = userSoapFunctions.generateAddUpdateUserSoapBody(userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c,user.Username, loginName, updateUser, removeUser, bmUserAccessType);
			BMXMLDom.Element bmAddUpdateUsers; 
			if (updateUser)
			{
				// Create a big machine Update Users element
				bmAddUpdateUsers = userSoapBody.getElementByTagName(BMGlobal.BM_UPDATE_USERS);
				System.assertEquals(BMGlobal.BM_UPDATE_USERS,bmAddUpdateUsers.nodeName);
			}
			else
			{
				// Create a big machine Add Users element
				bmAddUpdateUsers = userSoapBody.getElementByTagName(BMGlobal.BM_ADD_USERS);
				System.assertEquals(BMGlobal.BM_ADD_USERS,bmAddUpdateUsers.nodeName);
			}
			// Set the attributes for the big machine Add/Udate Users element
			System.assertEquals(BMGlobal.XMLNS_BM_URN, bmAddUpdateUsers.attributes.get(BMGlobal.XMLNS_BM));
			
			BMXMLDom.Element userElement = userSoapBody.getElementByTagName(BMGlobal.BM_USER);
			System.assertEquals(BMGlobal.BM_USER,userElement.nodeName);
			BMXMLDom.Element eachRecord = userElement.getElementByTagName(BMGlobal.BM_EACH_RECORD);
			System.assertEquals(BMGlobal.BM_EACH_RECORD,eachRecord.nodeName);
	
			System.assertEquals(BMGlobal.BM_COMPANY_VALUE.replace(BMGlobal.BM_SUB_DOMAIN, userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c), eachRecord.getElementByTagName(BMGlobal.BM_COMPANY_NAME).nodeValue);
			System.assertEquals(loginName, eachRecord.getElementByTagName(BMGlobal.BM_LOGIN).nodeValue);
			// System.assertEquals(BMGlobal.BM_TYPE_SALES_AGENT, eachRecord.getElementByTagName(BMGlobal.BM_TYPE).nodeValue);
			System.assertEquals(user.FirstName==null?'':user.FirstName, eachRecord.getElementByTagName(BMGlobal.BM_FIRST_NAME).nodeValue);
			System.assertEquals(user.LastName==null?'':user.LastName, eachRecord.getElementByTagName(BMGlobal.BM_LAST_NAME).nodeValue);
			System.assertEquals(user.Title==null?'':user.Title, eachRecord.getElementByTagName(BMGlobal.BM_JOB_TITLE).nodeValue);
			System.assertEquals(user.Email==null?'':user.Email, eachRecord.getElementByTagName(BMGlobal.BM_EMAIL).nodeValue);
			System.assertEquals(user.Phone==null?'':user.Phone, eachRecord.getElementByTagName(BMGlobal.BM_PHONE).nodeValue);
			System.assertEquals(user.Fax==null?'':user.Fax, eachRecord.getElementByTagName(BMGlobal.BM_FAX).nodeValue);
			System.assertEquals(user.Street==null?'':user.Street, eachRecord.getElementByTagName(BMGlobal.BM_BILL_ADDRESS).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_BILL_ADDRESS_2).nodeValue);
			System.assertEquals(user.City==null?'':user.City, eachRecord.getElementByTagName(BMGlobal.BM_BILL_CITY).nodeValue);
			System.assertEquals(user.State==null?'':user.State, eachRecord.getElementByTagName(BMGlobal.BM_BILL_STATE).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_BILL_STATE_PROVINCE).nodeValue);
			System.assertEquals(user.PostalCode==null?'':user.PostalCode, eachRecord.getElementByTagName(BMGlobal.BM_BILL_ZIP).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_BILL_COUNTRY).nodeValue);
			System.assertEquals('false', eachRecord.getElementByTagName(BMGlobal.BM_SEPARATE_SHIP_ADDR).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_ADDRESS_1).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_ADDRESS_2).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_CITY).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_STATE).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_STATE_PROVINCE).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_ZIP).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_COUNTRY).nodeValue);
			System.assertEquals('false', eachRecord.getElementByTagName(BMGlobal.BM_NOTIFICATION_PREF).getElementByTagName(BMGlobal.BM_IS_NOTIFY_PREF).nodeValue);
			System.assertEquals(user.BMLanguage__c==null?'':user.BMLanguage__c, eachRecord.getElementByTagName(BMGlobal.BM_LANGUAGE).nodeValue);
			System.assertEquals(user.BMCurrencyPreference__c==null?'':user.BMCurrencyPreference__c, eachRecord.getElementByTagName(BMGlobal.BM_CURRENCY_PREFERENCE).nodeValue);
			System.assertEquals(user.FirstName==null?'':user.FirstName, eachRecord.getElementByTagName(BMGlobal.BM_BILL_FIRST_NAME).nodeValue);
			System.assertEquals(user.LastName==null?'':user.LastName, eachRecord.getElementByTagName(BMGlobal.BM_BILL_LAST_NAME).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_BILL_COMPANY).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_BILL_COMPANY_2).nodeValue);
			System.assertEquals(user.Phone==null?'':user.Phone, eachRecord.getElementByTagName(BMGlobal.BM_BILL_PHONE).nodeValue);
			System.assertEquals(user.Fax==null?'':user.Fax, eachRecord.getElementByTagName(BMGlobal.BM_BILL_FAX).nodeValue);
			System.assertEquals(user.Email==null?'':user.Email, eachRecord.getElementByTagName(BMGlobal.BM_BILL_EMAIL).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_FIRST_NAME).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_LAST_NAME).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_COMPANY).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_COMPANY_2).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_PHONE).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_FAX).nodeValue);
			System.assertEquals('', eachRecord.getElementByTagName(BMGlobal.BM_SHIP_EMAIL).nodeValue);
			System.assertEquals(user.BMUnit__c==null?'':user.BMUnit__c, eachRecord.getElementByTagName(BMGlobal.BM_UNITS).nodeValue);
			System.assertEquals(user.BMDateFormat__c==null?'':user.BMDateFormat__c, eachRecord.getElementByTagName(BMGlobal.BM_DATE_FORMAT).nodeValue);
			System.assertEquals(user.BMTimeZone__c==null?'':user.BMTimeZone__c, eachRecord.getElementByTagName(BMGlobal.BM_TIME_ZONE).nodeValue);
			System.assertEquals(user.BMNumberFormat__c==null?'':user.BMNumberFormat__c, eachRecord.getElementByTagName(BMGlobal.BM_NUMBER_FORMAT).nodeValue);

			System.assertEquals(user.Username==null?'':user.Username, eachRecord.getElementByTagName(BMGlobal.BM_PARTNER_LOGIN).nodeValue);
			System.assertEquals(BMGlobal.BM_PARTNER_PASSWORD_VALUE, eachRecord.getElementByTagName(BMGlobal.BM_PARTNER_PASSWORD).nodeValue);
			System.assertEquals('false', eachRecord.getElementByTagName(BMGlobal.BM_SEND_PASSWORD_EMAIL).nodeValue);

			System.assertEquals('Active', eachRecord.getElementByTagName(BMGlobal.BM_STATUS).nodeValue);
	
			if (user.BMUserGroup__c != null && user.BMUserGroup__c.length() > 0)
			{
				String[] groupsForUser = user.BMUserGroup__c.split(';', 0);
				for (String g : groupsForUser)
				{
					if (g.trim() == eachRecord.getElementByTagName(BMGlobal.BM_GROUP_LIST).getElementByTagName(BMGlobal.BM_GROUP).getElementByTagName(BMGlobal.BM_VARIABLE_NAME).nodeValue)
						System.assertEquals(g.trim(), eachRecord.getElementByTagName(BMGlobal.BM_GROUP_LIST).getElementByTagName(BMGlobal.BM_GROUP).getElementByTagName(BMGlobal.BM_VARIABLE_NAME).nodeValue);
				}
			}
		}
		catch(Exception e){
			System.debug('Exception in generateAddUpdateUserSoapBodyTest: ' + e.getMessage());
		}			
	}	
	
	static testMethod void generateGetUserSoapBodyTest()
	{
		try{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;

			BMUserSecurity__c userSecurity = getAPIUserInfo();
		
			User user = getUserInfo();
			String userName = user.UserName;
			String loginName = userName.split('@', 0)[0];
			
			UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
			String envelope = userSoapFunctions.generateGetUserSoapBody(userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c, userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, BMGlobal.SESSIONID_VALUE, loginName);
			BMXMLDom dom = new BMXMLDom(envelope);
			BMXMLDom.Element userSoapBody = dom.getElementByTagName(BMGlobal.BODY);
			System.Debug(userSoapBody.toXmlString());
			// Create a big machine Get User element
			BMXMLDom.Element bmGetUsers = userSoapBody.getElementByTagName(BMGlobal.GET_USER);
					
			System.assertEquals(BMGlobal.GET_USER,bmGetUsers.nodeName);
			System.assertEquals(BMGlobal.XMLNS_BM_URN,bmGetUsers.attributes.get(BMGlobal.BM));
			BMXMLDom.Element bmUserInfo = userSoapBody.getElementByTagName(BMGlobal.USER_INFO);
			System.assertEquals(BMGlobal.USER_INFO,bmUserInfo.nodeName);
			
			System.assertEquals(loginName,bmUserInfo.getElementByTagName(BMGlobal.USER_ID).nodeValue);
		}
		catch(Exception e){
			System.debug('Exception in generateGetUserSoapBodyTest: ' + e.getMessage());
		}	
	}

	static testMethod void generateAddUpdateRemoveUserSoapMessageTest()
	{
		try{
			BMUserSecurity__c[] userSecurities = [SELECT Name FROM BMUserSecurity__c];
			delete userSecurities;
			
			BMUserSecurity__c bmSec = getBmSec();	
			insert bmSec;

			BMUserSecurity__c userSecurity = getAPIUserInfo();
		
			Boolean updateUser = true;
			Boolean removeUser = false;
			
			User user = getUserInfo();
			String userName = user.UserName;
			String loginName = userName.split('@', 0)[0];
			UserSoapFunctions userSoapFunctions = new UserSoapFunctions();
			String bmUserAccessType = '';
			String envelope = userSoapFunctions.generateAddUpdateRemoveUserSoapMessage(userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c,userSecurity.BMSSLRequired__c==null?'':userSecurity.BMSSLRequired__c==true?BMGlobal.BM_HTTP_WITH_SSL_VALUE:BMGlobal.BM_HTTP_VALUE, userSecurity.APISubDomain__c==null?'':userSecurity.APISubDomain__c, BMGlobal.SESSIONID_VALUE, user.Username, loginName, updateUser, removeUser, bmUserAccessType);
			BMXMLDom dom = new BMXMLDom(envelope);
		}
		catch(Exception e){
			System.debug('Exception in generateAddUpdateRemoveUserSoapMessageTest: ' + e.getMessage());
		}	
	}
}