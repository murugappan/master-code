trigger fillApproverList on Bb_Approvals__c (before insert, before update) 
{
	for(Bb_Approvals__c a: Trigger.new) 
  	{    
		a.Managed_Hosting_User__c = null;
		a.Services_User__c = null;
		a.Training_User__c = null;
		a.Presidium_User__c = null;
		a.Vertical_Leadership_User__c = null;
		a.RVP_User__c = null;
		a.Mobile_User__c = null;
			
		// String vars and default Region
		String defaultApprover, verticalRegion = 'NAHE-NE' ;			
		
		List<User> u = [Select Vertical_Region__c From User Where Id In (Select o.OwnerId From Opportunity o Where o.Id = :a.Opportunity__c) Limit 1];
		if ( u.size() == 1 )
		{
			verticalRegion = u[0].Vertical_Region__c;
		}

 		// fill the lookup Map 
		Map<String, Id> routings = new Map<String, Id>();
		List<ApprovalRouting__c> routes = 	[Select ApproverType__c, Approver__c From ApprovalRouting__c Where VerticalRegion__c = :verticalRegion ];
		for ( ApprovalRouting__c appRouting :routes )
		{
			routings.put(appRouting.ApproverType__c , appRouting.Approver__c);			
		}

		if ( a.Managed_Hosting__c )
		{
			a.Managed_Hosting_User__c = routings.get('Managed Hosting');
			defaultApprover = routings.get('Managed Hosting');
  		}
 		
  		if ( a.Services__c == true)
		{			
			a.Services_User__c =  routings.get('Services');
			defaultApprover =  routings.get('Services');
  		}
  		
  		if ( a.Training__c == true)
		{			
			a.Training_User__c = routings.get('Training');
			defaultApprover = routings.get('Training');	
  		}
		
  		if ( a.Presidium__c == true)
		{			
			a.Presidium_User__c = routings.get('Presidium');
			defaultApprover = routings.get('Presidium');			
  		}
 
  		if ( a.Vertical_Leadership__c == true)
		{			
			a.Vertical_Leadership_User__c =  routings.get('Vertical Leadership');	
			defaultApprover = routings.get('Vertical Leadership');
		}

  		if ( a.RVP__c == true)
		{			
			a.RVP_User__c = routings.get('RVP');
			defaultApprover = routings.get('RVP');
  		}
  		
  		if ( a.Mobile__c == true)
		{			
			a.Mobile_User__c = routings.get('Mobile');
			defaultApprover = routings.get('Mobile');
  		}
  		
  		// now fill in any blanks
  		if ( a.Managed_Hosting_User__c == null ) a.Managed_Hosting_User__c = defaultApprover;
   		if ( a.Services_User__c == null ) a.Services_User__c = defaultApprover;
   		if ( a.Training_User__c == null ) a.Training_User__c = defaultApprover;
   		if ( a.Presidium_User__c == null ) a.Presidium_User__c = defaultApprover;
   		if ( a.Vertical_Leadership_User__c == null ) a.Vertical_Leadership_User__c = defaultApprover;
   		if ( a.RVP_User__c == null ) a.RVP_User__c = defaultApprover;
   		if ( a.Mobile_User__c == null ) a.Mobile_User__c = defaultApprover;
  	
	}// end-for
}// end-trigger