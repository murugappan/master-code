public without sharing class caseViewController {

  GlobalComponent gc = new GlobalComponent();
  public List<Case> Cases                           {get; set;}
  public String Notes                               {get; set;}
  public boolean moodleroom{get;set;}
  public boolean analytics{get;set;}
  public boolean islearnsaas{get;set;}
  public boolean isxplor{get;set;}
  public boolean readonly{get;set;}
  public transient List<CaseHistoryItem> CHIlist              {get; set;}
  public Case aCase                                 {get; set;}
  public String caseID                              {get; set;}
  public List<Task> tasks                           {get; set;}
  public transient List<Case_Note__c> CaseNotes               {get; set;}
  public List<CaseSolution> Articles                {get; set;}
  public List<Solution_Detail__c> Solutions         {get; set;}
  public List<Task> CaseTasks                       {get; set;}
  public List<Case_Attachment__c> CaseAttachments   {get;set;}
  public List<EmailMessage> Emails                      {get; set;}
  public Set<String> prefixSet          {get; set;}
  public boolean showAll                {get; set;}
  public Blob AttachmentBody            {get; set;}
  public String AttachmentName          {get; set;}
  public String AttachmentURL;
  public String InternalURL;
  public String ExternalURL;
  public String InstanceURL             {get; set;}
  public String SiteURL                 {get; set;}
  public String aNoteId;
  public Case_Note__c aNote {get; set;}
  List <User> userList;
  public Set<Id> AttachmentID = new Set<ID>();
  public List<Case_Attachment__c> attachments = new List<Case_Attachment__c>();
  public String closecomments{get;set;}
  public String reopencomments {get;set;}
  public String acceptedcomments {get;set;}
  public String declinedcomments {get;set;}
  public String build { get; set; }
  public String version { get; set; }
  public String nickName { get; set; }    
  public String URL1 { get; set; }
  public String applicationServerOS {get;set;}
  public String database {get;set;}
  public String databaseServerOS {get;set;}
  public String jdkVersion {get;set;}
  public Boolean isManagedHosting {get;set;}
  public Boolean showeditassetlink {get;set;}
  public string local{get;set;}
  String ownername;
  public Decimal sla;
  public boolean endusercase {get;set;}
  public boolean isCLB {get;set;}
  public boolean collabadmincase {get;set;}
  public boolean collabendusercase{get;set;}
  public String ccRecipients {get;set;}
  public String ccRecipients2 {get;set;}
  public boolean ccerrorShow{get;set;}
  public String  ccerrorMessage{get;set;}
  public boolean ccerrorShow2{get;set;}
  public string externalmailbody{get;set;}
  public string cstatus{get;set;}
  public string nextaction{get;set;}
  public string productname{get;set;}
  
  public List<Case_Attachment__c> getCaseNoteAttachments(){
         System.Debug('>>> AttachmentID >>> getCaseNoteAttachments >>>'+AttachmentId);
         List<Case_Attachment__c> attlist = new List<Case_Attachment__c>();
         attlist = [select Id,Name,Bucket_Name__c,File_Name__c from Case_Attachment__c where ID NOT IN: AttachmentID and Related_To__c = :ApexPages.currentPage().getParameters().get('id') and UserID__c =:Userinfo.getUserId() ];     
         Attachments  = attlist;
         return attlist;
    } 
  
  public caseViewController(){
    aNote = new Case_Note__c();
    caseId = Apexpages.currentPage().getParameters().get('id'); 
    
    aCase = [SELECT Reason_for_Reopen__c,
                    Id,Invoke_Premium_Support__c,RecordType.Name,BusinessHoursID, End_User__c, End_User__r.Name, End_User_Product__c, Primary_Group_Name__c,URL_Access__c, User_Role__c ,Client_OS__c,Client_OS_Version__c,Browser__c, CMS_LMS__c , Java_Version__c, Browser_Version__c, CMS_LMS_URL__c ,MR_Case_Type__c,IsClosedByRelevantArticle__c,IsClosed, AssetID, Asset.Managed_Hosting__c, ClosedDate ,Case_Record__c, CaseNumber, Account.Name,Account.language__c, AccountId, Subject, Contact.Name, ContactId, Status, CreatedDate,
                    Description, Steps_to_Replicate__c, Customer_Portal_Status__c,OwnerId, Owner.Name, Case_Severity__c,Fix_Version__c,
                    Asset.Database_Server_OS__c,Asset.Database__c,Asset.Application_Server_OS__c,Asset.JDK_Version__c,Asset.Status,Asset.Software_URL__c,Asset.Version_Build__c,Asset.Version__c,Asset.External_Asset_Name__c,Asset.Product2.Name,Asset.Nickname__c,Asset.Name, Core_License__r.Name,Module_Name__c,Functional_Area_Name__c,Category__r.Name, Version_on_Case__c, Source_Build_on_Case__c,Send_email_client_case_team__c,
                    ccEmail1__c,ccEmail2__c,ccEmail3__c,ccEmail4__c,ccEmail5__c,Core_License__r.Product__c,Fixed_In_Build__c,Site_URL__c,Course_ID__c
                    From Case Where Id = :caseId];
    productname=acase.Asset.Product2.Name;
    system.debug('Product name-->'+productname);
    cstatus = acase.status;
    nextaction = ServiceCloudUtility.getPortalNextAction(cstatus);

     if(aCase.RecordType.Name == 'Collaborate End User Open' || aCase.RecordType.Name.Contains('Collaborate')){
         endusercase = true;
         
     }
     local = aCase.RecordType.Name; 
     system.debug('Murugappan'+local);              
     if(aCase.RecordType.Name.Contains('Moodlerooms'))
     {
     moodleroom = true;
     }
     if(aCase.RecordType.Name.Contains('Analytics'))
     {
     analytics = true;
     
     if((aCase.Asset.Managed_Hosting__c == 'Learn - Managed Hosting' || aCase.Asset.Managed_Hosting__c == 'Analytics – Managed Hosting') == true)
        isManagedHosting = false;
        else
        isManagedHosting = true;
     }
     if(aCase.Asset.Managed_Hosting__c == 'Learn - SaaS'){

      showeditassetlink = true;
     }
     if(aCase.RecordType.Name.Contains('xpLor'))
     {
       isxplor = true;
     }
     
     if(aCase.Asset.Status !='Installed'){
     showeditassetlink = true;
     }
     
     if(acase.Core_License__r.Product__c == 'Learn SAAS'){
      islearnsaas = true;  
     }
     
     if(aCase.Case_Record__c == 'Collaborate'){
     isCLB = true;
     }
     
     if(aCase.RecordType.Name == 'Collaborate End User Open'|| aCase.RecordType.Name == 'Collaborate End User Closed' ){
         collabendusercase = true;
     }
   
   userList = new List<User>([select ID,ContactID from User where ID =: Userinfo.getUserID()]); 
   set<string>BusinnesUnitAccess= new set<string>();
    
     if(userList != null && userList.size() > 0){       
     for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c,c.BusinessUnit__c,c.accesscode__c From Contact_Role__c c where Contact__c =: userList[0].ContactID AND Expire_Role__c = false and role__c != null and BusinessUnit__c!=null and AccessCode__c = '7']){
  
                for(contact_role__c c : cr)
                    {
                  for(string s: c.BusinessUnit__c.split(','))
                       {
                      BusinnesUnitAccess.add(s);
                       }
                   }
             if(BusinnesUnitAccess.contains(aCase.Core_License__r.name))      
             {
               readonly = false;
             }
          else
          {
            readonly = true;
          }   
        
       
      
  
 }
     }
    //Populate ccemail's
      if(aCase.ccemail1__c != null||aCase.ccemail2__c != null||aCase.ccemail3__c != null||aCase.ccemail4__c != null||aCase.ccemail5__c != null)
            {
                string tempmail= (aCase.ccemail1__c!=null?aCase.ccEmail1__c:'')+';'+(aCase.ccemail2__c!=null?aCase.ccEmail2__c:'') +';'+(aCase.ccemail3__c!=null?aCase.ccEmail3__c:'')+';'+(aCase.ccemail4__c!=null?aCase.ccEmail4__c:'')+';'+(aCase.ccemail5__c!=null?aCase.ccEmail5__c:'');
                tempmail = tempmail.replaceall('[_;]{2,}',';') ;
                ccRecipients=ccRecipients2=tempmail;
            }


      ownername = aCase.owner.name;    
      aCase.Reason_for_Reopen__c = null;         
     if(aCase.Case_record__c != null && aCase.Case_record__c.contains('ANGEL') && aCase.Description != 'Description for Test Class')
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Learn'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('CE'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Xythos'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Transact'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Moodlerooms'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Moodlerooms'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Analytics'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Analytics'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('Collaborate'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;
     else if(aCase.Case_record__c != null && aCase.Case_record__c.contains('xpLor'))
          sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: aCase.Case_Severity__c AND Core_License__c = 'xpLor'].SLA__c;     
                                                               
    if((aCase.Asset.Managed_Hosting__c == 'Learn - Managed Hosting' || aCase.Asset.Managed_Hosting__c == 'ANGEL - Managed Hosting') == true)
        isManagedHosting = true;
    else
        isManagedHosting = false;

      

    InstanceURL = URL.getSalesforceBaseUrl().toExternalForm();
    SiteURL = Site.getCurrentSiteUrl();
    CHIlist= new List<CaseHistoryItem>();
    caseId = Apexpages.currentPage().getParameters().get('id'); 
    CHIlist= new List<CaseHistoryItem>();
    Cases = [Select Id, CaseNumber From Case Where Id =:caseId Limit 1];
    CaseNotes = [Select Id, Article_Id__c, Article_Number__c, Article_Title__c, CreatedById, CreatedBy.Name, CreatedDate, Details__c, Type__c, Has_Attachment__c, Article__c, Article__r.SolutionName, Article__r.SolutionNumber, Is_Email__c, Public__c, From_Type__c, Incoming_Outgoing__c,Processed_By_Email_Service__c  From Case_Note__c Where Case__c = :caseId AND Public__c = True AND Processed_By_Email_Service__c = false  ];
    Emails = [Select Id,(select attachment.id,attachment.name from EmailMessage.attachments),  CreatedById, CreatedBy.Name, CreatedDate, TextBody, HTMLBody, Subject, FromName, ToAddress, MessageDate, hasAttachment, Incoming, Status, FromAddress From EmailMessage Where ParentId = :caseId];// AND Incoming = True];
    system.debug(emails);
    CaseAttachments = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, File_Name__c, Content_Type__c, Notes__c, Preview_Link__c, Internal_Only_Attachment__c, Case_Note__c, File_Name_w_ext__c FROM Case_Attachment__c Where Related_to__c = :caseId AND Case_Note__c = null AND Internal_Only_Attachment__c = False ];
    Solutions = [Select Id, Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, Description__c, Comments__c, Subject__c, Status__c, Article__c, Article__r.SolutionNumber, Article__r.SolutionName, Article_Id__c, Article_Number__c, Article_Title__c From Solution_Detail__c Where Case__c = :caseId];
    Articles = [Select SolutionId, CreatedById, CreatedBy.Name, CreatedDate, CaseId, Solution.SolutionNumber, Solution.SolutionName, Solution.Summary__c From CaseSolution Where CaseId = :caseId And Solution.Status = 'Published' And Solution.Visible_in_Customer_Portal__c = true];
    prefixSet=new Set<String>();
    Map<String, Schema.SObjectType> gD = Schema.getGlobalDescribe();
    Set<String>keys=gD.keySet();
    
    
    nickName = aCase.Asset.Nickname__c;
    version = aCase.Asset.Version__c;
    build = aCase.Asset.Version_Build__c;
    URL1 = aCase.Asset.Software_URL__c;
    jdkVersion = aCase.Asset.JDK_Version__c; 
    applicationServerOS = aCase.Asset.Application_Server_OS__c;
    database = aCase.Asset.Database__c; 
    databaseServerOS = aCase.Asset.Database_Server_OS__c;
        
    for(String key:keys){
        Schema.DescribeSObjectResult r = gD.get(key).getDescribe();
        if(r!=null &&r.getKeyPrefix()!=null && r.getKeyPrefix()!='')
        prefixSet.add(r.getKeyPrefix());
    }  

        String Subject;
        String Summary;
        String Details;
        String oldVal;
        String newVal;
        String Subject_email;
        String Subject_comment;
        String Subject_phonecall;
        String to;

