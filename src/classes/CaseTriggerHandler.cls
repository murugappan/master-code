public without sharing class CaseTriggerHandler 
{
    public static Boolean hasRun {get{if (hasRun == null) return false; return hasRun;} private set;}
    public static Boolean hasAfterInsertRun {get{if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} private set;}
    public static Boolean hasBeforeUpdateRun {get{if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} private set;}
    public static Boolean hasAfterUpdateRun {get{if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} private set;}
    public static Boolean hasBBWPrimaryRun {get; set;} // This variable is here because of an old trigger
    public static Boolean hasupdateRun {get; set;}
    public static Boolean hasinsertRun {get;set;}
     public static Boolean hasupdatePsftProductIdRun{get{if (hasupdatePsftProductIdRun == null) return false; return hasupdatePsftProductIdRun;}private set;}
     map<id,Schema.RecordTypeInfo> caserecodtypemap{
        get{
            return Schema.SObjectType.Case.getRecordTypeInfosById();        
        }
     }
    
    public CaseTriggerHandler()
    {
        hasRun = true;
    }
    
    public void afterInsert(list<Case> newList)
    {
        if (!hasAfterInsertRun)
        {
            set<Id> supportIncidentIdSet = new set<Id>();
            map<Id, learnJIRA__c> supportIncidentMap;
            list<learnJIRA__c> siUpdateList;
            hasAfterInsertRun = true;
            
            for (Case c : newList)
            {
                if (c.LearnJIRA_SI__c != null)
                {
                    supportIncidentIdSet.add(c.LearnJIRA_SI__c);
                }
            }
            supportIncidentMap = querySIsOnCase(supportIncidentIdSet);
            
            if (globalcomponent.getapiuser(UserInfo.getuserid()) != true && !LearnJIRATriggerHandler.hasRun)
            {
                siUpdateList = modifySupportIncidents(newList, null, supportIncidentMap);
            }
            
            // Dml Operations
            updateSupportIncidentList(siUpdateList);
        
        //TP3031 
          list<Case> caseupdatelist=new list<Case>();  
             for (Case c : newList)
            {
             case cs=new case(id=c.id);
            cs.open_time_stamp__c=c.createddate;  //TP3031 initialization
            caseupdatelist.add(cs);
            }
        //DML for TP3031    
          updatecaselist(caseupdatelist) ; 
          
          updateenduserrecord(newlist);
        }
    }
    
    public void beforeUpdate(list<Case> newList, list<Case> oldList)
    {
        if (!hasBeforeUpdateRun)
        {
            set<Id> supportIncidentIdSet = new set<Id>();
            set<Id> relatedBugIdSet = new set<Id>();
            set<Id> patchRequestIdSet = new set<Id>();
            map<Id, Case> newMap = new map<Id, Case>(newList);
            map<Id, Case> oldMap = new map<Id, Case>(oldList);
            map<Id, Case> caseMap;
            map<Id, learnJIRA__c> siMap;
            map<Id, Related_Bug__c> bugMap;
            map<Id, Patch_Request__c> patchMap;
            map<Id, Case_Support_Incident__c> siBookmarkMap;
            Boolean isApiUser = globalcomponent.getapiuser(UserInfo.getuserid());
            learnJIRA__c tempSI;
            Related_Bug__c tempBug;
            Patch_Request__c tempPatch;
            Case oldCase, systemCase;
            EmailTemplate et;
            String emailSubject, emailBody, sentEmailString;
            hasBeforeUpdateRun = true;
            
            for (Case c : newList)
            {
               // system.debug('KK:'+c.Support_Incident_Fix__c);
                if (c.LearnJIRA_SI__c != null)
                {
                    supportIncidentIdSet.add(c.LearnJIRA_SI__c);
                    
                }
                if (c.Patch_Request__c != null)
                {
                    patchRequestIdSet.add(c.Patch_Request__c);
                }
                if (c.Support_Incident_Fix__c != null)
                {
                    relatedBugIdSet.add(c.Support_Incident_Fix__c);
                }
            }
            
            
            caseMap = queryCase(newMap.keySet());
            siMap = querySIsOnCase(supportIncidentIdSet);
            bugMap = queryBugsOnCase(relatedBugIdSet);
            system.debug('BUGMAP IS'+bugmap);
            patchMap = queryPatchesOnCase(patchRequestIdSet);
            siBookmarkMap = queryBookmarksOnCase(oldMap.keySet());
            
                        
            for (Case c : newList)
            {
                c.Bug_Time_Frame__c = c.Support_Incident_Fix__r.Timeframe__c;
                tempSI = null;
                tempBug = null;
                tempPatch = null;
                c.Send_Bug_Email__c = false;
                c.Send_Patch_Email__c = false;
                if (siMap.containsKey(c.LearnJIRA_SI__c))
                {
                    tempSI = siMap.get(c.LearnJIRA_SI__c);
                    c.Known_Issue__c = tempSI.Known_Issue__c;
                    c.Known_Issue_Article_Number__c = tempSI.Article_Number__c;
                   // c.Known_Issue_Article_Subject__c = tempSI.Article_Title__c; 
                   //c.Known_Issue_Article_Link__c = tempSI.Known_Issue__r.Link__c;
                    c.Known_Issue_Article_Id__c = tempSI.Article_Id__c;
                    c.Jira_Key__c = tempSI.Jira_Key__c; //TP 4975
                    c.SI_Issue_Rank__c = tempSI.Issue_Rank__c; //TP 4975
                    
                }
                else{
                c.Jira_Key__c = ''; //TP 5163
                c.SI_Issue_Rank__c = null; //TP 5163
                }
               // system.debug('The Tempbug is:' +tempbug);
                if (bugMap.containsKey(c.Support_Incident_Fix__c))
                {
                    tempBug = bugMap.get(c.Support_Incident_Fix__c);
                   // system.debug('The Tempbug is:' +tempbug);
                    c.Fix_Version__c = tempBug.Name;
                    c.Fix_Timeframe__c = tempBug.Timeframe__c;
                }
                if (patchMap.containsKey(c.Patch_Request__c))
                {
                    tempPatch = patchMap.get(c.Patch_Request__c);
                    c.Codeline_Patch__c = tempPatch.Codeline_Patch__c;
                }
                if (caseMap.containsKey(c.Id) && oldMap.containsKey(c.Id))
                {
                    oldCase = oldMap.get(c.Id);
                    systemCase = caseMap.get(c.Id);
                    
                    if (c.Override_Jira_Case_Status__c == false  &&(LearnJIRATriggerHandler.hasRun || RelatedBugTriggerHandler.hasRun || CaseSupportIncidentTriggerHandler.hasRun || 
                        c.LearnJIRA_SI__c != oldCase.LearnJIRA_SI__c || c.Support_Incident_Fix__c != oldCase.Support_Incident_Fix__c || c.Patch_Request__c != oldCase.Patch_Request__c))
                    {
                       // system.debug('The TEMPBUG is:' +tempbug);
                     //   system.debug('NNNNNNNNNN'+ tempSI);
                     //   system.debug('MMMMMMMMMM'+ tempSI.RecordType.Name);
                        
                        if(tempSI != null && tempSI.RecordType.Name =='Learn'  ){
                        //if(tempSI != null && tempSI.Master_Case__r.Core_License__r.Name == 'Learn'){
                        modifyCaseStatus(c, oldCase, systemCase, tempSI, tempBug, tempPatch); 
                                                
                        }
                        else if(tempSI != null && tempSI.RecordType.Name =='Moodlerooms'){
                        modifyCaseStatusMoodlerooms(c, oldCase, systemCase, tempSI);
                        }
                        
                        else if(tempSI != null && tempSI.RecordType.Name =='Collaborate'){
                        modifyCaseStatusCollaborate(c, oldCase, systemCase, tempSI);
                        }

                        else if(tempSI != null && tempSI.RecordType.Name =='Analytics'){
                        modifyCaseStatusAnalytics(c, oldcase, systemCase, tempSI);    
                        }
                        
                        else{
                        c.Status ='Needs Attention';
                        c.Needs_Attention_Reason__c = 'SI Unattached';
                        }
                    }
                    
                    //
                    if ((c.Override_Jira_Case_Status__c == false && oldCase.Override_Jira_Case_Status__c == true) &&(c.LearnJIRA_SI__c == oldCase.LearnJIRA_SI__c || c.Support_Incident_Fix__c == oldCase.Support_Incident_Fix__c || c.Patch_Request__c == oldCase.Patch_Request__c)){
                    
                          if(tempSI != null && tempSI.RecordType.Name =='Learn'  ){

                                     modifyCaseStatus(c, oldCase, systemCase, tempSI, tempBug, tempPatch); 
                                                
                                 }
                          else if(tempSI != null && tempSI.RecordType.Name =='Moodlerooms'){
                            
                                     modifyCaseStatusMoodlerooms(c, oldCase, systemCase, tempSI);
                                 }  
                          else if(tempSI != null && tempSI.RecordType.Name =='collaborate'){
                            
                                      modifyCaseStatusCollaborate(c, oldCase, systemCase, tempSI);
                                 } 
                           else if(tempSI != null && tempSI.RecordType.Name =='Analytics'){
                                     
                                      modifyCaseStatusAnalytics(c, oldCase, systemCase, tempSI); 
                                  }                

                    //modifyCaseStatus(c, oldCase, systemCase, tempSI, tempBug, tempPatch); 


                    }
                //
                    
                }
                
                if (isApiUser != true && oldMap.containsKey(c.Id) && c.LearnJIRA_SI__c != null && siBookMarkMap.containsKey(c.LearnJIRA_SI__c) &&
                    (c.Send_Bug_Email__c || c.Send_Patch_Email__c))
                {
                    sentEmailString = siBookmarkMap.get(c.LearnJIRA_SI__c).Emails_Sent__c;
                    if (c.Send_Bug_Email__c)
                    {
                        if (sentEmailString != null && sentEmailString != '' && sentEmailString.contains('=' + c.Case_Status_Bug__c + '='))
                        {
                            c.Send_Bug_Email__c = false;
                        }
                    }
                    if (c.Send_Patch_Email__c)
                    {
                        if (sentEmailString != null && sentEmailString != '' && sentEmailString.contains('=' + c.Case_Status_Patch__c + '='))
                        {
                            c.Send_Patch_Email__c = false;
                        }
                    }
                }
            }            
        }
        
        
                /*for (Case c : newList){
                    if(c.Override_Jira_Case_Status__c == false && c.LearnJIRA_SI__c != null){
                    learnJIRA__c siup = [Select id, Name from learnJIRA__c where id =:c.LearnJIRA_SI__c ];
                    update siup;
                    }
                }*/
        
    }
    
    
    
    
    public void afterUpdate(list<Case> newList, list<Case> oldList)
    {
        if (!hasAfterUpdateRun)
        {
            set<Id> supportIncidentIdSet = new set<Id>();
            map<Id, Case> oldMap = new map<Id, Case>(oldList);
            map<String, EmailTemplate> jiraTemplateMap;
            map<String, EmailTemplate> collabJIRATemplateMap;
            map<String, EmailTemplate> MRJIRATemplateMap;
            map<String, EmailTemplate> ANJIRATemplateMap;

            map<Id, Case> caseMap = queryCase(oldMap.keySet());
            map<Id, learnJIRA__c> siMap;
            map<Id, Case_Support_Incident__c> siBookmarkMap;
            list<EmailMessage> messageList = new list<EmailMessage>();
            list<Case_Note__c> noteList = new list<Case_Note__c>();
            map<Id, Case_Support_Incident__c> bookMarkUpdateMap = new map<Id, Case_Support_Incident__c>();
            list<learnJIRA__c> siUpdateList;
            Case_Support_Incident__c csiObj;
            EmailTemplate et;
            Case_Note__c note;
            String emailSubject, emailBody, sentEmailString;
            hasAfterUpdateRun = true;
            Integer casecountlist;
            
            jiraTemplateMap = createTemplateMap(queryTemplate('%JIRA Update - Case Status:%'));
            collabJIRATemplateMap = createTemplateMapCollab(queryTemplate('%Collab SI%'));
            MRJIRATemplateMap = createTemplateMapMR(queryTemplate('%MR SI%'));
            ANJIRATemplateMap = createTemplateMapAN(queryTemplate('%AN SI%'));
            siBookmarkMap = queryBookmarksOnCase(oldMap.keySet());
            
            
            
              
              for (Case c : newList)
              {
                 if (c.LearnJIRA_SI__c != null)
                    {
                        supportIncidentIdSet.add(c.LearnJIRA_SI__c);
                        
                   }
             }
              simap = querySIsOnCase(supportIncidentIdSet);
               
              
           if (oldMap != null && jiraTemplateMap != null && caseMap != null && collabJIRATemplateMap != null )
              {
             
                for (Case c : newList)
                {
                
                    if (oldMap.containsKey(c.Id) && jiraTemplateMap.containsKey(c.Case_Status_Bug__c) && caseMap.containsKey(c.Id) && 
                        ((c.Send_Bug_Email__c && !oldMap.get(c.Id).Send_Bug_Email__c) || (c.Send_Patch_Email__c && !oldMap.get(c.Id).Send_Patch_Email__c)) ||
                        (oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Fix_Version__c != c.Fix_Version__c)&& c.Fix_Version__c != null &&  c.Fix_Version__c != '' && c.Fix_Version__c != 'N/A' && c.Case_Status_Bug__c =='Closed - Pending Release' && c.closedpendingreleaseboolean__c /*TP4665*/))
                    {
                    
                        if (siBookmarkMap.containsKey(c.LearnJIRA_SI__c))
                        {
                            csiObj = siBookmarkMap.get(c.LearnJIRA_SI__c);
                            sentEmailString = csiObj.Emails_Sent__c;
                            if (sentEmailString == null)
                            {
                                sentEmailString = '';
                            }
                            if (c.Send_Bug_Email__c)
                            {
                                if (sentEmailString == '' || !sentEmailString.contains('=' + c.Case_Status_Bug__c + '='))
                                {
                                    csiObj.Emails_Sent__c += (';=' + c.Case_Status_Bug__c + '=');
                                    bookMarkUpdateMap.put(csiObj.Id, csiObj);
                                }
                            }
                            if (c.Send_Patch_Email__c)
                            {
                                if (sentEmailString == '' || !sentEmailString.contains('=' + c.Case_Status_Patch__c + '='))
                                {
                                    csiObj.Emails_Sent__c += (';=' + c.Case_Status_Patch__c + '=');
                                    if (bookMarkUpdateMap.containsKey(csiObj.Id))
                                    {
                                        bookMarkUpdateMap.remove(csiObj.Id);
                                        bookMarkUpdateMap.put(csiObj.Id, csiObj);
                                    }
                                    else
                                    {
                                        bookMarkUpdateMap.put(csiObj.Id, csiObj);
                                    }
                                }
                            }
                        }
                        if(c.Case_Status_Bug__c == 'Closed'){
                            if(c.Bug_Not_Fixed_Reason__c!=null && c.Bug_Not_Fixed_Reason__c.containsignorecase('Functioning as Designed')){
                                et = jiraTemplateMap.get('Functioning as Designed');
                            
                            }
                            
                            else if(c.Bug_Not_Fixed_Reason__c!=null &&c.Bug_Not_Fixed_Reason__c.containsignorecase('Will Not Fix')){
                                et = jiraTemplateMap.get('Will Not Fix');
                            
                            }
                            
                            else if(c.Bug_Not_Fixed_Reason__c!=null &&c.Bug_Not_Fixed_Reason__c.containsignorecase('Cannot Reproduce')){
                                et = jiraTemplateMap.get('Closed - Cannot Reproduce');
                            
                            }
                            
                            else {
                            et = jiraTemplateMap.get(c.Case_Status_Bug__c);
                            }
                            
                        }
                        else {
                        
                            et = jiraTemplateMap.get(c.Case_Status_Bug__c);
                        }
                        
                        emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                        emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                        // Update this to create the case note of type email
                        messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                        /*note = new Case_Note__c();
                        note.To_Address__c = caseMap.get(c.Id).Contact.Email;
                        note.Contact__c = caseMap.get(c.Id).ContactId;
                        note.From_Type__c = 'JIRA';
                        note.Incoming_Outgoing__c = 'Outgoing';
                        note.Email_Subject__c = emailSubject;
                        note.Is_Email__c = true;
                        note.Type__c = 'Closed by JIRA';
                        note.Details__c = emailBody;
                        note.Case__c = c.Id;
                        note.Public__c = true;
                        noteList.add(note);*/
                    }

                    
                     if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Status != c.Status &&c.Status == 'Problem Reported'))
                      {

                        if((caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Moodlerooms')) && MRJIRATemplateMap != null )
                           
                           {
                              et = MRJIRATemplateMap.get('MR SI Automated - Problem Reported');
                           }
                        
                         else if((caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('collaborate')) && collabJIRATemplateMap != null )
                           {
                              
                              et = collabJIRATemplateMap.get('Collab SI Automated Problem Reported');
                           } 
                         else if((caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Analytics')) && ANJIRATemplateMap != null)
                           {
                              et = ANJIRATemplateMap.get('AN SI Automated - Problem Reported');
                           }       
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                     else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Status != c.Status &&c.Status == 'Closed - Pending Target')){
                        
                            et = collabJIRATemplateMap.get('Collab SI Automated Closed – Pending Target (Cloned to bug)');
                           
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                      else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Collab_JIRA_status__c != 'Fixed Released' && c.Collab_JIRA_status__c == 'Fixed Released' &&c.Status == 'Closed')){
                        
                            et = collabJIRATemplateMap.get('Collab SI Automated Fixed and Released');
                           
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                     else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Collab_JIRA_status__c != 'Will Not Fix' && c.Collab_JIRA_status__c == 'Will Not Fix' &&c.Status == 'Closed')){
                        
                            et = collabJIRATemplateMap.get('Collab SI Automated Will Not Fix');
                           
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                     else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Collab_JIRA_status__c != 'Functioning as Designed' && c.Collab_JIRA_status__c == 'Functioning as Designed' &&c.Status == 'Closed')){
                        
                            et = collabJIRATemplateMap.get('Collab SI Automated FAD');
                           
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                     else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Collab_JIRA_status__c != 'Cannot Reproduce' && c.Collab_JIRA_status__c == 'Cannot Reproduce' &&c.Status == 'Closed')){
                        
                            et = collabJIRATemplateMap.get('Collab SI Automated Cannot Reproduce');
                           
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                        
                                         
                                        
                            
                     }
                     
                     else if(oldMap.containsKey(c.Id)&& (oldMap.get(c.Id).Status != c.Status && c.Status == 'Enhancement Reported')){
                        if( (caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Moodlerooms')) && MRJIRATemplateMap != null && siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Status__c == 'New' ){
                               et = MRJIRATemplateMap.get('MR SI Automated-created');
                           }
                           else{
                            et = collabJIRATemplateMap.get('Collab SI Automated Enhancement Reported');
                           }
                     
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                           }
                           
                        else if(oldMap.containsKey(c.Id) && (oldMap.get(c.Id).Status != c.Status && (oldmap.get(c.id).status != 'Solution Suggested' && (c.Status == 'Closed' || c.status == 'Closed - Pending Release'))) && (caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Moodlerooms')) && MRJIRATemplateMap != null )
                        {  
                           
                           if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Accepted'){
                        
                            et = MRJIRATemplateMap.get('MR SI Automated-closed as Accepted');
                            
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Denied'){
                             
                             et = MRJIRATemplateMap.get('MR SI Automated-closed as Denied');
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Status__c == 'Resolved'){
                            
                             et = MRJIRATemplateMap.get('MR SI Automated - Pending Release');
                            
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Will Not Fix'){
                            
                             et = MRJIRATemplateMap.get('MR SI Automated - Won’t Fix');
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Functioning as Designed'){
                            
                             et = MRJIRATemplateMap.get('MR SI Automated-Functioning as Designed');
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Cannot Reproduce'){
                             
                             et = MRJIRATemplateMap.get('MR SI Automated - Cannot Reproduce');
                           }
                           else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Fixed Released'){
                            
                             et = MRJIRATemplateMap.get('MR SI Automated – Released');
                             
                           }   

                            if ( et != null && et.subject!= null ) 
                             { 
                               emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                               emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                               // Update this to create the case note of type email
                               messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                               ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                             }
                        }

                        //Analytics
                        else if(oldMap.containsKey(c.Id) && (oldMap.get(c.Id).Status != c.Status && (oldmap.get(c.id).status != 'Solution Suggested' && (c.Status == 'Closed' || c.status == 'Closed - Pending Release'))) && (caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Analytics')) && ANJIRATemplateMap != null )
                        {
                            if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Will Not Fix')
                            {
                               et = ANJIRATemplateMap.get('AN SI Automated - Will Not Be Fixed');
                            }
                            else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Functioning as Designed')
                            {
                               et = ANJIRATemplateMap.get('AN SI Automated - Closed - Functioning As Designed');
                            }
                            else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Cannot Reproduce')
                            {
                               et = ANJIRATemplateMap.get('AN SI Automated - Cannot Reproduce');
                            }
                            else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Resolution__c == 'Fixed Released')
                            {
                               et = ANJIRATemplateMap.get('AN SI Automated - Fixed Released');
                            }
                            else if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Status__c == 'Resolved')
                            {
                               et = ANJIRATemplateMap.get('AN SI Automated - Closed – Pending Release');
                            }


                            if ( et != null && et.subject!= null ) 
                             {
                               emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                               emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                               messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                               ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                             }

                         }
            

                        else if(oldMap.containsKey(c.Id) && (oldMap.get(c.Id).Status != c.Status && (c.Status == 'Problem Reported: Pending Pyramid Dev')) && (caserecodtypemap.get(c.recordtypeid).getname().containsIgnoreCase('Analytics')) && ANJIRATemplateMap != null ){
                            
                        if(siMap!= null && siMap.containskey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Status__c == 'On Hold' && siMap.get(c.LearnJIRA_SI__c).On_Hold_Reason__c == 'Waiting for Pyramid')
                        { 
                            et = ANJIRATemplateMap.get('AN SI Automated - Problem Reported: Pending Pyramid Dev');
                        }
                        if(et!=null && et.subject!= null){    
                       
                            emailSubject = convertMergeFields(et.Subject, c, caseMap.get(c.Id));
                            emailBody = convertMergeFields(et.Body, c, caseMap.get(c.Id));
                            // Update this to create the case note of type email
                            messageList.add(new EmailMessage(FromAddress = 'support@blackboard.com', FromName = 'Bb Support', HtmlBody = et.HtmlValue, MessageDate = system.now(),
                            ParentId = c.Id, Status = '3', Subject = emailSubject, TextBody = emailBody, ToAddress = caseMap.get(c.Id).Contact.Email));
                          }
                        }
        
                        else{
                     
                            }
                     
                }
                
                
                
            }
           //simap = querySIsOnCase(supportIncidentIdSet);
             if (globalcomponent.getapiuser(UserInfo.getuserid()) != true && !LearnJIRATriggerHandler.hasRun)
            {
                siUpdateList = modifySupportIncidents(newList, oldMap, siMap);
            }
            
            // Dml Operations
            insertEmailMessageList(messageList);
            //insertCaseNoteList(noteList);
            updateSupportIncidentList(siUpdateList);
            updateBookmarkList(bookmarkUpdateMap.values());
               
            
            //Update Solution Detail if case closed by system TP3067
            List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
            for (Case c : newList)
            {
                if((c.status!=oldMap.get(c.id).status)&&(c.status=='Closed')&&(oldMap.get(c.id).status=='Solution Suggested')&&(oldMap.get(c.id).Send_Email__c != c.Send_Email__c))  //TP3067
                 {
                    for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c =: c.id AND Status__c = 'In Consideration' order by createddate desc limit 1 ]){
                    Solution_Detail__c sd2 = new Solution_Detail__c(ID = sd1.id);
                    sd2.Status__c = 'Successful Resolution';
                    sdlist.add(sd2);
                    } 
        
                 } 
            }
        //DML TP3067
        updatesolutionlist(sdlist);
        
           
        }
    }
    
    private map<Id, learnJIRA__c> querySIsOnCase(set<Id> supportIncidentIdSet)
    {
        return new map<Id, learnJIRA__c>([Select Id, Name,RecordTypeId,RecordType.Name,Case_Count__c,Jira_Key__c, Status__c,Number_of_Related_Bugs__c,Type__c,Tier_2_Assessment__c, Known_Issue__c, Known_Issue__r.SolutionNumber, Resolution__c, Known_Issue__r.SolutionName, 
                                                 Known_Issue__r.Link__c,Issue_Rank__c, On_Hold_Reason__c, Known_Issue__r.Id, Known_Issue__r.Status, Known_Issue__r.IsPublishedInPublicKb, Master_Case__c,Master_Case__r.Core_License__r.Name, Article_Id__c, Article_Number__c, 
                                                 Article_Version_Id__c,  Article_Title__c, (Select Id From Related_Bugs__r), (Select Id From Patch_Requests__r)
                                          From learnJIRA__c 
                                          Where Id IN : supportIncidentIdSet]);
    }
    
    private map<Id, Related_Bug__c> queryBugsOnCase(set<Id> relatedBugIdSet)
    {
        return new map<Id, Related_Bug__c>([Select Id, Not_Fixed_Reason__c, Status__c, Name, Timeframe__c From Related_Bug__c Where Id IN : relatedBugIdSet]);
    }
    
    private map<Id, Patch_Request__c> queryPatchesOnCase(set<Id> patchRequestIdSet)
    {
        return new map<Id, Patch_Request__c>([Select Id, Name, Codeline_Patch__c, Status__c, Support_Comment__c, Support_Incident__c, Version__c 
                                              From Patch_Request__c 
                                              Where Id IN : patchRequestIdSet]);
    }
    
    private map<Id, Case> queryCase(set<Id> caseIdSet)
    {   
        
        return new map<Id, Case>([Select Id, CaseNumber, learnJIRA_SI__c, learnJIRA_SI__r.Status__c, learnJIRA_SI__r.Number_of_Related_Bugs__c, Support_Incident_Fix__c, 
                                         Support_Incident_Fix__r.Status__c, Core_License__c, Core_License__r.Name, Support_Incident_Fix__r.Not_Fixed_Reason__c, Status,
                                         Support_Incident_Fix__r.Name, learnJIRA_SI__r.Known_Issue__c, LearnJIRA_SI__r.Known_Issue__r.SolutionName, 
                                         LearnJIRA_SI__r.Known_Issue__r.Link__c, LearnJIRA_SI__r.Known_Issue__r.SolutionNumber, LearnJIRA_SI__r.Known_Issue__r.Id,
                                         Known_Issue_Article_Number__c,Customer_Portal_Status__c, Bug_Time_Frame__c, Known_Issue_Article_Subject__c, Known_Issue_Article_Link__c, Known_Issue_Article_Id__c,
                                         Fix_Version__c, Fix_Timeframe__c, Closed_Patch_Statuses__c, Support_Incident_Fix__r.Timeframe__c, IsClosed, Contact.Email, ContactId, Contact.Name, OwnerId, Owner.Name, 
                                         Owner.FirstName, Owner.LastName 
                                  From Case
                                  Where Id IN : caseIdSet]);
    }
    
    private list<EmailTemplate> queryTemplate(String templateName)
    {
        return [Select Id, Name, HtmlValue, Subject, Body From EmailTemplate Where Name like : templateName];
    }
    
    private map<Id, Case_Support_Incident__c> queryBookmarksOnCase(set<Id> caseIdSet)
    {
        map<Id, Case_Support_Incident__c> siBookmarkMap = new map<Id, Case_Support_Incident__c>();
        for (Case_Support_Incident__c csi : [Select Id, Name, Support_Incident__c, Case__c, Emails_Sent__c From Case_Support_Incident__c Where Case__c IN : caseIdSet])
        {
            if (csi.Support_Incident__c != null)
            {
                siBookmarkMap.put(csi.Support_Incident__c, csi);
            }
        }
        return siBookmarkMap;
    }
    
    private list<learnJIRA__c> modifySupportIncidents(list<Case> newList, map<Id, Case> oldMap, map<Id, learnJIRA__c> siMap)
    {
        set<Id> supportIncidentIdSet = new set<Id>();
        list<learnJIRA__c> supportIncidentUpdateList = new list<learnJIRA__c>();
        learnJIRA__c tempSI;
        
        for (Case c : newList)
        {
            if (oldMap != null && oldMap.containsKey(c.Id) && c.LearnJIRA_SI__c != oldMap.get(c.Id).LearnJIRA_SI__c)
            {
                if (c.LearnJIRA_SI__c != null)
                {
                    supportIncidentIdSet.add(c.LearnJIRA_SI__c);
                    
                    
                }
                if (oldMap.get(c.Id).LearnJIRA_SI__c != null)
                {
                    supportIncidentIdSet.add(c.LearnJIRA_SI__c);
                }
            }
            else if (oldmap==null && c.LearnJIRA_SI__c != null)
            {
                supportIncidentIdSet.add(c.LearnJIRA_SI__c);
            }
            /*
            if (c.LearnJIRA_SI__c != null && 
                ((c.IsClosed && oldCase == null) || (oldCase != null && c.IsClosed != oldCase.IsClosed)))
            {
                supportIncidentIds.add(c.LearnJIRA_SI__c);
            }*/
        }
        
        for (Id i : supportIncidentIdSet)
        {
            if (siMap.containsKey(i))
            {
                tempSI = siMap.get(i);
             //   system.debug('Murugappan' +tempSI.RecordType.Name);
                if(tempSI.RecordType.Name=='Learn')
                {
                 tempSI.isChanged__c = true;
                }
                supportIncidentUpdateList.add(tempSI);
            }
        }
        return supportIncidentUpdateList;
    }
    
    public Master_Case_Email__c Mc = null;
    private void modifyCaseStatus(Case newCase, Case oldCase, Case systemCase, learnJIRA__c si, Related_Bug__c bug, Patch_Request__c patch)
    {
        String coreLicense = systemCase.Core_License__r.Name;
        Boolean bugChanged = false;
        Boolean patchChanged = false;
    
    
        if (newCase.LearnJIRA_SI__c == null && oldCase.LearnJIRA_SI__c != null)
        {
            newCase.Status = 'Needs Attention';
            newCase.Needs_Attention_Reason__c = '';
        }   
        else if (!newCase.IsClosed && si != null && (si.Related_Bugs__r == null || si.Related_Bugs__r.isEmpty()) && (si.Patch_Requests__r == null || si.Patch_Requests__r.isEmpty()))
        {
           if (si.Status__c == 'New')
           {
              newCase.Status = 'Pending Evaluation';
              newCase.Needs_Attention_Reason__c = '';
           }
           //else if (si.Status__c == 'On Hold' || (si.Status__c == 'Closed' && si.Resolution__c != null && si.Resolution__c != ''))
            //{
              //  newCase.Status = 'Needs Attention';
            //}
            else if(si.Status__c == 'Closed' && si.Resolution__c != null && si.Resolution__c != '')
            {
                newCase.Status = 'Needs Attention';
                newCase.Needs_Attention_Reason__c = 'SI Status is Closed';
            }
            else if(newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.On_Hold_Reason__c == 'Waiting for Client Support Response' || newCase.Id == si.Master_Case__c && si.Status__c == 'Closed' && (si.Status__c == 'Closed' && si.Resolution__c != null && si.Resolution__c != ''))
            {
                newCase.Status = 'Needs Attention';
                newCase.Needs_Attention_Reason__c = 'SI is On Hold and Needs More Information';
            }
            else
            {
                newCase.Status = 'Pending Development';
                newCase.Needs_Attention_Reason__c = '';
            }
        }
        else if (patch != null)
        {
            if (patch.Status__c == 'New' || patch.Status__c == 'Open' || patch.Status__c == 'In Progress' || patch.Status__c == 'On Hold' || 
                patch.Status__c == 'Code Review' || patch.Status__c == 'In Testing' || patch.Status__c == 'Verified' )
            {
                newCase.Case_Status_Patch__c = 'Patch Development';
                newCase.Needs_Attention_Reason__c = '';
                patchChanged = true;
                //newCase.Send_Patch_Email__c = true;
            }
            else if (patch.Status__c == 'Closed - Public Patch')
            {
                            
                if(newCase.Closed_Patch_Statuses__c == null){
                    newCase.Closed_Patch_Statuses__c = '=' + patch.Id +':Closed - Public Patch=';
                    newCase.Needs_Attention_Reason__c = 'Patch Status is Closed - Public Patch';
                    newCase.Case_Status_Patch__c = 'Needs Attention';
                    patchChanged = true;
                }
                
                else if(newCase.Closed_Patch_Statuses__c != null){
                    if(!newCase.Closed_Patch_Statuses__c.contains('=' + patch.Id +':Closed - Public Patch=')){
                        newCase.Needs_Attention_Reason__c = 'Patch Status is Closed - Public Patch';
                        newCase.Case_Status_Patch__c = 'Needs Attention';
                        newCase.Closed_Patch_Statuses__c += ';' + '=' + patch.Id +':Closed - Public Patch=';
                        patchChanged = true;
                    }
                }
           }
            else if (patch.Status__c == 'Closed - Private Patch')
            {
                if(newCase.Closed_Patch_Statuses__c == null){
                    newCase.Closed_Patch_Statuses__c = '=' + patch.Id +':Closed - Private Patch=';
                    newCase.Needs_Attention_Reason__c = 'Patch Status is Closed - Private Patch';
                    newCase.Case_Status_Patch__c = 'Needs Attention';
                    patchChanged = true;
                }
                else if(newCase.Closed_Patch_Statuses__c != null){
                 //   system.debug(newCase.Closed_Patch_Statuses__c);
                    if(!newCase.Closed_Patch_Statuses__c.contains('=' + patch.Id +':Closed - Private Patch=')){
                        newCase.Needs_Attention_Reason__c = 'Patch Status is Closed - Private Patch';
                        newCase.Case_Status_Patch__c = 'Needs Attention';
                        newCase.Closed_Patch_Statuses__c += ';' + '=' + patch.Id +':Closed - Private Patch=';
                        patchChanged = true;
                    }
                }
            }
            else if (patch.Status__c == 'Closed - Not Patched' || patch.Status__c == 'Codeline Request cancelled')
            {
                 if(newCase.Closed_Patch_Statuses__c == null || (newCase.Closed_Patch_Statuses__c == '')){
                    newCase.Closed_Patch_Statuses__c = '=' + patch.Id +':Closed - Not Patched=';
                    newCase.Needs_Attention_Reason__c = 'Patch Status is Closed - Not Patched/Codeline Request cancelled';
                    newCase.Case_Status_Patch__c = 'Needs Attention';
                    patchChanged = true;
                }
                
                else if(newCase.Closed_Patch_Statuses__c != null){
                    if(!newCase.Closed_Patch_Statuses__c.contains('=' + patch.Id +':Closed - Not Patched=')){
                        newCase.Needs_Attention_Reason__c = 'Patch Status is Patch Status is Closed - Not Patched/Codeline Request cancelled';
                        newCase.Case_Status_Patch__c = 'Needs Attention';
                        newCase.Closed_Patch_Statuses__c += ';' + '=' + patch.Id +':Closed - Not Patched=';
                        patchChanged = true;
                    }
                }
            }
        }
        if (bug != null && coreLicense != null)
        {
            coreLicense = coreLicense.toUpperCase();
            if ((bug.Status__c == 'New' && coreLicense.contains('LEARN')) || 
                (bug.Status__c == 'Open' && (coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')) && bug.Name == 'n/a'))
            {
                newCase.Case_Status_Bug__c = 'Closed - Pending Target';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
            }
            else if (((bug.Status__c == 'Targeted' || bug.Status__c == 'Fixed - Unreleased') && coreLicense.contains('LEARN')) || 
                    ((bug.Status__c == 'Open' || bug.Status__c == 'Resolved') && (coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')) && bug.Name != 'n/a'))
            {
                newCase.Case_Status_Bug__c = 'Closed - Pending Release'; //TP 3569
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
            }
            else if (bug.Status__c == 'Future Reference')
            {
                newCase.Case_Status_Bug__c = 'Closed - Future Reference';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
            }
            else if (coreLicense.contains('LEARN') && (bug.Status__c == 'Fixed - Released' ) || 
                    ((coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')) && bug.Status__c == 'Closed' && bug.Not_Fixed_Reason__c != null && bug.Not_Fixed_Reason__c != ''))
            {
                newCase.Case_Status_Bug__c = 'Closed';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
            }
            
            else if (coreLicense.contains('LEARN') && bug.Status__c == 'Not Fixed' && bug.Not_Fixed_Reason__c == 'Cannot Reproduce') 
            {
                newCase.Case_Status_Bug__c = 'Closed';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
                newcase.Bug_Not_Fixed_Reason__c=bug.Not_Fixed_Reason__c;
            }
           
            /*else if ((bug.Not_Fixed_Reason__c == 'Functioning As Designed' || bug.Not_Fixed_Reason__c == 'Will Not Fix' || bug.Not_Fixed_Reason__c == 'Duplicate') && 
                    ((bug.Status__c == 'Not Fixed' && coreLicense.contains('LEARN')) || (bug.Status__c == 'Closed' && (coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')))))
            {
                //newCase.Case_Status_Bug__c = 'Closed - Not Fixed';
                newCase.Case_Status_Bug__c = 'Needs Attention';
                bugChanged = true;
            }*/
            else if ((bug.Not_Fixed_Reason__c == 'Functioning as Designed' || bug.Not_Fixed_Reason__c == 'Will Not Fix') && 
                    ((bug.Status__c == 'Not Fixed' && coreLicense.contains('LEARN')) || (bug.Status__c == 'Closed' && (coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')))))
            {
                newCase.Case_Status_Bug__c = 'Closed';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
                newCase.Send_Bug_Email__c = true;
                newcase.Bug_Not_Fixed_Reason__c=bug.Not_Fixed_Reason__c;
            }
            else if ((bug.Not_Fixed_Reason__c == 'Duplicate') && 
                    ((bug.Status__c == 'Not Fixed' && coreLicense.contains('LEARN')) || (bug.Status__c == 'Closed' && (coreLicense.contains('ANGEL') || coreLicense.contains('CE/VISTA')))))
            {
                
                newCase.Case_Status_Bug__c = 'Needs Attention';
                newCase.Needs_Attention_Reason__c = 'Bug Status is Duplicate';  
                bugChanged = true;
               
            }
            
            
            else if (bug.Status__c == 'Pending' && !newCase.IsClosed)
            {
                newCase.Case_Status_Bug__c = 'Pending Development';
                newCase.Needs_Attention_Reason__c = '';
                bugChanged = true;
            }
        }
        
       if (patchChanged && patch != null)
        {
            newCase.Status = newCase.Case_Status_Patch__c;
        }
        else if (bugChanged && bug != null && patch == null)
        {
            newCase.Status = newCase.Case_Status_Bug__c;
        }       
    }
    
    list<Known_Issue__kav> articleList = new list<Known_Issue__kav>(); //moodle

    private void modifyCaseStatusMoodlerooms(Case newCase, Case oldCase, Case systemCase, learnJIRA__c si)
    {
            if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'This is a bug')
            {
                newCase.Status = 'Pending Evaluation ';
                
            }
            
            else if (si.Status__c == 'Open' && si.Tier_2_Assessment__c == 'This is a bug' )
            {
              
               newCase.Status = 'Problem Reported';
               if(oldCase.Status != newCase.Status){
                newCase.Send_MR_Problem_Reported_Email__c = true;
               }
               
            }   
            else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c =='Waiting on Moodle Development')
            {
                newCase.Status = 'Problem Reported: Pending Moodle Dev';

            } 
            else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting on 3rd Party Development')
            {
                newCase.Status = 'Problem Reported: Pending 3rd Party Dev';

            }
            else if (newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Client Support Response')
            {
                newCase.Status = 'Needs Attention';

            }
            
            else if (newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Client Response')
            {
                newCase.Status = 'Needs Attention';

            }
            else if (si.Status__c == 'In Testing' && si.Tier_2_Assessment__c == 'This is a Bug')
            {
                newCase.Status = 'Problem Reported: In Testing';
            }
            
            else if (si.Status__c == 'Resolved' && si.Tier_2_Assessment__c == 'This is a Bug')
            {
                newCase.Status = 'Closed - Pending Release';
                
               if(oldCase.Status != newCase.Status){
                newCase.Send_pending_release_email_for_MI_user__c = true;
               }

            }
            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Duplicate')
            {
                newCase.Status = 'Needs Attention';

            }
            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Will Not Fix')
            {
                newCase.Status = 'Closed';
                
               if(oldCase.Status != newCase.Status || oldcase.Resolution_Reason_From_SI__c != newcase.Resolution_Reason_From_SI__c){
                newCase.Send_MR_will_not_fix_email__c = true;
               }

            }

            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Functioning as Designed')
            {
                newCase.Status = 'Closed';
                if(oldCase.Status != newCase.Status || oldcase.Resolution_Reason_From_SI__c != newcase.Resolution_Reason_From_SI__c){
                newCase.send_MR_FAD_email__c = true;
               }

            }

            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Cannot Reproduce')
            {
                newCase.Status = 'Closed';
                if(oldCase.Status != newCase.Status || oldcase.Resolution_Reason_From_SI__c != newcase.Resolution_Reason_From_SI__c){
                newCase.send_MR_cannot_reproduce_email__c = true;
               }

            }
            
            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Fixed Released')
            {
                newCase.Status = 'Closed';
                if(oldCase.Status != newCase.Status || oldcase.Resolution_Reason_From_SI__c != newcase.Resolution_Reason_From_SI__c){
                newCase.send_MR_fixed_released_email__c = true;
               }


            }
            else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c != 'Duplicate')
            {
                newCase.Status = 'Closed';

            }
                        
            else if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'Enhancement')
            {
                newCase.Status = 'Enhancement Reported';
                if(oldCase.Status != newCase.Status){
                newCase.send_MR_enhancement_reported_email__c = true;
               }


            }
            
            else if (si.Status__c == 'Open' && si.Tier_2_Assessment__c == 'Enhancement')
            {
                newCase.Status = 'Enhancement Reported';

            }
            else if (newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'Enhancement' && si.On_Hold_Reason__c =='Waiting for Client Support Response')
            {
                newCase.Status = 'Needs Attention';

            }

           else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Enhancement' && si.Resolution__c == 'Accepted')
            {
                newCase.Status = 'Closed';
                if(oldCase.Status != newCase.Status){
                newCase.MR_closed_as_accepted__c = true;
               }
                
                
           }

           else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Enhancement' && si.Resolution__c == 'Denied')
            {
                newCase.Status = 'Closed';
                if(oldCase.Status != newCase.Status){
                newCase.send_closed_as_denied_email_for_MR_users__c = true;
               }

            }
            
   
    
    else{
    //Do Nothing
    }
    
   }
    
      
   private void modifyCaseStatusCollaborate(Case newCase, Case oldCase, Case systemCase, learnJIRA__c si)
    {
     if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'Operations Issue')
            {
                newCase.Status = 'Pending Evaluation';
               
            }
            
     if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'Software Issue')
            {
                newCase.Status = 'Pending Evaluation';
                
            }       
            
     else if (si.Status__c == 'Open' && si.Tier_2_Assessment__c == 'Operations Issue') 
            {
                newCase.Status = 'Problem Reported';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Email__c = true;
                }
            }
            
     else if (si.Status__c == 'Open' && si.Tier_2_Assessment__c == 'Software Issue')
            {
                newCase.Status = 'Problem Reported';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Email__c = true;
                }
            }        
            
            
    
    /* else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'Software Issue' && si.On_Hold_Reason__c == 'Waiting for Development')
            {
                newCase.Status = 'Problem Reported: Pending Dev';

            } */
    
    else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'Operations Issue' && si.On_Hold_Reason__c == 'Waiting for Operations')
            {
                newCase.Status = 'Problem Reported: Pending Ops';

            }
    
else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'Operations Issue' && si.On_Hold_Reason__c == 'Waiting on 3rd party')
            {
                newCase.Status = 'Problem Reported: Pending Ops';

            }
else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c ==  'Software Issue' && si.On_Hold_Reason__c == 'Waiting on 3rd party')
            {
                newCase.Status = 'Problem Reported: Pending Ops';

            }
            
else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'Operations Issue'  && si.On_Hold_Reason__c == 'Waiting for Client Support Response')
            {
                newCase.Status = 'Needs Attention';

            }
else if (si.Status__c == 'On Hold' && si.Tier_2_Assessment__c ==  'Software Issue' && si.On_Hold_Reason__c == 'Waiting for Client Support Response')
            {
                newCase.Status = 'Needs Attention';

            }
            
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue'  && si.Resolution__c == 'Cloned to Bug')
            {
                newCase.Status = 'Closed - Pending Target';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Closed_Pending_Target_Email__c = true;
                }

            }
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Cloned to Bug')
            {
                newCase.Status = 'Closed - Pending Target';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Closed_Pending_Target_Email__c = true;
                }

            }  
            
            
else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue'  && si.Resolution__c == 'Operations Fixed')
            {
                newCase.Status = 'Needs Attention';
                

            }
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Operations Fixed')
            {
                newCase.Status = 'Needs Attention';
               

            }            
            
            
            
            
                     
            
            
            
            
             

 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue'  && si.Resolution__c == 'Fixed Released')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Fixed Released';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Fixed Released'){
                newCase.Send_Collab_Fixed_Released_Email__c = true;
                }

            }
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Fixed Released')
            {
                newCase.Status = 'Closed';
               newCase.Collab_JIRA_status__c = 'Fixed Released';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Fixed Released'){
                newCase.Send_Collab_Fixed_Released_Email__c = true;
                }

            }

            
     else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue' && si.Resolution__c == 'Will Not Fix')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Will Not Fix';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Will Not Fix'){
                newCase.Send_Collab_Will_Not_Fix_Email__c = true;
                }

            }
            
     else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Will Not Fix')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Will Not Fix';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Will Not Fix'){
                newCase.Send_Collab_Will_Not_Fix_Email__c = true;
                }

            }





            
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue' && si.Resolution__c == 'Functioning as Designed')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Functioning as Designed';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Functioning as Designed'){
                newCase.Send_Collab_FAD_Email__c = true;
                }


            }

 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Functioning as Designed')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Functioning as Designed';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Functioning as Designed'){
                newCase.Send_Collab_FAD_Email__c = true;
                }


            }

     
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue' && si.Resolution__c == 'Cannot Reproduce')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Cannot Reproduce';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Cannot Reproduce'){
                newCase.Send_Collab_Cannot_Reproduce_Email__c = true;
                }


            }
 else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Cannot Reproduce')
            {
                newCase.Status = 'Closed';
                newCase.Collab_JIRA_status__c = 'Cannot Reproduce';
                //if(oldCase.Status != newCase.Status){
                if(oldCase.Collab_JIRA_status__c != 'Cannot Reproduce'){
                newCase.Send_Collab_Cannot_Reproduce_Email__c = true;
                }


            }
            
