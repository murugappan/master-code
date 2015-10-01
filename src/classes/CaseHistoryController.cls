public class CaseHistoryController {

  public boolean FullComment            {get; set;}
  public List<CaseHistoryItem> CHIlist  {get; set;}
  public Case aCase                     {get; set;}
  public String caseID                  {get; set;}
  public List<Task> tasks               {get; set;}
  public boolean showAll                {get; set;}
  public Set<String> prefixSet          {get; set;}
  public Boolean showFullDesc           {get; set;}
  public Boolean showPublicOnly         {get; set;}
  public Boolean showAttachments        {get; set;}
  public Boolean showEmails             {get; set;}
  public Boolean HidePrivate            {get; set;}
  
  public CaseHistoryController(){
    CHIlist= new List<CaseHistoryItem>();
    caseId = Apexpages.currentPage().getParameters().get('id'); 
    aCase = [select CaseNumber, Account.Name, AccountId, Subject, Contact.Name, ContactId, Status, CreatedDate,
    (Select Id, CreatedById, CreatedBy.Name, WhatId, What.Name, Subject, ActivityDate, Status, OwnerId, Description, CreatedDate, Owner.Name,External__c, Type, Who.Name From Tasks),
    (Select Id, CreatedDate, CreatedBy.Name, CreatedById, CommentBody From CaseComments),
    (Select Id, CreatedById, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue From Histories),
    (Select Id, CreatedById, CreatedBy.Name, CreatedDate, TextBody, HTMLBody, Subject, FromName, ToAddress, MessageDate From EmailMessages),
    (Select Id, CreatedById, CreatedBy.Name, CreatedDate, File_Name__c, Content_Type__c, Notes__c, Preview_Link__c FROM Case_Attachment__r) 
    from Case where id = :caseID];
    setupTasks(aCase);
    setupAttachments(aCase);
    setupHistories(aCase);
    setupEmails(aCase);
    sortByCreateDate();
  }
  
public PageReference ShowFull(){
    showFullDesc = true;
    return null;    
}

public PageReference HideFull() {
   showFullDesc = false;
   return null;
}

public PageReference HidePrivateActivities() {
    hidePrivate = true;
    return null;
}

public PageReference ShowPrivateActivities() {
    hidePrivate = false;
    return null;
}

public pageReference sortByExternal(){
showAll=true;
return null;
}
  public PageReference sortByOwner(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('OWNER',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByCreateDate(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('CREATEDATE',0, CHIlist.size()-1);
    return null;
  }

  public PageReference sortByDueDate(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('DUEDATE',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByCreateBy(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('CREATEBY',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByType(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('TYPE',0, CHIlist.size()-1);
    return null;
  }

  public PageReference sortBySubject(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('SUBJECT',0, CHIlist.size()-1);
    return null;
  }
    
  public void setupHistories(Case c){
    List<CaseHistory> cHistories = c.Histories;
    String subject;
    String oldVal;
    String newVal;
  
    setupPrefix();
  
    for (CaseHistory ch:cHistories){
      oldVal=String.valueOf(ch.oldValue);
      newVal=String.valueOf(ch.newValue);
      
      if(isId(oldVal)||isId(newVal))
        subject=null;
      else if(ch.Field=='Primary_Group_Name__c')
        subject = '<strong>Primary Group</strong> changed from <strong>'+oldVal+'</strong> to <strong>'+newVal+'</strong>';
      else if(ch.OldValue==null&&ch.NewValue==null)
        subject = 'Support Case Opened';
      else if(ch.Field == 'Escalated_Tier_2__c' && ch.NewValue==true)
        subject = '<strong>Case Escalated to Tier 2. ⬆</strong>';
      else if(ch.Field == 'Escalated_Tier_3__c' && ch.NewValue==true)
        subject = '<strong>Case Escalated to Tier 3. ⬆</strong>';
      else if(ch.OldValue==null)
         subject = '<strong>'+ch.Field+'</strong> changed or set to <strong>'+newVal+'</strong>';
      else if(ch.newValue==null)
         subject = '<strong>'+ch.Field+'</strong> changed or set to <strong>'+newVal+'</strong>';
      else{
        subject = '<strong>'+ch.Field+'</strong> changed from <strong>'+oldVal+'</strong> to <strong>'+newVal+'</strong>';
      }
      
      
      if(subject!=null)
        CHIlist.add(new CaseHistoryItem(ch.CreatedDate, subject, ch.CreatedBy.Name, ch.CreatedById, null, 'Update', null, null, null, null,'Private'));
      }
    }
  
   public void setupEmails(Case c){
    List<EmailMessage> emailMessages=c.EmailMessages;
    String subject='';
    for(EmailMessage em:emailMessages){
     subject='<strong>Date Sent:</strong>&nbsp; '+em.MessageDate.format('MM/d/yyyy')+'<br /><strong>From:</strong>&nbsp; '+em.FromName+' <br /><strong>To:</strong>&nbsp;'+em.ToAddress+'<br /><strong>Subject:</strong>&nbsp;'+em.Subject+'<br /><br />'+em.TEXTBody;
     CHIlist.add(new CaseHistoryItem(em.CreatedDate, subject, em.CreatedBy.Name, em.CreatedById,  null, 'Email', null, null, null, null,'Public'));
    }
  }
   
  private void setupPrefix(){
    prefixSet=new Set<String>();
    Map<String, Schema.SObjectType> gD = Schema.getGlobalDescribe();
    Set<String>keys=gD.keySet();
    for(String key:keys){
      Schema.DescribeSObjectResult r = gD.get(key).getDescribe();
      if(r!=null &&r.getKeyPrefix()!=null && r.getKeyPrefix()!='')
       prefixSet.add(r.getKeyPrefix());
    }     
  }
  
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

  public void setupAttachments(Case c){
    List <Case_Attachment__c> Attachments = c.Case_Attachment__r;
    String subject = ' ';
    for(Case_Attachment__c ca: Attachments){
      subject='<strong>Date Uploaded:</strong>&nbsp; '+ca.CreatedDate.format('MM/d/yyyy')+'<br /><strong>By:</strong>&nbsp; '+ca.CreatedBy.Name+' <br /><strong>Download Link:</strong>&nbsp;'+ca.Preview_Link__c+'<br /><strong>Notes:</strong>&nbsp;'+ca.Notes__c;
      CHIlist.add(new CaseHistoryItem(ca.CreatedDate, subject, ca.CreatedBy.Name, ca.CreatedById, null,'Attachment', null, null, null, null,'Private'));
    }
  }
  
  public void setupTasks(Case c){
    tasks = c.Tasks;
    for (task t: tasks){
        if(notEmail(t.Subject))
                if(t.External__C)
                    CHIlist.add(new CaseHistoryItem(t.CreatedDate, t.Subject, t.CreatedBy.Name, t.CreatedById, t.Id, 'Note', t.ActivityDate, t.Who.Name, t.Type+'<br /><strong>Description:</strong>&nbsp;&nbsp; '+t.Description, t.WhoId,'Public'));
                else
                    CHIlist.add(new CaseHistoryItem(t.CreatedDate, t.Subject, t.CreatedBy.Name, t.CreatedById, t.Id, 'Note', t.ActivityDate, t.Who.Name, t.Type+'<br /><strong>Description:</strong>&nbsp;&nbsp; '+t.Description, t.WhoId,'Private'));
    }   
  }
  private Boolean notEmail(String testVal){
    if(testVal != null && testVal.length()<5)
     return true;
   if(testVal != null) 
    String subTestVal = testVal.substring(0, 5);
    // Mac please check this line, we realy need this condition.
   /* if(subTestVal.equalsIgnoreCase('Email'))
     return false;*/
     return true;
  }
  
  public void quickSort(String key, integer left, integer right) {
    integer index = partition(key, left, right);
    if (left < index - 1)
     quickSort(key, left, index - 1);
    if (index < right)
     quickSort(key, index, right);
  }
  
  public integer partition(String key, integer left, integer right){
      integer i = left, j = right;
      CaseHistoryItem tmp;
      CaseHistoryItem pivot = CHIlist[(left + right) / 2];
      while (i <= j) {
            while (compare(key, CHIlist[i], pivot))
                  i++;
            while (compare(key,pivot, CHIlist[j]))
                  j--;
            if (i <= j) {
                  tmp = CHIlist[i];
                  CHIlist[i] = CHIlist[j];
                  CHIlist[j] = tmp;
                  i++;
                  j--;
            }
      }

      return i;
  }
  
  //sorts by key then 'CREATEDATE' if keys are equal
  public boolean compare(String key, CaseHistoryItem left, CaseHistoryItem right){
    if (key=='CREATEDATE')
     return right.createdDate<left.createdDate;
    
    else if(key=='DUEDATE'){
       if(left.dueDate==null && right.dueDate==null)
        return compare('CREATEDATE', right, left);
       else if(left.dueDate==null)
         return false;
       else if(right.dueDate==null)
         return true;
       else{
         if(left.dueDate==right.dueDate)
           return compare('CREATEDATE', right, left);
         else
           return left.dueDate<right.dueDate;
       }
     }
    
    else if(key=='OWNER'){
       if(left.ownerName==null && right.ownerName==null)
        return compare('CREATEDATE', right, left);
       else if(left.ownerName==null)
         return false;
       else if(right.ownerName==null)
         return true;
       else{
         if(left.ownerName==right.ownerName)
           return compare('CREATEDATE', right, left);
         else
           return left.ownerName<right.ownerName;
       }
     }
     
    else if(key=='CREATEBY'){
     if(left.createdName==right.createdName)
       return compare('CREATEDATE', right, left);
     else
       return left.createdName<right.createdName;
    }
    
    else if(key=='TYPE'){
     if(left.itemTypeName==right.itemTypeName)
       return compare('CREATEDATE', right, left);
     else
       return left.itemTypeName<right.itemTypeName;
      }
    
    else if(key=='SUBJECT'){
     if(left.subject==right.subject)
       return compare('CREATEDATE', right, left);
     else
       return left.subject<right.subject;
     }
    
    else
     return right.createdDate<left.createdDate;  
  }
  
  public Class CaseHistoryItem{
    public Datetime createdDate   {get; set;}
    public Date dueDate           {get; set;}
    public String subject         {get; set;}
    public String createdName     {get; set;} 
    public String createdId       {get; set;}
    public String mainId          {get; set;}
    public String itemType        {get; set;}
    public boolean isActivity     {get; set;}
    public String createDateFix   {get; set;}
    public String dueDateFix      {get; set;}
    public String subjectSort     {get; set;}
    public String ownerName       {get; set;}
    public String taskDescription {get; set;}
    public String ownerId         {get; set;}
    public String itemTypeName    {get; set;}
    public string external {get;set;}
    
    CaseHistoryItem(Datetime aCreateDate,String aSubject, String aCreatedName, String aCreatedId,  String aMainId, String aType, Date aDueDate, String aOwnerName, String aTaskDesc, String aOwnerId,string aExternal){
      createdDate=aCreateDate;
      external=aExternal;
      createDateFix=createdDate.format('MM/d/yyyy @ h:mm a');
      subject=aSubject;
      createdName=aCreatedName;
      createdId=aCreatedId;
      mainId=aMainId;
      itemType=getTypeImageMap(aType);
      itemTypeName=aType;
      dueDate=aDueDate;
      if(dueDate!=null){
        isActivity=true;
        dueDateFix=dueDate.format(); 
      }
      else 
        isActivity=false;
      ownerName=aOwnerName;
      taskDescription=aTaskDesc;
      ownerId=aOwnerId;
    }
    
    private String getTypeImageMap(String aType){
      
      if (aType=='Update' && Subject == '<strong>Case Escalated to Tier 2. ⬆</strong>')
        return '/resource/1306098880000/caseUpdate48/attention.png'; /*/resource/**ID OF STATIC RESOURCE - MUST BE UPDATED W/EVERY MIGRATION TO NEW ENVIRONMENT*/
      else if(aType=='Update' && Subject == '<strong>Case Escalated to Tier 3. ⬆</strong>')
        return '/resource/1306098880000/caseUpdate48/attention.png'; 
      else if(aType=='Update' && subject.contains('Owner'))
        return '/resource/1306098880000/caseUpdate48/user.png';
      else if(aType=='Update' && subject.contains('Primary Group'))
        return '/resource/1306098880000/caseUpdate48/users.png';
      else if(aType=='Update' && subject.contains('Status'))
        return '/resource/1306098880000/caseUpdate48/process.png';
      else if(aType=='Update')
        return '/resource/1306098880000/caseUpdate48/refresh.png';
      else if(aType=='Attachment')
        return '/resource/1306098880000/caseUpdate48/attachment.png';
      else if(aType=='Email')
        return '/resource/1306098880000/caseUpdate48/mail_send.png';
      else
        return '/resource/1306098880000/caseUpdate48/full_page.png';
    }
  }

 static testMethod void testCaseHistoryController() {
    Account ac=TestMethodUtility.createAccount();
    insert ac;
    

    Contact ct= TestMethodUtility.createContact(ac);
    insert ct;
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    insert a;
    
    Case cs1=TestMethodUtility.createCase1(ac,a);
    cs1.Status='Solution Suggested';
    cs1.Description='this case has to be resolved';
    cs1.Type='abc';
    cs1.Subject='abc';
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Previous_Owner__c='yyyy';
    cs1.AccountId=ac.id;
    cs1.Contact=ct;
    cs1.Replication_in_the_Case__c = 'Test';
    insert cs1;
    
    cs1.Type='bcd';
    Update cs1;
    
    Case cs2=TestMethodUtility.createCase1(ac,a);
    cs2.Status='Solution Suggested';
    cs2.Description='this case has to be resolved';
    cs2.Type='abc';
    cs2.Subject='abc';
    cs2.Case_Severity__c='1';
    cs2.Primary_Group_Name__c='ANGEL - Development';
    cs2.Previous_Owner__c='yyyy';
    cs2.AccountId=ac.id;
    cs2.Contact=ct;
    cs2.Replication_in_the_Case__c = 'Test';
    insert cs2;
   
    
    Task t = new Task();
    t.WhatID = cs1.ID;
    t.subject='Email';
    insert t;
    
    Case c = new Case(ID = cs1.ID);
    c.Status = 'New';
    c.Case_Severity__c = '2';
    Update c;
    
    Case c1 = new Case(ID = cs1.ID);
    c1.Status = 'Pending User';
    c1.Case_Severity__c = '3';
    Update c1;
    
    Case_Note__c cn = new Case_Note__c();
    cn.CurrencyIsoCode='GBP';
    cn.Case__c=cs1.id;
    cn.Contact__c=ct.id;
    cn.PS_Note_Seq_Nbr__c='1234';
    cn.Type__c='Test';
    insert cn;
    
    
    Case_Attachment__c ca = new Case_Attachment__c();
    ca.CurrencyIsoCode='GBP';
    ca.Case_Note__c=cn.id;
    ca.Related_To__c=cs1.id;
    insert ca;
    
   Case css =[Select id,Status,Description,Type,Subject,Case_Severity__c,Primary_Group_Name__c,Previous_Owner__c,AccountId,AssetId,ContactId,Replication_in_the_Case__c,(select NewValue,OldValue,Field,CaseId from Histories) from case where id =:cs1.id];
    
   List<CaseHistory> ch = new List<CaseHistory>([select ID from CaseHistory where CaseID =: cs1.ID]);
   System.debug('AAAAAAAAAA'+css);

   ApexPages.currentPage().getParameters().put('id', css.Id );
   CaseHistoryController CHC = new CaseHistoryController();
   CHC.caseID = ApexPages.currentPage().getParameters().get('id');

   CHC.FullComment = true;
   CHC.showPublicOnly = true;         
   CHC.showAttachments = true;       
   CHC.showEmails = true; 
   CHC.sortByCreateBy();
   CHC.sortByDueDate();
   CHC.sortBySubject();
   CHC.sortByType();
   CHC.HideFull();
   CHC.HidePrivateActivities();
   CHC.setupAttachments(css);
   CHC.ShowFull();
   CHC.setupHistories(css);
   CHC.ShowPrivateActivities();
   CHC.sortByExternal();
   CHC.sortByOwner();
   CHC.isId('Test');
   CHC.isId('NikhilTest');
  }
}