/* * * * * * * * * * * * * EMAILMESSAGES * * * * * * * * * * * * */       
        
        for(EmailMessage em : Emails) 
        {
            if(em.Incoming == true && em.FromName != 'Bb Support')
            {
                list<String> emailSubject = new list<String>();
                if(em.subject!=null)
                {
                    emailSubject=String.valueOf(em.Subject).split('>');
                }
                else
                {
                    emailSubject.add('');
                }
                Subject = emailSubject[0] + ' from ' + em.FromName;
                if(em.attachments.size()>0)
                {
                    subject = subject + '<br/> Attachment(s):';
                    for(attachment at : em.attachments)
                    {
                        subject = subject + ' ' + at.name;
                    }
                }
                
                Summary = em.TextBody;
                if(em.Htmlbody != null && em.Htmlbody !='' && !em.Htmlbody.contains('[Message Clipped]'))
                {
                    Details = em.HtmlBody;
                }
                else if(em.textbody != null && em.textbody !='')
                {
                    system.debug('Email--'+em.id+em.textbody);
                       string temp=(em.TextBody).escapeHtml4().replaceAll('[\\n]|[\\r]','<br/>');
                    if(temp.length()>31950)
                    {
                Details=temp.substring(0,31950)+'<br/><br/>[Message clipped]';
                    }
                    else
                    {
                Details=temp;
                }
                }
               
                if(em.Incoming != false && em.FromName != 'Bb Support')
                {
                    CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.FromName, em.CreatedById,  em.Id, 'Email', em.HasAttachment, false, 'Public', null));
                }
            }
            system.debug(em.Incoming);
            system.debug(em.Subject);
            if (em.Incoming == false && em.Subject.contains('Case Number'))
            {
                system.debug('Here');
                list<String> emailSubject2 = String.valueOf(em.Subject).split('\\[');
                Subject = emailSubject2[0];
                Summary = em.textbody;
                Details = em.textbody;
                if(Details != null)
                {
                    Details = Details.replaceAll('[\\n]|[\\r]','<br/>');
                }
                CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.FromName, em.CreatedById,  em.Id, 'Email', em.HasAttachment, false, 'Public', null));
            }
            system.debug(CHIlist);
        }
        
