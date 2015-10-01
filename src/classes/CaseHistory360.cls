public class CaseHistory360 {

    public transient List <CaseHistoryItem> CHIlist            {get; set;}
    public List<Case> Cases                         {get; set;}
    public transient List<CaseHistory> Histories              {get; set;}
    public transient List  <Case_Note__c> Notes                 {get; set;}
    public transient List<CaseSolution> Articles              {get; set;}
    public transient List<CaseArticle> caseArticles           {get; set;}
    public transient List<Solution_Detail__c> Solutions       {get; set;}
    public transient List<Task> tasks                         {get; set;}
    public transient List<Case_Attachment__c> Attachments     {get;set;}
    public transient List<EmailMessage> Emails                {get; set;}
    public transient List<Chirp_Ticket__c> Chirps             {get; set;}
    public String caseID                            {get; set;}
    public Case aCase                               {get; set;}  
    public transient Set<String> prefixSet                    {get; set;}
    private map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>();
  
  public CaseHistory360(){

    CHIlist= new List<CaseHistoryItem>();
    caseId = Apexpages.currentPage().getParameters().get('id'); 
    
    Cases = [Select Id, CaseNumber From Case Where Id =:caseId Limit 1];
    Histories = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue, Case.Status From CaseHistory Where CaseId = :caseId AND Field != 'Escalated_Tier_2__c'];
    Notes = [Select Id, Article_Id__c, Article_Number__c, Article_Title__c, CreatedById, CreatedBy.Name, CreatedDate, Details__c, Type__c, Has_Attachment__c, Article__c, Article__r.SolutionName, Article__r.SolutionNumber, Is_Email__c, Public__c, From_Type__c, Incoming_Outgoing__c From Case_Note__c Where Case__c = :caseId AND (Incoming_Outgoing__c != 'Incoming' OR (Incoming_Outgoing__c = 'Incoming' AND Type__c = 'BTBB Comment')OR (Incoming_Outgoing__c = 'Incoming' AND isDataload__c = true)) ];
    Emails = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, TextBody, HTMLBody, Subject, FromName, ToAddress, MessageDate, hasAttachment, Incoming, Status, FromAddress From EmailMessage Where ParentId = :caseId ];
    Attachments = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, File_Name__c, Content_Type__c, Notes__c, Preview_Link__c, Internal_Only_Attachment__c, Case_Note__c, File_Name_w_ext__c FROM Case_Attachment__c Where Related_to__c = :caseId AND Case_Note__c = null ];
    List<Case_Attachment__c> MigratedAttachment=[Select Id, CreatedById, CreatedBy.Name, CreatedDate, File_Name__c, Content_Type__c, Notes__c, Preview_Link__c, Internal_Only_Attachment__c, Case_Note__c, File_Name_w_ext__c FROM Case_Attachment__c Where Related_to__c = :caseId AND Case_note__r.isDataload__c=true AND Case_Note__c IN :Notes ];
    Solutions = [Select Id, Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, Description__c, Comments__c, Subject__c, Status__c, Article__c, Article__r.SolutionNumber, Article__r.SolutionName, Article_Id__c, Article_Number__c, Article_Title__c From Solution_Detail__c Where Case__c = :caseId];
    Chirps = [Select Id, Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, Subject__c, Details__c, Priority__c, Status__c From Chirp_Ticket__c Where Case__c = :caseId];
    Articles = [Select SolutionId, CreatedById, CreatedBy.Name, CreatedDate, Solution.SolutionNumber, Solution.SolutionName, Solution.Summary__c From CaseSolution Where CaseId = :caseId];
    // Added by Dominic on 8/9/2012
    caseArticles = [Select c.KnowledgeArticleId, c.Id, c.CreatedDate, c.CreatedById, c.CreatedBy.Name, c.CaseId, c.ArticleVersionNumber, c.ArticleLanguage From CaseArticle c Where CaseId =: caseId];
    if (caseArticles != null && !caseArticles.isEmpty())
    {
        set<Id> articleIdSet = new set<Id>();
        for (CaseArticle ca : caseArticles)
        {
            if (ca.KnowledgeArticleId != null)
            {
                articleIdSet.add(ca.KnowledgeArticleId);
            }
        }
        for (KnowledgeArticleVersion kav : [Select KnowledgeArticleId, Title, ArticleNumber, Summary, UrlName 
                                            From KnowledgeArticleVersion 
                                            Where IsVisibleInCsp = true
                                            And KnowledgeArticleId IN : articleIdSet
                                            And PublishStatus = 'Online'
                                            And Language = 'en_US'])
        {
            kavMap.put(kav.KnowledgeArticleId, kav);
        }
    }
    prefixSet=new Set<String>();
    Map<String, Schema.SObjectType> gD = Schema.getGlobalDescribe();
    Set<String>keys=gD.keySet();
        
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
        
