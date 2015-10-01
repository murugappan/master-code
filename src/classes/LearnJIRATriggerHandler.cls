public with sharing class LearnJIRATriggerHandler 
{

    public static Boolean hasRun {get{if (hasRun == null) return false; return hasRun;} set;}
    public static Boolean hasBeforeInsertRun {get{if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
    public static Boolean hasAfterInsertRun {get{if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
    public static Boolean hasBeforeUpdateRun {get{if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} set;}
    public static Boolean hasAfterUpdateRun {get{if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    
    public LearnJIRATriggerHandler()
    {
        hasRun = true;
    }
    
    public void beforeInsert(list<learnJIRA__c> newList)
    {
        if (!hasBeforeInsertRun)
        {
         Beforeinsertmthd1(newList);
         // beforeInsertmthd2(newList);  // temp commenting dont delete 
         beforeInsertmthd3(newList);
         
          for(learnJIRA__c rb : newlist){
                if(rb.Do_Not_Publish__c = false ){
                     rb.DNP_Last_Modified__c  = system.now();
                }
                
                else if(rb.Steps_to_Replicate_HTML__c != null ){
                    rb.Steps_to_Replicate_Last_Modified__c  = system.now();
                }
            }
        }
       
       
    }
   // Added by Avik 
   
   
   
  public void beforeInsertmthd2(list<learnJIRA__c> newList)
    {

     Group MoodleroomProductDev =[Select Id,Name from Group q where Name='Moodlerooms: Product Development'];
     Group MoodleroomProductDev1 =[Select Id,Name from Group q where Name='Moodlerooms: Advanced Support - Tech Ops'];
     Group MoodleroomProductStr =[Select Id,Name from Group q where Name='Moodlerooms: Product Strategy'];
     Group MoodleroomProductStr2 =[Select Id,Name from Group q where Name='Moodlerooms: Product Strategy'];
     User CurrenUser =[select id,Primary_Group__c from User where id =:Userinfo.GetUserId()];
     RecordType rt =[SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE Name = 'Moodlerooms' AND SobjectType = 'learnJira__c'];
     //RecordType lrt =[SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE Name = 'Learn' AND SobjectType = 'learnJira__c']; 
      
     for(learnJIRA__c lj : newList)
      {
        
         if(lj.Tier_2_Assessment__c != Null)
         {
             /*if(lj.Tier_2_Assessment__c=='This is a Bug' && lj.RecordTypeId =='012V00000000Fyq' )
             {
                lj.OwnerId=CurrenUser.id;
             } */
             
             if(lj.Tier_2_Assessment__c=='This is a Bug' && lj.RecordTypeId == rt.id )
             {
              lj.OwnerId=MoodleroomProductDev.id;
              //lj.Initial_SI_Owner__c=MoodleroomProductDev.Name; (original)
              //lj.Primary_Group__c=CurrenUser.Primary_Group__c;  (original) 
              lj.Initial_SI_Owner__c='Moodlerooms: Product Development';
              lj.Primary_Group__c='Moodlerooms: Product Development';
             
              }
            else if(lj.Tier_2_Assessment__c=='Enhancement')
             {
              lj.OwnerId=MoodleroomProductStr2.id;
              //lj.Initial_SI_Owner__c=MoodleroomProductStr.Name; (original) 
              //lj.Primary_Group__c=CurrenUser.Primary_Group__c;  (original)
              lj.Initial_SI_Owner__c='Moodlerooms: Product Strategy';
              lj.Primary_Group__c='Moodlerooms: Product Strategy';
             
             }
          }
      
      }    
        
     }
     
     
     
     
     public void beforeInsertmthd3(list<learnJIRA__c> newList)
    {

     //Group MoodleroomProductDev =[Select Id,Name from Group q where Name='Moodlerooms: Product Development'];
     //Group MoodleroomProductDev1 =[Select Id,Name from Group q where Name='Moodlerooms: Advanced Support - Tech Ops'];
     //Group MoodleroomProductStr =[Select Id,Name from Group q where Name='Moodlerooms: Product Strategy'];
     //Group MoodleroomProductStr2 =[Select Id,Name from Group q where Name='Moodlerooms: Product Strategy'];
     User CurrenUser =[select id,Primary_Group__c from User where id =:Userinfo.GetUserId()];
     RecordType rt =[SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE Name = 'Collaborate' AND SobjectType = 'learnJira__c'];
      
     for(learnJIRA__c lj : newList)
      {
        
         if(lj.Tier_2_Assessment__c != Null && rt.Name == 'Collaborate')
         {
             
             if(lj.Tier_2_Assessment__c=='This is a Bug' && lj.RecordTypeId == rt.id )
             {
                    //lj.Initial_SI_Owner__c=MoodleroomProductDev.Name; (original)
                    lj.Primary_Group__c=CurrenUser.Primary_Group__c;   
              
             }
           
          }
      
      }    
        
     }


 Private void Beforeinsertmthd1(list<learnJIRA__c> newList) 
  {
            map<Id, Case> caseMap;
            set<Id> caseIdSet = new set<Id>();
            
            hasBeforeInsertRun = true; // To avoid this from running again.
            flipIsChanged(newList);
            
            for (learnJIRA__c lj : newList)
            {
                if (lj.OriginCaseID__c != null)
                {
                    caseIdSet.add(lj.OriginCaseID__c);
                }
            }
            
            caseMap = queryForCaseMap(caseIdSet);
            copyFieldsFromCase(newList, caseMap);
            updateMasterCase(newList, null, null);
  }  
    
    
    public void afterInsert(list<learnJIRA__c> newList)
    {
        if (!hasAfterInsertRun)
        {
           //list<Known_Issue__kav> articleList = new list<Known_Issue__kav>(); //moodle
           //list<CaseArticle> caseArticleList = new list<CaseArticle>(); //moodle
           
           list<Case> caseUpdateList;
            map<Id, learnJIRA__c> supportIncidentMap = new map<Id, learnJIRA__c>(newList);
            map<Id, learnJIRA__c> siFullMap; // This map is after quering all fields and related lists on the si
            map<Id, Case> caseMap;
            set<Id> caseIdSet = new set<Id>();
            set<Id> supportIncidentIdSet = new set<Id>();
            Boolean articleInsertPass = false;
          
            
            
            hasAfterInsertRun = true;
            
            for (learnJIRA__c lj : newList)
            {
                if (lj.Id != null)
                {
                    supportIncidentIdSet.add(lj.Id);
                     
                }
                if (lj.OriginCaseID__c != null)
                {
                    caseIdSet.add(lj.OriginCaseID__c);
                }
              /*if (lj.Summary__c != null && lj.RecordType.Name =='Moodlerooms')  //moodle
                 {  String urlName = lj.Summary__c;
                    urlName = urlName.replaceAll(' ', '-');
                    urlName = urlName.replaceAll('\'', '-');
                    system.debug('Murugappan' + urlname);
                    articleList.add(new Known_Issue__kav(Support_Incident__c = lj.Id,SI_ID__c = lj.Name, Title = lj.Summary__c, UrlName = urlName,
                    Steps_to_Replicate__c = lj.Steps_to_Replicate_HTML__c + '' + lj.Client_Facing_Description_HTML__c, Resolution_Workaround__c = lj.Workaround__c, 
                    Cause__c = lj.Cause__c, Symptoms__c =  lj.Symptoms__c, Product__c = lj.Product_ID__c));
                 } //moodle */ 
                 
               
            
            }
            
       
            
            siFullMap = queryForSupportIncidentMap(supportIncidentIdSet);
            //caseMap = queryForCaseMap(caseIdSet);
            
            // Dml Statements
            
             // insert articleList; //moodle
             //system.debug('Murugappan'+ articlelist);// moodle
             set<Id> kavIds = new set<Id>();
             map<Id, Id> kavSiMap = new map<Id, Id>();
             map<Id, Id> kavCaseMap = new map<Id, Id>();
             list<learnJIRA__c> siUpdatelist = new list<learnJIRA__c>();
            /* for (Known_Issue__kav ki : articleList) //moodle
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
                //learnJIRA__c lj = new learnJIRA__c(Id = supportIncidentId); //moodle
                if (kavCaseMap.containsKey(kav.Id) && kavCaseMap.get(kav.Id) != null)
                {
                    caseArticleList.add(new CaseArticle(CaseId = kavCaseMap.get(kav.Id), KnowledgeArticleId = kav.KnowledgeArticleId));
                }
                lj.Article_Id__c = kav.KnowledgeArticleId;
                lj.Article_Version_Id__c = kav.Id;
                lj.Article_Number__c = kav.ArticleNumber;
                lj.Article_Title__c = kav.Title;
                lj.Article_Published_Status__c = kav.PublishStatus;
                siUpdateList.add(lj);
            } //moodle   */
          //  insert caseArticleList; //moodle
           //update siUpdateList; //moodle
            //caseUpdateList = modifyCaseRecords(siFullMap, caseMap, articleList, true);
            //map<Id, Case> caseUpdateMap = new map<Id, Case>(caseUpdateList);
            //DmlListAction.updateCaseList(caseUpdateMap.keySet(), caseUpdateMap, String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
        }
    }
    

    
    public void beforeUpdate(list<learnJIRA__c> newList, list<learnJIRA__c> oldList)
    {
        set<Id> supportIncidentIdSet = new set<Id>();
        map<Id, learnJIRA__c> newMap = new map<Id, learnJIRA__c>(newList);
        map<Id, Known_Issue__kav> knownIssueMap;
        map<Id, learnJIRA__c> siFullMap = queryForSupportIncidentMap(newMap.keySet()); // This map is after quering all fields and related lists on the si
        map<Id, learnJIRA__c> oldMap = new map<Id, learnJIRA__c>(oldList);
        if (!hasBeforeUpdateRun)
        {
            hasBeforeUpdateRun = true;
            flipIsChanged(newList);
            knownIssueMap = queryForKnownIssueMap(newMap.keySet());
            //updateKnownIssueField(newList, knownIssueMap); this need to be taken out or rewritten
            
            for (learnJIRA__c lj : newList)
            {
               learnJIRA__c oldBug = oldMap.get(lj.Id);
                if (oldBug.Do_Not_Publish__c != lj.Do_Not_Publish__c ) {
                     lj.DNP_Last_Modified__c  = system.now();
                }
                
                
                else if (oldBug.Steps_to_Replicate_HTML__c != lj.Steps_to_Replicate_HTML__c ) {
                     lj.Steps_to_Replicate_Last_Modified__c  = system.now();
                }
             }
            
        }
     updateMasterCase(newList, oldList, siFullMap);
    }
    
    //RecordType rtt =[SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE Name = 'Learn' AND SobjectType = 'learnJira__c'];
    id rtt=learnJira__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Learn').getRecordTypeId();
    list<Known_Issue__kav> articleList = new list<Known_Issue__kav>(); //moodle
    
    /*public void afterupdatemethod1(list<learnJIRA__c> newList, list<learnJIRA__c> oldList)
    {
        map<Id, learnJIRA__c> oldsimap = new map<Id, learnJIRA__c>(oldlist);
        map<Id, learnJIRA__c> simap;
        map<Id, Case> casemap;

        set<Id> supportIncidentIdSet = new set<Id>();
        set<Id> caseIdset = new set<Id>();

        for(learnJIRA__c si : newList)
        {
            learnJIRA__c oldsi = oldsiMap.get(si.Id); 
            if(si.Id!= null && si.Resolution__c!= null )
            {
                if(oldsi.Resolution__c != si.Resolution__c)
                {
                   supportIncidentIdSet.add(si.Id); 
                }
            }
        }
        simap = queryForSupportIncidentMap(supportIncidentIdSet);
        caseMap = queryCaseWithSI(supportIncidentIdSet);

    } */ 
    public void afterUpdate(list<learnJIRA__c> newList, list<learnJIRA__c> oldList)
    {
        if (!hasAfterUpdateRun)
        {
            map<Id, learnJIRA__c> oldMap = new map<Id, learnJIRA__c>(oldList);
           
            map<Id, learnJIRA__c> siFullMap; // This map is after quering all fields and related lists on the si
            map<Id, Case> caseMap;
           
            set<id> mastercaseidset = new set<id>();
            
            
            list<Case> caseUpdateList;
            set<Id> supportIncidentIdSet = new set<Id>();
            set<Id> caseIdSet = new set<Id>();
            
            hasAfterUpdateRun = true;
            
             for (learnJIRA__c lj : newList)
            {
                
                if (lj.Id != null)
                {
                    supportIncidentIdSet.add(lj.Id);
                    
                   
                }
                if (lj.OriginCaseID__c != null)
                {
                    caseIdSet.add(lj.OriginCaseID__c);
                }
                
         if (lj.Summary__c != null && lj.Status__c == 'Open' && lj.Type__c == 'Moodlerooms' && lj.Tier_2_Assessment__c == 'This is a bug' || lj.Summary__c != null && lj.Status__c == 'On Hold' && lj.Type__c == 'Moodle core' && lj.Tier_2_Assessment__c == 'This is a bug' && lj.On_Hold_Reason__c == 'Waiting for Moodle Development' || lj.Summary__c != null && lj.Status__c == 'On Hold' && lj.Type__c == 'Third Party' && lj.Tier_2_Assessment__c == 'This is a bug' && lj.On_Hold_Reason__c == 'Waiting for 3rd Party Development' ) //moodle
                 {  
                   If(lj.isArticleCreated__c != true){
                    String urlName = lj.Summary__c;
                    urlName = urlName.replaceAll(' ', '-');
                    urlName = urlName.replaceAll('\'', '-');
                    urlName = urlName.replaceAll(':', '-');
                    urlName = urlName.replaceAll('"', '-');
                    urlName = urlName.replaceAll('--', '-');
                    system.debug('Murugappan' + urlname);
                    articleList.add(new Known_Issue__kav(Support_Incident__c = lj.Id,SI_ID__c = lj.Name, Title = lj.Summary__c, UrlName = urlName,
                    Steps_to_Replicate__c = lj.Steps_to_Replicate_HTML__c + '' + lj.Client_Facing_Description_HTML__c, Resolution_Workaround__c = lj.Workaround__c, 
                    Cause__c = lj.Cause__c, Symptoms__c =  lj.Symptoms__c, Product__c = lj.Product_ID__c));
                    }
                    learnJIRA__c lj1=new learnJira__c(id=lj.id);
                    lj1.isArticleCreated__c=true;
                    update lj1;
                  }
                  insert articleList; 
                 // system.debug('MURUGURU');
                 
                        
                if (lj.Master_Case__c != null)
                {
                    mastercaseidset.add(lj.Master_Case__c);
                }
                
                               
            }
            
           /*list<learnJIRA__c> countlist;
           list<learnJIRA__c> countupdatelist = new list<learnJIRA__c>();
           countlist = [Select id,Name, (Select id from Cases__r) from learnJIRA__c WHERE id IN :supportIncidentIdSet];
            for(learnJIRA__c lj: countlist){
                lj.Case_Count__c = lj.Cases__r.size();
                countupdatelist.add(lj);
            }
           update countupdatelist; */
            
            Map<id, Case> masterCasemap = new Map<id,Case>([select Id, OwnerId, Owner.Email from case where Id IN:mastercaseidset ]);
            list<Email__c> emailmasterlist = new list<Email__c>();
            if(masterCasemap != null){
                for(learnJIRA__c lj: newlist){
                    String value;
                    String newIdentity = lj.Status__c;
                    String newIdentity1 = lj.On_Hold_Reason__c;
                    String oldIdentity = oldMap.get(lj.id).Status__c;
                    String oldIdentity1 = oldMap.get(lj.id).On_Hold_Reason__c;
                    
                    if(masterCasemap.containskey(lj.Master_Case__c) && oldIdentity != 'On Hold' && oldIdentity1 != 'Waiting on Client Support Response'  && lj.Status__c == 'On Hold' && lj.On_Hold_Reason__c == 'Waiting for Client Support Response' && lj.RecordTypeId == rtt)
                    {
                       Email__c Mc = new Email__c();
                       Mc.User__c = masterCasemap.get(lj.Master_Case__c).OwnerId;
                       value = Mc.User__c;
                       Mc.Subject__c = lj.JIRA_Key__c +' '+'has been placed On Hold by Tier 3 Support';
                       Mc.Body__c = lj.JIRA_Key__c + lj.Name +'has been placed On Hold by Tier 3 Support, indicating that more information is required for them to proceed with this issue. Please refer to the latest comment in the SI and respond with the requested information so that work on this SI may continue.';
                       if(value.startswith('00570000001')){
                       emailmasterlist.add(Mc);
                       }
                    }
                
                }
                if(emailmasterlist != null && !emailmasterlist.isempty()){
                    insert emailmasterlist;
                } 
             }           
            siFullMap = queryForSupportIncidentMap(supportIncidentIdSet);
            
            //caseMap = queryForCaseMap(caseIdSet);
            caseMap = queryCaseWithSI(supportIncidentIdSet);
            
            caseUpdateList = modifyCaseRecords(siFullMap, caseMap, null, false, oldMap);
            
            // Dml statements
            map<Id, Case> caseUpdateMap = new map<Id, Case>(caseUpdateList);
            DmlListAction.updateCaseList(caseUpdateMap.keySet(), caseUpdateMap, String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
        }
        
    }
    
    
    //This method will check the isChanged flag on the SI if the current User is not JIRA
    private void flipIsChanged(list<learnJIRA__c> siList)
    {
        //RecordType lrt =[SELECT Id,IsActive,Name,SobjectType FROM RecordType WHERE Name = 'Learn' AND SobjectType = 'learnJira__c']; 
        id rttt =learnJira__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Learn').getRecordTypeId();
        String username = UserInfo.getUserName();
        if (username != null)
        {
            username = username.toLowerCase();
            if (!username.containsignorecase('pddireleads@blackboard.com'))
            {
                for (learnJIRA__c lj : siList)
                {
                    system.debug('Murugappan' + rttt + ''+ lj.RecordTypeId );
                    if(lj.RecordTypeId == rttt){
                    lj.isChanged__c = true;
                    }
                }
            }
        }
    }
     
    
    
    // This method is for querying the SI object for all fields
    private map<Id, learnJIRA__c> queryForSupportIncidentMap(set<Id> supportIncidentIdSet)
    {
        return new map<Id, learnJIRA__c>([Select Id, Number_of_Related_Bugs__c,RecordType.Name, OriginCaseID__c,isArticleCreated__c,Master_Case__c, Master_Case__r.IsClosed,Resolution__c, (Select Id From Related_Bugs__r),
                                                 (Select Id, CaseNumber, IsClosed,Support_Incident_Fix__c, CreatedDate, LearnJIRA_SI__c From Cases__r) 
                                          From learnJIRA__c 
                                          Where Id IN : supportIncidentIdSet]);
    }
    
    // This method is for querying the Case object fromt the ids you pass
    private map<Id, Case> queryForCaseMap(set<Id> caseIdSet)
    {
        return new map<Id, Case>([Select Id, CaseNumber, Steps_To_Replicate__c, Support_Incident_Fix__c, LearnJIRA_SI__c,JIRA_Source_Build__c, Description, Subject, A2__c, Asset.Version_Build__c, 
                                         Asset.Front_Back_Access__c, Module__c, Module__r.Name,Functional_Area__r.Name, Category__r.Name, Core_License__r.Name, OwnerId, Owner.Email
                                  From Case 
                                  Where Id IN : caseIdSet]);
    }
    
    
    private map<Id, Case> queryCaseWithSI(set<Id> supportIncidentIdSet)
    {
        return new map<Id, Case>([Select Id, CaseNumber, Steps_To_Replicate__c, Support_Incident_Fix__c, LearnJIRA_SI__c, JIRA_Source_Build__c, Description, Subject, A2__c, Asset.Version_Build__c, 
                                         Asset.Front_Back_Access__c, Module__c, Module__r.Name,Functional_Area__r.Name, Category__r.Name, Core_License__r.Name                               
                                  From Case 
                                  Where LearnJIRA_SI__c IN : supportIncidentIdSet]);
    }
    
    
   
   
    // This method copies fields from the case record to the SI 
    // (Might replace with the Create SI page)
    private void copyFieldsFromCase(list<learnJIRA__c> siList, map<Id, Case> caseMap)
    {
        set<Id> caseIdSet = new set<Id>();
        String stepsToReplicate;
        Case caseObj;
        
        if (caseMap != null && !caseMap.isEmpty())
        {
            for (learnJIRA__c lj : siList)
            {
                if (caseMap.containsKey(lj.OriginCaseID__c))
                {
                    caseObj = caseMap.get(lj.OriginCaseID__c);
                    if (caseObj.Steps_To_Replicate__c != null && caseObj.Steps_To_Replicate__c != '')
                    {
                        stepsToReplicate = caseObj.Steps_To_Replicate__c;
                       // lj.Steps_to_Replicate__c = stepsToReplicate; commenting this for TP#16551
                        stepsToReplicate  = stepsToReplicate.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
                        lj.Steps_to_Replicate_HTML__c = stepsToReplicate;
                    }
                    lj.Module__c = caseObj.Module__r.Name;
                    lj.Functional_Area__c = caseObj.Functional_Area__r.Name;
                    lj.Category__c = caseObj.Category__r.Name;
                    lj.System_Information__c = caseObj.Asset.Front_Back_Access__c;
                    //lj.Steps_to_Replicate__c = caseObj.A2__c; commenting this for TP#16551
                    //lj.Reported_In_Version__c = caseObj.Asset.Version_Build__c;
                    if (lj.Reported_In_Version__c == null || lj.Reported_In_Version__c == '' || lj.Reported_In_Version__c == '-Please Select-')
                    {
                        lj.Reported_In_Version__c = 'Unknown';
                    }
                    /*else{
                        lj.Reported_In_Version__c = caseObj.JIRA_Source_Build__c;
                    }*/
                    lj.Product_ID__c = caseObj.Core_License__r.Name;
                }
            }
        }
    }
    
    // This method will query all known issues for the SIs in the trigger
    private map<Id, Known_Issue__kav> queryForKnownIssueMap(set<Id> supportIncidentIdSet)
    {
        return new map<Id, Known_Issue__kav>([Select k.UrlName, k.Title, k.Target_Release__c, k.Symptoms__c, k.Support_Incident__c, k.Summary, k.Steps_to_Replicate__c, k.SourceId, 
                                                     /*k.Solution_Published_Date__c,*/ k.Solution_Number__c, k.SolutionID__c, k.Service_Packs__c, k.Resolution_Workaround__c, k.Release__c, 
                                                     k.PublishStatus, k.Public_URL__c, k.Product__c, k.Patch_Versions__c, k.Patch_Information__c, k.Patch_Available__c, k.OwnerId, 
                                                     k.Number_of_Clients_Reporting__c, k.LastPublishedDate, k.LastModifiedDate, k.LastModifiedById, k.Language, k.KnowledgeArticleId, 
                                                     k.Issue_Description__c, k.Internal_Only_Notes__c, k.Id, k.FirstPublishedDate, k.CurrencyIsoCode, k.CreatedDate, k.CreatedById, 
                                                     k.Cause__c, k.Best_Practice_Information__c, k.Attachment_5__Name__s, k.Attachment_5__Length__s, k.Attachment_5__ContentType__s, 
                                                     k.Attachment_5__Body__s, k.Attachment_4__Name__s, k.Attachment_4__Length__s, k.Attachment_4__ContentType__s, k.Attachment_4__Body__s, 
                                                     k.Attachment_3__Name__s, k.Attachment_3__Length__s, k.Attachment_3__ContentType__s, k.Attachment_3__Body__s, k.Attachment_2__Name__s, 
                                                     k.Attachment_2__Length__s, k.Attachment_2__ContentType__s, k.Attachment_2__Body__s, k.Attachment_1__Name__s, 
                                                     k.Attachment_1__Length__s, k.Attachment_1__ContentType__s, k.Attachment_1__Body__s, k.ArticleNumber, k.ArchivedDate, k.ArchivedById 
                                              From Known_Issue__kav k
                                              Where Support_Incident__c IN : supportIncidentIdSet
                                              And PublishStatus = 'Online'
                                              And Language = 'en_US']);
    }
    
    // This method will insert article records and return true if successful and false if not
    private Boolean insertArticleList(list<Known_Issue__kav> articleList)
    {
        if (articleList != null & !articleList.isEmpty())
        {
            try
            {
                insert articleList;
                return true;
            }
            catch (DmlException e)
            {
                system.debug('Known Issue Article Insert Failed!');
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
                return false;
            }
        }
        return false;
    }
    
    // This method will insert CaseArticle records
    private void insertCaseArticleList(list<CaseArticle> caseArticleList)
    {
        if (caseArticleList != null & !caseArticleList.isEmpty())
        {
            try
            {
                insert caseArticleList;
            }
            catch (DmlException e)
            {
                system.debug('Case Article Insert Failed!');
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
    
    // This method will set the Case fields to be updated and return a list
    private list<Case> modifyCaseRecords(map<Id, learnJIRA__c> supportIncidentMap, map<Id, Case> caseMap, list<Known_Issue__kav> articleList, Boolean isInsert, map<Id, learnJIRA__c> oldMap)
    {
        list<Case> caseUpdateList = new list<Case>();
        set<Id> updatedCaseIdSet = new set<Id>();
        map<Id, Case> caseUpdateMap = new map<Id, Case>();
        Case caseObj;
        
        if (caseMap != null && !caseMap.isEmpty() && supportIncidentMap != null && !supportIncidentMap.isEmpty())
        {
            if (isInsert && articleList != null && !articleList.isEmpty())
            {
                for (Known_Issue__kav ki : articleList)
                {
                    if (supportIncidentMap.containsKey(ki.Support_Incident__c) && caseMap.containsKey(supportIncidentMap.get(ki.Support_Incident__c).OriginCaseID__c))
                    {
                        if (caseUpdateMap.containsKey(supportIncidentMap.get(ki.Support_Incident__c).OriginCaseID__c))
                        {
                            caseObj = caseUpdateMap.get(supportIncidentMap.get(ki.Support_Incident__c).OriginCaseID__c);
                        }
                        else
                        {
                            caseObj = caseMap.get(supportIncidentMap.get(ki.Support_Incident__c).OriginCaseID__c);
                        }
                        caseObj.Article_Number__c = ki.ArticleNumber;
                        caseObj.Article_Id__c = ki.KnowledgeArticleId;
                        caseObj.Known_Issue_Article_Number__c = ki.ArticleNumber;
                        caseUpdateMap.put(caseObj.Id, caseObj);
                    }
                }
            }
            /*for(Id key:supportIncidentMap.keySet())
            {
               if(supportIncidentMap.get(key).Resolution__c != null && supportIncidentMap.get(key).Resolution__c != oldMap.get(key).Resolution__c)
               {
                      caseObj.Resolution_Reason_From_SI__c = supportIncidentMap.get(key).Resolution__c;
               }
            }*/

            for(case c: casemap.values())
            {
                if(c.LearnJIRA_SI__c != null && supportIncidentMap.get(c.LearnJIRA_SI__c)!= null)
                {
                    if(caseupdatemap.get(c.id) != null)
                    {
                        caseObj=caseUpdateMap.get(c.id);
                        if(supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c != null && supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c != oldMap.get(c.LearnJIRA_SI__c).Resolution__c)
                        {
                            caseObj.Resolution_Reason_From_SI__c = supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c;
                        }
                        caseupdateMap.put(caseObj.id, caseObj);
                    }
                    else
                    {
                        caseObj=c;
                        if(supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c != null && supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c != oldMap.get(c.LearnJIRA_SI__c).Resolution__c)
                        {
                            caseObj.Resolution_Reason_From_SI__c = supportIncidentMap.get(c.LearnJIRA_SI__c).Resolution__c;
                            caseupdateMap.put(caseObj.id, caseObj);
                        }
                    }

                }
            }
            
            // UPDATE LATER: Should change this to only update the case if the SI has changed to need it
            for (Case c: caseMap.values())
            {
                if (!caseUpdateMap.containsKey(c.Id))
                {                    
                    caseUpdateMap.put(c.Id, c);
                     
                }
                
            }

        }
        
        return caseUpdateMap.values();
    }
    
    // This method updates the Known Issue field on the SI
    private void updateKnownIssueField(list<learnJIRA__c> newList, map<Id, Known_Issue__kav> knownIssueMap)
    {
        map<Id, learnJIRA__c> newMap = new map<Id, learnJIRA__c>(newList);
        map<Id, learnJIRA__c> siUpdateMap = new map<Id, learnJIRA__c>();
        
        if (newMap != null && !newMap.isEmpty() && knownIssueMap != null && !knownIssueMap.isEmpty())
        {
            for (Known_Issue__kav ki : knownIssueMap.values())
            {
                if (newMap.containsKey(ki.Support_Incident__c))
                {
                    newMap.get(ki.Support_Incident__c).Known_Issue__c = ki.KnowledgeArticleId;
                    siUpdateMap.put(ki.Support_Incident__c, newMap.get(ki.Support_Incident__c));
                }
            }
            
            for (learnJIRA__c lj : newList)
            {
                if (siUpdateMap.containsKey(lj.Id))
                {
                    lj.Known_Issue__c = siUpdateMap.get(lj.Id).Known_Issue__c;
                }
                else
                {
                    lj.Known_Issue__c = null;
                }
            }
        }
    }
    
    // This method will update the Master Case field on the SI
    private void updateMasterCase(list<learnJIRA__c> newList, list<learnJIRA__c> oldList, map<Id, learnJIRA__c> siMap)
    {
        map<Id, learnJIRA__c> oldMap;
        Case currentMaster;
        learnJIRA__c currentSI;
        boolean flag;
        
        if (oldList == null)
        {
            for (learnJIRA__c lj : newList)
            {
                lj.Master_Case__c = lj.OriginCaseID__c;
            }
        }
        else
        {
            oldMap = new map<Id, learnJIRA__c>(oldList);
            for (learnJIRA__c lj : newList)
            {
                if (oldMap.containsKey(lj.Id) && lj.Master_Case__c == oldMap.get(lj.Id).Master_Case__c && siMap.containsKey(lj.Id))
                {
                    currentSI = siMap.get(lj.Id);
                    flag = false;
                    for (Case c : currentSI.Cases__r){
                        if(currentSI.Master_Case__c == c.id ){
                            flag = true;
                        }
                    }
                    if (flag == false || currentSI.Master_Case__r.IsClosed || currentSI.Cases__r == null || currentSI.Cases__r.isEmpty() || currentSI.Master_Case__c == null)
                    {
                        currentMaster = null;
                        lj.Master_Case__c = null;
                        if (currentSI.Cases__r != null && !currentSI.Cases__r.isEmpty())
                        {
                            for (Case c : currentSI.Cases__r)
                            {
                                system.debug(c.CaseNumber);
                                if (currentMaster == null)
                                {
                                    currentMaster = c;
                                    
                                }
                                else if (!currentMaster.isClosed && currentMaster.Id != lj.OriginCaseID__c)
                                {
                                    if (!c.isClosed && c.CreatedDate < currentMaster.CreatedDate)
                                    {
                                        currentMaster = c;
                                        
                                    }
                                     
                                }
                                else if (currentMaster.isClosed)
                                {
                                    if (!c.IsClosed)
                                    {
                                        currentMaster = c;
                                    }
                                    else if (currentMaster.Id != lj.OriginCaseID__c && c.CreatedDate < currentMaster.CreatedDate)
                                    {
                                        currentMaster = c;
                                    }
                                }
                                
                            }
                        }
                        if (currentMaster != null)
                        {
                            lj.Master_Case__c = currentMaster.Id;
                        }
                    }
                }
            }           
        }
    }
}