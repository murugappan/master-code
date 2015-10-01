public with sharing class RelatedBugTriggerHandler
{
    public static Boolean hasRun {get{if (hasRun == null) hasRun = false; return hasRun;} private set;}
    public static Boolean hasAfterInsertRun {get{if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} private set;}
    public static Boolean hasAfterUpdateRun {get{if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} private set;}
    public static Boolean hasAfterDeleteRun {get{if (hasAfterDeleteRun == null) return false; return hasAfterDeleteRun;} private set;}
    public static Boolean hasBBWAddArticleRun {get{if (hasBBWAddArticleRun == null) hasBBWAddArticleRun = false; return hasBBWAddArticleRun;} private set;}
    
    public RelatedBugTriggerHandler()
    {
        hasRun = true;
    }
    
    public void afterInsert(list<Related_Bug__c> newList)
    {
        if (!hasAfterInsertRun)
        {
            set<Id> bugIdSet = new set<Id>();
            set<Id> supportIncidentIdSet = new set<Id>();
            set<Id> supportIncidentUpdateIdSet = new set<Id>();
            set<Id> caseUpdateIdSet = new set<Id>();
            list<learnJIRA__c> supportIncidentInitialList;
            list<learnJIRA__c> supportIncidentUpdateList;
            list<Case> caseUpdateList;
            
            map<Id, Case> caseMap;
            map<Id, learnJIRA__c> supportIncidentInitialMap;
            hasAfterInsertRun = true;
            list<Known_Issue__kav> articleList = new list<Known_Issue__kav>();
            list<CaseArticle> caseArticleList = new list<CaseArticle>();
            
            for (Related_Bug__c rb : newList)
            {
                if (rb.Name != null && rb.Id != null && rb.Support_Incident__c != null)
                {
                    bugIdSet.add(rb.Id);
                    supportIncidentIdSet.add(rb.Support_Incident__c);
                    
                }
                
            }
            
            list<learnJira__c> SIlist= [Select Id,Name,Summary__c,Steps_to_Replicate_HTML__c,Target_Release__c,Client_Facing_Description_HTML__c,Workaround__c,Cause__c,Symptoms__c,Product_ID__c,Do_Not_Publish__c,Article_First_Published_Date__c,KI_Article_Created__c,Version_Number__c,OriginCaseID__c from LearnJira__c where Id in:supportIncidentIdSet];
            map<Id, learnJIRA__c> supportIncidentMap = new map<Id, learnJIRA__c>(SIlist);
            for(learnJira__c lj:SIlist)
            {
                if (lj.Summary__c != null && lj.KI_Article_Created__c == false)
                {
                    String urlName = lj.Summary__c;
                    urlname += string.valueof(system.now());
                    urlName = urlName.replace(' ', '-');
                    urlName = urlName.replace('.', '-');
                    urlName = urlName.replace('\\', '-');
                    urlName = urlName.replace('\'', '-');
                    urlName = urlName.replace(':', '-');
                    urlName = urlName.replace('_', '-');
                    urlName = urlName.replace(')', '-');
                    urlName = urlName.replace('()', '-');
                    urlName = urlName.replace('(', '-');
                    urlName = urlName.replace('^', '-');
                    urlName = urlName.replace('%', '-');
                    urlName = urlName.replace('$', '-');
                    urlName = urlName.replace('!', '-');
                    urlName = urlName.replace('@', '-');
                    urlName = urlName.replace('#', '-');
                    urlName = urlName.replace('~', '-');
                    urlName = urlName.replace('/', '-');
                    urlName = urlName.replace('[]', '-');
                    urlName = urlName.replace('[', '-');
                    urlName = urlName.replace(']', '-');
                    urlName = urlName.replace('>', '-');
                    urlName = urlName.replace('<', '-');
                    urlName = urlName.replace(',', '-');
                    urlName = urlName.replace('?', '-');
                    urlName = urlName.replace('"', '-');
                    urlName = urlName.replace('}', '-');
                    urlName = urlName.replace('{', '-');
                    urlName = urlName.replace('{}', '-');
                    urlName = urlName.replace('|', '-');
                    urlName = urlName.replace('||', '-');
                    urlName = urlName.replace('&', '-');
                    urlName = urlName.replace('`', '-');
                    urlName = urlName.replace('*', '-');
                    urlName = urlName.replace('+', '-');
                    urlName = urlName.replace('=', '-');
                    urlName = urlName.replace(';', '-');
                                      
                    articleList.add(new Known_Issue__kav(Support_Incident__c = lj.Id,SI_ID__c = lj.Name, Title = lj.Summary__c, UrlName = urlName,
                    Steps_to_Replicate__c = lj.Steps_to_Replicate_HTML__c + '' + lj.Client_Facing_Description_HTML__c, Resolution_Workaround__c = lj.Workaround__c, 
                    Cause__c = lj.Cause__c, Symptoms__c =  lj.Symptoms__c, Product__c = lj.Product_ID__c));
                    
                    
                 }
            }
            
            caseMap = new map<Id, Case>([Select Id, CaseNumber, LearnJIRA_SI__c, Bug_Time_Frame__c, Bug_Target_Release__c, Support_Incident_Fix__c, Support_Incident_Fix__r.Name, 
                                                Support_Incident_Fix__r.Status__c
                                         From Case 
                                         Where LearnJIRA_SI__c IN : supportIncidentIdSet]);
                                         
            supportIncidentInitialMap = querySIsAndBugChildren(supportIncidentIdSet);
            map<Id, learnJIRA__c> updateSiMap = new map<Id, learnJIRA__c>();
            if (supportIncidentInitialMap != null && !supportIncidentInitialMap.IsEmpty())
            {
                supportIncidentUpdateList = modifySupportIncidents(supportIncidentInitialMap);
                caseUpdateList = modifyCases(caseMap, supportIncidentInitialMap);
                system.debug('MMMM' + caseUpdateList);
                updateSiMap = new map<Id, learnJIRA__c>(supportIncidentUpdateList);
            }
                                    
            // DML methods
            //----------------------
         
         
            //------------------------
            //updateCases(caseUpdateIdSet, caseMap); // Removed for TP 4709 
            insert articleList;
  
            set<Id> kavIds = new set<Id>();
            map<Id, Id> kavSiMap = new map<Id, Id>();
            map<Id, Id> kavCaseMap = new map<Id, Id>();
            list<learnJIRA__c> siUpdatelist = new list<learnJIRA__c>();
            for (Known_Issue__kav ki : articleList)
            {
                if (ki.Id != null && supportIncidentMap.get(ki.Support_Incident__c) != null)
                {
                    kavIds.add(ki.Id);
                    kavSiMap.put(ki.Id, ki.Support_Incident__c);
                    kavCaseMap.put(ki.Id, supportIncidentMap.get(ki.Support_Incident__c).OriginCaseID__c);
                }
             }
             for (KnowledgeArticleVersion kav : [Select k.VersionNumber, k.ValidationStatus, k.UrlName, k.Title, k.SystemModstamp, k.Summary, k.SourceId, k.PublishStatus, k.OwnerId, 
                                                       k.LastPublishedDate, k.LastModifiedDate, k.LastModifiedById, k.Language, k.KnowledgeArticleId, k.IsVisibleInPrm, 
                                                       k.IsVisibleInPkb, k.IsVisibleInCsp, k.IsVisibleInApp, k.IsDeleted, k.Id, k.FirstPublishedDate, k.CurrencyIsoCode, k.CreatedDate, 
                                                       k.CreatedById, k.ArticleNumber, k.ArchivedDate, k.ArchivedById 
                                                From KnowledgeArticleVersion k Where Id IN : kavIds])
            {
                Id supportIncidentId = kavSiMap.get(kav.Id);
                learnJIRA__c lj = updateSiMap.get(supportIncidentId);
                if (lj != null)
                {
                    if (kavCaseMap.containsKey(kav.Id) && kavCaseMap.get(kav.Id) != null)
                    {
                        caseArticleList.add(new CaseArticle(CaseId = kavCaseMap.get(kav.Id), KnowledgeArticleId = kav.KnowledgeArticleId));
                    }
                    lj.Article_Id__c = kav.KnowledgeArticleId;
                    lj.Article_Version_Id__c = kav.Id;
                    lj.Article_Number__c = kav.ArticleNumber;
                    lj.Article_Title__c = kav.Title;
                    lj.Article_Published_Status__c = kav.PublishStatus;
                    lj.Article_First_Published_Date__c = kav.FirstPublishedDate;
                    lj.Version_Number__c = string.valueOf(kav.VersionNumber);
                    lj.KI_Article_Created__c = true;
                }
            } 
            insert caseArticleList;
            updateSupportIncidents(updateSiMap.keySet(), updateSiMap);
            Casetriggerhandler.hasBeforeUpdateRun=false;
            Casetriggerhandler.hasAfterUpdateRun=false;
            updateCases(caseUpdateIdSet, caseMap);// Added for TP 4709 
            
            
            
            
        }
    }
    
    public void afterUpdate(list<Related_Bug__c> newList, list<Related_Bug__c> oldList)
    {
        if (!hasAfterUpdateRun)
        {
            
            map<Id, Related_Bug__c> oldMap = new map<Id, Related_Bug__c>(oldList);
            set<Id> bugIdSet = new set<Id>();
            set<Id> supportIncidentIdSet = new set<Id>();
            set<Id> supportIncidentUpdateIdSet = new set<Id>();
            set<Id> caseUpdateIdSet = new set<Id>();
            list<learnJIRA__c> supportIncidentInitialList;
            list<learnJIRA__c> supportIncidentUpdateList;
            list<Case> caseUpdateList;
            map<Id, Case> caseMap;
            list<Case> cslist;
            map<Id, learnJIRA__c> supportIncidentInitialMap;
            hasAfterUpdateRun = true;
                        
            for (Related_Bug__c rb : newList)
            {
                if(rb.Id != null && rb.Name != null && rb.Support_Incident__c != null && oldMap.containsKey(rb.Id) && 
                    (rb.Name != oldMap.get(rb.Id).Name || rb.Not_Fixed_Reason__c != oldMap.get(rb.Id).Not_Fixed_Reason__c || rb.Status__c != oldMap.get(rb.Id).Status__c))
                {
                    bugIdSet.add(rb.Id);
                    supportIncidentIdSet.add(rb.Support_Incident__c);
                    system.debug('MUU'+supportIncidentIdSet);                   
                }
            }
            
            
          system.debug('MUU'+supportIncidentIdSet); 
            
            caseMap = new map<Id, Case>([Select Id, CaseNumber, LearnJIRA_SI__c, Bug_Time_Frame__c, Bug_Target_Release__c, Support_Incident_Fix__c, Support_Incident_Fix__r.Name, 
                                                Support_Incident_Fix__r.Status__c
                                         From Case 
                                         Where Support_Incident_Fix__c IN : bugIdSet]);
                                         
             supportIncidentInitialMap = querySIsAndBugChildren(supportIncidentIdSet);
            
            
            
            
            if (supportIncidentInitialMap != null && !supportIncidentInitialMap.IsEmpty())
            {
                supportIncidentUpdateList = modifySupportIncidents(supportIncidentInitialMap);
                 
                if (supportIncidentUpdateList != null && !supportIncidentUpdateList.isEmpty())
                {
                    for (learnJIRA__c lj : supportIncidentUpdateList)
                    {
                        if (supportIncidentInitialMap.containsKey(lj.Id))
                        {
                            supportIncidentUpdateIdSet.add(lj.Id);
                            supportIncidentInitialMap.put(lj.Id, lj);
                        }
                    }
                }
                
                
                
                caseUpdateList = modifyCases(caseMap, null);
                
                if (caseUpdateList != null && !caseUpdateList.isEmpty())
                {
                    for (Case c : caseUpdateList)
                    {
                        if (caseMap.containsKey(c.Id))
                        {
                            caseUpdateIdSet.add(c.Id);
                            caseMap.put(c.Id, c);
                        }
                    }
                }
            }
            
            // DML methods
            updateSupportIncidents(supportIncidentUpdateIdSet, supportIncidentInitialMap);
            updateCases(caseUpdateIdSet, caseMap);
             //Logic to update service pack and Target Release fields in articles
            /*list<Known_Issue__kav> articleLists = new list<Known_Issue__kav>();
            list<learnJira__c> SIilist= [Select Id,Name,Summary__c,Steps_to_Replicate_HTML__c,Target_Release__c,Client_Facing_Description_HTML__c,Workaround__c,Cause__c,Symptoms__c,Article_Version_Id__c,Product_ID__c,Article_First_Published_Date__c,Version_Number__c,OriginCaseID__c from LearnJira__c  where Id in:supportIncidentIdSet];
            for(learnJira__c lj:SIilist)
            {
                if (lj.Summary__c != null)
                {
                    articleLists.add(new Known_Issue__kav(Support_Incident__c = lj.Id, id=lj.Article_Version_Id__c,Target_Release__c = lj.Target_Release__c, Release__c = lj.Target_Release__c ));
                    system.debug('MUU'+articlelists);
                   
                }
                
            }
            update articleLists; */
            // 
               
        }
    }
    
    public void afterDelete(list<Related_Bug__c> oldList)
    {
        if (!hasAfterDeleteRun)
        {
            set<Id> bugIdSet = new set<Id>();
            set<Id> supportIncidentIdSet = new set<Id>();
            set<Id> supportIncidentUpdateIdSet = new set<Id>();
            list<learnJIRA__c> supportIncidentUpdateList;
            map<Id, learnJIRA__c> supportIncidentInitialMap;
            hasAfterDeleteRun = true;
            
            for(Related_Bug__c rb : oldList)
            {
                if (rb.Id != null)
                {
                    bugIdSet.add(rb.Id);
                }
                if (rb.Support_Incident__c != null)
                {
                    supportIncidentIdSet.add(rb.Support_Incident__c);
                }
            }
            
            supportIncidentInitialMap = querySIsAndBugChildren(supportIncidentIdSet);
            if (supportIncidentInitialMap != null && !supportIncidentInitialMap.IsEmpty())
            {
                supportIncidentUpdateList = modifySupportIncidents(supportIncidentInitialMap);
                
                if (supportIncidentUpdateList != null && !supportIncidentUpdateList.isEmpty())
                {
                    for (learnJIRA__c lj : supportIncidentUpdateList)
                    {
                        if (supportIncidentInitialMap.containsKey(lj.Id))
                        {
                            supportIncidentUpdateIdSet.add(lj.Id);
                            supportIncidentInitialMap.put(lj.Id, lj);
                        }
                    }
                }
            }
            
            map<Id, Case> caseMap = new map<Id, Case>([Select Id From Case Where Support_Incident_Fix__c IN : bugIdSet]);
            
            // DML methods
            updateSupportIncidents(supportIncidentUpdateIdSet, supportIncidentInitialMap);
            updateCases(caseMap.keySet(), caseMap);
        }
    }
    
    // This method queries SIs and the related bug children
    private map<Id, learnJIRA__c> querySIsAndBugChildren(set<Id> supportIncidentIdSet)
    {
        if (supportIncidentIdSet != null && !supportIncidentIdSet.isEmpty())
        {
            return new map<Id, learnJIRA__c>([Select Name, Id, Target_Release__c, Not_Fixed_Reason__c, Summary__c, Steps_to_Replicate_HTML__c, Client_Facing_Description_HTML__c, 
                                                     Workaround__c, Cause__c, Symptoms__c, Product_ID__c, Article_Id__c,Do_Not_Publish__c,KI_Article_Created__c, Article_Version_Id__c, Article_Number__c, Article_Title__c,
                                                     Article_Published_Status__c, Article_First_Published_Date__c, Version_Number__c, 
                                                (Select Id, Name, Status__c,Impact_Area__c, Not_Fixed_Reason__c,Labels__c From Related_Bugs__r order by Name asc) 
                                              From learnJIRA__c 
                                              Where Id IN : supportIncidentIdSet]);
        }
        return null;
    }
    
    // This method will update the Target Release on the SIs
    // this mathod will update the Not Fixed reason on the SIs
    private list<learnJIRA__c> modifySupportIncidents(map<Id, learnJIRA__c> supportIncidentMap)
    {
        list<learnJIRA__c> supportIncidentUpdateList = new list<learnJIRA__c>();
        String targetRelease, notFixedReason;
        
        if (supportIncidentMap != null && !supportIncidentMap.isEmpty())
        {
            for (learnJIRA__c lj : supportIncidentMap.values())
            {
                targetRelease = null;
                notFixedReason = null;
                
                for (Related_Bug__c rb : lj.Related_Bugs__r)
                {
                    if (rb.Name != null && rb.Name != 'N/A')
                    {
                        if (targetRelease == null)
                        {
                            targetRelease = rb.Name;
                        }
                        else if (!targetRelease.contains(rb.Name))
                        {
                            targetRelease += (', ' + rb.Name);
                        }
                    }
                    
                    system.debug('Muru');
                    
                                        
                    if (rb.Not_Fixed_Reason__c != null && rb.Not_Fixed_Reason__c != 'N/A')
                    {
                        if (notFixedReason == null)
                        {
                            notFixedReason = rb.Not_Fixed_Reason__c;
                        }
                        else if (!notFixedReason.contains(rb.Not_Fixed_Reason__c))
                        {
                            notFixedReason += (', ' + rb.Not_Fixed_Reason__c);
                        }
                    }
                }
                
                if (lj.Target_Release__c != targetRelease || lj.Not_Fixed_Reason__c != notFixedReason)
                {
                    if (lj.Target_Release__c != targetRelease)
                    {
                        lj.Target_Release__c = targetRelease;
                    }
                    if (lj.Not_Fixed_Reason__c != notFixedReason)
                    {
                        lj.Not_Fixed_Reason__c = notFixedReason;
                        //lj.Do_Not_Publish__c = true;
                    }
                    
                    
                    if(notFixedReason =='Duplicate' || notFixedReason =='Will Not Fix' || notFixedReason =='Functioning as Designed'){
                    
                    lj.Do_Not_Publish__c = true;
                    
                    }
                    
                    if(notFixedReason =='Cannot Reproduce'){
                    
                    lj.Do_Not_Publish__c = false;
                    
                    }
                    
                   
                }
                
                for (Related_Bug__c rb : lj.Related_Bugs__r)
                {
                
                   if(rb.Impact_Area__c != null && rb.Impact_Area__c.contains('Security') || rb.Labels__c != null && rb.Labels__c.contains('Security') || rb.Impact_Area__c != null && rb.Impact_Area__c.contains('security') || rb.Labels__c != null && rb.Labels__c.contains('security') )
                    {
                      system.debug('Muru1');
                      lj.Do_Not_Publish__c = true;
                                        
                    }
                } 
                    
                
                supportIncidentUpdateList.add(lj);
            }
        }
        return supportIncidentUpdateList;
    }
    
    // This method will update the Target Release on the Case
    private list<Case> modifyCases(map<Id, Case> caseMap, map<Id, learnJIRA__c> siMap)
    {
        list<Case> caseUpdateList = new list<Case>();
        String targetRelease;
        
        if (caseMap != null && !caseMap.isEmpty())
        {
            for (Case c : caseMap.values())
            {
                if (siMap != null && siMap.containsKey(c.LearnJIRA_SI__c) && siMap.get(c.LearnJIRA_SI__c).Related_Bugs__r != null && 
                    siMap.get(c.LearnJIRA_SI__c).Related_Bugs__r.size() == 1)
                {
                    c.Support_Incident_Fix__c = siMap.get(c.LearnJIRA_SI__c).Related_Bugs__r[0].Id;
                }
                targetRelease = null;
                
                if (c.Support_Incident_Fix__r.Status__c != null && c.Support_Incident_Fix__r.Status__c != 'Not Fixed') // Ask about this logic
                {
                    targetRelease = c.Support_Incident_Fix__r.Name;
                }
                if (c.Bug_Target_Release__c != targetRelease)
                {
                    c.Bug_Target_Release__c = targetRelease;
                }
                caseUpdateList.add(c);
            }
        }
        
        return caseUpdateList;
    }
    
    private void updateSupportIncidents(set<Id> siIdSet, map<Id, learnJIRA__c> siMap)
    {
        list<learnJIRA__c> siList = new list<learnJIRA__c>();
        
        if (siIdSet != null && !siIdSet.isEmpty() && siMap != null && !siMap.isEmpty())
        {
            for (Id i : siIdSet)
            {
                if (siMap.containsKey(i))
                {
                    siList.add(siMap.get(i));
                }
            }
            
            if (siList != null && !siList.isEmpty())
            {
                try
                {
                    update siList;
                }
                catch (DMLException e)
                {
                    system.debug('SI Update Failed!');
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
    }
    
    private void updateCases(set<Id> caseIdSet, map<Id, Case> caseMap)
    {/*This is what the code should do in the future, but for now, we have to update cases on all bug changes to trigger status changes
        list<Case> caseList = new list<Case>();
        
        if (caseIdSet != null && !caseIdSet.isEmpty() && caseMap != null && !caseMap.isEmpty())
        {
            for (Id i : caseIdSet)
            {
                if (caseMap.containsKey(i))
                {
                    caseList.add(caseMap.get(i));
                }
            }
            
            if (caseList != null && !caseList.isEmpty())
            {
                try
                {
                    update caseList;
                }
                catch (DMLException e)
                {
                    system.debug('Case Update Failed!');
                    Exception_Log__c el = new Exception_Log__c(Exception__c = e, Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    insert el;
                }
            }
        }*/
        
        
        if (caseMap != null && !caseMap.isEmpty())
        {
            try
            {
                update caseMap.values();
                system.debug('CASEMAP VALUES:'+caseMap.values());
            }
            catch (DMLException e)
            {
                system.debug('Case Update Failed!');
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
    
    private void updateBookmarks(list<Case_Support_Incident__c> csiList)
    {
        if (csiList != null && !csiList.isEmpty())
        {
            try
            {
                update csiList;
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
      
}