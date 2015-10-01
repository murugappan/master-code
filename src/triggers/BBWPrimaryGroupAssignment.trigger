trigger BBWPrimaryGroupAssignment on Case (before insert, before update) {
       if(globalcomponent.getapiuser(userinfo.getuserid()) != true ){
        CaseTriggerHandler.hasBBWPrimaryRun = true;
        String prevOwnerGroupName;
        List<Case> caslist = new List<Case>();
        List<Case> caslist1 = new List<Case>();
        List<Case> casusrlist = new List<Case>();
        List<Case> casprgrplist = new List<Case>();
        List<Case> casemaillist = new List<Case>();
        Set<ID> userID = new Set<ID>();
        Set<ID> accID = new Set<ID>();
        Set<ID> cId = new Set<ID>(); 
        List<Case_Recurring_Email__c> crlist = new List<Case_Recurring_Email__c>();
        Set<ID> deleteId = new Set<ID>(); 
        Set<ID> closeallmile = new Set<ID>();
        Profile p = [select Id,Name from Profile where Id =: Userinfo.getProfileID()];
        if(p.Name.contains('SRV')||p.Name.contains('BTBB Profile')){
            
            for(Case c : Trigger.New){
            if(Trigger.isInsert && CaseTriggerHandler.hasinsertRun != true){
             if(c.AccountID != null)
             {
                accID.add(c.AccountID);
                }
                else
                {
                accID.add(c.Account_ID__c);
                }  
                caslist.add(c);
             if(c.isclosed != true)
             {
                c.open_time_stamp__c=system.now();
             }
                
               
             }
             else if(Trigger.isUpdate && CaseTriggerHandler.hasupdateRun != true){
                Case oldc = Trigger.oldMap.get(c.ID);
                
                if(c.isClosed != oldc.isclosed && c.isclosed == true)
                    closeallmile.add(c.ID);  
                
                if(c.OwnerID != oldc.OwnerID && String.valueof(c.OwnerID).substring(0,3) == '00G'){
                    casprgrplist.add(c);
                    
                }else if(c.OwnerID != oldc.OwnerID && String.valueof(c.OwnerID).substring(0,3) == '005'){
                    casusrlist.add(c);
                    userID.add(c.OwnerID); 
                }
                if(oldc.Send_Email__c != c.Send_Email__c){
                    casemaillist.add(c);
                    if(c.status=='Solution Suggested')
                    cID.add(c.ID);
                }else if(oldc.Pending_User_9_days__c != c.Pending_User_9_days__c && c.Type != 'Project (including planned upgrades)'){
                    //c.Portal_Status__c = 'Closed' ;     //TP1969
                     casemaillist.add(c);
                     cID.add(c.ID);
                }
                if((oldc.Researching_Count__c != c.Researching_Count__c))
                {
                    c.status='Needs Attention';
                }
                if(oldc.Status != c.Status && (c.Status == 'Pending User' || c.status =='Solution Suggested' || c.status=='Researching')){
                    caslist1.add(c);    
                }
               
             
              
                     
            }
        }    
      }
      
    if(Trigger.isUpdate )
      { 
      for(case c:trigger.new)
      {
      Case oldc = Trigger.oldMap.get(c.ID);
      //if(c.Status != oldc.Status || (c.OwnerID != oldc.OwnerID && String.valueof(c.OwnerID).substring(0,3) == '005')) Commented for 1850 TP
                if(c.Status != oldc.Status)
                     deleteId.add(c.ID);             //TP 2875 include status change triggered from e mails
                      
     }
    
      }
      
        if(closeallmile.size() > 0){
            Datetime t = System.now();
            for(List<CaseMilestone> cmsToUpdate :[select Id, completionDate from CaseMilestone cm  where caseId IN: closeallmile AND completionDate = null]){
                for(CaseMilestone c : cmsToUpdate){
                    c.completionDate = t;
                }
                Update cmsToUpdate;
            }
        }
       
        if(deleteId.size() > 0){
            List<Case_Recurring_Email__c> deletecrlist = new List<Case_Recurring_Email__c>([select ID from Case_Recurring_Email__c where Case__c IN: deleteId]);
            delete deletecrlist; 
        }
        
        if(casemaillist.size() > 0){
            CaseRecurringEmail cr = new CaseRecurringEmail();
            cr.sendCaseEmail(casemaillist,cID);
            for(Case c : Trigger.New){
                if(cId.contains(c.ID))
                {
                    c.Status = 'Closed';
                    c.Reason='No response from client';
                }    
            }
        }
        
        if(caslist1.size() > 0){
            for(Case c : caslist1){
                Case_Recurring_Email__c cr = new Case_Recurring_Email__c();
                cr.Case__c = c.ID; 
                crlist.add(cr);
            }
        }
        
        Upsert crlist;
        
        Map<String,String> queuemap = new Map<String,String>();
    
        for(List<Group> g : [select ID,Name from Group where Type = 'Queue']){
                for(Group g1 : g){
                    queuemap.put(g1.ID,g1.Name); 
                }
        }
       
        if(caslist.size() > 0){
           Case_Assignment cas_asgn = new Case_Assignment();
           cas_asgn.changeowner(caslist,accID);
        }  
       
        
       for(case c:trigger.new )  //for TP546 
    {
    if(Trigger.isUpdate && CaseTriggerHandler.hasupdateRun != true)
    {
    Case oldc = Trigger.oldMap.get(c.ID);
     
               if((c.Submit_for_Case_Review__c !=  oldc.Submit_for_Case_Review__c) && (c.Submit_for_Case_Review__c == true))
               {
               if(oldc.Submit_for_Case_Review_time__c == null)
               {
               c.Submit_for_Case_Review_time__c= system.now();
               }
               }  
    }
    if(Trigger.isUpdate )
    {
        
    if(((c.follow_the_sun__c != Trigger.oldMap.get(c.ID).follow_the_sun__c ) && (c.follow_the_sun__c == true) && c.status != 'Closed')||((c.status!=Trigger.oldMap.get(c.ID).status)&&(c.status=='Reopened')&&c.follow_the_sun__c == true))
    {
        c.FTS_Date_Time__c = system.now();
    }
    else if((c.follow_the_sun__c != Trigger.oldMap.get(c.ID).follow_the_sun__c ) && (c.follow_the_sun__c == false) && c.status != 'Closed')
    {
    
    //c.Time_in_FTS_counter__c = ((c.Time_in_FTS_counter__c != null)?c.Time_in_FTS_counter__c:0.0)  + ((system.now().gettime()-c.FTS_Date_time__c.gettime())/(1000.0*60.0*60.0));
    c.Time_in_FTS_counter__c =  Trigger.oldMap.get(c.ID).Time_in_FTS__c;
    }
    else if((c.status!=Trigger.oldMap.get(c.ID).status)&& (c.status == 'Closed'||c.status == 'Closed - Duplicate Case'||c.status == 'Closed - Future Reference'||c.status == 'Closed - Not Fixed'||c.status == 'Closed - Pending Target'||c.status == 'Closed - Pending Release'||c.status == 'Solution Suggested') )
    {
    c.follow_the_sun__c=false;
    //c.Time_in_FTS_counter__c = ((c.Time_in_FTS_counter__c != null)?c.Time_in_FTS_counter__c:0.0)+ ((system.now().gettime()-c.FTS_Date_time__c.gettime())/(1000.0*60.0*60.0));
    c.Time_in_FTS_counter__c = Trigger.oldMap.get(c.ID).Time_in_FTS__c; 
    }
    //Time in Pending User TP3032
    if((c.status!=Trigger.oldmap.get(C.ID).status)&&(c.status=='Pending User'))
    {
    c.pending_User_time_stamp__c=system.now();
    }
    else if((c.status!=Trigger.oldmap.get(C.ID).status)&&(Trigger.oldmap.get(C.ID).status=='Pending User'))
    {
    c.PendingUser_time_counter__c=  Trigger.oldMap.get(c.ID).Time_in_Pending_User__c;
    }
    
    system.debug('case--open--'+c.isclosed+'old--'+Trigger.oldMap.get(c.ID).isclosed); 
    // Time Open  TP 3031
    if((c.isclosed!=Trigger.oldMap.get(c.ID).isclosed) &&(c.isclosed==true)  )
    {
        system.debug('open time stamp--1');
     c.Open_time_Counter__c=Trigger.oldMap.get(c.ID).Time_open__c;  
    }
    else if((c.isclosed!=Trigger.oldMap.get(c.ID).isclosed) &&(c.isclosed==false))
    {
        system.debug('open time stamp--2');
        c.open_time_stamp__c=system.now();
    }
    //Time Open Tier2
    if((c.Escalated_Tier_2__c!=Trigger.oldMap.get(c.ID).Escalated_Tier_2__c) &&(c.Escalated_Tier_2__c==false)&& !c.isclosed  )
    {
     c.Open_Time_Counter_Tier2__c=Trigger.oldMap.get(c.ID).Time_Open_Tier_2__c;  
    }
    else if((c.Escalated_Tier_2__c!=Trigger.oldMap.get(c.ID).Escalated_Tier_2__c) &&(c.Escalated_Tier_2__c==true) && !c.isclosed)
    {
        c.Open_Time_Stamp_tier2__c=system.now();
    }
    else if((c.isclosed!=Trigger.oldMap.get(c.ID).isclosed) &&(c.isclosed==true)&&(c.Escalated_Tier_2__c==true) )
    {
     c.Open_Time_Counter_Tier2__c=Trigger.oldMap.get(c.ID).Time_Open_Tier_2__c; 
    }
    else if((c.isclosed!=Trigger.oldMap.get(c.ID).isclosed) &&(c.isclosed==false)&&(c.Escalated_Tier_2__c==true))
    {
        c.Open_Time_Stamp_tier2__c=system.now();
    }
    
    }
    if(Trigger.isInsert && CaseTriggerHandler.hasinsertRun != true)
    {
    if(c.follow_the_sun__c == true && c.status != 'Closed')
    {
        c.FTS_Date_Time__c = system.now();
    }
    if(c.status=='Pending User')   //TP3032 initialization
    {
    c.pending_user_time_stamp__c=system.now();  
    }
    
    }
    }  
        
          
        
        Map<String,String> usrmap = new Map<String,String>();
        
        for(List<User> usrlist : [select ID,Primary_Group__c from User where ID IN: userID]){
            for(User u : usrlist){
                usrmap.put(u.ID,u.Primary_Group__c);
            }
        }    
        system.debug('asdasdasdasd');
        if(casusrlist.size() > 0){
            for(Case c : casusrlist){
                c.Primary_Group_Name__c = usrmap.get(c.OwnerID);
               
            }
        }
        
        if(casprgrplist.size() > 0){
            for(Case c : casprgrplist){
                c.Primary_Group_Name__c = queuemap.get(c.OwnerID);
               
            }
        }  
         if(Trigger.isInsert && CaseTriggerHandler.hasinsertRun != true){
         for(case c:caslist){
            c.Queue_Name__c=c.Primary_Group_Name__c;
        }
            }
         if(Trigger.isInsert)
         {
            CaseTriggerHandler.hasinsertRun = true;
         }  
         else if(Trigger.isUpdate)
         {
            CaseTriggerHandler.hasupdateRun = true;
         } 
    }
            
}