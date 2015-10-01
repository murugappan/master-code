public with sharing class UserSoapFunctions 
{
	
	// Element to create addUpdate Soap Header
	private BMXMLDom.Element addUpdateHeader;
	// Element to create addUpdate Soap Body
	private BMXMLDom.Element addUpdateBody;
	
	// Element that hold the user body
	private BMXMLDom.Element userBody;
	private String currentLoginName;
	
	private Boolean currentAddRemoveSoap = false;

	//Constructor
	public UserSoapFunctions()
	{
	}

	// Retrieve the Add/Update User Soap Header
	//	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	//		<soapenv:Header>
	//			<bm:userInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">
	//				<bm:sessionId>7f00000150447d8961f5a9447b8d23d0c9f7e9f8a1</bm:sessionId>
	//			</bm:userInfo>
	//			<bm:category xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">Users</bm:category>
	//			<bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">
	//				<bm:schemaLocation>http://nsalesdemo.bigmachines.com/bmfsweb/nsalesdemo/schema/v1_0/users/Users.xsd</bm:schemaLocation>
	//			</bm:xsdInfo>
	//		</soapenv:Header>
	public BMXMLDom.Element generateAddUpdateUserSoapHeader(String subDomain, String httpValue, String sessionId)
	{
		// Check if the Add/Update User Header is null or if child nodes are not created
		if (addUpdateHeader == null || addUpdateHeader.hasChildNodes() == false)
		{
			// Call the Add/Update User header
			addUpdateHeader = SoapBase.getSoapHeader();
			// Create the big machine userInfo
			BMXMLDom.Element bmUserInfo = new BMXMLDom.Element(BMGlobal.BM_USER_INFO);
			bmUserInfo.attributes.put(BMGlobal.XMLNS_BM, BMGlobal.XMLNS_BM_URN);
			bmUserInfo.attributes.put(BMGlobal.SOAPENV_ACTOR, BMGlobal.SOAPENV_ACTOR_URL);
			bmUserInfo.attributes.put(BMGlobal.SOAPENV_MUSTUNDERSTAND, BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE);
			BMXMLDom.Element bmSessionId = new BMXMLDom.Element(BMGlobal.BM_SESSION_ID);
			bmSessionId.nodeValue = sessionId;
			bmUserInfo.appendChild(bmSessionId);

			// Append the child element to the addUpdate Header
			addUpdateHeader.appendChild(bmUserInfo);		
			
			// Create the big machine category
			BMXMLDom.Element bmCategory = new BMXMLDom.Element(BMGlobal.XMLNS_BM_CATEGORY);

			// Set the attributes for the big machine category element
			bmCategory.attributes.put(BMGlobal.XMLNS_BM, BMGlobal.XMLNS_BM_URN);
			bmCategory.attributes.put(BMGlobal.SOAPENV_ACTOR, BMGlobal.SOAPENV_ACTOR_URL);
			bmCategory.attributes.put(BMGlobal.SOAPENV_MUSTUNDERSTAND, BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE);

			// Set the node value for the big machine category to addUpdate
			bmCategory.nodeValue = BMGlobal.USERS;
			
			// Append the child element to the addUpdate Header
			addUpdateHeader.appendChild(bmCategory);		

			// Create the big machine xsd info
			BMXMLDom.Element bmXsdInfo = new BMXMLDom.Element(BMGlobal.BM_XSDINFO);

			// Set the attributes for the big machine xsd info element
			bmXsdInfo.attributes.put(BMGlobal.XMLNS_BM, BMGlobal.XMLNS_BM_URN);
			bmXsdInfo.attributes.put(BMGlobal.SOAPENV_ACTOR, BMGlobal.SOAPENV_ACTOR_URL);
			bmXsdInfo.attributes.put(BMGlobal.SOAPENV_MUSTUNDERSTAND, BMGlobal.SOAPENV_MUSTUNDERSTAND_VALUE);
			
			// Create the big machine schema location element
			BMXMLDom.Element bmSchemaLocation = new BMXMLDom.Element(BMGlobal.BM_SCHEMA_LOCATION);
			// Set the node value for the big machine schema location element
			bmSchemaLocation.nodeValue = BMGlobal.BM_USER_SCHEMA_LOCATION_VALUE.replace(BMGlobal.BM_SUB_DOMAIN, subDomain).Replace(BMGlobal.BM_HTTP_REPLACE_VALUE, httpValue);
			
			// Append the schema location element to the xsd Info element
			bmXsdInfo.appendChild(bmSchemaLocation);
			
			// Finally add the xsd info element to the addUpdate header
			addUpdateHeader.appendChild(bmXsdInfo);
		}
		
		// return Add/Update User header element
		return addUpdateHeader;
	}
	
	// Retrieve the Add/Update User Soap Body
	//		<soapenv:Body>
	//			<bm:addUsers xmlns:bm="urn:soap.bigmachines.com">
	//				<bm:User>
	//					<bm:each_record>
	//						<bm:company_name>nsalesdemo</bm:company_name>
	//						<bm:login>superuser</bm:login>
	//						<bm:password/>
	//						<bm:type>FullAccess</bm:type>
	//						<bm:first_name>Dennis</bm:first_name>
	//						<bm:last_name>Adams</bm:last_name>
	//						<bm:job_title>System Administrator</bm:job_title>
	//						<bm:email>junk@bigmachines.com</bm:email>
	//						<bm:phone>(847) 572-0300</bm:phone>
	//						<bm:fax>(847) 510-0510</bm:fax>
	//						<bm:bill_address_1>570 W. Lake Cook Road</bm:bill_address_1>
	//						<bm:bill_address_2>Suite 126</bm:bill_address_2>
	//						<bm:bill_city>Deerfield</bm:bill_city>
	//						<bm:bill_state_province>Illinois</bm:bill_state_province>
	//						<bm:bill_zip>60015</bm:bill_zip>
	//						<bm:bill_country>United States</bm:bill_country>
	//						<bm:separate_ship_addr>false</bm:separate_ship_addr>
	//						<bm:ship_address_1/>
	//						<bm:ship_address_2/>
	//						<bm:ship_city/>
	//						<bm:ship_state_province/>
	//						<bm:ship_zip/>
	//						<bm:ship_country/>
	//						<bm:notification_pref>
	//							<bm:is_notify_email>false</bm:is_notify_email>
	//						</bm:notification_pref>
	//						<bm:bm_language>English</bm:bm_language>
	//						<bm:currency_preference>USD</bm:currency_preference>
	//						<bm:bill_first_name>Dennis</bm:bill_first_name>
	//						<bm:bill_last_name>Adams</bm:bill_last_name>
	//						<bm:bill_company>BigMachines</bm:bill_company>
	//						<bm:bill_company_2/>
	//						<bm:bill_phone>(847) 572-0300</bm:bill_phone>
	//						<bm:bill_fax>(847) 510-0510</bm:bill_fax>
	//						<bm:bill_email>admin@bigmachines.demo</bm:bill_email>
	//						<bm:ship_first_name/>
	//						<bm:ship_last_name/>
	//						<bm:ship_company/>
	//						<bm:ship_company_2/>
	//						<bm:ship_phone/>
	//						<bm:ship_fax/>
	//						<bm:ship_email/>
	//						<bm:bm_units>System Default</bm:bm_units>
	//						<bm:date_format>MM/dd/yyyy h:mm a</bm:date_format>
	//						<bm:time_zone>(GMT-5:00 GMT-4:00) US Eastern Time</bm:time_zone>
	//						<bm:number_format>####.##</bm:number_format>
	//						<bm:partner_login>username</bm:partner_login>
	//						<bm:partner_password>passw0rd</bm:partner_password>
	//						<bm:send_password_email>false</bm:send_password_email>
	//						<bm:status>Active</bm:status>
	//						<bm:group_list>
	//							<bm:group>
	//								<bm:variable_name>superuser</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>authReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>authReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>nonAuthReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>standard_group</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>appExchange_group</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>groups_us_west_sales</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>sales_group</bm:variable_name>
	//							</bm:group>
	//						</bm:group_list>
	//					</bm:each_record>
	//				</bm:User>
	//			</bm:addUsers>
	//		</soapenv:Body>
	public BMXMLDom.Element generateAddUpdateUserSoapBody(String bmCompanyName, String userName, String loginName, Boolean updateUser, Boolean removeUser, String bmUserAccessType)
	{
		// Check if the Add/Update User Header is null or if child nodes are not created or if the username / password has changed
		if (addUpdateBody == null || addUpdateBody.hasChildNodes() == false || currentAddRemoveSoap != updateUser || currentLoginName != loginName)
		{
			currentLoginName = loginName;
			currentAddRemoveSoap = updateUser; 
			
			//User user;
			User[] users = [Select 
							u.CompanyName, u.Username, u.FirstName, u.LastName, u.Title, u.Email, 
							u.Phone, u.Fax, u.Street, u.City, u.State, u.PostalCode, u.Country,
							u.BMCurrencyPreference__c, u.BMLanguage__c, u.BMNumberFormat__c,
							u.BMTimeZone__c, u.BMUnit__c, BMUserGroup__c, u.BMDateFormat__c,
							u.BMUserType__c
						 from User u where u.Username = :userName];
			
			User user;
			// Create element for the big machine API Add/Update user body
			BMXMLDom.Element bmEachRecord = new BMXMLDom.Element(BMGlobal.BM_EACH_RECORD);
			if (users.size() > 0)
			{
				user = users[0];			 
				BMXMLDom.Element bmCompanyNameElement = new BMXMLDom.Element(BMGlobal.BM_COMPANY_NAME);
				bmCompanyNameElement.nodeValue = bmCompanyName;
				System.debug('bmCompanyName -' + bmCompanyName); 
				bmEachRecord.appendChild(bmCompanyNameElement);
				BMXMLDom.Element bmLogin = new BMXMLDom.Element(BMGlobal.BM_LOGIN);
				bmLogin.nodeValue = loginName;
				bmEachRecord.appendChild(bmLogin);
				BMXMLDom.Element bmType = new BMXMLDom.Element(BMGlobal.BM_TYPE);
				System.debug('bmUserAccessType -' + bmUserAccessType);
				bmType.nodeValue = bmUserAccessType;
				bmEachRecord.appendChild(bmType);
				BMXMLDom.Element bmFirstName = new BMXMLDom.Element(BMGlobal.BM_FIRST_NAME);
				if (user.FirstName != null)
					bmFirstName.nodeValue = user.FirstName;
				bmEachRecord.appendChild(bmFirstName);
				BMXMLDom.Element bmLastName = new BMXMLDom.Element(BMGlobal.BM_LAST_NAME);
				if (user.LastName != null)
					bmLastName.nodeValue = user.LastName;
				bmEachRecord.appendChild(bmLastName);
				BMXMLDom.Element bmJobTitle = new BMXMLDom.Element(BMGlobal.BM_JOB_TITLE);
				if (user.Title != null)
					bmJobTitle.nodeValue = user.Title;
				bmEachRecord.appendChild(bmJobTitle);
				BMXMLDom.Element bmEmail = new BMXMLDom.Element(BMGlobal.BM_EMAIL);
				if (user.Email != null)
					bmEmail.nodeValue = user.Email;
				bmEachRecord.appendChild(bmEmail);
				BMXMLDom.Element bmPhone = new BMXMLDom.Element(BMGlobal.BM_PHONE);
				if (user.Phone != null)
					bmPhone.nodeValue = user.Phone;
				bmEachRecord.appendChild(bmPhone);
				BMXMLDom.Element bmFax = new BMXMLDom.Element(BMGlobal.BM_FAX);
				if (user.Fax != null)
					bmFax.nodeValue = user.Fax;
				bmEachRecord.appendChild(bmFax);
				BMXMLDom.Element bmBillAddress = new BMXMLDom.Element(BMGlobal.BM_BILL_ADDRESS);
				if (user.Street != null)
					bmBillAddress.nodeValue = user.Street;
				bmEachRecord.appendChild(bmBillAddress);
				BMXMLDom.Element bmBillAddress2 = new BMXMLDom.Element(BMGlobal.BM_BILL_ADDRESS_2);
				bmBillAddress2.nodeValue = '';
				bmEachRecord.appendChild(bmBillAddress2);
				BMXMLDom.Element bmBillCity = new BMXMLDom.Element(BMGlobal.BM_BILL_CITY);
				if (user.City != null)
					bmBillCity.nodeValue = user.City;
				bmEachRecord.appendChild(bmBillCity);
				BMXMLDom.Element bmBillState = new BMXMLDom.Element(BMGlobal.BM_BILL_STATE);
				if (user.State != null)
					bmBillState.nodeValue = user.State;
				bmEachRecord.appendChild(bmBillState);
				BMXMLDom.Element bmBillStateProvince = new BMXMLDom.Element(BMGlobal.BM_BILL_STATE_PROVINCE);
				bmBillStateProvince.nodeValue = '';
				bmEachRecord.appendChild(bmBillStateProvince);
				BMXMLDom.Element bmBillZip = new BMXMLDom.Element(BMGlobal.BM_BILL_ZIP);
				if (user.PostalCode != null)
					bmBillZip.nodeValue = user.PostalCode;
				bmEachRecord.appendChild(bmBillZip);
				BMXMLDom.Element bmBillCountry = new BMXMLDom.Element(BMGlobal.BM_BILL_COUNTRY);
				//if (user.Country != null)
				//	bmBillCountry.nodeValue = user.Country;
				bmEachRecord.appendChild(bmBillCountry);
				BMXMLDom.Element bmSeparateShipAddr = new BMXMLDom.Element(BMGlobal.BM_SEPARATE_SHIP_ADDR);
				bmSeparateShipAddr.nodeValue = 'false';
				bmEachRecord.appendChild(bmSeparateShipAddr);
				BMXMLDom.Element bmShipAddress1 = new BMXMLDom.Element(BMGlobal.BM_SHIP_ADDRESS_1);
				bmShipAddress1.nodeValue = '';
				bmEachRecord.appendChild(bmShipAddress1);
				BMXMLDom.Element bmShipAddress2 = new BMXMLDom.Element(BMGlobal.BM_SHIP_ADDRESS_2);
				bmShipAddress2.nodeValue = '';
				bmEachRecord.appendChild(bmShipAddress2);
				BMXMLDom.Element bmShipCity = new BMXMLDom.Element(BMGlobal.BM_SHIP_CITY);
				bmShipCity.nodeValue = '';
				bmEachRecord.appendChild(bmShipCity);
				BMXMLDom.Element bmShipState = new BMXMLDom.Element(BMGlobal.BM_SHIP_STATE);
				bmShipState.nodeValue = '';
				bmEachRecord.appendChild(bmShipState);
				BMXMLDom.Element bmShipStateProvince = new BMXMLDom.Element(BMGlobal.BM_SHIP_STATE_PROVINCE);
				bmShipStateProvince.nodeValue = '';
				bmEachRecord.appendChild(bmShipStateProvince);
				BMXMLDom.Element bmShipZip = new BMXMLDom.Element(BMGlobal.BM_SHIP_ZIP);
				bmShipZip.nodeValue = '';
				bmEachRecord.appendChild(bmShipZip);
				BMXMLDom.Element bmShipCountry = new BMXMLDom.Element(BMGlobal.BM_SHIP_COUNTRY);
				bmShipCountry.nodeValue = '';
				bmEachRecord.appendChild(bmShipCountry);
				BMXMLDom.Element bmNotificationPref = new BMXMLDom.Element(BMGlobal.BM_NOTIFICATION_PREF);
				BMXMLDom.Element bmIsNotifyPref = new BMXMLDom.Element(BMGlobal.BM_IS_NOTIFY_PREF);
				bmIsNotifyPref.nodeValue = 'false';
				bmNotificationPref.appendChild(bmIsNotifyPref);
				bmEachRecord.appendChild(bmNotificationPref);
				
				BMXMLDom.Element bmLanguage = new BMXMLDom.Element(BMGlobal.BM_LANGUAGE);
				// Make sure we change the en_US to English
				if (user.BMLanguage__c != null)
					bmLanguage.nodeValue = user.BMLanguage__c;
				bmEachRecord.appendChild(bmLanguage);
				BMXMLDom.Element bmCurrencyPreference = new BMXMLDom.Element(BMGlobal.BM_CURRENCY_PREFERENCE);
				// Not sure where the preference is for USD
				if (user.BMCurrencyPreference__c != null)
					bmCurrencyPreference.nodeValue = user.BMCurrencyPreference__c;
				bmEachRecord.appendChild(bmCurrencyPreference);
				BMXMLDom.Element bmBillFirstName = new BMXMLDom.Element(BMGlobal.BM_BILL_FIRST_NAME);
				if (user.FirstName != null)
					bmBillFirstName.nodeValue = user.FirstName;
				bmEachRecord.appendChild(bmBillFirstName);
				BMXMLDom.Element bmBillLastName = new BMXMLDom.Element(BMGlobal.BM_BILL_LAST_NAME);
				if (user.LastName != null)
					bmBillLastName.nodeValue = user.LastName;
				bmEachRecord.appendChild(bmBillLastName);
				BMXMLDom.Element bmBillCompany = new BMXMLDom.Element(BMGlobal.BM_BILL_COMPANY);
				if (user.CompanyName != null)
					bmBillCompany.nodeValue = user.CompanyName;
				//bmBillCompany.nodeValue = BMGlobal.BM_BILL_COMPANY_VALUE;
				bmBillCompany.nodeValue = ''; 
				bmEachRecord.appendChild(bmBillCompany);
				BMXMLDom.Element bmBillCompany2 = new BMXMLDom.Element(BMGlobal.BM_BILL_COMPANY_2);
				bmBillCompany2.nodeValue = '';
				bmEachRecord.appendChild(bmBillCompany2);
				BMXMLDom.Element bmBillPhone = new BMXMLDom.Element(BMGlobal.BM_BILL_PHONE);
				if (user.Phone != null)
					bmBillPhone.nodeValue = user.Phone;
				bmEachRecord.appendChild(bmBillPhone);
				BMXMLDom.Element bmBillFax = new BMXMLDom.Element(BMGlobal.BM_BILL_FAX);
				if (user.Fax != null)
					bmBillFax.nodeValue = user.Fax;
				bmEachRecord.appendChild(bmBillFax);
				BMXMLDom.Element bmBillEmail = new BMXMLDom.Element(BMGlobal.BM_BILL_EMAIL);
				if (user.Email != null)
					bmBillEmail.nodeValue = user.Email;
				bmEachRecord.appendChild(bmBillEmail);
				BMXMLDom.Element bmShipFirstName = new BMXMLDom.Element(BMGlobal.BM_SHIP_FIRST_NAME);
				bmShipFirstName.nodeValue = '';
				bmEachRecord.appendChild(bmShipFirstName);
				BMXMLDom.Element bmShipLastName = new BMXMLDom.Element(BMGlobal.BM_SHIP_LAST_NAME);
				bmShipLastName.nodeValue = '';
				bmEachRecord.appendChild(bmShipLastName);
				BMXMLDom.Element bmShipCompany = new BMXMLDom.Element(BMGlobal.BM_SHIP_COMPANY);
				bmShipCompany.nodeValue = '';
				bmEachRecord.appendChild(bmShipCompany);
				BMXMLDom.Element bmShipCompany2 = new BMXMLDom.Element(BMGlobal.BM_SHIP_COMPANY_2);
				bmShipCompany2.nodeValue = '';
				bmEachRecord.appendChild(bmShipCompany2);
				BMXMLDom.Element bmShipPhone = new BMXMLDom.Element(BMGlobal.BM_SHIP_PHONE);
				bmShipPhone.nodeValue = '';
				bmEachRecord.appendChild(bmShipPhone);
				BMXMLDom.Element bmShipFax = new BMXMLDom.Element(BMGlobal.BM_SHIP_FAX);
				bmShipFax.nodeValue = '';
				bmEachRecord.appendChild(bmShipFax);
				BMXMLDom.Element bmShipEmail = new BMXMLDom.Element(BMGlobal.BM_SHIP_EMAIL);
				bmShipEmail.nodeValue = '';
				bmEachRecord.appendChild(bmShipEmail);
				BMXMLDom.Element bmUnits = new BMXMLDom.Element(BMGlobal.BM_UNITS);
				//u.BMLanguage__c, u.BMNumberFormat__c, u.BMTimeZone__c
				if (user.BMUnit__c != null)
					bmUnits.nodeValue = user.BMUnit__c;
				//bmUnits.nodeValue = 'System Default';
				bmEachRecord.appendChild(bmUnits);
				BMXMLDom.Element bmDateFormat = new BMXMLDom.Element(BMGlobal.BM_DATE_FORMAT);
				if (user.BMDateFormat__c != null)
					bmDateFormat.nodeValue = user.BMDateFormat__c;
				bmEachRecord.appendChild(bmDateFormat);
				BMXMLDom.Element bmTimeZone = new BMXMLDom.Element(BMGlobal.BM_TIME_ZONE);
				if (user.BMTimeZone__c != null)
					bmTimeZone.nodeValue = user.BMTimeZone__c;
				//bmTimeZone.nodeValue = '(GMT-5:00 GMT-4:00) US Eastern Time';
				bmEachRecord.appendChild(bmTimeZone);
				BMXMLDom.Element bmNumberFormat = new BMXMLDom.Element(BMGlobal.BM_NUMBER_FORMAT);
				if (user.BMNumberFormat__c != null)
					bmNumberFormat.nodeValue = user.BMNumberFormat__c;
				//bmNumberFormat.nodeValue = '####.##';
				bmEachRecord.appendChild(bmNumberFormat);
	
				BMXMLDom.Element bmPartnerLogin = new BMXMLDom.Element(BMGlobal.BM_PARTNER_LOGIN);
				bmPartnerLogin.nodeValue = user.Username;
				bmEachRecord.appendChild(bmPartnerLogin);
	
				BMXMLDom.Element bmPartnerPassword = new BMXMLDom.Element(BMGlobal.BM_PARTNER_PASSWORD);
				bmPartnerPassword.nodeValue = BMGlobal.BM_PARTNER_PASSWORD_VALUE;
				bmEachRecord.appendChild(bmPartnerPassword);
				
				BMXMLDom.Element bmSendPasswordEmail = new BMXMLDom.Element(BMGlobal.BM_SEND_PASSWORD_EMAIL);
				bmSendPasswordEmail.nodeValue = 'false';
				bmEachRecord.appendChild(bmSendPasswordEmail);
	
				BMXMLDom.Element bmStatus = new BMXMLDom.Element(BMGlobal.BM_STATUS);
	
				if (removeUser)
					bmStatus.nodeValue = 'Inactive';
				else
					bmStatus.nodeValue = 'Active';
				bmEachRecord.appendChild(bmStatus);
				
				BMXMLDom.Element bmGroupList = new BMXMLDom.Element(BMGlobal.BM_GROUP_LIST);
				if (user.BMUserType__c == BMGlobal.BM_INTERNAL_USER && user.BMUserGroup__c != null && user.BMUserGroup__c.length() > 0)
				{
					String[] groupsForUser = user.BMUserGroup__c.split(';', 0);
		
					for (String g : groupsForUser)
					{
						BMXMLDom.Element bmGroup = new BMXMLDom.Element(BMGlobal.BM_GROUP);
						BMXMLDom.Element bmVariableName = new BMXMLDom.Element(BMGlobal.BM_VARIABLE_NAME);
						bmVariableName.nodeValue = g.trim();
						bmGroup.appendChild(bmVariableName);
						bmGroupList.appendChild(bmGroup);
					}
				}			
				bmEachRecord.appendChild(bmGroupList);
				//System.Debug('Each Record - ' + bmEachRecord.toXmlString());
			} 
			
			// Call the addUpdate body
			addUpdateBody = SoapBase.getSoapBody();
			
			BMXMLDom.Element bmAddUpdateUsers; 
			if (updateUser)
				// Create a big machine Update Users element
				bmAddUpdateUsers = new BMXMLDom.Element(BMGlobal.BM_UPDATE_USERS);
			else
				// Create a big machine Add Users element
				bmAddUpdateUsers = new BMXMLDom.Element(BMGlobal.BM_ADD_USERS);
				
			// Set the attributes for the big machine Add/Udate Users element
			bmAddUpdateUsers.attributes.put(BMGlobal.XMLNS_BM, BMGlobal.XMLNS_BM_URN);
			
			// Create element for the user info
			BMXMLDom.Element bmUser = new BMXMLDom.Element(BMGlobal.BM_USER);
			// Add each record to User element
			bmUser.appendChild(bmEachRecord);
			// Add User to Add/Update Users element
			bmAddUpdateUsers.appendChild(bmUser);
			// Append the login info for API user to Add/Update Users body
			addUpdateBody.appendChild(bmAddUpdateUsers);
		}
		return addUpdateBody;
	}

	//	<soapenv:Body>
	//		<bm:getUser xmlns:bm="urn:soap.bigmachines.com">
	//			<bm:userInfo>
	//				<bm:user_id>aries3</bm:user_id>
	//			</bm:userInfo>
	//		</bm:getUser>
	//	</soapenv:Body>
	public String generateGetUserSoapBody(String subDomain, String httpValue, String sessionId, String loginName)
	{
		// Check if the Add/Update User Header is null or if child nodes are not created or if the username / password has changed
		if (userBody == null || userBody.hasChildNodes() == false || currentLoginName != loginName)
		{
			currentLoginName = loginName;
			// Call the getSoapBody body
			userBody = SoapBase.getSoapBody();

			// Create a big machine Get User element
			BMXMLDom.Element bmGetUsers = new BMXMLDom.Element(BMGlobal.BM_GET_USER);
				
			// Set the attributes for the big machine Get User element
			bmGetUsers.attributes.put(BMGlobal.XMLNS_BM, BMGlobal.XMLNS_BM_URN);
			// Create element for the user info
			BMXMLDom.Element bmUserInfo = new BMXMLDom.Element(BMGlobal.BM_USER_INFO);
						
			// Create element for the user id
			BMXMLDom.Element bmUserID = new BMXMLDom.Element(BMGlobal.BM_LOGIN);
			bmUserID.nodeValue = loginName;
			
			bmUserInfo.appendChild(bmUserID);
			//System.debug('bmUserInfo ' + bmUserInfo.toXmlString());
			bmGetUsers.appendChild(bmUserInfo);
			//System.debug('bmUserInfo ' + bmGetUsers.toXmlString());

			userBody.appendChild(bmGetUsers);
		}

		// Initialize the root value
		String rootValue = '';
		try
		{
			//System.Debug(this.root.toXmlString());
			//System.Debug('Envelope - ' + getSoapEnvelope().toXmlString());
			// Generate the envelope and at the same time add the soap header element
			BMXMLDom.Element envelope = SoapBase.getSoapEnvelope();
			envelope.appendChild(generateAddUpdateUserSoapHeader(subDomain, httpValue, sessionId));

			// Add the soap body element
			envelope.appendChild(userBody);
			
			// Concatenate encoding and version along with the soap envelope that was created
			rootValue = envelope.toXmlString();
		}
		catch(System.CalloutException e) 
		{
			System.debug('Exception e: ' + e);
		}   
		return rootValue;
	}
	
	// Generate User soap message based on envelop, header and body
	//	<?xml version="1.0" encoding="UTF-8"?>
	//	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	//		<soapenv:Header>
	//			<bm:userInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">
	//				<bm:sessionId>7f00000150447d8961f5a9447b8d23d0c9f7e9f8a1</bm:sessionId>
	//			</bm:userInfo>
	//			<bm:category xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">Users</bm:category>
	//			<bm:xsdInfo xmlns:bm="urn:soap.bigmachines.com" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">
	//				<bm:schemaLocation>http://nsalesdemo.bigmachines.com/bmfsweb/nsalesdemo/schema/v1_0/users/Users.xsd</bm:schemaLocation>
	//			</bm:xsdInfo>
	//		</soapenv:Header>
	//		<soapenv:Body>
	//			<bm:addUsers xmlns:bm="urn:soap.bigmachines.com">
	//				<bm:User>
	//					<bm:each_record>
	//						<bm:company_name>nsalesdemo</bm:company_name>
	//						<bm:login>superuser</bm:login>
	//						<bm:password/>
	//						<bm:type>FullAccess</bm:type>
	//						<bm:first_name>Dennis</bm:first_name>
	//						<bm:last_name>Adams</bm:last_name>
	//						<bm:job_title>System Administrator</bm:job_title>
	//						<bm:email>junk@bigmachines.com</bm:email>
	//						<bm:phone>(847) 572-0300</bm:phone>
	//						<bm:fax>(847) 510-0510</bm:fax>
	//						<bm:bill_address_1>570 W. Lake Cook Road</bm:bill_address_1>
	//						<bm:bill_address_2>Suite 126</bm:bill_address_2>
	//						<bm:bill_city>Deerfield</bm:bill_city>
	//						<bm:bill_state_province>Illinois</bm:bill_state_province>
	//						<bm:bill_zip>60015</bm:bill_zip>
	//						<bm:bill_country>United States</bm:bill_country>
	//						<bm:separate_ship_addr>false</bm:separate_ship_addr>
	//						<bm:ship_address_1/>
	//						<bm:ship_address_2/>
	//						<bm:ship_city/>
	//						<bm:ship_state_province/>
	//						<bm:ship_zip/>
	//						<bm:ship_country/>
	//						<bm:notification_pref>
	//						<bm:is_notify_email>false</bm:is_notify_email>
	//						</bm:notification_pref>
	//						<bm:bm_language>English</bm:bm_language>
	//						<bm:currency_preference>USD</bm:currency_preference>
	//						<bm:bill_first_name>Dennis</bm:bill_first_name>
	//						<bm:bill_last_name>Adams</bm:bill_last_name>
	//						<bm:bill_company>BigMachines</bm:bill_company>
	//						<bm:bill_company_2/>
	//						<bm:bill_phone>(847) 572-0300</bm:bill_phone>
	//						<bm:bill_fax>(847) 510-0510</bm:bill_fax>
	//						<bm:bill_email>admin@bigmachines.demo</bm:bill_email>
	//						<bm:ship_first_name/>
	//						<bm:ship_last_name/>
	//						<bm:ship_company/>
	//						<bm:ship_company_2/>
	//						<bm:ship_phone/>
	//						<bm:ship_fax/>
	//						<bm:ship_email/>
	//						<bm:bm_units>System Default</bm:bm_units>
	//						<bm:date_format>MM/dd/yyyy h:mm a</bm:date_format>
	//						<bm:time_zone>(GMT-5:00 GMT-4:00) US Eastern Time</bm:time_zone>
	//						<bm:number_format>####.##</bm:number_format>
	//						<bm:status>Active</bm:status>
	//						<bm:group_list>
	//							<bm:group>
	//								<bm:variable_name>superuser</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>authReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>authReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>nonAuthReseller</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>standard_group</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>appExchange_group</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>groups_us_west_sales</bm:variable_name>
	//							</bm:group>
	//							<bm:group>
	//								<bm:variable_name>sales_group</bm:variable_name>
	//							</bm:group>
	//						</bm:group_list>
	//					</bm:each_record>
	//				</bm:User>
	//			</bm:addUsers>
	//		</soapenv:Body>
	//	</soapenv:Envelope>
	public String generateAddUpdateRemoveUserSoapMessage(String subDomain, String httpValue, String bmCompanyName, String sessionId, 
			String userName, String loginName, Boolean updateUser, Boolean removeUser, String bmUserAccessType)
	{
		// Initialize the root value
		String rootValue = '';
		try
		{
			//System.Debug(this.root.toXmlString());
			//System.Debug('Envelope - ' + getSoapEnvelope().toXmlString());
			// Generate the envelope and at the same time add the soap header element
			BMXMLDom.Element envelope = SoapBase.getSoapEnvelope();
			envelope.appendChild(generateAddUpdateUserSoapHeader(subDomain, httpValue, sessionId));
			//System.Debug('Envelope with soapHeader - ' + SoapBase.getSoapEnvelope().toXmlString());

			// Add the soap body element
			System.debug('bmCompanyName -' + bmCompanyName);
			System.debug ('bmUserAccessType - ' + bmUseraccessType);
			envelope.appendChild(generateAddUpdateUserSoapBody(bmCompanyName, userName, loginName, updateUser, removeUser, bmUserAccessType));

			//System.Debug('Envelope with soapBody - ' + envelope.toXmlString());

			// Concatenate encoding and version along with the soap envelope that was created
			rootValue = BMGlobal.XML_VERSION_ENCODING + envelope.toXmlString();
		}
		catch(System.CalloutException e) 
		{
			System.debug('Exception e: ' + e);
		}   
		return rootValue;
	}
}