else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Operations Issue' && si.Resolution__c == 'Duplicate')
            {
                newCase.Status = 'Needs Attention';

            }
else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c ==  'Software Issue' && si.Resolution__c == 'Duplicate')
            {
                newCase.Status = 'Needs Attention';

            }





            
     else if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'Enhancement')
            {
                newCase.Status = 'Enhancement Reported';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Enhancement_Reported_Email__c = true;
                }

            }
            
     else if (si.Status__c == 'Open' && si.Tier_2_Assessment__c == 'Enhancement')
            {
                newCase.Status = 'Enhancement Reported';
                if(oldCase.Status != newCase.Status){
                newCase.Send_Collab_Enhancement_Reported_Email__c = true;
                }

            }
            
     else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Enhancement' && si.Resolution__c == 'Accepted')
            {
                newCase.Status = 'Closed';

            }
            
     else if (si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'Enhancement' && si.Resolution__c == 'Denied')
            {
                newCase.Status = 'Closed';

            }
                   
           else {
           
           }
            
    }
    
 // Analytics code

   private void modifyCaseStatusAnalytics(Case newCase, Case oldCase, Case systemCase, learnJIRA__c si)
   
   {
     if (si.Status__c == 'New' && si.Tier_2_Assessment__c == 'This is a bug')
         {
            newCase.Status = 'Pending Evaluation';
         }
    else if(si.Status__c == 'open' && si.Tier_2_Assessment__c == 'This is a bug')
         {
            newcase.Status = 'Problem Reported';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_Confirmed_as_Bug_email__c = true;
            }
         }
    else if(si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Development')
         {
            newcase.status = 'Problem Reported: Pending Development';
         }
    else if(si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Pyramid')
         {
            newcase.status = 'Problem Reported: Pending Pyramid Dev';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_SI_On_Hold_email__c = true;
            }
         }
    else if(newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Client Support Response')
         {
            newcase.status = 'Needs Attention';
         }   
    else if(newCase.Id == si.Master_Case__c && si.Status__c == 'On Hold' && si.Tier_2_Assessment__c == 'This is a bug' && si.On_Hold_Reason__c == 'Waiting for Client Response')
         {
            newcase.status = 'Needs Attention';
         }
    else if(si.Status__c == 'Resolved' && si.Tier_2_Assessment__c == 'This is a bug')
         {
            newcase.status = 'Closed - Pending Release';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_SI_Resolved_email__c = true;
            }
         }
    else if(si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Duplicate')
         {
            newcase.Status = 'Needs Attention';
         }
    else if(si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Will Not Fix')
         {
            newcase.Status = 'Closed';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_will_not_fix_email__c = true;
            }
         }
    else if(si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Functioning as Designed')
         {
            newcase.Status = 'Closed';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_FAD_email__c = true;
            }
         }
    else if(si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Cannot Reproduce')
         {
            newcase.Status = 'Closed';
            if(oldCase.Status != newCase.Status)
            {
                newCase.send_AN_cannot_reproduce_email__c = true;
            }
         }
    else if(si.Status__c == 'Closed' && si.Tier_2_Assessment__c == 'This is a bug' && si.Resolution__c == 'Fixed Released')
         {
            newcase.Status = 'Closed';
            if(oldcase.status != newcase.status)
            {
                newcase.Send_AN_fixed_released_email__c = true;
            }
         }
    }   
    
    
    
    
    
    
    
    
    private map<String, EmailTemplate> createTemplateMap(list<EmailTemplate> templates)
    {
        map<String, EmailTemplate> templateMap = new map<String, EmailTemplate>();
        
        if (templates != null && !templates.isEmpty())
        {
            for (EmailTemplate et : templates)
            {
                if (et.Name != null && et.Name.contains('Pending Target'))
                {
                    templateMap.put('Closed - Pending Target', et);
                }
               else if (et.Name != null && et.Name.contains('Pending Release'))
                {
                   templateMap.put('Closed - Pending Release', et);
                }
                else if (et.Name != null && et.Name.contains('Future Reference'))
                {
                    templateMap.put('Closed - Future Reference', et);
                }
                
                else if (et.Name != null && et.Name.contains('FAD'))
                {
                    templateMap.put('Functioning as Designed', et);
                }
                
                 else if (et.Name != null && et.Name.contains('WNF'))
                {
                    templateMap.put('Will Not Fix', et);
                }
                
                else if (et.Name != null && et.Name.contains('Cannot Reproduce'))
                {
                    templateMap.put('Closed - Cannot Reproduce', et);
                }
                
               
                else
                {
                    templateMap.put('Closed', et);
                }
            }
        }
        return templateMap;
    }
    
     private map<String, EmailTemplate> createTemplateMapCollab(list<EmailTemplate> templates)
    {
        map<String, EmailTemplate> templateMap = new map<String, EmailTemplate>();
        
        if (templates != null && !templates.isEmpty())
        {
            for (EmailTemplate et : templates)
            {
                
                if (et.Name != null && et.Name.contains('Problem Reported'))
                {
                    templateMap.put('Collab SI Automated Problem Reported', et);
                }
                
                else if (et.Name != null && et.Name.contains('Collab SI Automated Cannot Reproduce'))
                {
                    templateMap.put('Collab SI Automated Cannot Reproduce', et);
                }
                
                else if (et.Name != null && et.Name.contains('Enhancement Reported'))
                {
                    templateMap.put('Collab SI Automated Enhancement Reported', et);
                }
                
                else if (et.Name != null && et.Name.contains('Fixed and Released'))
                {
                    templateMap.put('Collab SI Automated Fixed and Released', et);
                }
                
                else if (et.Name != null && et.Name.contains('Collab SI Automated FAD'))
                {
                    templateMap.put('Collab SI Automated FAD', et);
                }
                
                else if (et.Name != null && et.Name.contains('Pending Target'))
                {
                    templateMap.put('Collab SI Automated Closed – Pending Target (Cloned to bug)', et);
                }
                
                else if (et.Name != null && et.Name.contains('Will Not Fix'))
                {
                    templateMap.put('Collab SI Automated Will Not Fix', et);
                }
               
               
               
                else
                {
                    
                }
            }
        }
        return templateMap;
    }
    private map<String, EmailTemplate> createTemplateMapMR(list<EmailTemplate> templates)
    {
        map<String, EmailTemplate> templateMap = new map<String, EmailTemplate>();
        
        if (templates != null && !templates.isEmpty())
        {
            for (EmailTemplate et : templates)
            {
                
                if (et.Name != null && et.Name.contains('MR SI Automated - Cannot Reproduce'))
                {
                    templateMap.put('MR SI Automated - Cannot Reproduce', et);
                }
                
                else if (et.Name != null && et.Name.contains('MR SI Automated - Pending Release'))
                {
                    templateMap.put('MR SI Automated - Pending Release', et);
                }
                
                else if (et.Name != null && et.Name.contains('MR SI Automated - Problem Reported'))
                {
                    templateMap.put('MR SI Automated - Problem Reported', et);
                }
                
                else if (et.Name != null && et.Name.contains('Won’t Fix'))
                {
                    templateMap.put('MR SI Automated - Won’t Fix', et);
                }
                
                else if (et.Name != null && et.Name.contains('MR SI Automated – Released'))
                {
                    templateMap.put('MR SI Automated – Released', et);
                }
                
                else if (et.Name != null && et.Name.contains('closed as Accepted'))
                {
                    templateMap.put('MR SI Automated-closed as Accepted', et);
                }
                
                else if (et.Name != null && et.Name.contains('closed as Denied'))
                {
                    templateMap.put('MR SI Automated-closed as Denied', et);
                }
                else if (et.Name != null && et.Name.contains('MR SI Automated-created'))
                {
                    templateMap.put('MR SI Automated-created', et);
                }
                else if (et.Name != null && et.Name.contains('Functioning as Designed'))
                {
                    templateMap.put('MR SI Automated-Functioning as Designed', et);
                }
               
               
               
                else
                {
                    
                }
            }
        }
        return templateMap;
    }
    
    private map<String, EmailTemplate> createTemplateMapAN(list<EmailTemplate> templates)
    {

        map<String, EmailTemplate> templateMap = new map<String, EmailTemplate>();
        
        if (templates != null && !templates.isEmpty())
        {
           for (EmailTemplate et : templates)
           {
              if (et.Name != null && et.Name.contains('AN SI Automated - Problem Reported') && et.Name == 'AN SI Automated - Problem Reported')
                {
                    templateMap.put('AN SI Automated - Problem Reported', et);
                } 

              else if(et.Name !=null && et.Name.contains('AN SI Automated - Problem Reported: Pending Pyramid Dev') && et.Name == 'AN SI Automated - Problem Reported: Pending Pyramid Dev') 
              {
                    templateMap.put('AN SI Automated - Problem Reported: Pending Pyramid Dev',et);  
              }

              else if(et.Name !=null && et.Name.contains('AN SI Automated - Closed – Pending Release'))
              {
                    templateMap.put('AN SI Automated - Closed – Pending Release',et);
              }  
              
              else if(et.Name !=null && et.Name.contains('AN SI Automated - Will Not Be Fixed'))
              {
                    templateMap.put('AN SI Automated - Will Not Be Fixed',et);
              }

              else if(et.Name !=null && et.Name.contains('AN SI Automated - Closed - Functioning As Designed'))
               {
                     templateMap.put('AN SI Automated - Closed - Functioning As Designed',et);
               }

              else if(et.Name !=null && et.Name.contains('AN SI Automated - Cannot Reproduce'))
               {
                     templateMap.put('AN SI Automated - Cannot Reproduce',et);
               }

              else if(et.Name !=null && et.Name.contains('AN SI Automated - Fixed Released'))
               {
                     templateMap.put('AN SI Automated - Fixed Released',et);
               }
           } 
        }

         return templateMap; 
    }



    private String convertMergeFields(String oldString, Case newCase, Case oldCase)
    {
        String newString = oldString;
        if (oldCase.Contact.Name != null)
        {
            newString = newString.replace('{!Case.Contact}', oldCase.Contact.Name);
        }
        else
        {
            newString = newString.replace('{!Case.Contact}', '');
        }
        system.debug('+++___***MM'+newCase.Known_Issue_Article_Number__c);
        if (newCase.Known_Issue_Article_Number__c != null)
        {
            newString = newString.replace('{!Case.Known_Issue_Article_Number__c}', newCase.Known_Issue_Article_Number__c);
        }
        else
        {
            newString = newString.replace('{!Case.Known_Issue_Article_Number__c}', '');
        }
        if (newCase.Fix_Version__c != null)
        {
            newString = newString.replace('{!Case.Fix_Version__c}', newCase.Fix_Version__c);
        }
        else
        {
            newString = newString.replace('{!Case.Fix_Version__c}', '');
        }
        if (newCase.Id != null)
        {
            newString = newString.replace('{!Case.Id}', newCase.Id);
        }
        else
        {
            newString = newString.replace('{!Case.Id}', '');
        }
        if (newCase.CaseNumber != null)
        {
            newString = newString.replace('{!Case.CaseNumber}', newCase.CaseNumber);
        }
        else
        {
            newString = newString.replace('{!Case.CaseNumber}', '');
        }
        if (newCase.Subject != null)
        {
            newString = newString.replace('{!Case.Subject}', newCase.Subject);
        }
        else
        {
            newString = newString.replace('{!Case.Subject}', '');
        }
        if (newCase.Fix_Timeframe__c != null)
        { 
            if(newCase.Fix_Timeframe__c.containsIgnoreCase('DUMMY DATE HERE'))
            {
                newString = newString.replace('{!Case.Fix_Timeframe__c}', 'Future Release');
            }
            else{
                newString = newString.replace('{!Case.Fix_Timeframe__c}', newCase.Fix_Timeframe__c);
            }
        }
        else
        {
            newString = newString.replace('{!Case.Fix_Timeframe__c}', '');
        }
        if (newCase.Closed_Comments__c != null)
        {
            newString = newString.replace('{!Case.Closed_Comments__c}', newCase.Closed_Comments__c);
        }
        else
        {
            newString = newString.replace('{!Case.Closed_Comments__c}', '');
        }
        if (newCase.Customer_Portal_Status__c != null)
        {
            newString = newString.replace('{!Case.Customer_Portal_Status__c}', newCase.Customer_Portal_Status__c);
        }
        else
        {
            newString = newString.replace('{!Case.Customer_Portal_Status__c}', '');
        }
        return newString;
    }
    
    private void insertEmailMessageList(list<EmailMessage> messageList)
    {
        if (messageList != null && !messageList.isEmpty())
        {
            try
            {
                insert messageList;
            }
            catch (DMLException e)
            {
                system.debug('Email Message Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void insertCaseNoteList(list<Case_Note__c> noteList)
    {
        if (noteList != null && !noteList.isEmpty())
        {
            try
            {
                insert noteList;
            }
            catch (DMLException e)
            {
                system.debug('Case Note Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void updatesolutionlist(list<Solution_Detail__c> sollist) //TP3067
    {
         if (sollist != null && !sollist.isEmpty())
        {
            try
            {
                update sollist;
            }
            catch (DMLException e)
            {
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void updatecaselist(list<case> caselist)
    {
       if (caselist != null && !caselist.isEmpty())
        {
            try
            {
                update caselist;
            }
            catch (DMLException e)
            {
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void updateSupportIncidentList(list<learnJIRA__c> siList)
    {
        if (siList != null && !siList.isEmpty())
        {
            try
            {
                update siList;
            }
            catch (DMLException e)
            {
                system.debug('Support Incident Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void updateBookmarkList(list<Case_Support_Incident__c> bookmarkList)
    {
        if (bookmarkList != null && !bookmarkList.isEmpty())
        {
            try
            {
                update bookmarkList;
            }
            catch (DMLException e)
            {
                system.debug('Case Support Incident Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    private void updateenduserrecord(list<case> newlist)
    {
      set<id> enduserids = new set<id>();
      map<id,id> chatcaseids= new map<id,id>();
          for(case cs: newlist)
          {
            if(cs.End_User__c != null)
            {
                enduserids.add(cs.End_User__c);
                
            }
            if(cs.Chatcase__c != null)
            {
                chatcaseids.put(cs.Chatcase__c,cs.id);
                
            }
          }
        if(enduserids != null && enduserids.size()>0)
        {  
            list<enduser__c> enduserlist=[select id,Time_of_Last_Created_Case__c from enduser__c where id in:enduserids];
            for(enduser__c en:enduserlist)
            {
                en.Time_of_Last_Created_Case__c=system.now();
            }
            update enduserlist;
        }
        if(chatcaseids != null && chatcaseids.size()>0)
        {
            list<livechattranscript> livetranscriptlist=[select id,chatcase__c from livechattranscript where chatcase__c in:chatcaseids.keyset()];
            for(livechattranscript lt:livetranscriptlist)
            {
               lt.caseid=chatcaseids.get(lt.chatcase__c);
            }
            update livetranscriptlist;
        }
    }
}