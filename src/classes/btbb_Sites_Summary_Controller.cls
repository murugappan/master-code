public without sharing class btbb_Sites_Summary_Controller {
           
    public list<Asset> aList {get;set;}    
    public List<selectOption> accounts {get; set;}
    public String selectedAccount {get; set;}
    
    public Integer Total_Purchased_Number_of_Users {get; set;}
    public Integer Total_Allocated_Disk_Storage {get; set;}
    public Integer Total_Actual_Disk_Usage {get; set;}
    public Integer Total_Actual_Active_User_Count {get; set;}
   
    public btbb_Sites_Summary_Controller(ApexPages.StandardController controller) {
       aList = new list<Asset>();
       
       Account acc = (Account)controller.getRecord();
       
       if(acc != null && acc.Id!=null)
         loadAccountdetails(acc.Id);
       else {          
               loadAccounts();
               
               if(accounts != null && accounts.size() > 0)
                 selectedAccount = accounts[0].getValue();
               
               if(selectedAccount!=null)
                 loadAccountdetails(selectedAccount);
       }
   }
 
   public void loadAccountdetails(string accID) {
        aList = new list<Asset>();
                Date currentDate = system.today();
      //  list<core_license__c> mRLicense = [select id, name from core_license__c where name = 'Moodlerooms'] ;
        
        List<AggregateResult> results = [Select Sum(a.User_Quantity__c) Quant, sum(a.Data_Storage_Quantity__c) DataStorage, 
                                                                                        sum(a.Actual_Disk_Usage_GB__c) DiskUsage, sum(a.Actual_Active_Users_Count__c) UsersCount, a.accountId 
                                                                         From Asset a 
                                                                         where a.accountId = :accID 
                                                                           and a.Status = 'Installed' 
                                                                           and a.CPQ_Contract_End_Date__c >= :currentDate
                                                                           and a.CPQ_Active__c = true
                                                                           and a.Core_License__r.Name = 'Moodlerooms'
                                                                         group by a.accountId];
                                                                         
       for(AggregateResult ar : results) {
          Total_Purchased_Number_of_Users = Integer.ValueOf(ar.get('Quant'));
          Total_Allocated_Disk_Storage = Integer.valueOf(ar.get('DataStorage'));
          Total_Actual_Disk_Usage = Integer.valueOf(ar.get('DiskUsage'));
          Total_Actual_Active_User_Count = Integer.valueOf(ar.get('UsersCount'));
        } 
        
        aList = [Select a.Id,a.name,a.User_Quantity__c, a.Data_Storage_Quantity__c, a.Actual_Disk_Usage_GB__c, a.Actual_Active_Users_Count__c,
                                    a.Usage_Snapshot_Date__c, a.AccountId, a.Software_URL__c, a.CPQ_Contract_End_Date__c, a.Status
                 From Asset a
                 where a.accountId =:accID
                   and a.Status = 'Installed' 
                   and a.CPQ_Contract_End_Date__c >= :currentDate
                   and a.CPQ_Active__c = true
                   and a.Core_License__r.Name = 'Moodlerooms'
                   and ( a.User_Quantity__c > 0
                   or a.Data_Storage_Quantity__c > 0
                   or a.Actual_Disk_Usage_GB__c > 0 
                   or a.Actual_Active_Users_Count__c > 0)];
        }
   
    public PageReference fetchAccountDetails() {
        loadAccountdetails(selectedAccount);
        return null;
    }
        
    public void loadAccounts() {
                accounts = new List<selectOption>();
                List<User> u = new List<User>([select ID,ContactID from USer where ID =: Userinfo.getUserID()]);
                Set<Id> accId = new Set<ID>();
                System.debug(u[0].ContactID);
                for(Contact_Role__c cr : [Select c.Role__c, c.Expire_Role__c, c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND c.Expire_Role__c = false AND Contact__c!= NULL]){
                        accId.add(cr.Account__c);    
                        System.debug(accId);
                } 
                System.debug(accId.size());
                System.debug(accId);
                User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
                accId.add(loginUser.AccountId);
 
                for (account at : [SELECT id,name FROM Account WHERE ID IN: accId ORDER BY name])
                {
                    if((at.id!=null)||(at.name!=null))
                    {
                         accounts.add(new SelectOption(at.id,at.name));
                            
                    }

                }
    }  

}