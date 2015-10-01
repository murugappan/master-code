// Dominic Baker
//
// This is the controller class for the ManageChangeRequest Visualforce page. It will allow Users to view their change request, and request awaiting thier approval.

public with sharing class ManageChangeRequestController 
{
	public class DecisionWrapper
	{
		public CR_Decision__c decision {get; set;}
		public String oldStatus {get; set;}
		
		public DecisionWrapper(CR_Decision__c cd)
		{
			decision = cd;
			oldStatus = decision.Status__c;
		}
		
		public void updateDecision()
		{
			try
			{
				update decision;
			}
			catch (Exception e)
			{
				ApexPages.addMessages(e);
			}
		}
	}
	
	public Boolean isValidApprover {get; set;} // Should be valid member
	public Boolean isValidApprover2 {get; set;}
	public User currentUser {get; set;}
	public list<CR_Approver_Group__c> approverGroups {get; set;}
	public list<CR_Approver_Group_Member__c> members {get; set;}
	public list<Change_Request__c> myRequestList {get; set;}
	public list<CR_Decision__c> pendingApprovalList {get; set;}
	public list<DecisionWrapper> pendingDecisionList {get; set;}
	private String changeRequestPrefix;
	
	// This is the constructor method. It will verify that the current User is authorized to view or make change request.
	public ManageChangeRequestController(ApexPages.StandardController stdController)
	{
		isValidApprover = false;
		isValidApprover2 = false;
		changeRequestPrefix = Change_Request__c.sObjectType.getDescribe().getKeyPrefix();
		loadUser();
		loadGroups();
		if (members != null && !members.isEmpty())
		{
			isValidApprover = true;
			loadMyRequests();
			loadPendingApprovals();
		}
		else
		{
			String message = '';
			
			if (currentUser != null && currentUser.Name != null)
			{
				message = currentUser.Name + ', ';
			}
			
			message += 'You are not an approver or apart of a team. Please contact your manager to be added.';
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, message));
		}
	}
	
	private void loadUser()
	{
		try
		{
			currentUser = [Select Id, Name From User Where Id =: UserInfo.getUserId()];
		}
		catch (Exception e)
		{
			currentUser = new User();
			ApexPages.addMessages(e);
		}
	}
	
	private void loadGroups()
	{
		set<Id> approverGroupIds = new set<Id>();
		members = new list<CR_Approver_Group_Member__c>();
		approverGroups = new list<CR_Approver_Group__c>();
		
		for (CR_Approver_Group_Member__c cagm : [Select Id, Name, CR_Approver_Group__c, CR_Approver_Group__r.Name, Type__c 
												 From CR_Approver_Group_Member__c 
												 Where User__c =: currentUser.Id
												 order by Type__c])
		{
			if (cagm.Type__c != null && cagm.Type__c.contains('Approver'))
			{
				isValidApprover2 = true;
			}
			members.add(cagm);
			approverGroupIds.add(cagm.CR_Approver_Group__c);
		}
		
		if (!approverGroupIds.IsEmpty())
		{
			for (CR_Approver_Group__c cag : [Select Id, Name From CR_Approver_Group__c Where Id IN : approverGroupIds])
			{
				approverGroups.add(cag);
			}
		}
	}
	
	private void loadMyRequests()
	{
		try
		{
			myRequestList = [Select Id, Name, Status__c From Change_Request__c Where OwnerId =: currentUser.Id And IsClosed__c = false];
		}
		catch (Exception e)
		{
			myRequestList = new list<Change_Request__c>();
		}
	}
	
	private void loadPendingApprovals()
	{
		set<Id> approverIds = new set<Id>();
		pendingDecisionList = new list<DecisionWrapper>();
		
		if (members != null)
		{
			for (CR_Approver_Group_Member__c cagm : members)
			{
				if (cagm.Type__c.contains('Approver'))
				{
					approverIds.add(cagm.CR_Approver_Group__c);
				}
			}
		}
		
		for (CR_Decision__c cd : [Select Id, Name, Change_Request__c, Comments__c, CR_Approver_Group__c, Status__c
							   	  From CR_Decision__c 
							   	  Where CR_Approver_Group__c IN : approverIds
							   	  And Status__c = 'Pending'])
		{
			pendingDecisionList.add(new DecisionWrapper(cd));
		}
	}
	
	public void pageRefresh()
	{
		loadMyRequests();
		loadPendingApprovals();
	}
	
	public PageReference goToSettings()
	{
		PageReference pageRef = Page.ChangeRequestSetup;
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public PageReference newRequest()
	{
		return new PageReference('/' + changeRequestPrefix + '/e?retURL=/apex/ManageChangeRequest').setRedirect(true);
	}
	
	public PageReference goToChangeRequestListView()
	{
		return new PageReference('/' + changeRequestPrefix).setRedirect(true);
	}
	
	public static testMethod void testController()
	{
		Profile p = [Select Id From Profile Where Name = 'System Administrator'];
		User u = TestMethodUtility.createUser(p);
		try
		{
			u = [Select Id, Name, Username From User Where Username =: u.Username];
		}
		catch (Exception e)
		{
			u = TestMethodUtility.createUser(p);
			insert u;
		}
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
		Change_Request__c cr = TestMethodUtility.createChangeRequest(so);
		insert cr;
		
		Test.startTest();
			system.runAs(u)
			{
				ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(cr);
				ManageChangeRequestController mcrc = new ManageChangeRequestController(stdController);
				mcrc.pageRefresh();
				mcrc.goToSettings();
				mcrc.newRequest();
				mcrc.goToChangeRequestListView();
			}
		Test.stopTest();
	}
}