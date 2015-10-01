Public Class FullfilmentTaskdemo{
 
   
    public List<Custom_Task__c > selectedTasks = new List<Custom_Task__c >();
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    Public List<Custom_Task__c> LCustTask2 {get;set;}
    public List<cContact> LCustTask {get; set;}
    
    //Set of Ownerid
    Set<id> QueOwnId = New Set<id>();
    
    // To Store group id
    Set<id> Grpid = New set<id>(); 
   
    public  FullfilmentTaskdemo(ApexPages.StandardController controller) {
    LCustTask = new List<cContact>();
    ViewData();
    
   
     FOR(GroupMember grp: [Select GroupId,UserOrGroupId from GroupMember Where UserOrGroupId=:Userinfo.Getuserid() and Group.DeveloperName in( 'Fulfillment_Operations','Cloud_Provisioning','Materials_Team','Connect_TXT_Team','Moodle_Engagement_Team','ICM_Managers','Xythos_Support','Open_Education_Team','Mobile_Team')])
    {
        Grpid.Add(grp.GroupId);
        QueOwnId.Add(grp.GroupId); 
    }
    
    // To get all the users as well
    FOR(GroupMember grp: [Select GroupId,UserOrGroupId from GroupMember Where GroupId IN :Grpid])
    {
       QueOwnId.Add(grp.UserOrGroupId);
    }
    
   for(Custom_Task__c c:[Select id,Name,Subject__c,Type__c,Opportunity__r.id,Opportunity__r.name,Opportunity__r.Account.Market__c,Opportunity__r.Account.BillingCountry,Status__c,Priority__c,Due_Date__c,Ownerid,Owner.Name,Queue__c  from Custom_Task__c Where Ownerid IN : QueOwnId and Status__c!='Completed' and Status__c!='Deferred' ])
        LCustTask.add(new cContact(c,Grpid)); 
  
    }
    public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
  
   public List<cContact> getLCustTask() {
       return LCustTask;
   }


   public PageReference  ViewData() 
   {
   LCustTask2=New List<Custom_Task__c>(); 
   LCustTask=New List<cContact>();
      //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
    LCustTask2 = Database.query('Select id,Name,Subject__c,Type__c,Opportunity__r.id,Opportunity__r.name,Opportunity__r.Account.Market__c,Opportunity__r.Account.BillingCountry,Status__c,Priority__c,Due_Date__c,Ownerid,Owner.Name,Queue__c from Custom_Task__c Where Ownerid IN : QueOwnId and Status__c!=\'Completed\' and Status__c!=\'Deferred\'  order by ' + sortFullExp + '  limit 100');
           for(Custom_Task__c c:LCustTask2 )
           {
              LCustTask.add(new cContact(c,Grpid));
           }
           return Null;
   }
   
    
   
   public PageReference processSelected() {
      integer flag=0;
      List<Custom_Task__c> updateOwner=new list<Custom_Task__c>();
     system.debug('List'+getLCustTask());
       for(cContact cCon: getLCustTask()) {
       if(cCon.selected == true) {
       selectedTasks .add(cCon.con);
        }
        }
     for(Custom_Task__c c: GetSelectedTasks()) {
     
       
     c.Ownerid=Userinfo.getuserid();
     Update c;
     //updateOwner.add(c);
     
     
         flag=1;
        }
         
        LCustTask=null;
     
       // if(updateOwner!= null)
        //update updateOwner; 
        if(flag==1)
        {
        
                ViewData();
                }
        return Null;           
}
 //Re-set task list so selected tasks are not displayed in list
        
   
   public class cContact 
   {
  public Custom_Task__c con {get; set;}
  Public boolean Discheck {get;set;}
  public Boolean selected {get; set;}

  public cContact(Custom_Task__c c,Set<id> temp) 
  {
   con = c;
   selected = false;
   Discheck=True;
   If(temp.contains(c.Ownerid))
   {
    Discheck=False; 
   }
   
  }
 } 
 
 
  public PageReference getSelected()
    {
        selectedTasks.clear();
        for(cContact accwrapper : LCustTask)
        if(accwrapper.selected == true)
        selectedTasks.add(accwrapper.con);
        return null;
    } 
    
    public List<Custom_Task__c> GetSelectedTasks()
    {
        if(selectedTasks.size()>0)
        return selectedTasks;
        else
        return null;
    } 
 
 
 
 
 
 
 }