trigger AttachtoSI on Case_Attachment__c (before insert, before update) {

    Set<ID> caseId = new Set<ID>();
    Set<ID> caseId2 = new Set<ID>();
    
    for(Case_Attachment__c cas : Trigger.New){
        if(cas.Relate_to_SI__c == true){
            if(String.valueof(cas.Related_To__c).length() == 18)
                caseId.add(cas.Related_To__c);
        }
    }
    
    Map<String,String> simap = new Map<String,String>();
    
    for(learnJIRA__c si : [select ID,OriginCaseID__c from learnJIRA__c where OriginCaseID__c IN: caseID]){
        simap.put(si.OriginCaseID__c,si.ID);
    }
    
    
    for(Case_Attachment__c casatt : Trigger.New){
        if(Trigger.isInsert){
            if(casatt.Relate_to_SI__c == true){
                if(simap.containsKey(casatt.Related_To__c))
                    casatt.Support_Incident__c = simap.get(casatt.Related_To__c);
            }
        }else if(Trigger.isUpdate){
            Case_Attachment__c oldatt = Trigger.oldmap.get(casatt.ID);
            if(oldatt.Relate_to_SI__c != casatt.Relate_to_SI__c && casatt.Relate_to_SI__c == true){
                if(simap.containsKey(casatt.Related_To__c))
                    casatt.Support_Incident__c = simap.get(casatt.Related_To__c);            
            }else if(oldatt.Relate_to_SI__c != casatt.Relate_to_SI__c && casatt.Relate_to_SI__c == false){
                    casatt.Support_Incident__c = null;
            }
        }
    }

}