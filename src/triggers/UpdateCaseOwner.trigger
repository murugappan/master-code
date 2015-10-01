trigger UpdateCaseOwner on SurveyTaker__c (before insert) {

    Set<Id> caseId = new Set<ID>();
    Map<Id,String> ownermap = new Map<Id,String>();
    Map<Id,String> prmgrpmap = new Map<Id,String>();
     
    for(SurveyTaker__c st : Trigger.New){
        if(st.Case__c != null)
            caseId.add(st.Case__c);
    }
    
    for(Case c : [select Id,Owner.Name,Primary_Group_Name__c from Case where ID IN: caseId]){
        ownermap.put(c.ID,c.Owner.Name);
        prmgrpmap.put(c.Id,c.Primary_Group_Name__c);
    }
    
    for(SurveyTaker__c st : Trigger.New){
        st.Case_Owner_Name__c = ownermap.get(st.Case__c);
        st.Case_Primary_Group__c = prmgrpmap.get(st.Case__c);
    }

}