/* * * * * * * * * * * * * CASE_NOTE__C * * * * * * * * * * * * */
        
        for(Case_Note__c em : CaseNotes){
        
        String Category = ' ';
        
        Boolean isIncoming = false;
        
        if(em.is_Email__c == true)
            Category = 'Email';
        else if(em.Type__c.contains('call') || em.Type__c.contains('Call'))
            Category = 'Phone Call';
        else
            Category = em.Type__c;
        if(em.From_Type__c == 'Customer' || em.Incoming_Outgoing__c == 'Incoming' || em.Type__c == 'BTBB Comment')
            isIncoming = false;
        else
            isIncoming = true;
            
            if(em.Article_Id__c != null)
              {
                Details = '<b>Article Attached:</b><br/><a href="/btbb_articleView?id='+em.Article_Id__c+'">'+em.Article_Number__c+' '+em.Article_Title__c+'</a><br/><br/>'+em.Details__c; 
              } 
              else
              {
                
                if (em.Type__c == 'Closed by Support')
                {
                  Details = em.Type__c;
                }  
                else
                Details = em.Details__c;
                
                if(Details!= null)
                {
                  Details = Details.replaceAll( '[\\r]|[\\n]' , '<br/>' );
                  Details = Details.replaceAll( '</p><br/><p><br/>' , '<br/><br/>' ); 
                //  Details = Details.replaceAll( '<!--' , '&lt;!--');
                //  Details = Details.replaceAll( '-->' , '--&gt;');
                  if(em.Type__c == 'BTBB Comment')                 
                      Details = Details.replaceAll( '<br><br>' , '<br/>' );
                }
              }

            Subject = Category;
            if (em.Type__c == 'Closed by Support')
            Summary = '';
            else
            summary =em.Details__c;
            
            if(em.Type__c != 'Suggest Solution')
            CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.CreatedBy.Name, em.CreatedById,  em.Id, Category, em.Has_Attachment__c, isIncoming, 'Public', null));
        }

/* * * * * * * * * * * * * CASESOLUTIONS * * * * * * * * * * * * */
        
       /* for(CaseSolution cs: Articles){
            Details = cs.Solution.Summary__c;
            Subject = '<b>Article Attached to Case</b> <a href="/apex/btbb_articleview?id='+cs.SolutionId+'&cid='+cs.CaseId+'" style="color:blue;">Article #'+cs.Solution.SolutionNumber+' - '+cs.Solution.SolutionName+'</a>';
            Summary = ' ';
            CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Article', false, false, 'Public', null));
        }*/

/* * * * * * * * * * * * * CASE ATTACHMENTS * * * * * * * * * * * * */

        for(Case_Attachment__c cs: Attachments){
            Details = cs.Notes__c;
            Subject = '<b>Attachment</b>';
            Summary=  '<a href="/apex/LinkRedirect?id='+cs.Id+'">'+cs.File_Name_w_Ext__c+'</a>';
            CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Attachment', false, true, 'Public', null));
        }


