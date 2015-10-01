trigger UpdateSendEmail on Case_Recurring_Email__c (after update) {

	List<Case> caslist = new List<Case>();
	Set<ID> caslist1 = new Set<ID>();
	Set<ID> caslist2 = new Set<ID>();
	set<id> CaseResearchlist= new Set<ID>();
	for(Case_Recurring_Email__c d : Trigger.New){
		Case_Recurring_Email__c oldd = Trigger.oldMap.get(d.ID);
		if(oldd.Send_Email__c != d.Send_Email__c){
			caslist1.add(d.Case__c);
		}
		if(oldd.Pending_User_9_days__c != d.Pending_User_9_days__c){
			caslist2.add(d.Case__c);
		}
		if(oldd.Researching_Count__c != d.Researching_Count__c){
			CaseResearchlist.add(d.Case__c);
		}
	}

	for(Case c1 : [select Id,Send_Email__c,Status,Pending_User_9_days__c  from Case where Id IN: caslist1 OR ID IN: caslist2]){
		Case c = new Case(ID = c1.ID);
		System.debug(c1.Pending_User_9_days__c);
		if(caslist1.contains(c1.ID)){ 
			if(c1.Send_Email__c == null){
				c.Send_Email__c = 0;
			}else{
				c.Send_Email__c = c1.Send_Email__c + 1;
			}
			caslist.add(c);  
		}else if(caslist2.contains(c1.ID)){
			if(c1.Pending_User_9_days__c == null){
				c.Pending_User_9_days__c = 0;
			}else{
				c.Pending_User_9_days__c = c1.Pending_User_9_days__c + 1;
			}
			System.debug(c.Pending_User_9_days__c);
			caslist.add(c);       
		}

	}

	for(Case c1 : [select Id,Send_Email__c,Status,Pending_User_9_days__c,Researching_Count__c  from Case where Id IN:CaseResearchlist ]){
		Case c = new Case(ID = c1.ID);
		if(CaseResearchlist.contains(c1.id))
		{
			if(c1.Researching_Count__c == null){
				c.Researching_Count__c = 0;
			}else{
				c.Researching_Count__c = c1.Researching_Count__c + 1;
			}
			caslist.add(c);        
		}
	}          

	Update caslist;
}