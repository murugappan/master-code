public class CaseCommentController {
    GlobalComponent gc = new GlobalComponent();
    public Case_Note__c note = new Case_Note__c();
    public Case c = new Case();
    public Case TempCase{get;set;}
    public String userinformation {get;set;}
    public String SUB {get;set;}
    private User u = new User();
    public Solution_Detail__c Solution = new Solution_Detail__c();
    public Support_Workflow__c sw = new Support_Workflow__c();
    private Solution sol = new Solution();
    private KnowledgeArticleVersion kav = new KnowledgeArticleVersion();
    public String CommentBody {get;set;}
    public String Workflow {get;set;}
    public String SelectedArticleId {get;set;}
    public Boolean UserOptionResponseRequired {get;set;}
    public String SelectedResponseOption {get;set;}
    public List<Responsiveness__c> reslist1 = new List<Responsiveness__c>();
    public Decimal sla;
    public String ownername;
    public Boolean learnSI {get;set;}
    public Boolean sendEmail {get;set;}
    public Boolean sendEmailCustomer {get;set;}
    public Boolean sendEmailInternal {get;set;}
    public Boolean sendInternalNote{get;set;} //tp 17603
    public Boolean SolutionWorkflow {get;set;}
    public boolean MailBody{get;set;}
    public String ClosureReason {get;set;}
    public Boolean articleattached {get;set;}
    public List<Case_Attachment__c> attachments = new List<Case_Attachment__c>();
    public String ccRecipients {get;set;}
    public List<String> ccAddress;
    public Set<Id> AttachmentID = new Set<ID>();
    public String NoteId;
    public String InternalURL;
    public String ExternalURL;
    public String ccdonemail {get;set;}
    public String ccdonemailtext {get;set;}
    public boolean errorShow;
    public boolean errorShow2;
    public String errorTitle;
    public String errorTitle2;
    public String errorMessage;
    public String errorSeverity;
    public String errorField;
    public string instanceurl {get;set;}
    public String[] toAddresses;
    public id targetObjectId ;
    public string MailbodyDetails1;
    public string Mailbodydetails{get;set;}
    string supportworkflowtype{get;set;}
    public boolean getApiUser(){
    if(globalcomponent.getapiuser(userinfo.getuserid()) != true)
    return false;
    else
    return true;
    }
    public list<SelectOption> cannedResponseList {get; set;} 
    public Boolean hasCannedResponses {get; set;} 
    private map<Id, APEX_Email_Template__c> responseMap = new map<Id, APEX_Email_Template__c>();
    
    public String selectedResponse {get; set;} 
    
    public void setErrorTitle(String errorTitle) {
        this.errorTitle = errorTitle;
    }
    public String getErrorTitle() {
        return this.errorTitle;
    }
     public void setErrorTitle2(String errorTitle2) {
        this.errorTitle2 = errorTitle2;
    }
    public String getErrorTitle2() {
        return this.errorTitle2;
    }
    
    public void setErrorShow(boolean errorShow) {
        this.errorShow = errorShow;
    }
    public boolean getErrorShow() {
        return this.errorShow;
    }       
      public void setErrorShow2(boolean errorShow2) {
        this.errorShow2 = errorShow2;
    }
    public boolean getErrorShow2() {
        return this.errorShow2;
    }  
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    public String getErrorMessage() {
        return this.errorMessage;
    }   
    
    public void setErrorSeverity(String errorSeverity) {
        this.errorSeverity = errorSeverity;
    }
    public String getErrorSeverity() {
        return this.errorSeverity;
    }   

    public boolean getdisplayAttach(){
        if(attachments != null && attachments.size() > 0)
            return true;
        else     
            return false;    
    }

    /**** Mac Updated SOQL to Include a Where Clause that Brought back only Case Attachments not in the Id set ****/
    public List<Case_Attachment__c> getCaseNoteAttachments(){
                 
         List<Case_Attachment__c> attlist = new List<Case_Attachment__c>();
         attlist = [select Id,Name,Bucket_Name__c,File_Name__c, Relate_to_SI__c from Case_Attachment__c where ID NOT IN: AttachmentID and Related_To__c = :ApexPages.currentPage().getParameters().get('cid') and UserID__c =:Userinfo.getUserId() ];     
         Attachments  = attlist;
         return attlist;
    }
    
    /**Dominic Inserted these variables and methods**/
    public list<AttachmentWrapper> attachmentList {get
        {
            
            List<Case_Attachment__c> attlist = new List<Case_Attachment__c>();
            
            attlist = [select Id,Name,Bucket_Name__c,File_Name__c, Relate_to_SI__c from Case_Attachment__c where ID NOT IN: AttachmentID and Related_To__c = :ApexPages.currentPage().getParameters().get('cid') and UserID__c =:Userinfo.getUserId()];     
            
            Attachments  = attlist;
            list<AttachmentWrapper> attWrap = new list<AttachmentWrapper>();
            for (Case_Attachment__c ca : attlist)
            {
                attWrap.add(new AttachmentWrapper(ca));
            }
            return attWrap;
        } set;}
    
    public class AttachmentWrapper
    {
        public Case_Attachment__c caseAtt {get; set;}
        
        public AttachmentWrapper(Case_Attachment__c ca)
        {
            caseAtt = ca;
        }
        
        public void attachToSI()
        {
           
            caseAtt.Relate_to_SI__c = true;

            try
            {
                update caseAtt;
            }
            catch (Exception e)
            {
                system.debug('Case Attachment Update Failed!');
            }
        }
    }
    
    public List<SelectOption> getClosureReasons() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select Closure Reason --'));
        Schema.DescribeFieldResult fieldResult = case.Reason.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public String getWorkflow(){
        return Workflow;
    }
    
    public pageReference AddAttachment(){
        return null;
    }
    
    /* -- Evaluates Selected Workflow and Checks Email Conditions -- */
    public void evaluateWorkflow(){
        SolutionWorkflow = false;
       tempcase=new case(RecordTypeid=c.RecordTypeId);
        UserOptionResponseRequired = false;
        sendEmailInternal = false;
        sendEmailCustomer = false;
        sendEmail = false;
        sendInternalNote = false;
        ccdonemail = null;
        
        if(Workflow != null){
            List<Support_Workflow__c> s = new List<Support_Workflow__c>();
            
            if(Workflow == 'Close Case'){
                if((c.Case_record__c != null && (c.Case_record__c.contains('ANGEL') ||  c.Case_record__c.contains('Learn') || c.Case_record__c.contains('Vista') || c.Case_record__c.containsignorecase('Collaborate') )||(c.recordtype.name.containsignorecase('end user') || c.recordtype.name.containsignorecase('Moodlerooms') || c.recordtype.name.containsignorecase('Analytics') || c.recordtype.name.containsignorecase('xpLor'))))            
                    s = [Select s.Name, s.Send_Email_to_Case_Owner__c, s.Send_Email_to_Customer__c, s.Publish_to_BTBB__c, s.User_Option_Response_Required__c, s.Amazon_Attachment_Option__c From Support_Workflow__c s Where s.Name =: Workflow AND Close_Case_License__c = 'Learn and ANGEL' and case_record_type__c=:supportworkflowtype];
                else if(c.Case_record__c != null && c.Case_record__c.contains('Transact'))
                    s = [Select s.Name, s.Send_Email_to_Case_Owner__c, s.Send_Email_to_Customer__c, s.Publish_to_BTBB__c, s.User_Option_Response_Required__c, s.Amazon_Attachment_Option__c From Support_Workflow__c s Where s.Name =: Workflow AND Close_Case_License__c = 'Transact'];
                else if(c.Case_record__c != null && c.Case_record__c.contains('Xythos'))
                    s = [Select s.Name, s.Send_Email_to_Case_Owner__c, s.Send_Email_to_Customer__c, s.Publish_to_BTBB__c, s.User_Option_Response_Required__c, s.Amazon_Attachment_Option__c From Support_Workflow__c s Where s.Name =: Workflow AND Close_Case_License__c = 'Xythos'];                        
            }else
                s = [Select s.Name, s.Send_Email_to_Case_Owner__c, s.Send_Email_to_Customer__c, s.Publish_to_BTBB__c, s.User_Option_Response_Required__c, s.Amazon_Attachment_Option__c From Support_Workflow__c s Where s.Name =: Workflow  and case_record_type__c=:supportworkflowtype];
            
            if(s != null && s.size() > 0){
                if(s[0].User_Option_Response_Required__c == true)
                    UserOptionResponseRequired = true;
                else
                    UserOptionResponseRequired = false;
                if(s[0].Send_Email_to_Customer__c == true || s[0].Send_Email_to_Case_Owner__c == true)
                    sendEmail = true;
                else
                    sendEmail = false;
                if(s[0].Send_Email_to_Customer__c == true)
                    sendEmailCustomer = true;
                else
                    sendEmailCustomer = false;
                if(s[0].Send_Email_to_Case_Owner__c == true)
                    sendEmailInternal = true;
                else
                    sendEmailInternal = false;
                if(s[0].Name == 'Suggest Solution' || s[0].Name == 'Close Case' || s[0].Name == 'Closed - Pending Target (non-Learn)')
                    SolutionWorkflow = true;
                else
                    SolutionWorkflow = false;
                 if(s[0].Name == 'Internal Note')
                 {
                     sendInternalNote = true;
                     ccRecipients = null;
                 }
                 else
                 {       
                     sendInternalNote = false;
                 }    
            }
        }    
        
        Set<Id> userId = new Set<ID>();
        Set<ID> conId = new Set<ID>();
        if(sendEmail){
           List<CaseTeamRole> ctr = new List<CaseTeamRole>([Select c.Id,c.Name From CaseTeamRole c where Name LIKE '%on Email%' ]);
           if(ctr != null && ctr.size() > 0){
           
           for(List<CaseTeamMember> ctm : [Select c.TeamRoleId, c.ParentId, c.MemberId From CaseTeamMember c where TeamRoleId in: ctr and ParentID =: ApexPages.currentPage().getParameters().get('cid')]){
               for(CaseTeamMember ctm1 : ctm){
                   if(String.valueof(ctm1.MemberId).substring(0,3) == '005')
                      userId.add(ctm1.MemberId); 
                   else if(String.valueof(ctm1.MemberId).substring(0,3) == '003')
                      conId.add(ctm1.MemberId); 
                   }
               }
               
               if(userId.size() > 0){
               for(List<User> u : [select Id,Email,FirstName,LastName from User where ID IN: userID]){
                   for(User u1 : u){
                       if(ccdonemail == null)
                          ccdonemail = u1.Email;
                       else
                          ccdonemail = ccdonemail + ';' + u1.Email;
                       }
                   }
               }
               if(conId.size() > 0){
                  for(List<Contact> c : [select Id,Email,FirstName,LastName from Contact where ID IN: conId]){
                      for(Contact c1 : c){
                          if(ccdonemail == null)
                             ccdonemail = c1.Email;
                          else
                             ccdonemail = ccdonemail + ';' + c1.Email;
                      }
                  }
               }            
           }   
                 
        }
    }
    
    /* -- Retrieves Response Required/No Response Required Choices if Selected Support_Workflow__c.User_Option_Response_Required__c == true -- */
    public List<selectOption> ResponseOptions {
        get {            
            List<selectOption> options = new List<selectOption>();
                        options.add(new SelectOption('true','Response Required' ));
                        options.add(new SelectOption('false','No Response Required' ));
            return options;           
        }
        set;
    }
    
    // Updated by Dominic on 8/1/12
    /* -- Retrieves a List of Knowledge Artiles Attached to the Case via CaseArticle Object -- */
    public list<SelectOption> Articles
    {
        get 
        {
            map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>();
            set<Id> articleIdSet = new set<Id>();            
            list<SelectOption> articleoptions = new List<SelectOption>();
            articleoptions.add(new SelectOption('','-- Attach an Article --' ));
            for (CaseArticle art : [Select c.KnowledgeArticleId, c.IsDeleted,  c.CaseId
                                    From CaseArticle c
                                    Where c.CaseId = :ApexPages.currentPage().getParameters().get('cid')
                                    And IsDeleted = false
                                    And KnowledgeArticleId != null])
            {
                articleIdSet.add(art.KnowledgeArticleId);
            }
            
            for (KnowledgeArticleVersion kav : [Select KnowledgeArticleId, Title, ArticleNumber
                                                From KnowledgeArticleVersion 
                                                Where IsVisibleInCsp = true
                                                And KnowledgeArticleId IN : articleIdSet
                                                And PublishStatus = 'Online'
                                                And Language = 'en_US'
                                                order By ArticleNumber desc])
            {
                if (kav.KnowledgeArticleId != null)
                {
                    articleoptions.add(new SelectOption(kav.KnowledgeArticleId, '#' + kav.ArticleNumber + ' - ' + kav.Title));
                }
            }
            return articleoptions;          
        }
        set;
    }
    
    /* -- Retrieves a List of Workflows with Active Status from Support_Workflow__c Object -- */
    public List<selectOption> Workflows {
        get {            
            List<selectOption> options = new List<selectOption>();
                        options.add(new SelectOption('','-- Choose a Workflow --' ));
                    if(c.isClosed == true && c.IsVisibleInSelfService == true){
                for (Support_Workflow__c s : [SELECT Name FROM Support_Workflow__c s WHERE s.Active__c = true AND Active_Closed_Status__c = true AND Name != 'Incoming Call' and case_record_type__c=:supportworkflowtype Order By Name  ]){
                        if(s.name != null)
                        options.add(new SelectOption(s.name,s.name));
                }
            }
            
            if(c.isClosed == true && c.IsVisibleInSelfService == false){
                for (Support_Workflow__c s : [SELECT Name FROM Support_Workflow__c s WHERE s.Active__c = true AND Active_Closed_Status__c = true AND Name != 'Incoming Call' AND Name != 'Outbound Call' AND Name != 'Update Client' AND Name != 'Suggest Solution' AND Name != 'Need More Info' AND Name != 'Closed - Pending Target (non-LRN)' and case_record_type__c=:supportworkflowtype Order By Name  ]){
                        if(s.name != null)
                        options.add(new SelectOption(s.name,s.name));
                }
            }

            if(c.isClosed == false && c.IsVisibleInSelfService == true){
                for (Support_Workflow__c s : [SELECT Name FROM Support_Workflow__c s WHERE s.Active__c = true AND Active_Open_Status__c = true and case_record_type__c=:supportworkflowtype Order By Name  ]){
                        if(s.name != null){
                            //if(s.Name != 'Closed - Pending Target (non-Learn)'  || (s.Name == 'Closed - Pending Target (non-Learn)' && !c.Case_Record__c.contains('Learn'))) // Commented for 1931
                            options.add(new SelectOption(s.name,s.name));
                
                        }
                }
            }

            if(c.isClosed == false && c.IsVisibleInSelfService == false){
                for (Support_Workflow__c s : [SELECT Name FROM Support_Workflow__c s WHERE s.Active__c = true AND Active_Open_Status__c = true AND Name != 'Incoming Call' AND Name != 'Outbound Call' AND Name != 'Update Client' AND Name != 'Suggest Solution' AND Name != 'Need More Info' AND Name != 'Closed - Pending Target (non-LRN)'  and case_record_type__c=:supportworkflowtype Order By Name  ]){
                        if(s.name != null){
                            //if(s.Name != 'Closed - Pending Target (non-Learn)'  || (s.Name == 'Closed - Pending Target (non-Learn)' && !c.Case_Record__c.contains('Learn'))) // Commented for 1931
                            options.add(new SelectOption(s.name,s.name));
                
                        }
                }
            }  
                    
            return options;           
        }
        set;
    }
 
 
        public CaseCommentController(ApexPages.StandardController controller) {
           
            instanceurl =URL.getSalesforceBaseUrl().toExternalForm();
            this.note = (Case_Note__c)controller.getRecord();
            this.c = [Select Id, Case_Record__c,RecordType.Name,RecordTypeId,IsVisibleInSelfService, Date_Time_Last_Support_Communication__c,BusinessHoursID, Contact_Response_Initiated__c,Primary_Group_Name__c,Case_Severity__c, Status, CaseNumber, Subject, Contact.Email, Contact.Name, LearnJIRA_SI__c, ContactId, isClosed, Owner.Email, Owner.Name, Core_License__c,Core_License__r.Product__c,Core_License__r.Name,end_user__r.name,end_user__r.email__c,ccemail1__c,ccemail2__c,ccemail3__c,ccemail4__c,ccemail5__c,End_User_Email__c FROM Case WHERE Id = :ApexPages.currentPage().getParameters().get('cid')];
            this.tempcase=new case(RecordTypeid=c.RecordTypeId);
            articleattached = false;
            if(c.ccemail1__c != null||c.ccemail2__c != null||c.ccemail3__c != null||c.ccemail4__c != null||c.ccemail5__c != null)
            {
                string tempmail= (c.ccemail1__c!=null?c.ccEmail1__c:'')+';'+(c.ccemail2__c!=null?c.ccEmail2__c:'') +';'+(c.ccemail3__c!=null?c.ccEmail3__c:'')+';'+(c.ccemail4__c!=null?c.ccEmail4__c:'')+';'+(c.ccemail5__c!=null?c.ccEmail5__c:'');
                tempmail = tempmail.replaceall('[_;]{2,}',';') ;
                ccRecipients=tempmail;
            }
            if(c.Case_record__c != null && c.Case_record__c.contains('ANGEL'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'ANGEL'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Learn'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Learn'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('CE'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'CE'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Xythos'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Xythos'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Transact'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Transact'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Moodlerooms'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Moodlerooms'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Collaborate'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Collaborate'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('Analytics'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'Analytics'].SLA__c;
            else if(c.Case_record__c != null && c.Case_record__c.contains('xpLor'))
                 sla = [select Core_License__c,Severity__c,SLA__c,Event_Type__c from SLA_Information__c where Event_Type__c = 'Followup' AND Severity__c =: c.Case_Severity__c AND Core_License__c = 'xpLor'].SLA__c;

            for(List<Case_Attachment__c> cas : [select Id from Case_Attachment__c where Related_To__c =: c.ID]){
                for(Case_Attachment__c cas1 : cas){
                    AttachmentID.add(cas1.ID);
                }
            } 
            loadCannedResponses();
            if (ApexPages.currentPage().getParameters().get('cr') != null && responseMap != null && responseMap.containsKey(ApexPages.currentPage().getParameters().get('cr')))
            {
              selectedResponse = ApexPages.currentPage().getParameters().get('cr');
              CommentBody = responseMap.get(selectedResponse).Html_Body__c;
            } 
            if(c.RecordType.Name.containsAny('Learn')){
            learnSI = true;
            }
            
            if(c.Subject.length() <= 50){
            SUB = c.Subject;
            }
            else if(c.Subject.length() >= 50){
            SUB = c.Subject.substring(0,50);
            }
            
            if(this.c.recordtype.name.containsignorecase('end user'))
            {
                supportworkflowtype='Collaborate End User';
            }
            else
            {
                supportworkflowtype=null;
            }
           
            
    }
        
    public String getCaseID(){
        return c.ID;
    }        
    
    public String getCaseNumber(){
        return this.c.CaseNumber;
    }
    
    public String getSubject(){
        return this.c.Subject;
    }
    
    public String getStatus(){
        return this.c.Status;
    }
    
    public String getOwnerName(){
        return this.c.owner.name;
    }
    
    public String getOwnerEmail(){
        return this.c.owner.email;
    }
    
    public String getContactName(){
        if(this.c.recordtype.name.containsignorecase('end user'))
        {
            return this.c.end_user__r.name;
        }
        else
        {
            return this.c.contact.name;
        }
    }
    
    public String getContactEmail(){
        if(this.c.recordtype.name.containsignorecase('end user'))
        {
            return this.c.end_user__r.email__c;
        }
        else
        {
            return this.c.contact.email;
        }
        
    }
    public String getEndUserEmail(){
        
      return this.c.End_User_Email__c;
                
    }
    
    public String getEndUserName(){
        
         return this.c.end_user__r.name;
                
    }
    
    public PageReference Cancel() {
        PageReference Refresh = new PageReference('/'+c.id);
        Refresh.SetRedirect(true);
        return Refresh;   
    }

    /* -- Save/Submit Actions -- */
    public PageReference doSave()
    {
        ClosureReason=tempcase.Reason;  //Addded to accomodate collaborate specifc closure reason from reason picklist.
        Savepoint sp = Database.setSavepoint();
        errorShow2 = false;
        errorShow = false;
        if(Workflow == '' || Workflow == null)
        {
            system.debug('Entered VALIDATION -------');
            errorShow2 = true;
            errorTitle2 = 'Please select a workflow!';
            errorSeverity = 'error';
            return null;
        }
        if((Workflow == 'Suggest Solution' ||  Workflow == 'Close Case') && ClosureReason == null )   
        {
            errorField='Closure Reason';
        }
        else
        {
            errorField=null;
        }
        if(errorField != null) 
        {
            
            errorTitle = 'Insertion Error!';
            errorMessage = 'Please Enter ' + errorField + ' value';
            errorSeverity = 'error';
            errorShow = true;  
                     
            return null;
        }

    
        /* -- Retrieves Name and Title of Current Logged in User -- */
        u = [Select Name, Title From User Where Id = :UserInfo.getUserId()];
        
        /* -- Retrieves Values of the Selected Support_Workflow__c Record -- */
        if(Workflow == 'Close Case')
        {
        
           if((c.Case_record__c != null && (c.Case_record__c.contains('ANGEL') ||  c.Case_record__c.contains('Learn')|| c.Case_record__c.contains('Vista')|| c.Case_record__c.containsignorecase('Collaborate')))||(c.recordtype.name.containsignorecase('end user')))            
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'Learn and ANGEL' and case_record_type__c=:supportworkflowtype];
           else if(c.Case_record__c != null && c.Case_record__c.contains('Transact'))
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'Transact'];
           else if(c.Case_record__c != null && c.Case_record__c.contains('Xythos'))
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'Xythos'];             
           else if((c.Case_record__c != null && c.Case_record__c.contains('Moodlerooms'))|| c.recordtype.name.containsignorecase('Moodlerooms'))
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'Moodlerooms']; 

            else if((c.Case_record__c != null && c.Case_record__c.contains('Analytics'))|| c.recordtype.name.containsignorecase('Analytics'))
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'Analytics'];
            else if((c.Case_record__c != null && c.Case_record__c.contains('xpLor'))|| c.recordtype.name.containsignorecase('xpLor'))
               sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow AND Close_Case_License__c = 'xpLor'];                               
        }        
         
         
              
         else
              sw = [Select Name, Active__c, Send_Email_to_Customer__c, Case_Status_Update__c, Portal_Status_Update__c, Email_Subject__c,
                     Email_Introduction__c, Email_Signature__c, Email_Introduction_Text__c, Email_Signature_Text__c, 
                     Email_Signature_Type__c, Active_Open_Status__c, Active_Closed_Status__c, Include_Case_Summary__c,
                     Send_Email_to_Case_Owner__c, Publish_to_BTBB__c, Response_Required_Event__c, Support_Response_Event__c,
                     User_Option_Response_Required__c
                     From Support_Workflow__c 
                     Where Name =: Workflow and case_record_type__c=:supportworkflowtype];
        
        
        
    
        
        if (sw.Support_Response_Event__c == true){
            reslist1 = new List<Responsiveness__c>();
            for(List<Responsiveness__c> res : [select ID,Case__c,Stop_Time__c from Responsiveness__c where Case__c =: c.ID AND Stop_Time__c = null ORDER BY Case__c]){
                for(Responsiveness__c res1 : res){
                    Responsiveness__c res2 = new Responsiveness__c(ID = res1.ID);
                    res2.Stop_Time__c =  System.now();
                    reslist1.add(res2);
                }
            } 
            
            Update reslist1;
            
            if(c.Isclosed == false){  
               List<CaseMilestone> firstres = new List<CaseMilestone>([select ID,StartDate,CompletionDate from CaseMilestone where CaseID =: c.ID AND MilestoneType.Name = 'First Response']);
               if(firstres != null && firstres.size() > 0){
                  if(firstres[0].CompletionDate == null){
                     CaseMilestone cm = new CaseMilestone(ID = firstres[0].ID);
                     cm.completiondate = System.now();
                     Update cm;
                   
                  }  
               }
               List<CaseMilestone> contactres = new List<CaseMilestone>([select ID,StartDate,CompletionDate from CaseMilestone where CaseID =: c.ID AND MilestoneType.Name = 'Contact Response']);
               if(contactres != null && contactres.size() > 0){
                  if(contactres[0].CompletionDate == null){
                     CaseMilestone cm = new CaseMilestone(ID = contactres[0].ID);
                     cm.completiondate = System.now();
                     Update cm;
                  }
               }  
              
            }
        }
        
        if (sw.Response_Required_Event__c == true || (SelectedResponseOption == 'true' && UserOptionResponseRequired)){
            if(String.valueof(c.OwnerId).substring(0,3) == '005'){
               User u = [select Id,FirstName,LastName from User where ID =: String.valueof(c.OwnerId)];
               ownername = u.FirstName + u.LastName;
            }
            
            Responsiveness__c res = new Responsiveness__c();
            res.Case__c = c.ID;
            res.Start_Time__c = System.now();
            res.Start_Event__c = 'Client Email';
            res.Event_Type__c= 'Follow Up';
            if(String.valueof(c.OwnerId).substring(0,3) == '005'){
               User u1 = [select Name,Primary_Group__c from User where ID =: c.OwnerId]; 
               res.Event_Owner__c = u1.Name;
               res.Event_Owner_Primary_Group__c = u1.Primary_Group__c;
            }else{
               res.Event_Owner__c = c.Primary_Group_Name__c;
               res.Event_Owner_Primary_Group__c = c.Primary_Group_Name__c;
            }

            BusinessHours b1 = [select ID from BusinessHours where Name = 'Default'];
            if(sla != null){
                   if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2'){    
                       res.SLA_Expiry_Time__c =  BusinessHours.add(b1.ID,System.now(), Integer.valueof(sla) * 60 * 60 * 1000L);
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
            if(Workflow == 'Incoming Call')
            {
            c.status =  'Needs Attention';
            update c; 
            }
            if(c.IsClosed == false){
               if(c.Contact_Response_Initiated__c == false){
                  c.Contact_Response_Initiated__c = true;
                  Update c;
               }
               List<CaseMilestone> cm = new List<CaseMilestone>([select ID,StartDate,CompletionDate from CaseMilestone where CaseID =: c.ID AND MilestoneType.Name = 'Contact Response']);
               if(cm != null && cm.size() > 0){
                  if((c.Contact_Response_Initiated__c == false && cm[0].CompletionDate == null) || cm[0].CompletionDate != null){
                      CaseMilestone cm1 = new CaseMilestone(Id = cm[0].ID);
                      cm1.StartDate = System.now();
                      cm1.CompletionDate = null;
                      Update cm1;
                  }
               }
            }       
        }
        try {
        if(SelectedArticleId != Null){
                    
                    try
                    {
                        kav = [Select KnowledgeArticleId, Title, ArticleNumber, Summary 
                               From KnowledgeArticleVersion 
                               Where IsVisibleInCsp = true
                               And KnowledgeArticleId =: SelectedArticleId
                               And PublishStatus = 'Online'
                               And Language = 'en_US'];
                        articleattached = true;
                    }
                    catch (Queryexception e) {}
                }
            note=new Case_Note__c();
            NoteId = note.id;      
            if(workflow =='Need More Info' || workflow =='Update Client' || workflow == 'Suggest Solution' ||workflow =='Outbound Call' )     
            c.Date_Time_Last_Support_Communication__c = System.Now();

            /* -- Case Status Update -- */
            if(sw.Case_Status_Update__c != null && sw.Portal_Status_Update__c != null){
                if(ClosureReason != Null){
                c.Reason = ClosureReason;
                }
          
                c.Status = sw.Case_Status_Update__c;
                c.Last_Activity_Date_Time__c = System.now();
                c.Closed_Comments__c = CommentBody;
                if((SelectedArticleId != Null) && (workflow=='Close Case')  )
                {
                c.Closed_Comments__c = c.Closed_Comments__c +   '<br/><br/> A Knowledge Article has been referenced in this email.  To access it, '+
                     'please click the following link to access the article in Behind the '+
                     'Blackboard.<br/><br/><a href="'+gc.SiteURL+'/btbb_articleview?id='+kav.KnowledgeArticleId+'&cid='+c.Id+'">'+
                     'Article #'+kav.ArticleNumber+' - '+kav.Title+'</a><br/><b>Summary:</b>'+kav.Summary;
                }
            }
            if(sw.Send_Email_To_Customer__c == true)
            {
              c.Last_Activity_Date_Time__c = System.now();
            }
            
            update c;
            /* -- Create a List to Store the Attachments That Were Uploaded by the User -- */
            for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c, Case_Note__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('cid') and UserID__c =:Userinfo.getUserId()]){
                        for(Case_Attachment__c  attlist1 : attlist){
                                if(InternalURL != null){
                                    InternalURL = InternalURL + '<div><a href="/apex/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    InternalURL = '<div><a href="/apex/Linkredirect?id='+attlist1.ID+'">'+attlist1.File_Name__c+'</a></div>';
                                }
                                if(ExternalURL != null){
                                    ExternalURL = ExternalURL + '<div><a href="'+gc.SiteURL+'/Linkredirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }else{
                                    ExternalURL = '<div><a href="'+gc.SiteURL+'/LinkRedirect?id=' + attlist1.ID + '">' + attlist1.File_Name__c + '</a></div>';
                                }
                         attlist1.Case_Note__c = note.id;
                         update attlist1;
                         System.debug(Logginglevel.ERROR , ' ::::::: My Debug :::::::::::::') ;
                        }
                    }

                
                
       /* -- Creates New Solution Detail Record for Suggested Solution Workflow -- */
                if (SolutionWorkflow == true){
                    Solution = new Solution_Detail__c();
                    
                    list<Solution_Detail__c> Solutionlist = [Select id, Case__c, Status__c from Solution_Detail__c Where Case__c =: ApexPages.currentPage().getParameters().get('cid') AND Status__c = 'In Consideration'  ];
                    for(Solution_Detail__c sd:Solutionlist ){
                        if(Solutionlist.size() != null){
                        sd.Status__c = 'Not Considered';
                        update sd;
                        }
                            
                        else{
                        sd.Status__c = 'In Consideration';
                        }
                        
                    }
                    
                    
                    if(sw.Name == 'Close Case' || sw.Name == 'Closed - Pending Target (non-Learn)'){
                        solution.Status__c = 'Successful Resolution';
                        solution.Comments__c = '';
                    }
                    
                    else{
                       solution.Status__c = 'In Consideration';
                    }
                    
                    if(InternalURL != null){
                        if(sw.Name == 'Close Case'){
                            //solution.Description__c = 'Reason : '+ ClosureReason + '<br/><br/>'+ CommentBody + '<br/><br/><b>Attachment(s):</b><br/>'+InternalURL;  temp comm
                            solution.Description__c = '<br>'+ ClosureReason + '<br/><br/>'+ CommentBody + '<br/><br/><b>Attachment(s):</b><br/>'+InternalURL;            
                            solution.Subject__c = 'Close Case';
                        }else if(sw.Name == 'Closed - Pending Target (non-Learn)'){
                         //   solution.Description__c = sw.Email_Introduction__c + '<br/><br/>Comments : <br/><br/>' + CommentBody + '<br/><br/>' + sw.Email_Signature__c + InternalURL;
                            solution.Description__c = CommentBody;
                            solution.Subject__c = 'Closed - Pending Target';
                        }else{
                           solution.Description__c = CommentBody+'<br/><br/><b>Attachment(s):</b><br/>'+InternalURL;
                           solution.Subject__c = 'Solution Suggested';
                        }
                    }else{
                        if(sw.Name == 'Close Case'){
                            //solution.Description__c = 'Reason : '+ ClosureReason + '<br/><br/>'+ CommentBody; temp comm
                            solution.Description__c =  '<br/>'+ CommentBody;
                            solution.Subject__c = 'Close Case';
                        }else if(sw.Name == 'Closed - Pending Target (non-Learn)'){
                          //  solution.Description__c = sw.Email_Introduction__c + '<br/><br/>Comments : <br/><br/>' + CommentBody + '<br/><br/>' + sw.Email_Signature__c;
                           solution.Description__c = CommentBody;
                           solution.Subject__c = 'Closed - Pending Target';
                        }else{ 
                            solution.Description__c = CommentBody;
                            solution.Subject__c = 'Solution Suggested';
                        }
                    } 

                    solution.Article_Id__c = kav.KnowledgeArticleId;
                    solution.Article_Number__c = kav.ArticleNumber;              
                    solution.Article_Title__c = kav.Title;
                    solution.Case__c = ApexPages.currentPage().getParameters().get('cid');
                    insert solution;
                   } 
            
             /* -- Insert's Case Note (Case_Note__c Object) on Save -- */
                if (CommentBody != Null) {
            
                  userinformation = UserInfo.getUserId();
                  
                  if(Workflow == 'Incoming Call' && c.OwnerId != userinformation ){
                      c.New_Case_Comment_Comment_Body__c =  CommentBody;
                      c.incomingcallboolean__c = true;
                      update c; 
                  }
                  
                  else if(Workflow == 'Outbound Call' && c.OwnerId != userinformation ){
                      c.New_Case_Comment_Comment_Body__c =  CommentBody;
                      c.outboundcallboolean__c = true;
                      update c; 
                  }
                  
                  else if(Workflow == 'Internal Note' && c.OwnerId != userinformation ){
                      c.New_Case_Comment_Comment_Body__c =  CommentBody;
                      c.internalnoteboolean__c = true;
                      update c; 
                  } 
                
                
                    if(Attachments != null && Attachments.size() > 0){
                    note.Has_Attachment__c = true;
                    }
                    system.debug(selectedArticleId);
                    if(SelectedArticleId != Null)
                    {
                        //note.Article__c = SelectedArticleId;
                        note.Article_Id__c = kav.KnowledgeArticleId;
                        note.Article_Number__c = kav.ArticleNumber;
                        note.Article_Title__c = kav.Title;
                    }
                    if(sw.Send_Email_To_Customer__c == true){
                    note.To_Address__c = c.Contact.Email;
                    note.Contact__c = c.ContactId;
                    }
                    if(sw.Send_Email_To_Case_Owner__c == true){
                    note.To_Address__c = c.Owner.Email;
                    }
                    note.From_Type__c = 'Employee';
                    note.Incoming_Outgoing__c = 'Outgoing';
                    note.Email_Subject__c = sw.Email_Subject__c;
                    if(sendEmail == true)
                         note.Is_Email__c = true;
                    else
                          note.Is_Email__c = false;
                    if(sw.Name == 'Close Case')
                        note.Type__c = 'Closed by Support';
                    else
                        note.Type__c = sw.Name;
                    if(InternalURL != null){
                        if(sw.Name == 'Close Case')
                            note.Details__c = 'Reason : '+ ClosureReason + '<br/><br/>'+ CommentBody + '<br/><br/><b>Attachment(s):</b><br/>'+InternalURL;        
                        else 
                            note.Details__c = CommentBody+'<br/><br/><b>Attachment(s):</b><br/>'+InternalURL;
                    }else{
                        if(sw.Name == 'Close Case')
                            note.Details__c= 'Reason : '+ ClosureReason + '<br/><br/>'+ CommentBody;
                        else 
                            note.Details__c = CommentBody;
                    } 
                   
                    note.Case__c = c.id;
                    note.Public__c = sw.Publish_to_BTBB__c;
                    insert note;
                    
                    /* -- Insert Attachment Records (Amazon Integration) -- */
                    List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
                        if(note != null && note.ID != null){
                           for(List<Case_Attachment__c> attlist : [SELECT Id, File_Name__c FROM Case_Attachment__c WHERE Id NOT IN: AttachmentID AND Related_To__c = :ApexPages.currentPage().getParameters().get('cid') and UserID__c =:Userinfo.getUserId()]){
                                for(Case_Attachment__c attlist1 : attlist){
                                   Case_Attachment__c ca = new Case_Attachment__c(ID = attlist1.ID);
                                   ca.Case_Note__c = note.ID;
                                   System.Debug('>>>> !!!! >>>> !!!! >>>> !!!! >>>> !!!! NOTEID ====== ====== '+NoteId);
                                   caslist.add(ca);  
                                }
                            } 
                            Update caslist;
                        }
                    }         
            
            if (sendEmail == true) 
            {
                String AcceptMailTo;
                String DeclineMailTo;
                string Emailaddress;
                /* Production Code*/ 
                if(URL.getSalesforceBaseUrl().toExternalForm().contains('na5')||URL.getSalesforceBaseUrl().toExternalForm().containsignorecase('blackboard.my.salesforce'))
                {
                  Emailaddress = ServiceCloudUtility__c.getInstance('Solution Suggested Production').Link__c;  
                  AcceptMailTo = '<a href="mailto:'+Emailaddress+'?subject=Case Number:'+c.CaseNumber+':Response:1:Solution Id:'+solution.id+'" style="font-weight:bold;text-decoration:underline;">Accept/Close Case</a>';
                  DeclineMailTo = '<a href="mailto:'+Emailaddress+'?subject=Case Number:'+c.CaseNumber+':Response:0:Solution Id:'+solution.id+'" style="font-weight:bold;text-decoration:underline;">Decline/Reopen Case</a>';
                }
                else
                { 
                  Emailaddress = ServiceCloudUtility__c.getInstance('Solution Suggested Sandbox').Link__c;  
                  AcceptMailTo = '<a href="mailto:'+Emailaddress+'?subject=Case Number:'+c.CaseNumber+':Response:1:Solution Id:'+solution.id+'" style="font-weight:bold;text-decoration:underline;">Accept/Close Case</a>';
                  DeclineMailTo = '<a href="mailto:'+Emailaddress+'?subject=Case Number:'+c.CaseNumber+':Response:0:Solution Id:'+solution.id+'" style="font-weight:bold;text-decoration:underline;">Decline/Reopen Case</a>';
                }
                
                String EmailSignatureText          =  '\nRegards,\n'+u.Name+'\n'+u.Title;
                String EmailSignatureHTML          =  '<br/><br/>Regards,<br/><br/>'+u.Name+'<br/>'+u.Title;
                
                String CaseSummaryText             =  'Case ID: '+c.CaseNumber+'\nProduct: '+c.Core_License__r.Name+'\nSubject: '+c.Subject;
                String CaseSummaryHTML             =  '<b>Case ID:</b> '+c.CaseNumber+'<br/> <b>Product:</b> '+c.Core_License__r.Name+'<br/> <b>Subject:</b> '+c.Subject;
                string header                      =  '---Please do not edit this ---%#'+c.CaseNumber+'%#'+sw.name+'%#-----';
                
                String CaseUpdateInfoText          =  'To update your case, login to behind.blackboard.com using the link '+
                                                      'below.\n\n'+gc.SiteURL+'/btbb_caseview?id='+c.Id;
                
                String CaseUpdateInfoHTML          =  'To update your case, login to Behind the Blackboard using the link '+
                                                      'below.<br/><br/><a href="'+gc.SiteURL+'/btbb_caseview?id='+c.Id+'" title="Update Case #'+c.CaseNumber+'">'+
                                                      gc.SiteURL+'/btbb_caseview?id='+c.Id+'</a>';
                
                String ArticleAttachedInfoText     =  'A Knowledge Article has been referenced in this email.  To access it,'+
                                                      'click the link provided below.\n\n'+gc.SiteURL+
                                                      '/btbb_articleview?id='+kav.KnowledgeArticleId+'&cid='+c.Id;
                
                String ArticleAttachedInfoHTML     =  'A Knowledge Article has been referenced in this email.  To access it, '+
                                                      'please click the following link to access the article in Behind the '+
                                                      'Blackboard.<br/><br/><a href="'+gc.SiteURL+'/btbb_articleview?id='+kav.KnowledgeArticleId+'&cid='+c.Id+'">'+
                                                       'Article #'+kav.ArticleNumber+' - '+kav.Title+'</a><br/><b>Summary:</b>'+kav.Summary;
                 if(this.c.recordtype.name.containsignorecase('end user'))
                 {
                    CaseUpdateInfoText='';
                    CaseUpdateInfoHTML='';
                     
                  ArticleAttachedInfoText     =  'A Knowledge Article has been referenced in this email.  To access it,'+
                                                      'click the link provided below.\n\n'+gc.SiteURL+
                                                      '/publickbarticleview?id='+kav.KnowledgeArticleId+'&cid='+c.Id;
                
                  ArticleAttachedInfoHTML     =  'A Knowledge Article has been referenced in this email.  To access it, '+
                                                      'please click the following link to access the article in Behind the '+
                                                      'Blackboard.<br/><br/><a href="'+gc.SiteURL+'/publickbarticleview?id='+kav.KnowledgeArticleId+'&cid='+c.Id+'">'+
                                                       'Article #'+kav.ArticleNumber+' - '+kav.Title+'</a><br/><b>Summary:</b>'+kav.Summary;
                 }                                      
                
                /* -- Set the Email Message Attributes and Send the Email -- */
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new String[] {c.Owner.Email};
                
                /* -- Set the Email Recipients (To:) -- */
                if(sendEmailCustomer == true)
                {
                        mail.setTargetObjectId(c.ContactId);
                }
                    
                if(sendEmailInternal == true)
                {
                        mail.setToAddresses(toAddresses);
                }
                    
                /* -- Add Cc Recipients to the Email if Value is Set in the Cc: Field -- */
                
                if(ccRecipients!=NULL && ccRecipients.trim() != '') 
                {
                    ccaddress=ccRecipients.split(';', 0);
                } 
                
                System.debug('ccdonEmail>>>>>>>>>>' + ccdonEmail);
                if(ccdonEmail != null && ccdonEmail.trim() != '')
                {
                    List<String> cc1 = new List<String>();
                    cc1 = ccdonEmail.split(';',0);
                
                    if(ccaddress == null)
                        ccAddress = new List<String>();
                    for(String s : cc1)
                    {
                        ccaddress.add(s);
                    }  
                }
               
                /* -- Set Subject, Signature, and Sender (OrgWideEmailAddressId) -- */
                mail.setSubject('Case ID: '+c.CaseNumber+' '+sw.Email_Subject__c+' Subject: '+SUB+' >>%'+c.CaseNumber+'%'+sw.Name+'%<<'); //TP 5046
                
                /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
                 * CODE MAINTENANCE ACTION ITEM FOR SANDBOX REFRESH
                 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
                 mail.setOrgWideEmailAddressId('0D270000000Gmrt');
                
                 mail.setUseSignature(false);
                 mail.setCcAddresses(ccAddress);
                                
                /* -- Suggest Solution Email Body */
                if(sw.Name == 'Suggest Solution')
                {
                    /* QAX Code */
                    //  mail.setOrgWideEmailAddressId('0D2V00000008Oe1');
                    /* Production Code */
                        mail.setOrgWideEmailAddressId('0D270000000Gmzn');
                    
                    if(articleattached == true && ExternalURL != null)
                       mail.setHtmlBody(' //////// <b>THIS EMAIL HAS A SUGGESTED SOLUTION</b> ////////<br/><br/><b style= "color:blue"> THIS IS AN AUTOGENERATED MAIL PLEASE DO NOT REPLY. KINDLY USE ACCEPT/DECLINE LINKS FOR YOUR RESPONSE</b><br/><br/>To Accept/Decline this solution click one of the links below and you will be prompted to send a new email back to support, the body of which will contain your comments.  Please do not change the email addressee or the subject as this is an automated system and it will cause the email to fail and for support to not get notified.<br/><br/><b>'+AcceptMailTo+' &nbsp; &nbsp; &nbsp; '+DeclineMailTo+'</b><br/><br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+ArticleAttachedInfoHTML+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/><b>Attached File(s):</b><br/><br/>'+ExternalURL+sw.Email_Signature__c);
                    else if(articleattached == true && ExternalURL == null)
                       mail.setHtmlBody(' //////// <b>THIS EMAIL HAS A SUGGESTED SOLUTION</b> ////////<br/><br/><b style= "color:blue"> THIS IS AN AUTOGENERATED MAIL PLEASE DO NOT REPLY. KINDLY USE ACCEPT/DECLINE LINKS FOR YOUR RESPONSE</b><br/><br/>To Accept/Decline this solution click one of the links below and you will be prompted to send a new email back to support, the body of which will contain your comments.  Please do not change the email addressee or the subject as this is an automated system and it will cause the email to fail and for support to not get notified.<br/><br/><b>'+AcceptMailTo+' &nbsp; &nbsp; &nbsp; '+DeclineMailTo+'</b><br/><br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+ArticleAttachedInfoHTML+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/>'+sw.Email_Signature__c+'<br/>');
                    else if(articleattached == false && ExternalURL != null)
                       mail.setHtmlBody(' //////// <b>THIS EMAIL HAS A SUGGESTED SOLUTION</b> ////////<br/><br/><b style= "color:blue"> THIS IS AN AUTOGENERATED MAIL PLEASE DO NOT REPLY. KINDLY USE ACCEPT/DECLINE LINKS FOR YOUR RESPONSE</b><br/><br/>To Accept/Decline this solution click one of the links below and you will be prompted to send a new email back to support, the body of which will contain your comments.  Please do not change the email addressee or the subject as this is an automated system and it will cause the email to fail and for support to not get notified.<br/><br/><b>'+AcceptMailTo+' &nbsp; &nbsp; &nbsp; '+DeclineMailTo+'</b><br/><br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+'<b>Attached File(s):</b><br/><br/>'+ExternalURL+sw.Email_Signature__c);
                    else
                       mail.setHtmlBody(' //////// <b>THIS EMAIL HAS A SUGGESTED SOLUTION</b> ////////<br/><br/><b style= "color:blue"> THIS IS AN AUTOGENERATED MAIL PLEASE DO NOT REPLY. KINDLY USE ACCEPT/DECLINE LINKS FOR YOUR RESPONSE</b><br/><br/>To Accept/Decline this solution click one of the links below and you will be prompted to send a new email back to support, the body of which will contain your comments.  Please do not change the email addressee or the subject as this is an automated system and it will cause the email to fail and for support to not get notified.<br/><br/><b>'+AcceptMailTo+' &nbsp; &nbsp; &nbsp; '+DeclineMailTo+'</b><br/><br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+sw.Email_Signature__c);
                }
                /* -- Standard Email Body -- */
                else 
                {
                    if(articleattached == true && ExternalURL != null)
                       mail.setHtmlBody(header+'<br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+ArticleAttachedInfoHTML+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/>'+'<b>Attached File(s):</b><br/><br/>'+ExternalURL+sw.Email_Signature__c+'<br/><br/>');
                    else if(articleattached == true && ExternalURL == null)
                       mail.setHtmlBody(header+'<br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+ArticleAttachedInfoHTML+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/>'+sw.Email_Signature__c+'<br/><br/>');
                    else if(articleattached == false && ExternalURL != null)
                       mail.setHtmlBody(header+'<br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/><b>Attached File(s):</b><br/><br/>'+ExternalURL+sw.Email_Signature__c+'<br/><br/>');
                    else
                       mail.setHtmlBody(header+'<br/>'+CaseSummaryHTML+'<br/><br/>'+sw.Email_Introduction__c+'<br/><br/>'+CommentBody+'<br/><br/>'+CaseUpdateInfoHTML+'<br/><br/>'+sw.Email_Signature__c+'<br/><br/>');
                }
                
                    if(sendEmailCustomer == true)
                     emailviaworkflow.sendcaseteamemail(c,ccaddress,mail.htmlbody,mail.subject);
                    if(sendEmailInternal == true)
                     emailviaworkflow.sendowneremail(c,ccaddress,mail.htmlbody,mail.subject); 
                }
                if(sendInternalNote == true)
                {  
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                  
                  String CaseSummaryText =  'Case ID: '+c.CaseNumber+'\nProduct: '+c.Core_License__r.Name+'\nSubject: '+c.Subject;
                  String CaseSummaryHTML =  '<b>Case ID:</b> '+c.CaseNumber+'<br/> <b>Product:</b> '+c.Core_License__r.Name+'<br/> <b>Subject:</b> '+c.Subject;
                  String header = 'You are receiving this email because you have been cc\'d on this internal note for the following case:';
                  
                  String[] toAddresses = new String[] {c.Owner.Email};
                  mail.setToAddresses(toAddresses);
                  if(ccRecipients!=NULL && ccRecipients.trim() != '') 
                  {
                    
                    List<String> cc1 = new List<String>();
                    cc1 = ccRecipients.split(';',0);

                    if(ccaddress == null)
                        ccAddress = new List<String>();
                    if(cc1.size() == 1)  
                         ccAddress.add(cc1[0]);
                    for(String s : cc1)
                    {
                        ccaddress.add(s);
                    }  
                  }
                  
                  mail.setSubject('Case ID: '+c.CaseNumber+'Subject: '+SUB+' >>%'+c.CaseNumber+'%'+sw.Name+'%<<');
                  mail.setHtmlBody(header+'<br/><br/>'+CaseSummaryHTML+'<br/><br/>'+'Internal Note : '+CommentBody +'<br/><br/>');
                  mail.setCcAddresses(ccAddress);

                  emailviaworkflow.sendowneremail(c,ccaddress,mail.htmlbody,mail.subject);
                  
                }
               
            }
             catch(System.EmailException emlEx) { 
                                         Database.rollback(sp);
                                          errorshow =true;
                                          errortitle='Error while sending email';
                                          errormessage =emlEX.getMessage();
                                          errorSeverity = 'error';
                                           return null;
                                             
                                                }   
            catch(Exception Ex){
            Database.rollback(sp);
            errorshow =true;
              if(Ex.getmessage().contains('STRING_TOO_LONG'))
        {
            errortitle='Error:';
       errormessage='Comment size exceeded 32768 character limit.';     
        }else
        {
                error_log__c  err_log= new error_log__c();
                 err_log.Error_message__c=Ex.getmessage();
                 err_log.UserID__c=Userinfo.getuserid();
                 err_log.profileID__c=Userinfo.getprofileid();
                 err_log.Line_Number__c=Ex.getLineNumber();
                 err_log.StackTrace__c=Ex.getstacktracestring();
                 err_log.Type__c=Ex.getTypeName();
                 err_log.Related_Record__c=ApexPages.currentPage().getParameters().get('cid');
                 insert err_log;
         error_log__c  err_log2=[select name from error_log__c where id =:err_log.id] ;      
        errortitle='Error#:'+err_log2.name;
        errormessage ='An unexpected error occurred while processing your comment.Kindly contact your System Administrator.';
        }
      
  
       errorSeverity = 'error';
       return null;
            }
            
            /* -- Redirect Back to Case Page -- */
          PageReference Refresh = new PageReference('/'+c.id);
                Refresh.SetRedirect(true);
                return Refresh;
    }
    
    private void loadCannedResponses()
    {
      responseMap = new map<Id, APEX_Email_Template__c>();
    cannedResponseList = new list<SelectOption>();
    hasCannedResponses = false;
    
    for (APEX_Email_Template__c aet : [Select Id, Name, Subject__c, Abstract__c, Html_Body__c, Core_License__c 
                       From APEX_Email_Template__c 
                       Where Core_License__c =: c.Core_License__c Order By Name])
    {
      responseMap.put(aet.Id, aet);
      cannedResponseList.add(new SelectOption(aet.Id, aet.Name));
    }
    
    if (cannedResponseList != null && !cannedResponseList.isEmpty())
    {
      hasCannedResponses = true;
    }
    }
    
  public PageReference displayCannedResponse()
  {
    PageReference pageRef;
    
    if (selectedResponse != null && selectedResponse != '')
    {
      if (responseMap.containsKey(selectedResponse))
      {
        CommentBody = responseMap.get(selectedResponse).Html_Body__c;
      }
    }
    else
    {
      CommentBody = '';
    }
    
    pageRef = Page.CaseComment;
    pageRef.getParameters().put('cid', c.Id);
    if (selectedResponse != null && selectedResponse != '')
    {
      pageRef.getParameters().put('cr', selectedResponse);
    }
    pageRef.setRedirect(true);
    return pageRef;
  }
  
  
  public void actionFunMethod(){
  
  if (selectedResponse != null && selectedResponse != '')
    {
      if (responseMap.containsKey(selectedResponse))
      {
        Mailbodydetails = responseMap.get(selectedResponse).Html_Body__c;
      }
    }
    else
    {
      Mailbodydetails = '';
    }
    
    if (selectedResponse != null && selectedResponse != '')
    {
      ApexPages.currentPage().getParameters().put('cr', selectedResponse);
    }
    
 }
  public APEX_Email_Template__c testTemp {get; set;}

  private static testmethod void casecommentcontrollertest(){
        
        PageReference p = Page.CaseComment;
        Test.setCurrentPage(p);
        Case_Note__c cn = new Case_Note__c();
        Case c = BbTestUtility.createTestSev1Case();
        List<Case_Attachment__c> attachments = new List<Case_Attachment__c>();
        Set<Id> AttachmentID = new Set<ID>();
        ApexPages.CurrentPage().getParameters().Put('cid',c.id);
        ApexPages.StandardController cont = new ApexPages.StandardController(cn);
        CaseCommentController controller = new CaseCommentController (cont);
        controller.ClosureReason = 'User Did Not Attend Training';        
        controller.ClosureReason = 'User Did Not Attend Training';
        String Workflow;
        Workflow = controller.getWorkflow();
        controller.Workflow = 'Close Case';
        Workflow = 'Close Case';
        controller.evaluateWorkflow();
        String csub = c.Subject;
        csub = controller.getSubject();
        System.Assert('subject' == controller.getSubject());
        c.Status = controller.getStatus();
        System.Assert('New' == c.Status);
        String cname = c.Contact.FirstName+' '+c.Contact.LastName;
        cname = controller.getContactName();
        System.Assert('SRVTEST_FIRSTNAME SRVTEST_LASTNAME' == controller.getContactName());
        Contact con = [select firstname, lastname, email from contact where id =:c.contactid];
        con.Email = controller.getContactEmail();
        System.Assert('test@email.com' == controller.getContactEmail());
        List<Case_Attachment__c> attlist = new List<Case_Attachment__c>();
        attlist = [select Id,Name,Bucket_Name__c,File_Name__c from Case_Attachment__c WHERE Related_To__c = : c.id AND ID NOT IN: AttachmentID];
        System.Assert(attlist.size() == 0);
        Case_Attachment__c  catt = new Case_Attachment__c();
        catt.Bucket_Name__c = 'SFDCTest';
        catt.File_Name__c = 'Test.txt';
        catt.Related_To__c = c.ID;
        insert catt;
        String caseID = controller.getCaseID();
        System.Assert(caseID == c.ID);
        String casenum =  controller.getCaseNumber();
        String ownername = controller.getOwnerName();
        String owneremail = controller.getOwnerEmail();
        List<Case_Attachment__c> attlist2 = new List<Case_Attachment__c>();
        attlist2 = [select Id,Name,Bucket_Name__c,File_Name__c from Case_Attachment__c WHERE Related_To__c = : c.id AND ID NOT IN: AttachmentID];
        Attachments  = attlist2;
        System.Assert(attlist2.size() >= 0);
        System.Assert(Attachments != Null);
        boolean dispattach = true;
        attlist = controller.getCaseNoteAttachments();
        dispattach = controller.getdisplayAttach();
        String CommentBody = 'Test';
        controller.CommentBody = CommentBody;
        List<selectOption> cr = new List<selectOption>();
        cr = controller.getClosureReasons();
        controller.AddAttachment();
        List<selectOption> ro = new List<selectOption>();
        ro = controller.ResponseOptions;
        List<selectOption> art = new List<selectOption>();
        art = controller.Articles;
        List<selectOption> wflist = new List<selectOption>();
        wflist = controller.Workflows;
        controller.SelectedResponseOption = 'true';
        controller.Workflow = 'Close Case';
        controller.doSave();
        controller.Cancel();
        controller.getApiUser();
        controller.setErrorTitle('Hello');
        controller.getErrorTitle();
        controller.setErrorTitle2('Hello');
        controller.getErrorTitle2();
        controller.setErrorShow2(false);
        controller.getErrorShow2();
        controller.setErrorShow(false);
        controller.getErrorShow();
        controller.setErrorMessage('Hello');
        controller.getErrorMessage();
        controller.setErrorSeverity('1');
        controller.getErrorSeverity();
        list<AttachmentWrapper>  temp = controller.attachmentList;
    }
 private static testmethod void casecommentcontrollertest1(){
        
        PageReference p = Page.CaseComment;
        Test.setCurrentPage(p);
        Core_License__c test_corelicense = new Core_License__c(Name = 'Learn');
        insert test_corelicense;
        Module__c test_module = new Module__c(Name = 'TestModule',Core_Licence__c = test_corelicense.id);
        Case_Note__c cn = new Case_Note__c();
        Account test_account = new Account(
          Name = 'TestClass University',
          BillingCity = 'Vienna',
          BillingCountry = 'US',
          BillingPostalCode = '22066',
          BillingState = 'VA',
          BillingStreet = '123 Miller Road',
          Learn_Queue__c = 'Learn Primary Group');
          insert test_account;
       Contact test_contact = new Contact(
        FirstName = 'SRVTEST_FIRSTNAME',
        LastName = 'SRVTEST_LASTNAME',
        Email = 'test@email.com',
        Account = test_Account);
        insert test_contact;
      Asset test_asset = new Asset(
      Name = 'TestAsset',
      Core_License__c = test_corelicense.id,
      Status = 'Installed',
      AccountId = test_account.id);
      insert test_asset;
       
        Case c = new Case(
        ContactId = test_contact.id,
        AccountId = test_account.id,
        Subject = 'subject',
        Description = 'description',
        Steps_to_Replicate__c = 'steps to replicate',
        Core_License__c = test_corelicense.id,
        Module__c = test_module.id,
        Status = 'New',
        Case_Severity__c = '1',
        AssetId=test_asset.id,
        Origin = 'Web');
        insert c;
        SLA_Information__c slainfo = new SLA_Information__c(
        CurrencyIsoCode='GBP',
        Core_License__c='Learn',
        Event_Type__c='Followup',
        Severity__c='1');
        Insert slainfo;
        Support_Workflow__c supw = new Support_Workflow__c(Name='Workflow',
        CurrencyIsoCode='GBP',
        Close_Case_License__c='Learn and ANGEL',
        Active__c=True,User_Option_Response_Required__c=TRUE,Support_Response_Event__c=TRUE);
        insert supw;  
       ApexPages.CurrentPage().getParameters().Put('cid',c.id);
       ApexPages.StandardController cont = new ApexPages.StandardController(cn);
       CaseCommentController controller = new CaseCommentController (cont);
       controller.Workflow = 'Close Case'; 
       controller.doSave();
       controller.evaluateWorkflow();
       controller.Workflow = 'Close Case';
       controller.SolutionWorkflow=TRUE;
        controller.doSave();
        controller.Cancel();
        controller.getApiUser();
        controller.setErrorTitle('Hello');
        controller.getErrorTitle();
        controller.setErrorTitle2('Hello');
        controller.getErrorTitle2();
        controller.setErrorShow2(false);
        controller.getErrorShow2();
        controller.setErrorShow(false);
        controller.getErrorShow();
        controller.setErrorMessage('Hello');
        controller.getErrorMessage();
        controller.setErrorSeverity('1');
        controller.getErrorSeverity();
       
       }
       
    }