/* * * * * * * * * * * * * CASEHISTORIES * * * * * * * * * * * * */   

        for(CaseHistory ch : Histories) {
            oldVal=String.valueOf(ch.oldValue);
            newVal=String.valueOf(ch.newValue);
      
            if(isId(oldVal)||isId(newVal)){
                Subject=null;
            } else  if(newVal == null) {
                Subject = null;
            } else {
            if(ch.Case.Status == 'New' && ch.Field == 'Owner')
                Subject = 'Support Case Created and Assigned to <b>'+newVal+'</b>';
            else if(ch.Field == 'Status'){
                
                if(oldval=='Researching'&&newval=='Needs Attention')
                    Subject = 'Status Changed to <b>' + newVal + '</b>'; 
                else if(newVal == 'Reopened' || newVal == 'Needs Attention' || newVal == 'Closed' || newVal == 'Solution Suggested' || newVal == 'Pending User')
                    Subject = null; 
                else
                    Subject = 'Status Changed to <b>' + newVal + '</b>';
            } else {
            if(ch.Field == 'Primary_Group_Name__c' && ch.Case.Status != 'New')
                Subject = 'Primary Group Assigned to <b>' + newVal + '</b>';
            else if(oldVal != null && newVal != null)
                Subject = ch.Field + ' Changed from <b>' + oldVal + '</b> to <b>' + newVal + '</b>';
            else if(oldVal == null && ch.Field != 'Primary_Group_Name__c')
                Subject = ch.Field + ' Set to <b>' + newVal +  '</b>';
            else
                Subject = null;
            }
            if(Subject != Null){
                  CHIlist.add(new CaseHistoryItem(ch.CreatedDate, Subject, null, null, ch.CreatedBy.Name, ch.CreatedById, ch.Id, 'Transaction', false, false, 'Private'));  
             }
            }
           }

/* * * * * * * * * * * * * EMAILMESSAGES * * * * * */  
        
        for(EmailMessage em : Emails) {
            if(em.Incoming == true && em.FromName != 'Bb Support') {
                List<String> emailSubject=new list<string>();
                if(em.subject!=null)
                {
                 emailSubject = String.valueOf(em.Subject).split('>');
                }
                else
                {
                 emailSubject.add('');
                }
                if(em.HasAttachment == true)
                Subject = emailSubject[0] + ' from ' + em.FromName + ' <a href="/' + em.Id + '";>View Email Attachments</a>';
                else
                Subject = emailSubject[0] + ' from ' + em.FromName;              
                Summary = em.TextBody;
                system.debug('Email--'+em.id+em.textbody);
                if(em.Htmlbody != null && em.Htmlbody !='' && !em.Htmlbody.contains('[Message Clipped]'))
                {
                Details = em.HtmlBody;
                }
                else if(em.textbody != null && em.textbody !='')
                {
                    system.debug('Email--'+em.id);
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
                CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.FromName, em.CreatedById,  em.Id, 'Email', em.HasAttachment, em.Incoming, 'Public'));
               }
            if(em.Incoming == false && em.Subject.contains('Case Number')){
                List<String> emailSubject2 = String.valueOf(em.Subject).split('\\[');
                Subject = emailSubject2[0];
                Summary = em.textbody;
                Details = em.textbody;
                if(Details != null)
                    Details = Details.replaceAll('[\\n]|[\\r]','<br/>');
                CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.FromName, em.CreatedById,  em.Id, 'Email', em.HasAttachment, em.Incoming, 'Public'));
            }
            }
