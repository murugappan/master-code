public class SI{

public transient List<CaseHistoryItem> SIHistories {get;set;}
public String SIiD                            {get; set;}


public learnJIRA__C SInumber {get;set;}
    
    ///////////////
    public transient List <CaseHistoryItem> CHIlist            {get; set;}
    public List<Case> Cases                         {get; set;}
    public transient List<learnJIRA__History> Historiess              {get; set;}
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
    public transient List<learnJIRA__c > SI {get;set;} 
    public Case aCase                               {get; set;}  
    public transient Set<String> prefixSet                    {get; set;}
    private map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>();
  
  public SI(){

    CHIlist= new List<CaseHistoryItem>();
    
    
    SIid= Apexpages.currentPage().getParameters().get('id');
    SInumber = [Select id,CreatedDate, Name from learnJIRA__c where id=:SIid];
    
    //caseId = Apexpages.currentPage().getParameters().get('id'); 
    
   //Cases = [Select Id, CaseNumber From Case Where Id =:caseId Limit 1];
   Historiess = [SELECT CreatedById, CreatedBy.name,CreatedDate,Field,Id,IsDeleted,ParentId,OldValue,NewValue  FROM learnJIRA__History where ParentId =:SIid];
  // Histories = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue, Case.Status From CaseHistory Where CaseId = :caseId AND Field != 'Escalated_Tier_2__c'];
    
    //Notes = [Select Id, Article_Id__c, Article_Number__c, Article_Title__c, CreatedById, CreatedBy.Name, CreatedDate, Details__c, Type__c, Has_Attachment__c, Article__c, Article__r.SolutionName, Article__r.SolutionNumber, Is_Email__c, Public__c, From_Type__c, Incoming_Outgoing__c From Case_Note__c Where Case__c = :caseId AND (Incoming_Outgoing__c != 'Incoming' OR (Incoming_Outgoing__c = 'Incoming' AND Type__c = 'BTBB Comment')) ];
    // Emails = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, TextBody, HTMLBody, Subject, FromName, ToAddress, MessageDate, hasAttachment, Incoming, Status, FromAddress From EmailMessage Where ParentId = :caseId ];
    Attachments = [Select Id, CreatedById, CreatedBy.Name, CreatedDate, File_Name__c, Content_Type__c, Notes__c, Preview_Link__c, Internal_Only_Attachment__c, Case_Note__c, File_Name_w_ext__c FROM Case_Attachment__c Where support_incident__c = :SIid AND Case_Note__c = null ];
    //Solutions = [Select Id, Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, Description__c, Comments__c, Subject__c, Status__c, Article__c, Article__r.SolutionNumber, Article__r.SolutionName, Article_Id__c, Article_Number__c, Article_Title__c From Solution_Detail__c Where Case__c = :caseId];
    //Chirps = [Select Id, Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate, Subject__c, Details__c, Priority__c, Status__c From Chirp_Ticket__c Where Case__c = :caseId];
    //Articles = [Select SolutionId, CreatedById, CreatedBy.Name, CreatedDate, Solution.SolutionNumber, Solution.SolutionName, Solution.Summary__c From CaseSolution Where CaseId = :caseId];
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
        String Category;
        String Category1;
        String Subject;
        String Summary;
        String Details;
        String SIDetails;
        String oldVal;
        String newVal;
        String Subject_email;
        String Subject_comment;
        String Subject_phonecall;
        String to;
        
/* * * * * * * * * * * * * CASEHISTORIES * * * * * * * * * * * * */   

//SIHistories = new List<CaseHistoryItem>();           
//for(learnJIRA__History lh: [SELECT CreatedById, CreatedBy.name,CreatedDate,Field,Id,IsDeleted,ParentId,OldValue,NewValue  FROM learnJIRA__History where ParentId =:SIid]){
//SIHistories.add(new CaseHistoryItem(lh.CreatedDate,null,'<b>' + lh.Field + '</b> changed from <b>' + lh.OldValue + '</b> to <b>' + lh.NewValue + '</b>',null,lh.CreatedBy.name,null,null,lh.Id,null,null,null));
//}
/*for(learnJIRANote__c lhh: [SELECT name,CreatedById,Details_HTML__c,Title__c, CreatedBy.name,CreatedDate from learnJIRANote__c  where Support_Incident__c=:SIid]){
SIHistories.add(new CaseHistoryItem(lhh.CreatedDate,lhh.Title__c,lhh.Details_HTML__c,lhh.Title__c,lhh.CreatedBy.name,null,null,null,null,null,null));
} */
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           

/* * * * * * * * * * * * * EMAILMESSAGES * * * * * */  
        
        /* for(EmailMessage em : Emails) {
            if(em.Incoming == true && em.FromName != 'Bb Support') {
                List<String> emailSubject = String.valueOf(em.Subject).split('>');
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
                     string temp=(em.TextBody).replaceAll('[\\n]|[\\r]','<br/>');
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
            } */
/* * * * * * * * * * * * * CASE_NOTE__C * * * * * * * * * * * * */
/*for(learnJIRANote__c lhh: [SELECT name,CreatedById,Details_HTML__c,Title__c, CreatedBy.name,CreatedDate from learnJIRANote__c  where Support_Incident__c=:SIid]){
SIHistories.add(new CaseHistoryItem(lhh.CreatedDate,lhh.Title__c,lhh.Details_HTML__c,lhh.Title__c,lhh.CreatedBy.name,null,null,null,null,null,null));
} */


 SIHistories = new List<CaseHistoryItem>(); 
 for(learnJIRANote__c em : [SELECT name,CreatedById,Details_HTML__c,Title__c, CreatedBy.name,CreatedDate from learnJIRANote__c  where Support_Incident__c=:SIid]){
        
            Category = 'SI Notes';        
            Subject = em.Title__c;
            Summary = em.Details_HTML__c;
            if(Summary!=null)
            
            //CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.CreatedBy.Name, em.CreatedById,  em.Id, Category, em.Has_Attachment__c, isIncoming, Visibility));
            SIHistories.add(new CaseHistoryItem(em.CreatedDate,Subject,null,Summary,em.CreatedBy.name,null,em.Id,Category,null,null,null));
        } 
     Datetime dt = SINumber.CreatedDate; 
     dt = dt.addSeconds(10);
       
     for(learnJIRA__History lh:[SELECT CreatedById, CreatedBy.name,CreatedDate,Field,Id,IsDeleted,ParentId,OldValue,NewValue  FROM learnJIRA__History where ParentId =:SIid]){
       
        if(lh.OldValue == null){
                Summary=null;
            } else  if(lh.NewValue == null) {
                Summary = null;
            }
            Summary = null;
            //if(lh.Field == 'Status__c'){
            //Summary = 'Status Changed to <b>' + lh.NewValue + '</b>';
            //}
            
            if(lh.Field == 'Primary_Group__c'  && dt < lh.CreatedDate){
            Summary = 'Primary Group Changed to <b>' + lh.NewValue + '</b>';
            }
            
            if(lh.Field == 'Owner' && !isId(string.valueof(lh.oldvalue)) && !isId(string.valueof(lh.newvalue)) && dt < lh.CreatedDate) {
            system.debug(lh);
            Summary = 'Owner changed from <b>'+ lh.OldValue +' to ' + lh.NewValue + '</b>';
            }
            
            
            string st = lh.Field;
            if(st.indexof('__c')!= -1){
            system.debug(st);
            system.debug(st.indexof('__c'));
            st= st.substring(0,st.indexof('__c'));
            st= st.replace('_',' ');
            Summary = st + ' Changed to <b>' + lh.NewValue + '</b>';
            }
            
            //if(lh.Field == 'Reviewed__c'){
          //Summary = 'Reviewed Changed to <b>' + lh.NewValue + '</b>';
            //}
            
            //if(lh.Field == 'Resolution__c'){
            //Summary = 'Resolution Changed to <b>' + lh.NewValue + '</b>';
            //}
            
                    
            //Category1 = 'SI Notes';
            //else if(lh.OldValue != null && lh.NewValue != null && !isId(string.valueof(lh.oldvalue)) && !isId(string.valueof(lh.newvalue))){
                //Summary = '<b>' + lh.Field + '</b> changed from <b>' + lh.OldValue + '</b> to <b>' + lh.NewValue + '</b>';
           // }
            if(Summary != null){
            //CHIlist.add(new CaseHistoryItem(em.CreatedDate, Subject, Details, Summary, em.CreatedBy.Name, em.CreatedById,  em.Id, Category, em.Has_Attachment__c, isIncoming, Visibility));
            SIHistories.add(new CaseHistoryItem(lh.CreatedDate,null,null,Summary,lh.CreatedBy.name,null,lh.Id,'Transaction',null,null,null));
            }
        }   
        
        
        
        
        
        
        
        
        
        
        


/* * * * * * * * * * * * * CHIRP_TICKETS__R * * * * * * * * * * * */

       /* for(Chirp_Ticket__c ca : Chirps){
            Details = ca.Details__c;
            Subject='<strong>CHIRP Ticket #:</strong>  <a href="#" class="chirp_link" onclick="chirplink(\''+ca.id+'\')" >'+ca.Name+' - '+ca.Subject__c+'</a> - <strong>Status:</strong>  '+ca.Status__c;
            CHIlist.add(new CaseHistoryItem(ca.CreatedDate, Subject, Details, null,  ca.CreatedBy.Name, ca.CreatedById, ca.Id,'CHIRP Ticket', false, false, 'Private'));
        } */

/* * * * * * * * * * * * * CASESOLUTIONS * * * * * * * * * * * * */
        
        /* for(CaseSolution cs: Articles){
            Details = cs.Solution.Summary__c;
            Subject = '<b>Article Attached to Case: </b><a href="/apex/ArticleRedirect?id='+cs.SolutionId+'&isdtp=vw" target="_blank" style="color:blue;">Article #'+cs.Solution.SolutionNumber+' - '+cs.Solution.SolutionName+'</a>';
            Summary= cs.Solution.Summary__c;
            if(Summary != null)
                Summary = Summary.replaceAll( '\\/\\<\\/?[^>]+(>|$)/g' , '');
            CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Article', false, false, 'Public'));
        } */
        
        //------------------SI
        
        //for(learnJIRA__c lj: SI){
            //SIDetails = lj.learnJIRA__c .Status__c;
            //Subject = '<b>Article Attached to Case: </b><a href="/apex/ArticleRedirect?id='+cs.SolutionId+'&isdtp=vw" target="_blank" style="color:blue;">Article #'+cs.Solution.SolutionNumber+' - '+cs.Solution.SolutionName+'</a>';
            //Summary= cs.Solution.Summary__c;
            //if(Summary != null)
               // Summary = Summary.replaceAll( '\\/\\<\\/?[^>]+(>|$)/g' , '');
            //CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, SIDetails, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Article', false, false, 'Public'));
        //}
        
        
        
        
        //-----------------------End SI

// Added by Dominic on 8/9/2012
/* * * * * * * * * * * * * CASEARTICLES * * * * * * * * * * * * */
        
       /* for(CaseArticle cs: caseArticles)
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
        } */

/* * * * * * * * * * * * * ATTACHMENT__R * * * * * * * * * * * * */

        for(Case_Attachment__c cs: Attachments){
            Details = cs.Notes__c;
            Subject = '<b>Attachment</b>';
            Summary=  '<a href="/apex/LinkRedirect?id='+cs.Id+'">'+cs.File_Name_w_Ext__c+'</a>';
           // CHIlist.add(new CaseHistoryItem(cs.CreatedDate, Subject, Details, Summary, cs.CreatedBy.Name, cs.CreatedById, cs.Id,'Attachment', true, true, 'Public'));
            SIHistories.add(new CaseHistoryItem(cs.CreatedDate,Subject,Details,Summary,cs.CreatedBy.Name,cs.CreatedById,cs.Id,'Attachment',true,true,'Public'));
        } 

/* * * * * * * * * * * * * SOLUTION_DETAILS__R * * * * * * * * * * * * */

        /*for(Solution_Detail__c sd : Solutions){
            Subject= '<b>Solution Suggested</b> - <i>Status: '+sd.Status__c+'</i>';
            if(sd.Article_Id__c != null)
            {
                Details = '<div><b>Article:</b> <a href="apex/ArticleRedirect?id=' + sd.Article_Id__c + '">Article #' + sd.Article_Number__c + ' ' + sd.Article_Title__c + 
                    '</a><div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments:</b> ' + sd.Description__c + 
                    '</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/> ' + sd.Comments__c + '</div>';
            }
            else
            {
                Details = '<div style="display:block;padding:15px;margin-top:15px;border: 1px solid #999;"><b>Support Comments: </b>'+sd.Description__c+'</div><div style="padding:15px;margin-top:15px;background:#F0F0F0;color:#222;"><b>Customer Comments:</b><br/> '+sd.Comments__c+'</div>';
            }
            Summary=  sd.Description__c;
            if(Summary!= null)
            Summary = Summary.replaceAll( '\\/<\\/?[^\\>]+(>|$)/g' , '');
            if(Subject != Null)
            CHIlist.add(new CaseHistoryItem(sd.CreatedDate, Subject, Details, Summary, sd.CreatedBy.Name, sd.CreatedById, sd.Id,'Solution', false, false, 'Public'));
        }*/
}
/* * * * * * * * * * * * * End Constructor * * * * * * * * * * * * */
        
        /* public boolean isId(String at){
        if(at==null)
        return false;   
        else if(at.length()<5)
        return false;
        else{ 
        String testVal = at.substring(0,3);
        if(prefixset.contains(testVal))
        return true;     
        }
        return false;
        } */

    /*public String getUserType(){
        return UserInfo.getUserType();
    }
  
    public String getUserProfileId(){
        return UserInfo.getProfileId();
    }

    public String getCaseNumber(){
        return Cases[0].CaseNumber;
    } */
    public PageReference exportToPDF() {
        
        return Page.SIhistorypdf;
    } 
    
    public PageReference backtoSI(){
    PageReference pageRef = new PageReference('/'+ SIid);
    return pageRef;
    }
    
    
    public pagereference sinote(){
        PageReference pageRef = new PageReference('/a1q/e');
        pageRef.setRedirect(true); 
    return pageref;
    }
      
  public Class CaseHistoryItem{
    
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
    
    CaseHistoryItem(Datetime aCreateDate, String aSubject, String aDetails, String aSummary, String aCreatedName, String aCreatedId, String aMainId, String aType, boolean aHasAttachments, boolean aIsIncoming, string aExternal){
          isIncoming = aIsIncoming;
          hasAttachments = aHasAttachments;
          createdDate = aCreateDate;
          external = aExternal;
          createDateFix = createdDate.format('MM/d/yyyy hh:mm:ss a');
          Details = aDetails;
          Subject = aSubject;
          Summary = aSummary;
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
      //else if(aType.contains('Escalated'))
        //return '/resource/1320414452000/supporticons/icons/32x32/process_warning.png';
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
        
        
   //Method Written on 21st March by Abhinav for sorting list by date
   public List<CaseHistoryItem> getCaseHistoryItemSort(){      
      
       CaseHistoryItem temp ;
            
        for(Integer i=0;i<SIHistories.size();i++){
        
            for(Integer j=1;j<SIHistories.size()-i;j++)
            {               
             
                if(SIHistories[j-1].CreatedDate < SIHistories[j].CreatedDate ){
                    temp = CHIlist[j-1];
                    SIHistories[j-1] = SIHistories[j] ;
                    SIHistories[j] = temp;
                }
             }
        }
        return SIHistories;
    } 
  
  
  
}