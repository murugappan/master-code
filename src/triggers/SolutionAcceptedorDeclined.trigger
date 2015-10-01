trigger SolutionAcceptedorDeclined on Solution_Detail__c (after update) {
   if(globalcomponent.getapiuser(userinfo.getuserid()) != true){

    Set<ID> closecase = new Set<ID>();
    Set<ID> opencase = new Set<ID>();
     
    for(Solution_Detail__c sd : Trigger.New){
        Solution_Detail__c oldsd = Trigger.oldMap.get(sd.ID);
        if(sd.Status__c != oldsd.Status__c && sd.Status__c == 'Successful Resolution')
            closecase.add(sd.Case__c);
        else if(sd.Status__c != oldsd.Status__c && sd.Status__c == 'Failed Resolution')
            opencase.add(sd.Case__c);
    }
    
    List<Case> updcase1 = new List<Case>();
    
    for(List<Case> c : [select Status,Customer_Portal_Status__c,ID from Case where ID IN: closecase AND Status != 'Closed']){
        for(Case c1 : c){
            Case c2 = new Case(Id = c1.ID);
            c2.Status = 'Closed';
           // c2.Portal_Status__c = 'Closed';
            updcase1.add(c2);              
        }
    }
    
    if(updcase1.size() > 0)
        Update updcase1;
        
    List<Case> updcase2 = new List<Case>();
    
    for(List<Case> c : [select Status,Customer_Portal_Status__c,ID from Case where ID IN: opencase AND Status != 'Needs Attention']){
        for(Case c1 : c){
            Case c2 = new Case(Id = c1.ID);
            c2.Status = 'Reopened';
            c2.Case_Reopened__c = true;
        //    c2.Portal_Status__c = 'Work In Progress';
            updcase2.add(c2);              
        }
    }
    
    if(updcase2.size() > 0)
        Update updcase2;    
   }
}