/* * * * * * * * * * * * * CASE_NOTE__C * * * * * * * * * * * * */
        
        for(Case_Note__c em : Notes){
        String Category = ' ';
        String Visibility = ' ';
        Boolean isIncoming;
        
        String DetailsFix = ' ';
        String SummaryFix = ' ';
        
        if(em.is_Email__c == true)
            Category = 'Email';
        else if(em.Type__c.contains('call') || em.Type__c.contains('Call'))
            Category = 'Phone Call';
        else
            Category = em.Type__c;
        
        if(em.Public__c == true)
            Visibility = 'Public';
        else
            Visibility = 'Private';

        if(em.From_Type__c == 'Customer' || em.Incoming_Outgoing__c == 'Incoming' || em.Type__c == 'BTBB Comment')
            isIncoming = true;
        else
            isIncoming = false;

            if(em.Article_Id__c == null){
               Details = em.Details__c;
               if(Details!= null) {
                if(!(Details.contains('<li>')&&Details.contains('</li>')))//added for TP1953
                 Details = Details.replaceAll( '[\\r]|[\\n]' , '<br/>' );
                Details = Details.replaceAll( '</p><br/><p><br/>' , '<br/><br/>' );
               }
            } else {
                 Details = '<b>Article Attached:</b><br/><a class="article_link" onclick="articlelink(\''+em.Article_Id__c + '\')"  href="#">' + em.Article_Number__c + ' ' + em.Article_Title__c + '</a><br/><br/>' + em.Details__c;
            }
            for(Case_Attachment__c att: MigratedAttachment)
            {
                if(att.Case_Note__c==em.id)
                {
                    Details+='<br/>Attachment: <a href="/apex/Linkredirect?id=' + att.Id + '">' + att.File_Name__c + '</a>';
                    em.Has_Attachment__c=true;
                }
            }
            if(em.Type__c == 'Email' && em.From_Type__c == 'Customer')
            Subject = em.Email_Subject__c;
            else
            Subject = em.Type__c;
            Summary = em.Details__c;
            if(Summary!=null)
            Summary = Summary.replaceAll( ' \\/\\<\\/?[^>]+(>|$)/g ' , ' ' );
            if(em.Type__c != 'Suggest Solution')
            CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.CreatedBy.Name, em.CreatedById,  em.Id, Category, em.Has_Attachment__c, isIncoming, Visibility));
        }
        
        

/* * * * * * * * * * * * * CHIRP_TICKETS__R * * * * * * * * * * * */

        for(Chirp_Ticket__c ca : Chirps){
            Details = ca.Details__c;
            Subject='<strong>CHIRP Ticket #:</strong>  <a href="#" class="chirp_link" onclick="chirplink(\''+ca.id+'\')" >'+ca.Name+' - '+ca.Subject__c+'</a> - <strong>Status:</strong>  '+ca.Status__c;
            CHIlist.add(new CaseHistoryItem(ca.CreatedDate, Subject, Details, null,  ca.CreatedBy.Name, ca.CreatedById, ca.Id,'CHIRP Ticket', false, false, 'Private'));
        }

