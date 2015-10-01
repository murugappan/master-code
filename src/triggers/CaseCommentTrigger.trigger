trigger CaseCommentTrigger on CaseComment (after insert) {

set<Id> Idset = new set<Id>();
list<Case> updateCases = new list<Case>();
set<Id> createdbyIds = new set<Id>();

for(CaseComment cc: trigger.new){
    if(cc.Id != null){
        Idset.add(cc.parentId);
        createdbyIds.add(cc.CreatedById);
    }
}

list<Case> caseList = [Select id, OwnerId, Days_Since_Last_Case_Owner_Response__c,isFirstCaseComment__c, X1st_Case_Response__c from Case Where id IN: Idset AND Record_Type__c = 'Bb Business Operations'];
    
    for(Case c: caseList){
        if(caseList.size() > 0)
        {
            
            
            
            if(caseList.size() == 1 ){
            
                if(createdbyIds.contains(c.OwnerId) && c.isFirstCaseComment__c == false){
                    c.X1st_Case_Response__c = system.now();
                    c.isFirstCaseComment__c = true;
                    //c.Days_Since_Last_Case_Owner_Response__c = 0;
                    
                    updateCases.add(c);
                }
                
                else if(c.isFirstCaseComment__c == true && !createdbyIds.contains(c.OwnerId)){
                     
                     //c.Days_Since_Last_Case_Owner_Response__c = 0;
                     //integer Days = Integer.valueOf((DateTime.now().getTime() - c.X1st_Case_Response__c.getTime())/(1000*60*60*24));
                     //c.Days_Since_Last_Case_Owner_Response__c = Days;
                     c.isFirstCaseComment__c = false;
                     updateCases.add(c);  
                }
             }
        }
    }
    update updateCases;

}