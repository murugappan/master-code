public with sharing class RefreshSandbox {
	
	Public RestApiUtility rest;
	Public String username{get;set;}
	Public String password{get;set;}
	Public String message{get;set;}
	Public String source{get;set;}
	public boolean islogin{get;set;}

	public RefreshSandbox() {
		rest=new RestApiUtility();
		Source='Sandbox';
	}

	Public Void Login()
	{
		string key='3MVG9Nc1qcZ7BbZ2l4KH.8nRfOR1lvFdGPvF0i94P2UdmoAZJ8prCGr00cGIf40LvY64NfeARexD0oIEzv7dY';
		string secret='4163843976214368231';
		String URL='';
		if(source=='Production')
		{
			URL='https://login.salesforce.com/services/oauth2/token';
		}
		else if(source=='Sandbox')
		{
			URL='https://test.salesforce.com/services/oauth2/token';
		}
		string status=rest.login(username,password,url,key,secret);
		if(status=='SUCCESS')
		{
			islogin=true;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Login Success. Instance:'+rest.responseToken.instance_url);
			ApexPages.addmessage(myMsg); 
		}
		else
		{
			islogin=false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, status);
			ApexPages.addmessage(myMsg); 
		}

	}

	Public void refresh()
	{
		
		String coreLicencequery='Select Id, Name, Peoplesoft_Group_Id__c, Product__c, Psft_Business_Unit__c From Core_License__c';
		ReSTApiUtility.QueryResult CoreLicenseResult =rest.QueryRecords(CoreLicencequery);

		String issueTopicQuery='Select Id, Name, core_licence__c From Module__c';
		ReSTApiUtility.QueryResult IssueTopicResults =rest.QueryRecords(IssueTopicQuery);

		String FunctionalAreaQuery='Select Id, Name, Module__c From Functional_Area__c';
		ReSTApiUtility.QueryResult FAResults =rest.QueryRecords(FunctionalAreaQuery);

		String CategoryQuery='Select Id, Name, Functional_Area__c From Category__c';
		ReSTApiUtility.QueryResult CategoryResults =rest.QueryRecords(CategoryQuery);

		String AccountQuery='Select id, Name, Type , RecordTypeId, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, Phone, Fax, AccountNumber, Website, Sic, Industry, PS_Company_Id__c,Account_Status__c ,CustomerofAlertNow__c , CustomerofAnalytics__c ,CustomerofANGEL__c ,CustomerOfBbClassicCEVista__c,CustomerofCollaborate__c,CustomerofConnect__c ,CustomerofNetSpot__c,CustomerofEdline__c,CustomerofLearn__c, CustomerofMobile__c,CustomerofStudentServices__c ,CustomerofTransact__c,CustomerofXythos__c,Copy_to_Sandbox__c From Account Where PS_Company_Id__c != null AND Copy_to_Sandbox__c = true';
		ReSTApiUtility.QueryResult AccountResults =rest.QueryRecords(AccountQuery);

		String ContactQuery='Select id, FirstName, LastName,  Email, PS_Person_Id__c, RecordTypeId  From Contact Where Account.PS_Company_Id__c !=null AND PS_Person_Id__c != null AND Account.Copy_to_Sandbox__c = true';
		ReSTApiUtility.QueryResult ContactResults =rest.QueryRecords(ContactQuery);

		String ContactMapQuery='Select  id, Account.PS_Company_Id__c  From Contact Where Account.PS_Company_Id__c !=null AND PS_Person_Id__c != null AND Account.Copy_to_Sandbox__c = true';
		ReSTApiUtility.QueryResult ContactResultMap =rest.QueryRecords(ContactMapQuery);

		String AssetQuery='Select Id, Account.PS_Company_Id__c, CPQ_isCoreItem__c, Name, Description, Asset_Type__c, External_Description__c, Installed_Product_Id__c, Product2.Product_Id_Uom__c, Managed_Hosting__c, Version__c, Version_Build__c, Version_Effective_Date__c, Nickname__c, Psft_Product_Id__c, Software_URL__c, Status, Support_Level__c, Type__c, Platform__c, Product_Type__c from Asset Where Account.PS_Company_Id__c != null AND Account.Copy_to_Sandbox__c = true and Core_License__c!= null';
		ReSTApiUtility.QueryResult AssetResults =rest.QueryRecords(AssetQuery);

		String AssetQueryMap='Select Id, Account.PS_Company_Id__c,  Core_License__c , CPQ_isCoreItem__c, Name, Description, Asset_Type__c, External_Description__c, Installed_Product_Id__c, Product2.Product_Id_Uom__c, Managed_Hosting__c, Version__c, Version_Build__c, Version_Effective_Date__c, Nickname__c, Psft_Product_Id__c, Software_URL__c, Status, Support_Level__c, Type__c, Platform__c, Product_Type__c from Asset Where Account.PS_Company_Id__c != null AND Account.Copy_to_Sandbox__c = true and Core_License__c!= null';
		ReSTApiUtility.QueryResult AssetResultsMap =rest.QueryRecords(AssetQueryMap);

		String ContactRoleQuery='Select Id, Account__r.PS_Company_Id__c,Contact__r.PS_Person_Id__c,Role__c from Contact_Role__c where Account__r.copy_to_sandbox__c=true AND Account__c!=null AND Contact__c!= null AND Contact__r.PS_Person_Id__c !=null AND Contact__r.Account.Copy_to_Sandbox__c =true';
		ReSTApiUtility.QueryResult ContactRoleResults =rest.QueryRecords(ContactRoleQuery);

		String SLAInformationQuery='Select id,Core_License__c,Event_Type__c,Severity__c,SLA__c from SLA_Information__c';
		ReSTApiUtility.QueryResult SLAInformationResults =rest.QueryRecords(SLAInformationQuery);

		String SupportWorkflowQuery='Select Name,Active__c,Active_Closed_Status__c,Active_Open_Status__c,Amazon_Attachment_Option__c,case_record_type__c,Case_Status_Update__c,Close_Case_License__c,Email_Introduction__c,Email_Introduction_Text__c,Email_Signature__c,Email_Signature_Text__c,Email_Signature_Type__c,Email_Subject__c,Include_Case_Summary__c,Portal_Status_Update__c,Publish_to_BTBB__c,Reply_Portal_Status_Update__c,Reply_Status_Update__c,Response_Required_Event__c,Send_Email_to_Case_Owner__c,Send_Email_to_Customer__c,Support_Response_Event__c,User_Option_Response_Required__c from Support_Workflow__c';
		ReSTApiUtility.QueryResult SupportWorkflowResults =rest.QueryRecords(SupportWorkflowQuery);

		String TemplateQuery='Select id,Name,Core_License__r.id,Q1__c,Q10__c,Q2__c,Q3__c,Q4__c,Q5__c,Q6__c,Q7__c,Q8__c,Q9__c,Record_Type__c from Template__c';
		ReSTApiUtility.QueryResult TemplateResults =rest.QueryRecords(TemplateQuery);

		CopyCoreLicense(CoreLicenseResult);
		CopyIssueTopic(IssueTopicResults);
		CopyFunctionalArea(FAResults);
		CopyCategory(CategoryResults);
		CopyAccount(AccountResults);
		CopyContact(ContactResults,ContactResultMap);
		CopyAsset(AssetResults,AssetResultsMap);
		CopyContactRole(ContactRoleResults,ContactRoleResults);
		CopySLAInformation(SLAInformationResults);
		CopySupportWorkflow(SupportWorkflowResults);
		CopyEscalationTemplate(TemplateResults);

	}

    Public void deletedata()
	{ 
		delete [select id from core_license__c];
		delete [select id from Contact where Account.copy_to_sandbox__c=true];
		delete [select id from Asset where Account.copy_to_sandbox__c=true];
		delete [select id from Account where copy_to_sandbox__c=true];
		delete [select id from Support_Workflow__c];
		delete [select id from SLA_Information__c];
		delete [select id from Template__c];
	}

	Public void CopyCoreLicense(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Core_License__c> destinationRecords= new List<Core_License__c>();
			List<Core_License__c> sourceRecords=(List<Core_License__c>)result.records;
			for(Core_License__c cr: sourceRecords)
			{
				//Core_License__c Temprecord= (Core_License__c)cr; //cr.clone(false,false,false,false);
				//Core_License__c newrecord=Temprecord.clone(false,true,false,false);
				Core_License__c newrecord=cr.clone(false,true,false,false);
				newrecord.External_Id_for_migration__c=cr.id;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Core License Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Core License Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyIssueTopic(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Module__c> destinationRecords= new List<Module__c>();
			List<Module__c> sourceRecords=(List<Module__c>)result.records;
			for(Module__c module: sourceRecords)
			{
				
				Core_License__c cr= new Core_License__c(External_Id_for_migration__c=module.core_licence__c);
				Module__c newrecord=new Module__c(name=module.name);
				newrecord.core_licence__r=cr;
				newrecord.External_Id_for_Refresh__c=module.id;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Issue Topic Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Issue Topic Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyFunctionalArea(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Functional_Area__c> destinationRecords= new List<Functional_Area__c>();
			List<Functional_Area__c> sourceRecords=(List<Functional_Area__c>)result.records;
			for(Functional_Area__c record: sourceRecords)
			{
				
				Module__c parent= new Module__c(External_Id_for_Refresh__c=record.module__C);
				Functional_Area__c newrecord=new Functional_Area__c(name=record.name);
				newrecord.Module__r=parent;
				newrecord.External_Id_for_Migration__c=record.id;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Functional Area Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Functional Area Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyCategory(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Category__c> destinationRecords= new List<Category__c>();
			List<Category__c> sourceRecords=(List<Category__c>)result.records;
			for(Category__c record: sourceRecords)
			{
				
				Functional_Area__c parent= new Functional_Area__c(External_Id_for_Migration__c=record.Functional_Area__c);
				Category__c newrecord=new Category__c(name=record.name);
				newrecord.Functional_Area__r=parent;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Category Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Category Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyAccount(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Account> destinationRecords= new List<Account>();
			List<Account> sourceRecords=(List<Account>)result.records;
			for(Account record: sourceRecords)
			{
				
				Account newrecord=record.clone(false,true,false,false);
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Account Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Account Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyContact(ReSTApiUtility.QueryResult result,ReSTApiUtility.QueryResult resultMap)
	{
		if(result.status=='SUCCESS')
		{
			Map<id,Contact> parentMap= new Map<id,Contact>((List<Contact>)resultMap.records);
			List<Contact> destinationRecords= new List<Contact>();
			List<Contact> sourceRecords=(List<Contact>)result.records;
			for(Contact record: sourceRecords)
			{
				
				Contact newrecord=record.clone(false,true,false,false);
				Account parent=new Account(PS_Company_Id__c=parentMap.get(record.id).Account.PS_Company_Id__c);
				newrecord.Account=parent;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contact Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact Copy Failed'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyAsset(ReSTApiUtility.QueryResult result,ReSTApiUtility.QueryResult resultMap)
	{
		if(result.status=='SUCCESS')
		{
			Map<id,Asset> parentMap= new Map<id,Asset>((List<Asset>)resultMap.records);
			List<Asset> destinationRecords= new List<Asset>();
			List<Asset> sourceRecords=(List<Asset>)result.records;
			for(Asset record: sourceRecords)
			{
				
				Asset newrecord=record.clone(false,true,false,false);
				Account parent=new Account(PS_Company_Id__c=parentMap.get(record.id).Account.PS_Company_Id__c);
				Core_License__c cr= new Core_License__c(External_Id_for_migration__c=parentMap.get(record.id).Core_License__c);
				newrecord.Account=parent;
				newrecord.Core_License__r=cr;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Asset Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Asset Copy Failed:'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyContactRole(ReSTApiUtility.QueryResult result,ReSTApiUtility.QueryResult resultMap)
	{
		if(result.status=='SUCCESS')
		{
			Map<id,Contact_role__c> parentMap= new Map<id,Contact_role__c>((List<Contact_role__c>)resultMap.records);
			List<Contact_role__c> destinationRecords= new List<Contact_role__c>();
			List<Contact_role__c> sourceRecords=(List<Contact_role__c>)result.records;
			for(Contact_role__c record: sourceRecords)
			{
				
				Contact_role__c newrecord=record.clone(false,true,false,false);
				Account parent=new Account(PS_Company_Id__c=parentMap.get(record.id).Account__r.PS_Company_Id__c);
				Contact cn= new Contact(PS_Person_Id__c=parentMap.get(record.id).Contact__r.PS_Person_Id__c);
				newrecord.Account__r=parent;
				newrecord.Contact__r=cn;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Asset Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Asset Copy Failed:'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopySLAInformation(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<SLA_Information__c> sourceRecords=(List<SLA_Information__c>)result.records;
			List<SLA_Information__c> destinationRecords= new List<SLA_Information__c>();
			for(SLA_Information__c record: sourceRecords)
			{
				
				SLA_Information__c newrecord=record.clone(false,true,false,false);
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'SLA Information Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'SLA Information Copy Failed:'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopySupportWorkflow(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Support_Workflow__c> sourceRecords=(List<Support_Workflow__c>)result.records;
			List<Support_Workflow__c> destinationRecords= new List<Support_Workflow__c>();
			for(Support_Workflow__c record: sourceRecords)
			{
				
				Support_Workflow__c newrecord=record.clone(false,true,false,false);
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Support Workflow Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Support Workflow:'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}

	Public void CopyEscalationTemplate(ReSTApiUtility.QueryResult result)
	{
		if(result.status=='SUCCESS')
		{
			List<Template__c> sourceRecords=(List<Template__c>)result.records;
			List<Template__c> destinationRecords= new List<Template__c>();
			for(Template__c record: sourceRecords)
			{
				Core_License__c cr= new Core_License__c(External_Id_for_migration__c=record.Core_License__r.id);	
				Template__c newrecord=record.clone(false,true,false,false);
				newrecord.Core_License__r=cr;
				destinationRecords.add(newrecord);
			}
			try{
				system.debug('records--'+destinationRecords);
				upsert destinationRecords;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Escaltion Template Copied');
				ApexPages.addmessage(myMsg); 
		    }
		    Catch(exception e)
		    {
			    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getmessage());
				ApexPages.addmessage(myMsg); 	
		    }
		}
		else
		{
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Escaltion Template:'+result.errormessage);
			ApexPages.addmessage(myMsg); 
		}
	}
}