/* * * * * * * * * * * * * CASESOLUTIONS * * * * * * * * * * * * */
        
        for(CaseSolution cs: Articles){
            Details = cs.Solution.Summary__c;
            Subject = '<b>Article Attached to Case: </b><a href="/apex/ArticleRedirect?id='+cs.SolutionId+'&isdtp=vw" target="_blank" style="color:blue;">Article #'+cs.Solution.SolutionNumber+' - '+cs.Solution.SolutionName+'</a>';
            Summary= cs.Solution.Summary__c;
            if(Summary != null)
                Summary = Summary.replaceAll( '\\/\\<\\/?[^>]+(>|$)/g' , '');
            CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Article', false, false, 'Public'));
        }

// Added by Dominic on 8/9/2012
/* * * * * * * * * * * * * CASEARTICLES * * * * * * * * * * * * */
        
        for(CaseArticle cs: caseArticles)
        {
            if (kavMap.containsKey(cs.KnowledgeArticleId))
            {
                Subject = '<b>Knowledge Article Attached to Case: </b><a href="/apex/ArticleRedirect?id=' + cs.KnowledgeArticleId + 
                    '&isdtp=vw" target="_blank" style="color:blue;">Article #' + kavMap.get(cs.KnowledgeArticleId).ArticleNumber + ' - ' + 
                    kavMap.get(cs.KnowledgeArticleId).Title + '</a>';
                Summary= kavMap.get(cs.KnowledgeArticleId).Summary;
                Details = kavMap.get(cs.KnowledgeArticleId).Summary;
                if(Summary != null)
                    Summary = Summary.replaceAll( '\\/\\<\\/?[^>]+(>|$)/g' , '');
                CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Article', false, false, 'Public'));
            }
        }

/* * * * * * * * * * * * * CASE_ATTACHMENT__R * * * * * * * * * * * * */

        for(Case_Attachment__c cs: Attachments){
            Details = cs.Notes__c;
            Subject = '<b>Attachment</b>';
            Summary=  '<a href="/apex/LinkRedirect?id='+cs.Id+'">'+cs.File_Name_w_Ext__c+'</a>';
            CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Attachment', true, true, 'Public'));
        }

