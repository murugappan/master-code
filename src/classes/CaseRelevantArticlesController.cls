public class CaseRelevantArticlesController {

    GlobalComponent gc = new GlobalComponent();
    public String SearchText;
    public Id ArticleId;
    public String CaseNumber;
    public String CoreLicense;
    public String CaseCategory;
    public String CaseFunctionalArea;
    public String CaseIssueTopic;
    public String coreLic;
    public transient list<KnowledgeArticleWrapper> kavWrapperList {get; private set;}
    private map<String, Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
  private map<String, String> articlePrefixLabelMap;
    public String InternalURL;
    public String ExternalURL;
    public String aNoteId;
    public set<Id> AttachmentID = new set<ID>();
   Case_Note__c aNote = new Case_Note__c();
   public String Notes {get; set;}
   public List<Case_Attachment__c> attachments = new List<Case_Attachment__c>();
    public Case aCase {get; set;}
      String ownername;
   public Decimal sla;
   
    public Id caseId {
                        get{
                            if(ApexPages.currentPage().getparameters().get('id') != null)
                                caseId = ApexPages.currentPage().getparameters().get('id');
                            return caseId;
                            }
                        set;}
    
    public String getCaseNumber() {
        return caseNumber;
    }
    public void setCaseNumber(String caseNumber) {
        this.caseNumber = caseNumber;
    }
    public String getCoreLicense() {
        return CoreLicense;
    }
    public void setCoreLicense(String CoreLicense) {
        this.CoreLicense = CoreLicense;
    }
    public String getCaseCategory() {
        return CaseCategory;
    }
    public void setCaseCategory(String CaseCategory) {
        this.CaseCategory = CaseCategory;
    }
    public String getCaseFunctionalArea() {
        return CaseFunctionalArea;
    }
    public void setCaseFunctionalArea(String CaseFunctionalArea) {
        this.CaseFunctionalArea = CaseFunctionalArea;
    }
    public String getCaseIssueTopic() {
        return CaseIssueTopic;
    }
    public void setCaseIssueTopic(String CaseIssueTopic) {
        this.CaseIssueTopic = CaseIssueTopic;
    }
    public Id getArticleId() {
        return ArticleId;
    }
    public void setArticleId(Id aId) {
        articleId = aId;
    }
    public String getSearchText() {
        return searchText;
    }
    public void setSearchText(String s) {
        searchText = s;
    }
    
    private void loadArticleTypes()
  {
    list<String> articleTypeNameList = new list<String>();
      articlePrefixLabelMap = new map<String, String>();
      
        for (String s : globalDescribeMap.keySet()) 
        {
          if (s.endswith('__kav')) 
            {
              articleTypeNameList.add(s);
              Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
              articlePrefixLabelMap.put(r.getKeyPrefix().subString(0, 3), r.getLabel());
            }
        }        
  }

    public CaseRelevantArticlesController() 
    {
      loadArticleTypes();
        if(caseId != null) 
        {
          list <solution> tempsolutionlist = new list<solution>();
          aCase = [SELECT Reason_for_Reopen__c,
                    Id,Invoke_Premium_Support__c,BusinessHoursID,Primary_Group_Name__c,IsClosedByRelevantArticle__c,IsClosed, AssetID, Asset.Managed_Hosting__c, ClosedDate ,Case_Record__c, CaseNumber, Account.Name, AccountId, Subject, Contact.Name, ContactId, Status, CreatedDate,
                    Description, Steps_to_Replicate__c, Customer_Portal_Status__c,OwnerId, Owner.Name, Case_Severity__c,
                    Asset.Database_Server_OS__c,Asset.Database__c,Asset.Application_Server_OS__c,Asset.JDK_Version__c,Asset.Software_URL__c,Asset.Version_Build__c,Asset.Version__c,Asset.External_Asset_Name__c,Asset.Nickname__c,Asset.Name, Core_License__r.Name,Module_Name__c,Functional_Area_Name__c,Category__r.Name, Version_on_Case__c, Source_Build_on_Case__c
                    From Case Where Id = :caseId];
                    
          ownername = aCase.owner.name;      
        if(aCase.Case_record__c != null && aCase.Case_record__c.contains('ANGEL') && aCase.Description != 'Description for Test Class')
        {
              sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
        }
         else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Learn'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
          }
         else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('CE'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
          }
         else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Xythos'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
          }
         else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Transact'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;                   
          }
           else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Moodlerooms'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Moodlerooms'].SLA__c;                   
          }
          else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Collaborate'))
          {
            sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;                   
          }
                  
          Case caseObj = [SELECT Id, Subject, Core_License__r.Name, Module__r.Name,Version_On_Case__c, Functional_Area__r.Name, Category__r.Name, CaseNumber FROM Case WHERE Id = : caseId];
          searchText = caseObj.Subject;
          CaseNumber = caseObj.CaseNumber;
          CoreLicense = caseObj.Core_License__r.Name;
          CaseIssueTopic = caseObj.Module__r.Name;
          CaseFunctionalArea = caseObj.Functional_Area__r.Name;
          CaseCategory = caseObj.Category__r.Name;
          if (coreLicense != null)
          {
            coreLicense = coreLicense.toLowerCase();
          }
          else
          {
            coreLicense = '';
          }
          if (coreLicense.contains('learn'))
          {
            coreLicense = 'Learn';
          }
          else if (coreLicense.contains('angel'))
          {
            coreLicense = 'Angel';
          }
          else if (coreLicense.contains('vista'))
          {
            coreLicense = 'CE_Vista';
          }
          else if (coreLicense.contains('xythos'))
          {
            coreLicense = 'Xythos';
          }
          else if (coreLicense.contains('transact'))
          {
            coreLicense = 'Transact';
          }
          
          String categoryFilter = 'Product__c ABOVE_OR_BELOW ' + coreLicense + '__c';
          system.debug(categoryFilter);
          
          if(CoreLicense != null) 
          {
            if(CoreLicense.contains('Learn'))
            {
                coreLic = 'Blackboard Learn';
            }
            else
            {
                coreLic = CoreLicense;
            }
          }
           
          searchtext = String.escapeSingleQuotes(searchtext);
         list<KnowledgeArticleWrapper> testWrapper = new list<KnowledgeArticleWrapper>();
      String searchquery = 'FIND \'' + searchtext + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName, KnowledgeArticleId, LastPublishedDate, LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY '+categoryFilter ;
       list<list<SObject>>searchList;
       try
       {
         searchList = search.query(searchquery);
       }
       catch (Exception e)
       {
         searchList = new list<list<SObject>>();
       }
       kavWrapperList = new list<KnowledgeArticleWrapper>();
       KnowledgeArticleWrapper mainArticle;
       
       for (KnowledgeArticleVersion k : (list<KnowledgeArticleVersion>)searchList[0])
       {
         mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, '1', k.KnowledgeArticleId);
         String prefix = k.Id;
         prefix = prefix.substring(0, 3);
        mainArticle.articleType = articlePrefixLabelMap.get(prefix);
        mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
        if (kavWrapperList.size() <= 300)
        {
          kavWrapperList.add(mainArticle);
        }
       }
        
       String version_of_case = caseObj.Version_On_Case__c;
       if(kavWrapperList.size() > 0 && version_of_case != null)
       {/*
         list<KnowledgeArticleVersion> top_list = new list<KnowledgeArticleVersion>();
         list<KnowledgeArticleVersion> bottom_list= new list<KnowledgeArticleVersion>();
         for(KnowledgeArticleVersion sn : tempArticleVersionList )
         {
          String Major_Release = sn.Major_Release__c;
           if(Major_release != null &&(Major_Release.tolowercase().contains(version_of_case.tolowercase())))
           {
             top_list.add(sn);
           }
           else
           {
             bottom_list.add(sn);  
           }
        }
        if(top_list.size()>0)
        {
          results.addAll(top_list);
        }
        if(bottom_list.size()>0)
        {
          results.addAll(bottom_list);
        }*/
        //relatedArticleVersionList.addAll(tempArticleVersionList);
       }        
    }
     
        for(List<Case_Attachment__c> cas : [select Id from Case_Attachment__c where Related_To__c =: caseID])
        {
          for(Case_Attachment__c cas1 : cas)
          {
              AttachmentID.add(cas1.ID);
          }
      }         
    }

     public PageReference redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
            return null;
        }
    }
    
 ///deleteatt   
    
    
    
  //-------The attach notes section --------  
  public PageReference addNote() {
             Pattern nonWordChar = Pattern.compile('\\n');
            /* -- Create a List to Store the Attachments That Were Uploaded by the User -- */
            for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c, Case_Note__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('id')]){
                        for(Case_Attachment__c  attlist1 : attlist){
                                if(InternalURL != null){
                                    InternalURL = InternalURL + '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    InternalURL = '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }
                                if(ExternalURL != null){
                                    ExternalURL = ExternalURL + '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    ExternalURL = '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }
                         attlist1.Case_Note__c = aNoteId;
                         update attlist1;
                        }
                    }
           
           /* -- Insert New Case_Note__c -- */ 
           if(Notes != null) {
               if(Attachments != null && Attachments.size() > 0){
                   aNote.Has_Attachment__c = true;
                   aNote.Details__c = nonWordChar.matcher(Notes).replaceAll('<br>') + '<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+InternalURL+'</div>';
                   }
                   else {
                   aNote.Has_Attachment__c = false;
                   aNote.Details__c = nonWordChar.matcher(Notes).replaceAll('<br>');
                   }
                   aNote.Public__c = true;
                   aNote.From_Type__c = 'Customer';
                   aNote.Incoming_Outgoing__c = 'Incoming';
                   aNote.Case__c = Apexpages.currentPage().getParameters().get('id');
                   anote.Type__c = 'BTBB Comment';
                   
                   insert aNote;
               }
               
                   aNoteId = aNote.Id;
                   System.Debug('aNoteId >>>>>>>>>> AFTER NOTE INSERT >>>>> >>>>  '+aNoteId);
           
           /* -- Insert Attachment Records (Amazon Integration) -- */
                    List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
                        if(aNote != null && aNote.ID != null){
                           for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('id')]){
                                for(Case_Attachment__c attlist1 : attlist){
                                   Case_Attachment__c ca = new Case_Attachment__c(ID = attlist1.ID);
                                   ca.Case_Note__c = aNoteID;
                                   System.Debug('>>>> !!!! >>>> !!!! >>>> AFTER UPDATE OF ATTACHMENT LIST >>>> !!!! NOTEID ====== ====== '+aNoteId);
                                   caslist.add(ca);  
                                }
                            } 
                            Update caslist;
                        }           

           /* -- Update Case Status -- */
           Case c1 = new Case(ID = aCase.ID);
           if(aCase.Status != 'New'){
                c1.Status = 'Needs Attention';
              //  c1.Portal_Status__c = 'Work In Progress';
           }
           c1.Last_Activity_Date_Time__c = System.now();
           c1.AssignTo_Comment__c = Notes;
           update c1;
           
           /* -- Create a New Response Event -- */
            BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
            Responsiveness__c res = new Responsiveness__c();
            res.Case__c = aCase.ID;
            res.Start_Time__c = System.now();
            res.Start_Event__c = 'Client Note';
            res.Event_Type__c= 'Follow Up';
            if(String.valueof(aCase.OwnerId).substring(0,3) == '005'){
               User u1 = [select Name,Primary_Group__c from User where ID =: aCase.OwnerId]; 
               res.Event_Owner__c = u1.Name;
               res.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
            }else{
               res.Event_Owner__c = aCase.Primary_Group_Name__c;
               res.Event_Owner_Primary_Group__c = aCase.Primary_Group_Name__c;
            }
            if(sla != null){
               if(aCase.Case_Severity__c == '1' || aCase.Case_Severity__c == '2'){    
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
               }else{
                    String day = System.now().format('EEE');
                    if(day == 'Fri')
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 48) * 60 * 60 * 1000L);
                    else if(day == 'Sat')
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 24) * 60 * 60 * 1000L);
                    else
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                }
            }
            Insert res;
            
          
           /* -- Refresh Page -- */
           PageReference Refresh = new PageReference('/apex/btbb_caseConfirmation?id='+Apexpages.currentPage().getParameters().get('id'));
               Refresh.SetRedirect(true);
               return Refresh;
      }
      
public void deleteatt1(){
      String attid = ApexPages.CurrentPage().getParameters().get('attachid');
      if(attid != null){
          Case_Attachment__c cs = new Case_Attachment__c(ID = attid);
          delete cs;
      }
  }   
  
public List<Case_Attachment__c> getCaseNoteAttachments(){
         System.Debug('>>> AttachmentID >>> getCaseNoteAttachments >>>'+AttachmentId);
         List<Case_Attachment__c> attlist = new List<Case_Attachment__c>();
         attlist = [select Id,Name,Bucket_Name__c,File_Name__c from Case_Attachment__c where ID NOT IN: AttachmentID and Related_To__c = :ApexPages.currentPage().getParameters().get('id') ];     
         Attachments  = attlist;
         return attlist;
    }      
}