/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*   @name       :   Trigger_Non_time_based_alerts
*   @object:    :   Case
*   @scope      :   Case, Profile
*   @dataload   :   Yes
*   @abstract   :   Updates fields on the case that control workflow for Non-Time-Based Alerts.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
trigger Trigger_Non_time_based_alerts on Case (after insert,after update) {

    List<Case> caslist = new List<Case>();
    Set<ID> cas_stat_change = new Set<ID>();
    Set<ID> cas30minmail = new Set<ID>();
    Set<ID> cas45minmail = new Set<ID>();
    Set<ID> cas60minmail = new Set<ID>(); 
    List<Case> cashourlymail = new List<Case>(); 
     Set<ID> deleteId = new Set<ID>(); 

    profile p=[select  id,name from profile where id=:userinfo.getprofileid()];
         for(Case c : Trigger.New){
            if(Trigger.isUpdate){
                Case oldc = Trigger.oldMap.get(c.ID);
                if((c.Status != oldc.Status && (c.Status == 'Reopened' || c.Status == 'Needs Attention')) || (c.Case_Severity__c == '1' && c.Case_Severity__c != oldc.Case_Severity__c && (oldc.Case_Severity__c == '2' || oldc.Case_Severity__c == '3' || oldc.Case_Severity__c == '4')))
                    caslist.add(c);
                if(c.Case_Severity__c == '1' && c.Case_Severity__c != oldc.Case_Severity__c && (oldc.Case_Severity__c == '2' || oldc.Case_Severity__c == '3' || oldc.Case_Severity__c == '4'))
                    cas_stat_change.add(c.ID);
                if(c.X30_mins_mail__c != oldc.X30_mins_mail__c && c.X30_mins_mail__c == true)
                    cas30minmail.add(c.ID); 
                if(c.X45_min_mail__c != oldc.X45_min_mail__c && c.X45_min_mail__c == true)
                    cas45minmail.add(c.ID); 
                if(c.X60_min_mail__c != oldc.X60_min_mail__c && c.X60_min_mail__c == true)
                    cas60minmail.add(c.ID);
                if(c.Reopen_Counter__c != oldc.Reopen_Counter__c)
                    cas30minmail.add(c.ID); 
                if(c.Reopen_Counter_45min__c != oldc.Reopen_Counter_45min__c)
                    cas45minmail.add(c.ID);
                if(c.Reopen_Counter_60min__c != oldc.Reopen_Counter_60min__c)
                    cas60minmail.add(c.ID);
                
                 
           
            } 
        }   
        
   
    

    if(caslist.size() > 0){
        Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
        ntb.ntb_alerts(caslist,cas_stat_change);
    }

    if(cas30minmail.size() > 0){
        Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
        ntb.Thirtyminmail(cas30minmail);
    }

    if(cas45minmail.size() > 0){
        Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
        ntb.FortyFiveminmail(cas45minmail);
    }
    
    if(cas60minmail.size() > 0){
        Non_Time_based_Alerts ntb = new Non_Time_based_Alerts();
        ntb.sixtyminmail(cas60minmail);
    }
}