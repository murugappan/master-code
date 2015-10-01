/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*   @name       :   CaseResponse
*   @object:    :   Case
*   @scope      :   Responsiveness (insert/update), SLA Information, BusinessHours, Case, User
*   @dataload   :   Yes
*   @abstract   :   Inserts/Updates Responsiveness Records Based Upon Case Status/Severity
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
trigger CaseResponse on Case (after insert, after update) {
    if((globalcomponent.getapiuser(userinfo.getuserid()) != true) && !userinfo.getusername().contains('pddireleads@blackboard.com')){
    List<Responsiveness__c> reslist = new List<Responsiveness__c>();
    List<Responsiveness__c> reslist1 = new List<Responsiveness__c>();
    Map<ID,DateTime> closedID = new Map<ID,DateTime>();
    Map<String,Map<String,Decimal>> slamap = new Map<String,Map<String,Decimal>>();  
    
    Profile p = [select Id,Name from Profile where Id =: Userinfo.getProfileID()];
    if(p.Name.contains('SRV')||Userinfo.getUserName().contains('pddireleads@blackboard')){
        for(SLA_Information__c sl : [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Initial']){   
            Map<String,Decimal> sltemp = new Map<String,Decimal>();
            if(slamap.containskey(sl.Core_License__c)){
               sltemp = slamap.get(sl.Core_License__c);
               sltemp.put(sl.Severity__c,sl.SLA__c);
               slamap.put(sl.Core_License__c,sltemp); 
            }else{
                sltemp.put(sl.Severity__c,sl.SLA__c);
                slamap.put(sl.Core_License__c,sltemp); 
            }
        }
    
        for(Case c : Trigger.New){
            if(Trigger.isInsert && p.Name.contains('SRV')){
                Responsiveness__c res = new Responsiveness__c();
                res.Case__c = c.ID;
                res.Start_Time__c = c.CreatedDate;
                res.Start_Event__c = 'Case Create';
                res.Event_Type__c= 'Initial';
                if(String.valueof(c.OwnerId).substring(0,3) == '005'){
                   User u = [select Id,Primary_Group__c,FirstName,LastName,name from User where ID =: String.valueof(c.OwnerId)];
                   String ownername;
                   ownername = u.FirstName + u.LastName;
                   res.Event_Owner__c = u.name;
                   res.Event_Owner_Primary_Group__c = u.Primary_Group__c;
                }else
                   res.Event_Owner__c = c.Primary_Group_Name__c;
                   res.Event_Owner_Primary_Group__c = c.Primary_Group_Name__c;
                   BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
                   if(c.Case_Severity__c != null && c.Case_Severity__c.length() == 1 && c.Case_Record__c != null){
                     Map<String,Decimal> sltemp = new Map<String,Decimal>();
                     if(c.Case_record__c.contains('ANGEL')){
                         sltemp = slamap.get('ANGEL');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }else if(c.Case_record__c.contains('Learn')){
                         sltemp = slamap.get('Learn');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }else if(c.Case_record__c.contains('CE')){
                         sltemp = slamap.get('CE');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }else if(c.Case_record__c.contains('Xythos')){
                         sltemp = slamap.get('Xythos');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }else if(c.Case_record__c.contains('Transact')){
                         sltemp = slamap.get('Transact');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }else if(c.Case_record__c.contains('Collaborate')){
                         sltemp = slamap.get('Collaborate');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                         	
                       }else if(c.Case_record__c.contains('Moodlerooms')){
                         sltemp = slamap.get('Moodlerooms');
                         if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                             res.SLA_Expiry_Time__c =  BusinessHours.add(c.BusinessHoursID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         else{
                             String day = c.CreatedDate.format('EEE');
                             if(day == 'Fri')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 48) * 60 * 60 * 1000L);
                             else if(day == 'Sat')
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sltemp.get(c.Case_Severity__c)) + 24) * 60 * 60 * 1000L);
                             else
                               res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sltemp.get(c.Case_Severity__c)) * 60 * 60 * 1000L);
                         } 
                     }   
                }
                reslist.add(res);
            }else if(Trigger.isUpdate){
                Case oldc = Trigger.oldMap.get(c.ID);
                if(c.Isclosed != oldc.isClosed && c.Isclosed == true){
                   closedID.put(c.ID,c.ClosedDate); 
                }
            }    
        }
    }
    if(reslist.size() > 0)
        Insert reslist;
        
    if(closedId.size() > 0){
        for(List<Responsiveness__c> res : [select ID,Case__c,Stop_Time__c from Responsiveness__c where Case__c IN: closedID.keyset() AND Stop_Time__c = null ORDER BY Case__c]){
            for(Responsiveness__c res1 : res){
                Responsiveness__c res2 = new Responsiveness__c(ID = res1.ID);
                res2.Stop_Time__c =  closedID.get(res1.Case__c);
                reslist1.add(res2);
            }
        }
    }    
    
    Update reslist1;
    }
}