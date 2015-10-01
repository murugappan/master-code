global class batchDeleteEndUser implements Schedulable
{
    
    public static String CRON_EXP = '0 0 12 1 1/3 ? *';
 
    
    global static String scheduleIt() {
        batchDeleteEndUser delbatch = new batchDeleteEndUser();
        return System.schedule('Delete EndUser Batch', CRON_EXP, delbatch);
        } 
    
 
    
    global void execute(SchedulableContext sc) {
        
       Datetime days = system.now().addDays(-365);
        
       List<EndUser__c> objectList = new List<EndUser__c>();

 
        
        for (EndUser__c EUser: [
            select Id,name
            from EndUser__c
            where Id not in (select End_User__c from Case where status != 'Closed') and ((Time_of_Last_Created_Case__c<= :days and Time_of_Last_Initiated_Chat__c<=:days ) or (Time_of_Last_Created_Case__c=null and Time_of_Last_Initiated_Chat__c<=:days) or (Time_of_Last_Created_Case__c<= :days and Time_of_Last_Initiated_Chat__c=null))
        ]) {
            objectList.add(EUser);
           
        }
 
        if (!objectList.isEmpty()) {
           delete objectList;
           system.debug('enduser----'+objectList);
        }
  }  
}