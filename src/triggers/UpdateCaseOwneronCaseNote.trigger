trigger UpdateCaseOwneronCaseNote on Case_Note__c (before insert) {

    Set<Id> caseId = new Set<Id>();
    Map<String,String> casemap = new Map<String,String>();
    
    for(Case_Note__c c : Trigger.New){
        caseId.add(c.Case__c);
    }
    
    for(Case c : [select Id,Owner.Name from Case where ID IN: caseId]){
        casemap.put(c.ID,c.Owner.Name);
    }
    
    for(Case_Note__c c : Trigger.New){
        c.Case_Owner__c = casemap.get(c.Case__c);
    }
}