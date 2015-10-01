trigger Calculate on Responsiveness__c (before update){
    
    Map<String,String> casemap = new Map<String,String>();
    Map<String,Map<String,Decimal>> initialmap = new Map<String,Map<String,Decimal>>();
    Map<String,Map<String,Decimal>> followupmap = new Map<String,Map<String,Decimal>>();
    Set<ID> caseId = new Set<ID>();
    
    for(SLA_Information__c sl : [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Initial']){   
            Map<String,Decimal> sltemp = new Map<String,Decimal>();
            if(initialmap.containskey(sl.Core_License__c)){
               sltemp = initialmap.get(sl.Core_License__c);
               sltemp.put(sl.Severity__c,sl.SLA__c);
               initialmap.put(sl.Core_License__c,sltemp); 
            }else{
                sltemp.put(sl.Severity__c,sl.SLA__c);
                initialmap.put(sl.Core_License__c,sltemp); 
            }
    }
    
    for(SLA_Information__c sl : [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup']){   
            Map<String,Decimal> sltemp = new Map<String,Decimal>();
            if(followupmap.containskey(sl.Core_License__c)){
               sltemp = followupmap.get(sl.Core_License__c);
               sltemp.put(sl.Severity__c,sl.SLA__c);
               followupmap.put(sl.Core_License__c,sltemp); 
            }else{
                sltemp.put(sl.Severity__c,sl.SLA__c);
                followupmap.put(sl.Core_License__c,sltemp); 
            }
    }
    for(Responsiveness__c r : Trigger.New){
        caseId.add(r.Case__c);
    }
    
    for(Case c : [select Id,BusinessHoursId from Case where ID IN: caseId]){
        casemap.put(c.ID,c.BusinessHoursID);
    }
    
    
    for(Responsiveness__c r : Trigger.New){
        Responsiveness__c oldr = Trigger.oldMap.get(r.ID);
        if(r.Stop_Time__c != oldr.Stop_Time__c && r.Stop_Time__c != null)
            r.Event_Included__c = true;
        else if(r.Case_Severity__c != '1'){
            String day = r.Start_Time__c.format('EEE');
            if(day == 'Fri' && (((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, System.now())/1000)/60)/60) > 72) 
                r.Event_Included__c = true;
            else if(day == 'Sat' && (((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, System.now())/1000)/60)/60) > 48) 
                r.Event_Included__c = true;
            else if(day == 'Sun' && (((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, System.now())/1000)/60)/60) > 24) 
                r.Event_Included__c = true;    
        }   
        if(r.Stop_Time__c != null) 
            r.Response_Time__c = BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c,r.Stop_Time__c);
            
        if(r.Stop_Time__c == null)
            r.SLA__c = false;
        else if(r.Stop_Time__c != null){
            r.No_Response__c = false;
            if(r.Case_Severity__c == '1' || r.Case_Severity__c == '2'){
                if(r.Event_Type__c == 'Initial' && r.SLA_Expiry_Time__c != null){
                    if((((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, r.Stop_Time__c)/1000)/60)/60) <= (((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, r.SLA_Expiry_Time__c)/1000)/60)/60))
                         r.SLA__c = true;
                     else    
                         r.SLA__c = false;
                }else if(r.Event_Type__c == 'Follow Up'){
                    if(r.Grace_Time__c != null && ((((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, r.Stop_Time__c)/1000)/60)/60) - r.Grace_Time__c) <= 24)
                         r.SLA__c = true;
                     else    
                         r.SLA__c = false;
                }
            }else if((r.Case_Severity__c == '3' || r.Case_Severity__c == '4') && r.SLA_Expiry_Time__c != null){
                if((((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, r.Stop_Time__c)/1000)/60)/60) <= (((BusinessHours.diff(casemap.get(r.Case__c), r.Start_Time__c, r.SLA_Expiry_Time__c)/1000)/60)/60))
                         r.SLA__c = true;
                     else    
                         r.SLA__c = false;                
            }
        }    
    }
}