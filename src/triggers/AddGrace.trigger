trigger AddGrace on Responsiveness__c (before insert) {
string day;
    for(Responsiveness__c r : Trigger.New){
    
        if(r.Event_Type__c == 'Initial' && (r.Case_Severity__c == '1' || r.Case_Severity__c == '2'))
        {
            r.Grace_Time__c = 0;
            if(r.Case_Severity__c == '1')
                r.Event_Included__c = true;
        }
        else{
             day = r.Start_Time__c.format('EEE');
            if(day != 'Fri' && day != 'Sat' && day != 'Sun')
                r.Grace_Time__c = 0;
            else{
                if(day == 'Fri')
                    r.Grace_Time__c = 72; 
                else if(day == 'Sat'){
                    String a = r.Start_Time__c.format('H');
                    Integer b = 24 - Integer.valueof(a);
                    r.Grace_Time__c = 48 + b; 
                }else{
                    String a = r.Start_Time__c.format('H');
                    Integer b = 24 - Integer.valueof(a);
                    r.Grace_Time__c = 24 + b; 
                }
            }    
        }
       if(r.Grace_Time__c != null && r.SLA_Expiry_Time__c != null && (day != 'Fri' && day != 'Sat' && day != 'Sun' ))
       { 
                 r.SLA_Expiry_Time__c = r.SLA_Expiry_Time__c.addHours(Integer.valueof(r.Grace_Time__c));
                 
                 }
                 else if(r.Grace_Time__c != null && r.SLA_Expiry_Time__c != null)
                 {
                 if(day == 'Sat')
                 {
                 r.SLA_Expiry_Time__c = datetime.newinstance(system.today().addDays(2),time.newinstance(23,59,59,0));
                 }
                 else if(day =='Sun')
                 {
                 r.SLA_Expiry_Time__c = datetime.newinstance(system.today().addDays(1),time.newinstance(23,59,59,0));

                 }
                 else
                 r.SLA_Expiry_Time__c=system.now().addHours(Integer.valueof(r.Grace_Time__c));
                 }
    }
}