/* * * * * * * * * * * * * SOLUTION DETAILS * * * * * * * * * * * * */

        for(Solution_Detail__c sd : Solutions){
            system.debug(sd.Article_Id__c);
            if(sd.status__c.contains('Consideration'))
            Subject = '<span style="font-weight:bold;text-transform:uppercase;color:#00838a;">You Have a Solution Suggested that Needs Your Attention!</span>';
            else
            Subject= '<b>Solution Suggested</b> - <i>Status: '+sd.Status__c+'</i>';
            if(sd.Article_Id__c != null && sd.Comments__c != null)
            {
              Details = '<div><b>Article:</b> <a href="/btbb_articleview?id='+sd.Article_Id__c+'">Article #'+sd.Article_Number__c+' '+sd.Article_Title__c+'</a><div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b> '+'<br>' +sd.Description__c+'</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/> '+sd.Comments__c+'</div>';
             
            }
            else if(sd.Article_Id__c != null && sd.Comments__c == null)
            {
                Details = '<div><b>Article:</b> <a href="/btbb_articleview?id='+sd.Article_Id__c+'">Article #'+sd.Article_Number__c+' '+sd.Article_Title__c+'</a><div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b> '+'<br>' +sd.Description__c+'</div>';
            }
            else if(sd.Article_Id__c == null && sd.Comments__c != null)
            {
                Details = '<div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments: </b><br/>'+sd.Description__c+'</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/>'+'<br>' +sd.Comments__c+'</div>';
            }
            else
            {
                Details = '<div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b>'+'<br/>' +sd.Description__c+'</div>';
                 
            
            }
            //Summary=  sd.Description__c; // TP 4233
            Summary=  '';
            if(Subject != Null)
                CHIlist.add(new CaseHistoryItem(sd.CreatedDate, Subject, Details, Summary, sd.CreatedBy.Name, sd.CreatedById, sd.Id,'Solution', false, false, 'Public', sd.Status__c));
          }
        for(List<Case_Attachment__c> cas : [select Id from Case_Attachment__c where Related_To__c =: caseID]){
        for(Case_Attachment__c cas1 : cas){
            AttachmentID.add(cas1.ID);
        }
    }
  
  
  }/* END OF CONSTRUCTOR*/
  
  public void deleteatt1(){
      String attid = ApexPages.CurrentPage().getParameters().get('attachid');
      if(attid != null){
          Case_Attachment__c cs = new Case_Attachment__c(ID = attid);
          delete cs;
      }
  }
  
  public Pagereference closecase(){

        Case c1 = new Case(Id = aCase.ID);    
        c1.Reason = 'Closed by Client';
        c1.Closed_Comments__c = closecomments;
      //  c1.Portal_Status__c = 'Closed';
        c1.Status = 'Closed';
        c1.Last_Activity_Date_Time__c = System.now();
        update c1;
        
        List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
        for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c =: caseID AND Status__c = 'In Consideration']){
             Solution_Detail__c sd2 = new Solution_Detail__c(ID = sd1.id);
             sd2.Status__c = 'Not Considered';
             sdlist.add(sd2);
        } 
        Update sdlist;
        Case_Note__c note = new Case_Note__c();
        note.Case__c = aCase.Id;
        note.Details__c = closecomments;
        note.Type__c = 'Case Closed';
        note.Public__c = true;
        note.From_Type__c = 'Customer';
        note.Is_Email__c = false;
        insert note;
        
        if(aCase.Core_License__c != null){
            if(aCase.Core_License__r.Name != 'Transact' ){
                if(aCase.Account.language__c != null && aCase.Account.language__c.containsignorecase('spanish'))
                {
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000dhPT&cId='+aCase.ContactID+'&caId='+caseID);
               // Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2Cn00000009CCJ&cId='+aCase.ContactID+'&caId='+caseID);
                p.setredirect(true);
                return p;   
                }
                else
                {
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000ICvKEAW&cId='+aCase.ContactID+'&caId='+caseID);
               // Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2Cn00000009CCHEA2&cId='+aCase.ContactID+'&caId='+caseID);
                p.setredirect(true);
                return p;
                }
            }else if(aCase.Core_License__r.Name == 'Transact'){
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000ICvPEAW&cId='+aCase.ContactID+'&caId='+caseId);
               // Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2Cn00000009CCIEA2&cId='+aCase.ContactID+'&caId='+caseId);
                p.setredirect(true);
                return p;
            }
            else {
            Pagereference  p = new Pagereference('/apex/btbb_home');
                p.setredirect(true);
                return p;
            }
       }
       return null;
   }
   
    public Pagereference reopen(){

        Case c1 = new Case(ID = aCase.ID);
        c1.Status = 'Reopened';
      //  c1.Portal_Status__c = 'Work In Progress';
        c1.IsClosedByRelevantArticle__c = false;
        c1.Reopen_comment__c = reopencomments;
        c1.Case_Reopened__c = true;
        c1.Reopened_Time__c = System.now();
        c1.Last_Activity_Date_Time__c = System.now();
        c1.Reason_for_Reopen__c=aCase.Reason_for_Reopen__c;
        Update c1;
        
        List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
        for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c =: caseID AND Status__c = 'In Consideration']){
             Solution_Detail__c sd2 = new Solution_Detail__c(ID = sd1.id);
             sd2.Status__c = 'Not Considered';
             sdlist.add(sd2);
        } 
        Update sdlist;
        
        Case_Note__c cn = new Case_Note__c();
        cn.Details__c = 'Reason: '+c1.Reason_for_Reopen__c +'<br/><br/>'+reopencomments;
        cn.Type__c = 'Case Reopened';
        cn.Public__c = true;
        cn.From_Type__c = 'Customer';
        cn.Case__c = aCase.Id;
        cn.Is_Email__c = false;
        Insert cn;

        Pagereference p = new Pagereference('/apex/btbb_caseview?id='+caseId);
        p.setredirect(true);
        return p; 
    }
    
     public Pagereference solutionaccepted(){
        
        Case c1 = new Case(Id = aCase.ID);
        c1.Status = 'Closed';
        c1.Closed_Comments__c = acceptedcomments; 
      //  c1.Portal_Status__c = 'Closed';
        c1.Last_Activity_Date_Time__c = System.now();
        Update c1;
       
        Solution_Detail__c sd1 = [select Id,Name from Solution_Detail__c where Case__c =: caseID AND Status__c = 'In Consideration' ORDER BY CreatedDate DESC limit 1 ]; 
        Solution_Detail__c sd = new Solution_Detail__c(ID = sd1.id);
        sd.Status__c = 'Successful Resolution';
        sd.Comments__c = acceptedcomments;
        sd.Subject__c = 'Solution Accepted by Customer';
        sd.User__c = Userinfo.getUserID();
        Update sd; 
    
         
        if(aCase.Case_Record__c != null){
            
            if((aCase.Case_Record__c.contains('ANGEL') || aCase.Case_Record__c.contains('CE') || aCase.Case_Record__c.contains('Collaborate') || aCase.Case_Record__c.contains('Learn') || aCase.Case_Record__c.contains('Xythos')|| aCase.Case_Record__c.contains('Moodlerooms') || aCase.Case_Record__c.contains('Analytics') || acase.Case_Record__c.contains('xpLor')) && (aCase.Account.language__c != null && aCase.Account.language__c.containsignorecase('spanish')))
                {
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000dhPT&cId='+aCase.ContactID+'&caId='+caseID);
                p.setredirect(true);
                return p;   
                }
            
            
            else if((aCase.Case_Record__c.contains('ANGEL') || aCase.Case_Record__c.contains('Collaborate') || aCase.Case_Record__c.contains('CE') || aCase.Case_Record__c.contains('Learn') || aCase.Case_Record__c.contains('Xythos')|| aCase.Case_Record__c.contains('Moodlerooms') || aCase.Case_Record__c.contains('Analytics')) && (aCase.Account.language__c != 'Spanish' )){
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000ICvKEAW&cId='+aCase.ContactID+'&caId='+caseID);
                p.setredirect(true);
                return p;
             }
             
             
             
             else if(aCase.Case_Record__c.contains('Transact')){
                Pagereference  p = new Pagereference('/apex/TakeSurvey?id=a2C70000000ICvPEAW&cId='+aCase.ContactID+'&caId='+caseID);
                p.setredirect(true);
                return p;
            }
       }
       return null;
   }
   
   public PageReference relevantArticles(){
        PageReference PR  = new Pagereference('/apex/btbb_caserelevantarticles?id='+caseID);
        PR.setredirect(true);
        return PR;

   }
   
   public Pagereference solutiondeclined(){
       
        Case c1 = new Case(ID = aCase.ID);
        c1.Status = 'Reopened';
     //   c1.Portal_Status__c = 'Work In Progress';
        c1.Last_Activity_Date_Time__c = System.now();
        c1.Case_Reopened__c = true;// Added for TP 1231
        c1.Reopen_comment__c=declinedcomments;
        c1.AssignTo_Comment__c = declinedcomments;
        if(acase.Send_email_client_case_team__c!=null)
        {
        c1.Send_email_client_case_team__c=acase.Send_email_client_case_team__c+1;
        }
        else
        {
        c1.Send_email_client_case_team__c=1;
        }
        Update c1;
        
        // Added by Murugappan for TP 4450
        
        Case_Note__c cnn = new Case_Note__c(); 
        //cnn.Details__c = 'Case Reopened at: ' + system.now()+'<br/>'+'Declined Comments:'+'<br/>'+declinedcomments;
        cnn.Details__c = 'Declined Comments:'+'<br/>'+declinedcomments;
        cnn.Type__c = 'Case Reopened';
        cnn.Public__c = true;
        cnn.From_Type__c = 'Customer';
        cnn.Case__c = aCase.Id;
        cnn.Is_Email__c = false;
        Insert cnn;
        
        Non_Time_based_Alerts NTB= new Non_Time_based_Alerts ();
        acase.AssignTo_Comment__c=declinedcomments;
        acase.status=c1.status;
        string body=NTB.getBody('clientcomment',acase);
        string subject='Case#'+acase.casenumber+'  has been updated by the client';
        emailviaworkflow.mailStaffCaseTeam(acase,body,subject );
        
        Solution_Detail__c sd1 = [select Id,Name from Solution_Detail__c where Case__c =: caseID AND Status__c = 'In Consideration' limit 1]; 
        Solution_Detail__c sd = new Solution_Detail__c(ID = sd1.id);
        sd.Status__c = 'Failed Resolution';
        sd.Comments__c = declinedcomments;
        sd.Subject__c = 'Solution Declined by Customer';
        sd.User__c = Userinfo.getUserID();
        Update sd;  
        
        Responsiveness__c res_sol_dec1 = new Responsiveness__c();
         res_sol_dec1.Case__c = aCase.ID;
         res_sol_dec1.Start_Time__c = System.now();
         res_sol_dec1.Start_Event__c = 'Solution Declined';
         res_sol_dec1.Event_Type__c= 'Follow Up';
         if(String.valueof(aCase.OwnerId).substring(0,3) == '005'){
            User u1 = [select Name,Primary_Group__c from User where ID =: aCase.OwnerId]; 
            res_sol_dec1.Event_Owner__c = u1.Name;
            res_sol_dec1.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
         }else{
             res_sol_dec1.Event_Owner__c = aCase.Primary_Group_Name__c;
             res_sol_dec1.Event_Owner_Primary_Group__c = aCase.Primary_Group_Name__c;
         }
         BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
         if(sla != null){
               if(aCase.Case_Severity__c == '1' || aCase.Case_Severity__c == '2'){    
                       res_sol_dec1.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
               }else{
                    String day = System.now().format('EEE');
                    if(day == 'Fri')
                       res_sol_dec1.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 48) * 60 * 60 * 1000L);
                    else if(day == 'Sat')
                       res_sol_dec1.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), (Integer.valueof(sla) + 24) * 60 * 60 * 1000L);
                    else
                       res_sol_dec1.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID, System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
                }
            }   
         Insert res_sol_dec1;
        Pagereference  p = new Pagereference('/apex/btbb_caseview?id='+caseID); 
        p.setredirect(true);
        return p;     
    }
     
   public boolean isMLAAdmin {
                
        get{                   
           if(userList != null && userList.size() > 0) {
              Integer flag = 0;                
              for(Contact_Role__c contRole : [Select Role__c From Contact_Role__c where contact__c = :userList[0].ContactId AND Contact__c!= NULL]) {
                  if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin')))
                     isMLAAdmin = true;                      
                  else{
                        isMLAAdmin = false;  
                        break; 
                  }
              }
           }         
           return isMLAAdmin;
        }
        set{ 
            if(value != null) isMLAAdmin = value;
        }
    }    

   public PageReference addNote() {
      system.debug(aNote.Details__c);
      if(validateccemails(ccRecipients2)==false)
      {
        ccerrorShow2=true;
        return null;
      }

        externalmailbody=aNote.Details__c;
             Pattern nonWordChar = Pattern.compile('\\n');
            /* -- Create a List to Store the Attachments That Were Uploaded by the User -- */
            for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c, Case_Note__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('id') and UserID__c =:Userinfo.getUserId()]){
                        for(Case_Attachment__c  attlist1 : attlist){
                                if(InternalURL != null){
                                    InternalURL = InternalURL + '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    InternalURL = '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }
                                if(ExternalURL != null){
                                    ExternalURL = ExternalURL + '<div><a href="https://blackboard.secure.force.com/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    ExternalURL = '<div><a href="https://blackboard.secure.force.com/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }
                         attlist1.Case_Note__c = aNoteId;
                         update attlist1;
                        }
           
                    }     
           /* -- Insert New Case_Note__c -- */ 
           //if(Notes != null) {
              if (aNote.Details__c != null||((aNote.Details__c == null)&&(Attachments != null && Attachments.size() > 0))){ 
               if(Attachments != null && Attachments.size() > 0){
                   aNote.Has_Attachment__c = true;
                   //aNote.Details__c = nonWordChar.matcher(Notes).replaceAll('<br>') + '<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+InternalURL+'</div>';
                    if(aNote.Details__c!=null)
                    {
                    aNote.Details__c += '<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+InternalURL+'</div>';
                    externalmailbody+='<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+ExternalURL+'</div>';
                  }
                  else
                  {
                  aNote.Details__c='<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+InternalURL+'</div>';
                  externalmailbody='<div style="margin-top:15px;"><b>Attachment(s):</b><br/>'+ExternalURL+'</div>';
                  }
                  System.debug('NNNNNN'+Notes);
                   }
                   else {
                   aNote.Has_Attachment__c = false;
                   //aNote.Details__c = nonWordChar.matcher(Notes).replaceAll('<br>');
                   
                   //aNote.Details__c = Notes;
                  // System.debug('NNNNNN'+ aNote.Details__c);
                   }
                   aNote.Public__c = true;
                   aNote.From_Type__c = 'Customer';
                   aNote.Incoming_Outgoing__c = 'Incoming';
                   aNote.Case__c = Apexpages.currentPage().getParameters().get('id');
                   anote.Type__c = 'BTBB Comment';
                   
                   system.debug(anote.Details__c);
                   insert aNote;
                  // system.debug([select Id, Details__c From Case_Note__c Where Id =: aNote.Id]);
               }
               
                   aNoteId = aNote.Id;
                   
                   System.Debug('aNoteId >>>>>>>>>> AFTER NOTE INSERT >>>>> >>>>  '+aNoteId + aNote.Details__c);
           
           /* -- Insert Attachment Records (Amazon Integration) -- */
                    List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
                        if(aNote != null && aNote.ID != null){
                           for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('id') and UserID__c =:Userinfo.getUserId()]){
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
         //       c1.Portal_Status__c = 'Work In Progress';
           }
           c1.Last_Activity_Date_Time__c = System.now();
           c1.AssignTo_Comment__c = aNote.Details__c;
           if(acase.Send_email_client_case_team__c!= null)
           {
           c1.Send_email_client_case_team__c=acase.Send_email_client_case_team__c+1;
           }
           else
           {
           c1.Send_email_client_case_team__c=1;
           }
           update c1;
           Non_Time_based_Alerts NTB= new Non_Time_based_Alerts ();
           acase.AssignTo_Comment__c = aNote.Details__c;
           string body=NTB.getBody('clientcomment',acase);
           string subject='Case#'+acase.casenumber+'  has been updated by the client';
           emailviaworkflow.mailStaffCaseTeam(acase,body,subject );
           /* -- Create a New Response Event -- */
           
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
               res.Event_Owner_Primary_Group__c  = aCase.Primary_Group_Name__c;   
            }
            BusinessHours b1 = [select ID from BusinessHours where Name = 'Default']; 
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
            if(ccRecipients2!=null && ccRecipients2!='')
            sendccemail();
          
           /* -- Refresh Page -- */
           PageReference Refresh = new PageReference('/apex/btbb_caseview?id='+Apexpages.currentPage().getParameters().get('id'));
               Refresh.SetRedirect(true);
               return Refresh;
      }
      
    
  private void sendccemail()
  {
    
    try{
      EmailTemplate e=[Select Id, Name, HtmlValue, Subject, Body From EmailTemplate Where Name like :'SRV_Code: BtBb Add Comment'];
      string emailbody=e.HtmlValue ;
      string emailsubject=e.subject;
      emailbody=emailbody.replace('{!Case.CaseNumber}',acase.CaseNumber);
      emailbody=emailbody.replace('{!Case.Account}',acase.Account.name);
      emailbody=emailbody.replace('{!Case.Case_Severity__c}',acase.Case_Severity__c);
      emailbody=emailbody.replace('{!Case.Status}',acase.Status);
      emailbody=emailbody.replace('{!Case.CreatedDate}',string.valueof(acase.CreatedDate));
      emailbody=emailbody.replace('{!Case.Last_Activity_Date_Time__c}',string.valueof(system.now()));
      emailbody=emailbody.replace('{!Case.Subject}',acase.Subject);
      emailbody=emailbody.replace('{!Comment}',externalmailbody);
      emailsubject=emailsubject.replace('{!Case.CaseNumber}',acase.CaseNumber);
      emailsubject=emailsubject.replace('{!Case.Subject}',acase.Subject);
      
      list<string> ccemails=ccRecipients2.split(';');
      if(ccemails!= null && ccemails.size()>0)
      {
       emailviaworkflow.sendcaseteamemail(acase,ccemails,emailbody,emailsubject);
      }
    }
    catch(exception e)
    {
        system.debug('Cc email exception: '+e);
    }

  }

  /*private void setupPrefix(){
    prefixSet=new Set<String>();
    Map<String, Schema.SObjectType> gD = Schema.getGlobalDescribe();
    Set<String>keys=gD.keySet();
    for(String key:keys){
      Schema.DescribeSObjectResult r = gD.get(key).getDescribe();
      if(r!=null &&r.getKeyPrefix()!=null && r.getKeyPrefix()!='')
       prefixSet.add(r.getKeyPrefix());
    }     
  }*/
  
  public boolean isId(String at){
    if(at==null)
     return false;   
    else if(at.length()<5)
     return false;
    else{ 
      String testVal = at.substring(0,3);     
      for(String prefix : prefixSet){
        if(prefix.equals(testVal))
         return true;
      }
    }
    return false;
  }
    public Class CaseHistoryItem{

        public String addRegex = '\n';
        public string addRegex2='\n\n';
        public string addRegex3='<br />\r\n';
        public String stripRegex = '<.*?>';
        
        Pattern addPattern = pattern.compile(addRegex);
        Pattern addPattern2= pattern.compile(addRegex2);
        Pattern addPattern3= pattern.compile(addRegex3);
        Pattern stripPattern = pattern.compile(stripRegex);

        public Datetime createdDate   {get; set;}
        public String Details         {get; set;}
        public String Subject         {get; set;}
        public String Summary         {get; set;}
        public String createdName     {get; set;} 
        public String createdId       {get; set;}
        public String mainId          {get; set;}
        public String itemType        {get; set;}
        public String createDateFix   {get; set;}
        public String itemTypeName    {get; set;}
        public string external        {get; set;}
        public Boolean isIncoming     {get; set;}
        public Boolean hasAttachments {get; set;}
        public String SolutionStatus {get;set;}
        public string fixImages(string html)
        {
          
            string pattern = 'src="/servlet/rtaImage' ;
            string newpattern; 
            if(URL.getsalesforcebaseurl().toexternalform().contains('cs23')||URL.getsalesforcebaseurl().toexternalform().contains('dvx-blackboard.force.com')||URL.getsalesforcebaseurl().toexternalform().containsignorecase('dvx-blackboard.my.salesforce'))
            {
              newpattern = 'src="https://blackboard--DVX--c.cs23.content.force.com/servlet/rtaImage' ;
            }
            else if(URL.getsalesforcebaseurl().toexternalform().contains('cs24')||URL.getsalesforcebaseurl().toexternalform().contains('qax-blackboard.force.com')||URL.getsalesforcebaseurl().toexternalform().containsignorecase('qax-blackboard.my.salesforce'))
            {
               newpattern = 'src="https://blackboard--QAX--c.cs24.content.force.com/servlet/rtaImage' ; 
            }
            else 
            {
               newpattern = 'src="https://blackboard.secure.content.force.com/servlet/rtaImage';
            }   
            return html.Replace(pattern,newpattern);  
                  
        }


        CaseHistoryItem(Datetime aCreateDate, String aSubject, String aDetails, String aSummary, String aCreatedName, String aCreatedId, String aMainId, String aType, boolean aHasAttachments, boolean aIsIncoming, string aExternal, string ss){
              isIncoming = aIsIncoming;
              hasAttachments = aHasAttachments;
              createdDate = aCreateDate;
              external = aExternal;
              createDateFix = createdDate.format('MMM dd, yyyy hh:mm:ss a');
              
              if(aDetails != null)
              {
                Details = fixImages(aDetails);
              }
              else
              {
                Details =  aDetails; 
              }
              Subject = aSubject;
              Summary = aSummary;
              Matcher addMatcher;
               if(Details != null )
              {
                  addMatcher = addPattern3.matcher(Details);
              }
              Matcher stripMatcher;
              if(Summary != null)
               stripMatcher = stripPattern.matcher(Summary);
              if(Details!=null&&(!(Details.contains('<li>')&&Details.contains('</li>'))))//TP4303
                 {
                  if(addMatcher != null)  
                   {
                    Details = addMatcher.replaceAll('<br/>');
                    addMatcher=addPattern2.matcher(Details);
                    if(addMatcher != null)
                    Details=addMatcher.replaceAll('<br/>');
                    addMatcher=addPattern.matcher(Details);
                    if(addMatcher != null)
                    Details=addMatcher.replaceAll('<br/>');
                    //Details=Details.replaceall('<br/><br/>','<br/>');
                  }
              }
              if(stripMatcher != null)
                  Summary = stripMatcher.replaceAll(' ');
              createdName = aCreatedName;
              createdId = aCreatedId;
              mainId = aMainId;
              itemType = getTypeImageMap(aType,aHasAttachments,aIsIncoming, aExternal, aSubject);
              itemTypeName = aType;
              SolutionStatus = ss;
        }

        private String getTypeImageMap(String aType, Boolean aHasAttachments, Boolean aIsIncoming, String aExternal,String aSubject){
          if(aType=='Attachment')
            return '/resource/1320414452000/supporticons/icons/32x32/attachment.png';
          else if(aType=='Article')
            return '/resource/1320414452000/supporticons/icons/32x32/full_page.png';
          else if(aType=='Solution' && aSubject.contains('<span style="font-weight:bold;text-transform:uppercase;color:#00838a;">'))
            return '/resource/1320414452000/supporticons/icons/32x32/warning-Triangle.png';
          else if(aType=='Solution')            
            return '/resource/1320414452000/supporticons/icons/32x32/light_bulb.png';
          else if(aType=='BTBB Comment' && aHasAttachments == true)
            return '/resource/1320414452000/supporticons/icons/32x32/user_comment_attachment.png';
          else if(aType=='Case Reopened')
            return '/resource/1320414452000/supporticons/icons/32x32/refresh.png';
          else if(aType=='Case Closed')
            return '/resource/1320414452000/supporticons/icons/32x32/accept.png';
          else if(aType=='BTBB Comment')
            return '/resource/1320414452000/supporticons/icons/32x32/user_comment.png';
          else if(aType=='Email' && aIsIncoming != true && aHasAttachments == true)
            return '/resource/1320414452000/supporticons/icons/32x32/mail_attachment_send.png';
          else if(aType=='Email' && aIsIncoming == true && aHasAttachments == true)
            return '/resource/1320414452000/supporticons/icons/32x32/mail_attachment_receive.png';
          else if(aType=='Email' && aIsIncoming != true && aHasAttachments == false)
            return '/resource/1320414452000/supporticons/icons/32x32/mail_send.png';
          else if(aType=='Email' && aIsIncoming == true && aHasAttachments == false)
            return '/resource/1320414452000/supporticons/icons/32x32/mail_receive.png';
          else if(IsIncoming == true && (aType.contains('Escalated') || aType.contains('Closed') || aType.contains('Reopened')))
            return '/resource/1320414452000/supporticons/icons/32x32/mail_receive.png';
          else if(aType.contains('call') || aType.contains('Call'))
            return '/resource/1320414452000/supporticons/icons/32x32/mobile.png';
          else
            return '/resource/1320414452000/supporticons/icons/32x32/full_page.png';
        }
      }
  
  public PageReference Redirect() {
        System.debug('aCase >>>>>>' + aCase.AccountId);
        System.debug('userRedirect >>>>>>>>' + gc.userRedirect);
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } 
        else 
        {
          set<Id> accountIds = new set<Id>();
            
            if (gc.ContactId != null)
            {
                for (Contact_Role__c cr : [Select Id, Name, Contact__c, Account__c From Contact_Role__c Where Contact__c =: gc.ContactId AND Contact__c!= NULL])
                {
                    if (cr.Account__c != null)
                    {
                        accountIds.add(cr.Account__c);
                    }
                }
            }
            
            if ((aCase.AccountId != null && accountIds.contains(aCase.AccountId)) || gc.profileName.equals('System Administrator') || gc.profileName.equals('SRV - System Administrator'))
            {
                return null;
            }
            PageReference pageRedirect = new PageReference('/btbb_home');
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
    }
    
    public List<SelectOption> getApplServerOS() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe4 = Asset.Application_Server_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe4.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                applicationServerOS=picklistEntry.getvalue(); 
                }
              }
             return options; 
        
    }
    public List<SelectOption> getDatabaseList() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe3 = Asset.Database__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe3.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                database=picklistEntry.getvalue(); 
                }
              }
             return options; 
        
        
        
        
    }
    public List<SelectOption> getDbServerOS() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe2 = Asset.Database_Server_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe2.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                databaseServerOS=picklistEntry.getvalue(); 
                }
              }
             return options; 
        
        
    }
    
    public List<SelectOption> getJDKVersionList() {
        List<SelectOption> options = new List<SelectOption>();
          Schema.DescribeFieldResult BrowserDecribe1 = Asset.JDK_Version__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe1.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                jdkVersion=picklistEntry.getvalue(); 
                }
              }
             return options; 
        
    }
    

    // new versions code
     public List<selectOption> versions {


        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> ver = new Set<String>();
            if (aCase.AssetID!= null) {

                for (Asset a : [SELECT id, name, version__c, Product2Id, Product2.GKEY_Product_Group__c FROM Asset a /* WHERE Product2.GKEY_Product_Group__c != null AND Product2.Core_License__c != null AND*/ Where a.id =: aCase.AssetID]){
                    if(a.version__c!=null)
                        options.add(new SelectOption(a.version__c,a.version__c));
                      //  ver.add(a.Version__c);
                }
                
                list<Asset> listAsset = [Select id, name, Product2.GKEY_Product_Group__c from Asset Where Id=: aCase.AssetID];
                list<Version_Build_Tree__c > availversions;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversions = [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE Version__c != :[SELECT version__c FROM Asset WHERE id =: aCase.AssetID].version__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Active_Flag__c = true ORDER BY Version__c DESC ];
                }
                
                map<String, String> distinctVersions = new map<String, String>();
                for(Version_Build_Tree__c eachVersion : availversions ){
                distinctVersions.put(eachVersion.Version__c,eachVersion.Version__c);
                }
                
                for(String eachDistinctVersion: distinctVersions.keySet() ){
                ver.add(eachDistinctVersion);
                
                }
                // ver is filled with right set now
                for(String eachSelectableVersion: ver){
                if(eachSelectableVersion != null)
                options.add(new SelectOption(eachSelectableVersion,eachSelectableVersion));
                }
                
            }
             if(options.size()>0)
                for(integer i = 0; i<(options.size()-1);i++)
                {
                    for(integer y=i+1;y<=options.size()-1;y++)
                    {
                        try{                    
                            list<string> a=options[i].getValue().splitByCharacterTypeCamelCase();
                            list<string> b=options[y].getValue().splitByCharacterTypeCamelCase();
                            integer loop_length;
                            if(a.size()<b.size())
                                loop_length=a.size();
                            else
                                loop_length=b.size();
                            integer k=0;
                            while(k<loop_length)
                            {
                                if(((a[k]).isNumeric() && (b[k]).isNumeric() &&Integer.valueof(a[k])<integer.valueof(b[k]))||((a[k]).isAlpha() && (b[k]).isAlpha()&&a[k]<b[k]))
                                {
                                    selectoption temp;
                                    temp=options[i];
                                    options[i]=options[y];
                                    options[y]=temp;
                                    break;
                                } 
                                else if(a[k]==b[k])
                                {
                                    k++;    
                                }
                                else
                                {
                                    break;
                                }
                            }

                        }
                        catch (exception e)
                        {
                        }    
                    }
                }

            
            return options;
        }
        set;
    }

    // end versions code 
 
