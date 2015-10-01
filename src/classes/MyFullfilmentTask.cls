Public Class MyFullfilmentTask{

   
    Public List<Custom_Task__c> LCustTask{get;set;}
   // private List<Ac> accounts;
    private String sortDirection = 'ASC';
    private String sortExp = 'name';

    public  MyFullfilmentTask(ApexPages.StandardController controller) {
    
    LCustTask=New List<Custom_Task__c>();
    
    
    
    LCustTask=[Select id,Name,Subject__c,Type__c,Opportunity__r.id,Opportunity__r.name,Opportunity__r.Account.Market__c,Opportunity__r.Account.BillingCountry,Status__c,Priority__c,Due_Date__c,Ownerid,Queue__c from Custom_Task__c Where Ownerid =:userinfo.getuserid() and Status__c!='Completed' and Status__c!='Deferred' ];
    
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
  
   public List<Custom_Task__c> getLCustTask() {
       return LCustTask;
   }


   public PageReference ViewData() {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
       id Usrid=userinfo.getuserid();
       LCustTask=Database.query('Select id,Name,Subject__c,Type__c,Opportunity__r.id,Opportunity__r.name,Opportunity__r.Account.Market__c,Opportunity__r.Account.BillingCountry,Status__c,Priority__c,Due_Date__c,Queue__c from Custom_Task__c Where Ownerid =:Usrid and Status__c!=\'Completed\' and Status__c!=\'Deferred\' order by ' + sortFullExp + ' limit 10');
       return null;
   }

}