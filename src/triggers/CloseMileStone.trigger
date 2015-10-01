/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*   @name       :   CloseMilestone
*   @object:    :   Case
*   @scope      :   Case,CaseMilestone,MilestoneType
*   @dataload   :   Yes
*   @abstract   :   Controls the Closure of Tier 1/Tier 2 Escalation/Closure.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
trigger CloseMileStone on Case (after update) {

   if( globalcomponent.getapiuser(Userinfo.getUserId()) == false ){

    Set<ID> firstresponse = new Set<ID>();
    Set<ID> firstescal = new Set<ID>();
    Set<ID> secondescal = new Set<ID>();
    Datetime t = System.now();
    
    for(Case c: Trigger.New){
        Case c1 = Trigger.oldmap.get(c.ID);
      
        if(c.Escalated_Tier_2__c != c1.Escalated_Tier_2__c && c.Escalated_Tier_2__c == true)
            firstescal.add(c.ID);
        else if(c.Escalated_Tier_3__c != c1.Escalated_Tier_3__c && c.Escalated_Tier_3__c == true)
            secondescal.add(c.ID);     
    }

    if(firstescal.size() > 0){
        for(List<CaseMilestone> cmsToUpdate :[select Id, completionDate from CaseMilestone cm  where caseId IN: firstescal and cm.MilestoneType.Name =: 'Tier 1 Escalation / Closure' AND completionDate = null]){
            for(CaseMilestone c : cmsToUpdate){
                c.completionDate = t;
            }
            Update cmsToUpdate;
        }
    }
    
    if(secondescal.size() > 0){
        for(List<CaseMilestone> cmsToUpdate :[select Id, completionDate from CaseMilestone cm  where caseId IN: secondescal and cm.MilestoneType.Name =: 'Tier 2 Escalation / Closure' AND completionDate = null]){
            for(CaseMilestone c : cmsToUpdate){
                c.completionDate = t;
            }
            Update cmsToUpdate;
        }
    }
    }
}