public List<selectOption> sblist{
        get{
            List<selectOption> options = new List<selectOption>();
             for (Asset a : [SELECT id, name, Version_Build__c , Product2Id, Product2.GKEY_Product_Group__c FROM Asset a /* WHERE Product2.GKEY_Product_Group__c != null AND Product2.Core_License__c != null AND*/ Where a.id =: aCase.AssetID]){
                    if(a.Version_Build__c!=null)
                        options.add(new SelectOption(a.Version_Build__c ,a.Version_Build__c ));
                       build = a.Version_Build__c;
                }
            
              // We need Asset to get Product2 to get the GKEY Product Group
                list<Asset> listAsset = [Select id, name, Version__c, Version_Build__c, Product2.GKEY_Product_Group__c from Asset Where Id=: aCase.AssetID];
                list<Version_Build_Tree__c > availversionbuilds;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversionbuilds = [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c v WHERE Version_Build__c!= : [SELECT Version_Build__c FROM Asset WHERE id =: aCase.AssetID].Version_Build__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Version__c =: version AND version_build__c !=:build AND Active_Flag__c = true  ORDER BY Version_Build__c DESC];
                
                }
                
                map<String, String> distinctVersionBuilds = new map<String, String>();
                if(availversionbuilds != null){
                for(Version_Build_Tree__c eachVersionBuild : availversionbuilds){
                distinctVersionBuilds.put(eachVersionBuild.Version_Build__c ,eachVersionBuild.Version_Build__c );
                
                
                }
                }
                
                for(String eachDistinctVersionBuild: distinctVersionBuilds.keySet() ){
                options.add(new SelectOption(eachDistinctVersionBuild,eachDistinctVersionBuild));                   
                }
               if(options.size()>0)
                for(integer i = 0; i<(options.size()-1);i++)
                {
                    for(integer y=i+1;y<=options.size()-1;y++)
                    {
                        try{                    
                            list<string> a=options[i].getValue().splitByCharacterTypeCamelCase();
                            list<string> b=options[y].getValue().splitByCharacterTypeCamelCase();
                            integer loop_length;
                            if(a.size()<b.size())
                                loop_length=a.size();
                            else
                                loop_length=b.size();
                            integer k=0;
                            while(k<loop_length)
                            {
                                if(((a[k]).isNumeric() && (b[k]).isNumeric() &&Integer.valueof(a[k])<integer.valueof(b[k]))||((a[k]).isAlpha() && (b[k]).isAlpha()&&a[k]<b[k]))
                                {
                                    selectoption temp;
                                    temp=options[i];
                                    options[i]=options[y];
                                    options[y]=temp;
                                    break;
                                } 
                                else if(a[k]==b[k])
                                {
                                    k++;    
                                }
                                else
                                {
                                    break;
                                }
                            }

                        }
                        catch (exception e)
                        {
                        }    
                    }
                }

              
            return options;
        }
        set;
    }
    // end source build code
    
    public PageReference SaveAsset() {

        Asset ast1 = new Asset(Id=aCase.AssetID);
        ast1.Nickname__c = nickName;
        //ast1.Version__c = version;
        //ast1.Version_Build__c = build;
        ast1.Software_URL__c = URL1;
        ast1.JDK_Version__c = jdkVersion; 
        ast1.Application_Server_OS__c = applicationServerOS;
        ast1.Database__c = database; 
        ast1.Database_Server_OS__c = databaseServerOS; 
        update ast1;
        
        if(version != aCase.Asset.Version__c && build != aCase.Asset.Version_Build__c){
        Asset_Version_History__c AVH= new Asset_Version_History__c();
        AVH.Asset__c=aCase.AssetID;
        AVH.Current_Version__c=version;
        AVH.Current_Build__c=build;
        AVH.Effective_Date__c=system.now();
        insert AVH;
        }
        
        else if(version == aCase.Asset.Version__c && build != aCase.Asset.Version_Build__c){
        Asset_Version_History__c AVH= new Asset_Version_History__c();
        AVH.Asset__c=aCase.AssetID;
        AVH.Current_Version__c=version;
        AVH.Current_Build__c=build;
        AVH.Effective_Date__c=system.now();
        insert AVH;
        }
        
        Pagereference p = new Pagereference('/apex/btbb_caseview?id='+aCase.id);
        p.setredirect(true);
        return p;
    }

  public boolean isreadonly {get {
         
              if ((aCase.Case_Record__c!= null && aCase.Case_Record__c.containsignorecase('collaborate')) ||
                    (aCase.Core_License__c!=null && aCase.Core_License__r.name.containsignorecase('collaborate')))
               
               {
                 return !gc.isCollabAdmin();
                 
               }
               else
               {
                  return isMLAAdmin;
               }
     }
     set;
     } 
     
  public pagereference updateccemails()
  {
    ccerrorShow=false;
    case tempcase= new case(id=acase.id);
    integer x=1;
    list<string> ccemaillist=ccRecipients.split(';');
    if(validateccemails(ccRecipients)==false)
    {
      return null;
    }
    if(ccRecipients != null && ccRecipients!='')
        {
            tempcase.ccemail1__c= tempcase.ccemail2__c= tempcase.ccemail3__c= tempcase.ccemail4__c= tempcase.ccemail5__c=null;    
          for(string s: ccemaillist)
            {
              if(x==1)
                {
                    tempcase.ccemail1__c=s;
                }
                else if(x==2)
                {
                    tempcase.ccemail2__c=s;
                }
                else if(x==3)
                {
                    tempcase.ccemail3__c=s;
                }
                else if(x==4)
                {
                    tempcase.ccemail4__c=s;
                }
                else if(x==5)
                {
                    tempcase.ccemail5__c=s;
                }
               x++; 
            } 
            update tempcase; 
               Pagereference p = new Pagereference('/apex/btbb_caseview?id='+aCase.id);
               p.setredirect(true);
               return p;
         }
          else
        {
          tempcase.ccemail1__c= tempcase.ccemail2__c= tempcase.ccemail3__c= tempcase.ccemail4__c= tempcase.ccemail5__c=null;
          update tempcase;
           Pagereference p = new Pagereference('/apex/btbb_caseview?id='+aCase.id);
           p.setredirect(true);
           return p;
        }        
    
  }  

   Private boolean validateccemails(string  Recipients)
    {
      ccerrorShow=false;
      ccerrorMessage='';
      ServiceCloudUtility.ValidateEmailResults ccErrorResult= ServiceCloudUtility.validateccemails(Recipients);
      if(ccErrorResult != null && ccErrorResult.isSuccess==false)
      {
        ccerrorShow=true;
        ccerrorMessage=ccErrorResult.errormessage;
        return false;
      }
      return true;
       
    } 


}