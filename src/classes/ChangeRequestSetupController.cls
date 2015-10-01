public with sharing class ChangeRequestSetupController 
{
	public class ObjectWrapper
	{
		public Salesforce_Object__c sObj {get; set;}
		public Boolean selected {get; set;}
		public Boolean disabled {get; set;}
		
		public ObjectWrapper(Salesforce_Object__c s)
		{
			selected = false;
			disabled = false;
			sObj = s;
		}
		
		public ObjectWrapper(Salesforce_Object__c s, Boolean flag)
		{
			selected = flag;
			disabled = flag;
			sObj = s;
		}
	}
	
	public list<Salesforce_Object_Approver__c> objectList {get; set;}
	public CR_Approver_Group_Member__c memberRecord {get; set;}
	public list<ObjectWrapper> fullObjectList {get; set;}
	public Boolean isValidMember {get; set;}
	public Boolean isApprover {get; set;}
	public Boolean isEdit {get; set;}
	public Boolean selectAll {get; set;}
	
	public ChangeRequestSetupController()
	{
		isValidMember = false;
		isEdit = false;
		isApprover = false;
		selectAll = false;
		loadGroups();
		if (memberRecord != null && memberRecord.Id != null)
		{
			isValidMember = true;
			loadMyObjects();
			loadAllObjects();
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'You have reached this page in error. You are not an approver or apart of a team.'));
		}
	}
	
	private void loadGroups()
	{
		try
		{
			memberRecord = [Select Id, Name, CR_Approver_Group__c, CR_Approver_Group__r.Name, User__c ,Type__c, User__r.Name
					 		From CR_Approver_Group_Member__c
							Where User__c =: UserInfo.getUserId()];
			
			if (memberRecord.Type__c != null && memberRecord.Type__c.contains('Approver'))
			{
				isApprover = true;
			}
		}
		catch (QueryException  e)
		{
			memberRecord = new CR_Approver_Group_Member__c();
			//ApexPages.addMessages(e);
		}
	}
	
	private void loadMyObjects()
	{
		objectList = new list<Salesforce_Object_Approver__c>();
		
		if (memberRecord != null && memberRecord.CR_Approver_Group__c != null)
		{
			for (Salesforce_Object_Approver__c soa : [Select Id, CR_Approver_Group__c, CR_Approver_Group__r.Name, Salesforce_Object__c, Salesforce_Object__r.Name
											 		  From Salesforce_Object_Approver__c 
											 		  Where CR_Approver_Group__c =: memberRecord.CR_Approver_Group__c])
			{
				if (soa.Salesforce_Object__c != null && soa.CR_Approver_Group__c != null)
				{
					objectList.add(soa);
				}
			}
		}
	}
	
	private void loadAllObjects()
	{
		set<String> currentObjectNames = new set<String>();
		list<String> allObjectNames = new list<String>();
		map<String, Salesforce_Object__c> objectMap = new map<String, Salesforce_Object__c>();
		fullObjectList = new list<ObjectWrapper>();
		
		if (objectList != null && !objectList.isEmpty())
		{
			for (Salesforce_Object_Approver__c soa : objectList)
			{
				if (soa.Salesforce_Object__r.Name != null)
				{
					currentObjectNames.add(soa.Salesforce_Object__r.Name);
				}
			}
		}
		
		for (Salesforce_Object__c so : [Select Id, Name From Salesforce_Object__c])
		{
			if (so.Name != null)
			{
				allObjectNames.add(so.Name);
				objectMap.put(so.Name, so);
			}
		}
		
		allObjectNames.sort();
		
		for (String s : allObjectNames)
		{
			if (objectMap.containsKey(s))
			{
				if (currentObjectNames.contains(s))
				{
					fullObjectList.add(new ObjectWrapper(objectMap.get(s), true));
				}
				else
				{
					fullObjectList.add(new ObjectWrapper(objectMap.get(s)));
				}
			}
		}
	}
	
	private void loadAllObjects2()
	{/*
		map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		set<String> currentObjectNames = new set<String>();
		list<String> objectNames = new list<String>();
		fullObjectList = new list<ObjectWrapper>();
		isEdit = true;
		
		if (objectList != null && !objectList.isEmpty())
		{
			for (Salesforce_Object_Approver__c soa : objectList)
			{
				if (soa.Salesforce_Object__r.Name != null)
				{
					currentObjectNames.add(soa.Salesforce_Object__r.Name);
				}
			}
		}
		
		for (String s : gd.keySet())
		{
			objectNames.add(s);
		}
		
		objectNames.sort();
		
		for (String s : objectNames)
		{
			if (currentObjectNames.contains(s))
			{
				fullObjectList.add(new ObjectWrapper(s, true));
			}
			else
			{
				fullObjectList.add(new ObjectWrapper(s));
			}
		}*/		
	}
	
	public void flipFlags()
	{
		for (ObjectWrapper ow : fullObjectList)
		{
			if (!ow.disabled)
			{
				ow.selected = selectAll;
			}
		}
	}
	
	public PageReference updateObjects()
	{
		set<String> objectNames = new set<String>();
		list<Salesforce_Object__c> temp = new list<Salesforce_Object__c>();
		/*
		for (ObjectWrapper ow : fullObjectList)
		{
			if (ow.selected && !ow.disabled)
			{
				ow.disabled = true;
				objectNames.add(ow.objectName);
				temp.add(new Salesforce_Object__c(Name = ow.objectName));
			}
		}
		
		if (!temp.isEmpty())
		{
			insert temp;
		}*/
		
		list<Salesforce_Object_Approver__c> approvers = new list<Salesforce_Object_Approver__c>();
		
		for (ObjectWrapper ow : fullObjectList)
		{
			if (ow.selected && !ow.disabled && ow.sObj != null)
			{
				ow.disabled = true;
				approvers.add(new Salesforce_Object_Approver__c(Salesforce_Object__c = ow.sObj.Id, CR_ApproveR_Group__c = memberRecord.CR_Approver_Group__c));
			}
		}
		
		if (!approvers.isEmpty())
		{
			insert approvers;
		}
		
		//loadMyObjects();
		selectAll = false;
		return null;
	}
	@Istest
	public static  void testController()
	{
		Profile p = [Select Id From Profile Where Name = 'System Administrator'];
		User u = TestMethodUtility.createUser(p);
		insert u;
		CR_Approver_Group__c cag = TestMethodUtility.createApproverGroup();
		insert cag;
		CR_Approver_Group_Member__c cagm = TestMethodUtility.createApproverGroupMember(cag, u);
		insert cagm;
		Salesforce_Object__c so = TestMethodUtility.createSObject();
		insert so;
		Salesforce_Object_Approver__c soa = TestMethodUtility.createSObjectApprover(so, cag);
		insert soa;
		Salesforce_Object__c so2 = TestMethodUtility.createSObject();
		so2.Name += '2';
		insert so2;
		
		Test.startTest();
			system.runAs(u)
			{
				ChangeRequestSetupController crsc = new ChangeRequestSetupController();
				crsc.selectAll = true;
				crsc.flipFlags();
				crsc.updateObjects();
			}
		Test.stopTest();
	}
}