/* * * * * * * * * * * * * SOLUTION_DETAILS__R * * * * * * * * * * * * */

        for(Solution_Detail__c sd : Solutions){
            Subject= '<b>Solution Suggested</b> - <i>Status: '+sd.Status__c+'</i>';
            if(sd.Article_Id__c != null)
            {
                Details = '<div><b>Article:</b> <a href="apex/ArticleRedirect?id=' + sd.Article_Id__c + '">Article #' + sd.Article_Number__c + ' ' + sd.Article_Title__c + 
                    '</a><div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b> ' + sd.Description__c + 
                    '</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/> ' + sd.Comments__c + '</div>';
            }
            else
            {
                Details = '<div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b><br/>'+sd.Description__c+'</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/> '+sd.Comments__c+'</div>';
            }
            Summary=  sd.Description__c;
            if(Summary!= null)
            Summary = Summary.replaceAll( '\\/<\\/?[^\\>]+(>|$)/g' , '');
            if(Subject != Null)
            CHIlist.add(new CaseHistoryItem(sd.CreatedDate, Subject, Details, Summary, sd.CreatedBy.Name, sd.CreatedById, sd.Id,'Solution', false, false, 'Public'));
        }
}
/* * * * * * * * * * * * * End Constructor * * * * * * * * * * * * */
        
        public boolean isId(String at){
        if(at==null)
          return false;   
        else if(at.length()<5)
          return false;
        else{ 
          String testVal = at.substring(0,3);
          if(prefixset.contains(testVal))
          return true;     
    /*    for(String prefix : prefixSet){
          if(prefix.equals(testVal))
              return true;
          }*/
        }
        return false;
        }

    public String getUserType(){
        return UserInfo.getUserType();
    }
  
    public String getUserProfileId(){
        return UserInfo.getProfileId();
    }

    public String getCaseNumber(){
        return Cases[0].CaseNumber;
    }
    public PageReference exportToPDF() {
        
        return Page.CaseHistory360PDF;
    }
    
    public PageReference backtocase(){
    PageReference pageRef = new PageReference('/'+ caseId);
    return pageRef;
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
    public String Details         {get
        { if(Details!=null)
            return Details.replace('<script>','&lt;script&gt;');
          else
          return Details;
        } set;}
        
     public String Subject         {get
        {
            if(Subject!=null)
            return subject.replace('<script>','&lt;script&gt;');
            else
            return Subject;
        } set;}
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
    
    CaseHistoryItem(Datetime aCreateDate, String aSubject, String aDetails, String aSummary, String aCreatedName, String aCreatedId, String aMainId, String aType, boolean aHasAttachments, boolean aIsIncoming, string aExternal){
          isIncoming = aIsIncoming;
          hasAttachments = aHasAttachments;
          createdDate = aCreateDate;
          external = aExternal;
          createDateFix = createdDate.format('MM/d/yyyy hh:mm:ss a');
          Details=aDetails;
          summary=aSummary;
          Matcher addMatcher;
              if(Details != null )
              {
              Details = Details.replaceall('</div>\n','</div>');
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
                  
          Subject = aSubject;
          createdName = aCreatedName;
          createdId = aCreatedId;
          mainId = aMainId;
          itemType = getTypeImageMap(aType,aHasAttachments,aIsIncoming, aExternal);
          itemTypeName = aType;
    }
    
    private String getTypeImageMap(String aType, Boolean aHasAttachments, Boolean aIsIncoming, String aExternal){
      if (aType=='Transaction')
        return '/resource/1320414452000/supporticons/icons/32x32/process.png';
      else if(aType=='Attachment')
        return '/resource/1320414452000/supporticons/icons/32x32/attachment.png';
      else if(aType=='Article')
        return '/resource/1320414452000/supporticons/icons/32x32/full_page.png';
      else if(aType=='Solution')
        return '/resource/1320414452000/supporticons/icons/32x32/light_bulb.png';
      else if(aType=='CHIRP Ticket')
        return '/resource/1320414452000/supporticons/icons/32x32/tools.png';
      else if(aType=='BTBB Comment' && aHasAttachments == true)
        return '/resource/1320414452000/supporticons/icons/32x32/user_comment_attachment.png';
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
      else if(aType.contains('Escalated'))
        return '/resource/1320414452000/supporticons/icons/32x32/process_warning.png';
      else if(aType.Contains('Reopen'))
        return '/resource/1320414452000/supporticons/icons/32x32/refresh.png';
      else if(aType.Contains('Closed'))
        return '/resource/1320414452000/supporticons/icons/32x32/accept.png';
      else if(aType.contains('call') || aType.contains('Call'))
        return '/resource/1320414452000/supporticons/icons/32x32/mobile.png';
      else if( aHasAttachments != True && (aType == 'Internal Note' || (aExternal == 'Private' && aType != 'Transaction')))
        return '/resource/1320414452000/supporticons/icons/32x32/lock.png';
      else if(aType == 'Internal Note' && aHasAttachments == true)
        return '/resource/1320414452000/supporticons/icons/32x32/internal_attachment.png';
      else if(aType == 'Comment')
          return '/resource/1320414452000/supporticons/icons/32x32/user_comment.png';
      else
          return '/resource/1320414452000/supporticons/icons/32x32/full_page.png';
    }
    
   
   
  }
   //Method Written on 21st March by Abhinav for sorting list by date
   public List<CaseHistoryItem> getCaseHistoryItemSort(){      
      
       CaseHistoryItem temp ;
            
        for(Integer i=0;i<CHIlist.size();i++){
        
            for(Integer j=1;j<CHIlist.size()-i;j++)
            {               
             
                if(CHIlist[j-1].CreatedDate < CHIlist[j].CreatedDate ){
                    temp = CHIlist[j-1];
                    CHIlist[j-1] = CHIlist[j] ;
                    CHIlist[j] = temp;
                }
             }
        }
        return CHIlist;
    } 
  
 
}